#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init()
{
	team_score_init();
}

//chris_p - added dogs to the scoring
player_add_points( event, mod, hit_location, zombie)
{
	if( level.intermission )
	{
		return;
	}

	if( !is_player_valid( self ) )
	{
		return;
	}

	player_points = 0;
	team_points = 0;
	multiplier = self get_points_multiplier();
	gross_possible_points = 0;

	//iprintln("event: " + event + " mod: " + mod + " ");
	//print current weapon
	//iprintln("current weapon: " + self getcurrentweapon());
	
	//Mod adjust for Sabertooth Chainsaw
	if( isSubStr( self getcurrentweapon(), "sabertooth" ) && IsString(mod) && mod == "MOD_RIFLE_BULLET" )
	{
		mod = "MOD_MELEE";
	}

	switch( event )
	{
		case "death":
		case "ballistic_knife_death":
			player_points	= get_zombie_death_player_points();
			team_points		= get_zombie_death_team_points();
			gross_possible_points += player_points;

			//iprintln("zombie_death_player_points: " + player_points);
			//Headshots and melee bonus
			player_points += player_add_points_kill_bonus( mod, hit_location, self getcurrentweapon(), zombie );
			gross_possible_points += level.zombie_vars["zombie_score_bonus_head"];
			//iprintln("KILL BONUS: " + player_points);

			//Reimagined-Expanded - Apocalypse mod - Bonus points for killing zombies quickly
			if( level.apocalypse ) 
			{
				//No points for WondwerWeapons, double for pistols
				
				weapon_multiplier = weapon_points_multiplier( self getcurrentweapon(), mod, false, zombie );
				if( weapon_multiplier < 1 ) 
				{
					player_points *= weapon_multiplier;
				} 
				else 
				{
					player_points = Int( player_points * weapon_multiplier );
					gross_possible_points = Int( gross_possible_points * weapon_multiplier );
				}	
				

				//Bonus points for killing zombies quickly - not doubled, not valid on WW
				max_bonus = level.ARRAY_QUICK_KILL_BONUS_POINTS[level.round_number];
				if( IsDefined( max_bonus ) )
					gross_possible_points += max_bonus;
				else
					gross_possible_points += level.ARRAY_QUICK_KILL_BONUS_POINTS[ level.THRESHOLD_MAX_APOCALYSE_ROUND ];
				
				if( player_points > 0 )
					player_points += quick_kill_bonus_points( zombie );

				if( player_points < 0 )
					player_points = 0;
			}
			//iprintln("Points after multiplier: " + player_points);

			if(IsDefined(self.kill_tracker))
			{
				self.kill_tracker++;
			}
			else
			{
				self.kill_tracker = 1;
			}
			//stats tracking
			self.stats["kills"] = self.kill_tracker;

			break;

		case "damage_light":
		case "damage_ads":
		case "damage":
			//Reimagined-Expanded

			//put each variable in a seperate line for easier debugging
			//iprintln("defined: " + IsDefined( zombie ));
			//iprintln("animname: " + zombie.animname);
			//iprintln("respawn: " + zombie.respawn_zombie);		

			player_points = zombie_calculate_damage_points( level.apocalypse, zombie );
			if( level.apocalypse ) 
			{
				weapon_multiplier = weapon_points_multiplier( self getcurrentweapon(), mod, true, zombie );
				if( weapon_multiplier < 1 ) 
				{
					self.gross_possible_points += player_points; //points u could have got if u had a better weapon
					player_points *= weapon_multiplier;
				} 
				else 
				{
					player_points *= weapon_multiplier;
					self.gross_possible_points += player_points;
				}
			}
			

			break;

		case "rebuild_board":
		player_points	= mod* (Int(level.round_number/5)+1);
		break;
		case "carpenter_powerup":
			player_points	= mod* (Int(level.round_number/5)+1);
			if( player_points > level.THRESHOLD_MAX_POINTS_CARPENTER )
				player_points = level.THRESHOLD_MAX_POINTS_CARPENTER;
			break;

		case "bonus_points_powerup":
			player_points	= mod;
			break;

		case "nuke_powerup":
			player_points	= mod* (Int(level.round_number/5)+1);
			if( player_points > level.THRESHOLD_MAX_POINTS_NUKE )
				player_points = level.THRESHOLD_MAX_POINTS_NUKE;
			team_points		= mod;
			break;

		case "thundergun_fling":
			player_points = mod;
			if( level.apocalypse )
				player_points = 0;
			break;

		case "hacker_transfer":
			player_points = mod;
			break;

		case "reviver":
			player_points = mod;
			break;

		default:
			assertex( 0, "Unknown point event" );
			break;
	}

	//player_points = multiplier * round_up_score( player_points, 5 );
	//team_points = multiplier * round_up_score( team_points, 5 );

	player_points = int(multiplier * player_points);
	team_points = int(multiplier * team_points);

	if ( isdefined( self.point_split_receiver ) && (event == "death" || event == "ballistic_knife_death") )
	{
		split_player_points = player_points - round_up_score( (player_points * self.point_split_keep_percent), 10 );
		self.point_split_receiver add_to_player_score( split_player_points );
		player_points = player_points - split_player_points;
	}

	// Add the points
	self add_to_player_score( player_points );
	players = get_players();
	if ( players.size > 1 )
	{
		self add_to_team_score( team_points );
	}

	//stat tracking
	self.stats["score"] = self.score_total;
	self.gross_points += player_points;
	
	switch( event )
	{
		case "death":
		case "ballistic_knife_death":
		case "damage_light":
		case "damage_ads":
		case "damage":
			self.gross_possible_points += (multiplier * gross_possible_points);
			break;

		default:
			self.gross_possible_points += (multiplier * player_points);
			break;
	}

//	self thread play_killstreak_vo();
}

	zombie_calculate_damage_points( isApocalypseMode, zombie )
	{
		player_points = level.zombie_vars["zombie_score_damage_light"];

		if( isApocalypseMode ) 
		{
			if (level.round_number < level.LIMIT_ZOMBIE_DAMAGE_POINTS_ROUND_LOW )
			{
				player_points = level.VALUE_ZOMBIE_DAMAGE_POINTS_LOW;
			}
			else if (level.round_number < level.LIMIT_ZOMBIE_DAMAGE_POINTS_ROUND_MED ) 
			{
				player_points = level.VALUE_ZOMBIE_DAMAGE_POINTS_MED;
			}
			else
			{
				player_points = level.VALUE_ZOMBIE_DAMAGE_POINTS_HIGH;
			}

			//No points for shooting zombie if it respawned
			if( IsDefined( zombie ) && ( is_in_array( level.ARRAY_VALID_DESPAWN_ZOMBIES, zombie.animname ) ) )
			{
				if ( zombie.respawn_zombie )
					return level.VALUE_ZOMBIE_DAMAGE_POINTS_RESPAWN;
			}				
			//iprintln("Points after multiplier: " + player_points);

		}

		return player_points;
	}

//Reimagined-Expanded
weapon_points_multiplier( weapon, mod, isForDamage, zombie ) 
{
	multiplier = 1;
	//Reimagined-Expanded dont want to do a whole extra switch case for double pap damage, so we take subtring
	if( IsSubStr( weapon, "x2" ) ) {
			weapon = GetSubStr(weapon, 0, weapon.size-3);
	}

	if( !IsDefined( mod ) )
		mod = "MOD_UNKNOWN";
	
	if( !IsDefined( isForDamage ) )
		isForDamage = false;

	//if mod is melee, return 1
	if( mod == "MOD_MELEE" )
		return 1;

	switch( weapon ) 
	{
		case "cz75_zm":
		case "cz75dw_zm":
		case "python_zm":
		case "cz75_upgraded_zm":
		case "cz75dw_upgraded_zm":
		case "python_upgraded_zm":
			if(isSubStr(mod, "BULLET")) 
			{
				multiplier = 1.33;
				if( isForDamage )				
					multiplier = 2;
			}
		break;

		//No points for wonder weapons in apocalypse
		case "microwavegund_zm":
		case "microwavegund_upgraded_zm":
		case "microwavegundw_upgraded_zm":
		case "tesla_gun_powerup_zm":
		case "tesla_gun_powerup_upgraded_zm":
		case "tesla_gun_zm":
		case "tesla_gun_upgraded_zm":
		case "thundergun_zm":
		case "thundergun_upgraded_zm":
		//case "ray_gun_zm":
		//case "ray_gun_upgraded_zm":
		case "starburst_ray_gun_zm":
		case "freezegun_zm":
		case "freezegun_upgraded_zm":
		case "shrink_ray_zm":
		case "shrink_ray_upgraded_zm":
		case "humangun_upgraded_zm":

		iprintln("Wonder weapon: " + weapon);
		
		if( mod != "MOD_GRENADE_SPLASH" )
			multiplier = 0;

        break;

	}
	return multiplier;
}

/*



*/


get_points_multiplier()
{
	multiplier = self.zombie_vars["zombie_point_scalar"];

	if( level.mutators["mutator_doubleMoney"] )
	{
		multiplier *= 2;
	}

	return multiplier;
}

// Adjust points based on number of players (MikeA)
get_zombie_death_player_points()
{
	players = get_players();
	if( players.size == 1 )
	{
		points = level.zombie_vars["zombie_score_kill_1player"];
	}
	else if( players.size == 2 )
	{
		points = level.zombie_vars["zombie_score_kill_2player"];
	}
	else if( players.size == 3 )
	{
		points = level.zombie_vars["zombie_score_kill_3player"];
	}
	else
	{
		points = level.zombie_vars["zombie_score_kill_4player"];
	}
	
	if( level.apocalypse )
		points = level.VALUE_APOCALYPSE_ZOMBIE_DEATH_POINTS;
	
	return( points );
}


// Adjust team points based on number of players (MikeA)
get_zombie_death_team_points()
{
	players = get_players();
	if( players.size == 1 )
	{
		points = level.zombie_vars["zombie_score_kill_1p_team"];
	}
	else if( players.size == 2 )
	{
		points = level.zombie_vars["zombie_score_kill_2p_team"];
	}
	else if( players.size == 3 )
	{
		points = level.zombie_vars["zombie_score_kill_3p_team"];
	}
	else
	{
		points = level.zombie_vars["zombie_score_kill_4p_team"];
	}
	return( points );
}


//TUEY Old killstreak VO script---moved to utility
/*
play_killstreak_vo()
{
	index = maps\_zombiemode_weapons::get_player_index(self);
	self.killstreak = "vox_killstreak";

	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	if (!isdefined (self.killstreak_points))
	{
		self.killstreak_points = 0;
	}
	self.killstreak_points = self.score_total;
	if (!isdefined (self.killstreaks))
	{
		self.killstreaks = 1;
	}
	if (self.killstreak_points > 1500 * self.killstreaks )
	{
		wait (randomfloatrange(0.1, 0.3));
		if(level.player_is_speaking != 1)
		{
			level.player_is_speaking = 1;
			self playsound ("plr_" + index + "_" +self.killstreak, "sound_done");
			self waittill("sound_done");
			level.player_is_speaking = 0;

		}
		self.killstreaks ++;
	}


}
*/


quick_kill_bonus_points( zombie )
{
	//Reimagined-Expanded - Apocalypse mod - Bonus points for killing zombies quickly
	valid_bonus_points = ( IsDefined( zombie ) 
		&& ( zombie.animname == "zombie" )
		&& ( level.expensive_perks && level.tough_zombies )
		&& ( !zombie.respawn_zombie ) );

	valid_penalty_points = ( IsDefined( zombie ) 
		&& ( zombie.animname == "zombie" )
		&& ( level.expensive_perks && level.tough_zombies )
		&& ( zombie.respawn_zombie ) );

	if( valid_bonus_points ) 
	{
		bonus = level.ARRAY_QUICK_KILL_BONUS_POINTS[level.round_number];
		if( IsDefined( bonus ) )
			return bonus;
	}	

	if( valid_penalty_points ) 
	{
		penalty = -1*level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[level.round_number];
		if( IsDefined( penalty ) )
			return penalty;
		else
			return -1*level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[ level.THRESHOLD_MAX_APOCALYSE_ROUND ];
	}

	return 0;
}

player_add_points_kill_bonus( mod, hit_location, weapon, zombie )
{
	score = 0;

	//iprintln( "Mod for zomb kill: ");
	//iprintln( mod );
	if( mod == "MOD_MELEE" )
	{ 
		score = level.zombie_vars["zombie_score_bonus_melee"];
		if( self HasPerk( level.VLT_PRK ) && !level.classic )
			score += level.VALUE_VULTURE_BONUS_MELEE_POINTS;

		return score;
	}

	if( mod == "MOD_EXPLOSIVE" || mod == "MOD_GRENADE_SPLASH"
	 || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_PROJECTILE" )
	{ 
		if( self HasPerk( level.PHD_PRK ) )
			score += level.VALUE_PHD_EXPL_BONUS_POINTS;

		return score;
	}


	//Headshot bonus
	if( WeaponClass(weapon) == "spread" ) {
		//no bonus for shotgun
	}
	else if( mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET"  || mod == "MOD_IMPACT" ) 
	{
		switch( hit_location )
		{
			case "head":
			case "helmet":
			case "neck":
				score = level.zombie_vars["zombie_score_bonus_head"];
				break;
		}

		//Reimagined-Expanded - All sniper damage rewards headshot kill bonus
		if( is_in_array(level.ARRAY_VALID_SNIPERS, weapon) ) 
		{
			score = level.zombie_vars["zombie_score_bonus_head"];
		}
		

	} else {
		//No bonus for shotguns, explosives, melee, wonder weapons
	}
	
	return score;
}

player_reduce_points( event, mod, hit_location )
{
	if( level.intermission )
	{
		return;
	}

	points = 0;

	switch( event )
	{
		case "no_revive_penalty":
			percent = level.zombie_vars["penalty_no_revive"];
			points = self.score * percent;
			break;

		case "died":
			percent = level.zombie_vars["penalty_died"];
			points = self.score * percent;
			break;

		case "downed":
			percent = level.zombie_vars["penalty_downed"];
			self notify("I_am_down");
			points = self.score * percent;

			self.score_lost_when_downed = round_up_to_ten( int( points ) );
			break;

		default:
			assertex( 0, "Unknown point event" );
			break;
	}

	points = self.score - round_up_to_ten( int( points ) );

	if( points < 0 )
	{
		points = 0;
	}

	self.score = points;

	self set_player_score_hud();
}


//
//	Add points to the player's score
//	self is a player
//
add_to_player_score( points, add_to_total )
{
	if ( !IsDefined(add_to_total) )
	{
		add_to_total = false;
	}

	if( !IsDefined( points ) || level.intermission )
	{
		return;
	}

	self.score += points;

	if ( add_to_total )
	{
		self.score_total += points;
		self.gross_points += points;
		self.gross_possible_points += points;
	}

	// also set the score onscreen
	self set_player_score_hud();
}


//
//	Subtract points from the player's score
//	self is a player
//
minus_to_player_score( points )
{
	if( !IsDefined( points ) || level.intermission )
	{
		return;
	}

	self.score -= points;
	self.spent_points += points;
	if( points <= 250 )
		self.gross_possible_points += points;

	// also set the score onscreen
	self set_player_score_hud();
}


//
//	Add points to the team pool
//	self is a player.  We need to derive the team from the player
//
add_to_team_score( points )
{
	//MM (3/10/10)	Disable team points

// 	if( !IsDefined( points ) || points == 0 || level.intermission )
// 	{
// 		return;
// 	}
//
// 	// Find out which team pool to adjust
// 	team_pool = level.team_pool[ 0 ];
// 	if ( IsDefined( self.team_num ) && self.team_num != 0 )
// 	{
// 		team_pool = level.team_pool[ self.team_num ];
// 	}
//
// 	team_pool.score += points;
// 	team_pool.score_total += points;
//
// 	// also set the score onscreen
// 	team_pool set_team_score_hud();
}


//
//	Subtract points from the team pool
//	self is a player.  We need to derive the team from the player
//
minus_to_team_score( points )
{
	if( !IsDefined( points ) || level.intermission )
	{
		return;
	}

	team_pool = level.team_pool[ 0 ];
	if ( IsDefined( self.team_num ) && self.team_num != 0 )
	{
		team_pool = level.team_pool[ self.team_num ];
	}

	team_pool.score -= points;

	// also set the score onscreen
	team_pool set_team_score_hud();
}


//
//
//
player_died_penalty()
{
	// Penalize all of the other players
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] != self && !players[i].is_zombie )
		{
			players[i] player_reduce_points( "no_revive_penalty" );
		}
	}
}


//
//
//
player_downed_penalty()
{
	self player_reduce_points( "downed" );
}



//
// SCORING HUD --------------------------------------------------------------------- //
//

//
//	Sets the point values of a score hud
//	self will be the player getting the score adjusted
//
set_player_score_hud( init )
{
	num = self.entity_num;

	score_diff = self.score - self.old_score;

	if ( IsPlayer( self ) )
	{
		// local only splitscreen only displays each player's own score in their own viewport only
		if( !level.onlineGame && !level.systemLink && IsSplitScreen() )
		{
			self thread score_highlight( self, self.score, score_diff );
		}
		else
		{
			players = get_players();
			for ( i = 0; i < players.size; i++ )
			{
				players[i] thread score_highlight( self, self.score, score_diff );
			}
		}
	}

	// cap points at 10 million
	if(self.score > 10000000)
	{
		self.score = 10000000;
	}

	if( IsDefined( init ) && init )
	{
		return;
	}

	self.old_score = self.score;
}


//
//	Sets the point values of a score hud
//	self will be the team_pool
//
set_team_score_hud( init )
{
	//MM (3/10/10)	Disable team points
	self.score = 0;
	self.score_total = 0;

//
// 	if ( !IsDefined(init) )
// 	{
// 		init = false;
// 	}
//
// 	//		TEMP function call.  Might rename this function so it makes more sense
// 	self set_player_score_hud( false );
// 	self.hud SetValue( self.score );
}

// Creates a hudelem used for the points awarded/taken away
create_highlight_hud( x, y, value )
{
	font_size = 8;
	if ( self IsSplitscreen() )
	{
		font_size *= 2;
	}

	hud = create_simple_hud( self );

	//level.hudelem_count++;

	hud.foreground = true;
	hud.sort = 0;
	hud.x = x;
	hud.y = y;
	hud.fontScale = font_size;
	hud.alignX = "right";
	hud.alignY = "middle";
	hud.horzAlign = "user_right";
	hud.vertAlign = "user_bottom";

	if( value < -1 )
	{
		hud.color = ( 0.4, 0, 0 );
	}
	else if ( value > 0 )
	{
		hud.color = ( 0.9, 0.9, 0.0 );
		hud.label = &"SCRIPT_PLUS";
	}
	else
	{
		hud.color = ( 0, 0, 0 );
		hud.alpha = 0.5;
	}
	
	//hud.glowColor = ( 0.3, 0.6, 0.3 );
	//hud.glowAlpha = 1;
	hud.hidewheninmenu = true;

	hud SetValue( value );

	return hud;
}

//
// Handles the creation/movement/deletion of the moving hud elems
//
/*
score_highlight( scoring_player, score, value )
{
	self endon( "disconnect" );

	// Location from hud.menu
	score_x = -103;
	score_y = -100;

	if ( self IsSplitscreen() )
	{
		score_y = -95;
	}

	x = score_x;

	// local only splitscreen only displays each player's own score in their own viewport only
	if( !level.onlineGame && !level.systemLink && IsSplitScreen() )
	{
		y = score_y;
	}
	else
	{
		players = get_players();

		num = 0;
		for ( i = 0; i < players.size; i++ )
		{
			if ( scoring_player == players[i] )
			{
				num = players.size - i - 1;
			}
		}
		y = ( num * -20 ) + score_y;
	}

	if ( self IsSplitscreen() )
	{
		y *= 2;
	}

	if(value < 1)
	{
		y += 5;
	}
	else
	{
		y -= 5;
	}

	time = 1.0;
	half_time = time * 0.5;
	quarter_time = time * 0.25;

	player_num = scoring_player GetEntityNumber();

	if(value < 1)
	{
		if(IsDefined(self.negative_points_hud) && IsDefined(self.negative_points_hud[player_num]))
		{
			value += self.negative_points_hud_value[player_num];
			self.negative_points_hud[player_num] Destroy();
		}
	}
	else if(IsDefined(self.positive_points_hud) && IsDefined(self.positive_points_hud[player_num]))
	{
		value = self.positive_points_hud_value[player_num];
		self.positive_points_hud[player_num] Destroy();
	}

	hud = self create_highlight_hud( x, y, value );

	if( value < 1 )
	{
		if(!IsDefined(self.negative_points_hud))
		{
			self.negative_points_hud = [];
		}
		if(!IsDefined(self.negative_points_hud_value))
		{
			self.negative_points_hud_value = [];
		}
		self.negative_points_hud[player_num] = hud;
		self.negative_points_hud_value[player_num] = value;
	}
	else
	{
		if(!IsDefined(self.positive_points_hud))
		{
			self.positive_points_hud = [];
		}
		if(!IsDefined(self.positive_points_hud_value))
		{
			self.positive_points_hud_value = [];
		}
		self.positive_points_hud[player_num] = hud;
		self.positive_points_hud_value[player_num] = value;
	}

	// Move the hud
	hud MoveOverTime( time );
	hud.x -= RandomIntRange(30,50);
	if(value < 1)
	{
		hud.y += RandomIntRange(5,25);
	}
	else
	{
		hud.y -= RandomIntRange(-15,15);;
	}

	wait( half_time );

	if(!IsDefined(hud))
	{
		return;
	}

	// Fade half-way through the move
	hud FadeOverTime( half_time );
	hud.alpha = 0;

	wait( half_time );

	if(!IsDefined(hud))
	{
		return;
	}

	hud Destroy();
}
*/

//*
//OLD
//
// Handles the creation/movement/deletion of the moving hud elems
//
score_highlight( scoring_player, score, value )
{
	self endon( "disconnect" );

	if(!IsDefined(self.highlight_hudelem_count))
	{
		self.highlight_hudelem_count = 0; //keeps track of any score streak so the scores go in order
		self.current_highlight_hudelem_count = 0; //keeps track of current scores on screen to prevent overlapping
	}

	// Location from hud.menu
	score_x = -103;
	score_y = -100;

	if ( self IsSplitscreen() )
	{
		score_y = -95;
	}

	x = score_x;

	// local only splitscreen only displays each player's own score in their own viewport only
	if( !level.onlineGame && !level.systemLink && IsSplitScreen() )
	{
		y = score_y;
	}
	else
	{
		players = get_players();

		num = 0;
		for ( i = 0; i < players.size; i++ )
		{
			if ( scoring_player == players[i] )
			{
				num = players.size - i - 1;
			}
		}
		y = ( num * -20 ) + score_y;
	}

	if ( self IsSplitscreen() )
	{
		y *= 2;
	}

	time = 0.8;
	half_time = time * 0.5;
	quarter_time = time * 0.25;

	while(self.current_highlight_hudelem_count >= 5)
	{
		wait_network_frame();
	}

	self.highlight_hudelem_count++;
	self.current_highlight_hudelem_count++;
	self thread minus_after_wait(.05);
	hud = self create_highlight_hud( x, y, value );
	current_count = self.highlight_hudelem_count;
	//x_count = (int(current_count / 6) % 4);
	y_count = current_count % 5;
	if(y_count == 0)
	{
		y_count = 5;
	}
	y_count--;

	// Move the hud
	hud MoveOverTime( time );
	//hud.x -= 20 + RandomInt( 40 );
	//hud.y -= ( -15 + RandomInt( 30 ) );
	hud.x -= 50;
	hud.y += ( -20 + (((y_count + 2) % 5) * 15) );

	wait( time - quarter_time );

	// Fade half-way through the move
	hud FadeOverTime( quarter_time );
	hud.alpha = 0;

	wait( quarter_time );

	hud Destroy();
	level.hudelem_count--;
	if(self.highlight_hudelem_count - current_count == 0)
	{
		self.highlight_hudelem_count = 0;
	}
}

minus_after_wait(time)
{
	wait time;
	self.current_highlight_hudelem_count--;
}

//*/


//
//	Initialize the team point counter
//
team_score_init()
{
	//	NOTE: Make sure all players have connected before doing this.
	flag_wait( "all_players_connected" );

	level.team_pool = [];

	// No Pools in a 1 player game
	players = get_players();
	if ( players.size == 1 )
	{
		// just create a stub team pool...
		level.team_pool[0] = SpawnStruct();
		pool				= level.team_pool[0];
		pool.team_num		= 0;
		pool.score			= 0;
		pool.old_score		= pool.score;
		pool.score_total	= pool.score;
		return;
	}

	if ( IsDefined( level.zombiemode_versus ) && level.zombiemode_versus )
	{
		num_pools = 2;
	}
	else
	{
		num_pools = 1;
	}

	for (i=0; i<num_pools; i++ )
	{
		level.team_pool[i] = SpawnStruct();
		pool				= level.team_pool[i];
		pool.team_num		= i;
		pool.score			= 0;
		pool.old_score		= pool.score;
		pool.score_total	= pool.score;

		// Based on the Location of the player score from hud.menu
		pool.hud_x			= -103 + 5;	// 2nd # is an offset from the menu position to get it to line up
		pool.hud_y			= -71 - 36;	// 2nd # is spacing away from the player score

		if( !IsSplitScreen() )
		{
			players = get_players();
			num = players.size - 1;
			pool.hud_y += (num+(num_pools-1 - i)) * -18;	// last number is a spacing gap from the player scores
		}

		//MM (3/10/10)	Disable team points
//		pool.hud = create_team_hud( pool.score, pool );
	}
}


//
//	Initialize the team score hud
//
create_team_hud( value, team_pool )
{
	AssertEx( IsDefined( team_pool ), "create_team_hud:  You must specify a team_pool when calling this function" );
	font_size = 8.0;

	hud				= create_simple_hud();
	hud.foreground	= true;
	hud.sort		= 10;
	hud.x			= team_pool.hud_x;
	hud.y			= team_pool.hud_y;
	hud.fontScale = font_size;
	hud.alignX		= "left";
	hud.alignY		= "middle";
	hud.horzAlign	= "user_right";
	hud.vertAlign	= "user_bottom";
	hud.color		= ( 0.9, 0.9, 0.0 );
	hud.hidewheninmenu = false;

	hud SetValue( value );

	// Set score icon
	bg_hud				= create_simple_hud();
	bg_hud.alignX		= "right";
	bg_hud.alignY		= "middle";
	bg_hud.horzAlign	= "user_right";
	bg_hud.vertAlign	= "user_bottom";
	bg_hud.color		= ( 1, 1, 1 );
	bg_hud.sort			= 8;
	bg_hud.x			= team_pool.hud_x - 8;
	bg_hud.y			= team_pool.hud_y;
	bg_hud.alpha		= 1;
	bg_hud SetShader( "zom_icon_community_pot", 32, 32 );

	// Set score highlight
	bg_hud				= create_simple_hud();
	bg_hud.alignX		= "left";
	bg_hud.alignY		= "middle";
	bg_hud.horzAlign	= "user_right";
	bg_hud.vertAlign	= "user_bottom";
	bg_hud.color		= ( 0.0, 0.0, 0 );
	bg_hud.sort			= 8;
	bg_hud.x			= team_pool.hud_x - 24;
	bg_hud.y			= team_pool.hud_y;
	bg_hud.alpha		= 1;
	bg_hud SetShader( "zom_icon_community_pot_strip", 128, 16 );

	return hud;
}
