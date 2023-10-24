#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_net;

#using_animtree( "generic_human" );

//Reimagined-Expanded - _zombiemode_effects.gsc custom file for isolating weapon effects for x2 PaP weapons
init()
{
	//These effects always included
	level._effect["tesla_bolt"]				= loadfx( "maps/zombie/fx_zombie_tesla_bolt_secondary" );
	level._effect["tesla_shock"]			= loadfx( "maps/zombie/fx_zombie_tesla_shock" );
	level._effect["tesla_shock_secondary"]	= loadfx( "maps/zombie/fx_zombie_tesla_shock_secondary" );
	
	//Explosion
	level._effect["custom_large_explosion"] = LoadFX( "explosions/fx_explosion_charge_large" );
	level._effect["custom_large_fire"] = LoadFX( "env/fire/fx_fire_xlg_fuel" );
	level._effect["custom_med_fire"] = Loadfx("env/fire/fx_fire_player_torso_mp");
	precacheshellshock( "electrocution" );
	
	//Freeze
	level._effect[ "trail_freezegun_ring_emit" ]			= Loadfx( "weapon/freeze_gun/fx_trail_freezegun_ring_emit" );
	level._effect[ "freezegun_damage_torso" ]			= LoadFX( "weapon/freeze_gun/fx_exp_freezegun_impact" );
	

	set_zombie_var( "tesla_max_arcs",			5 );
	set_zombie_var( "tesla_max_enemies_killed", 10 );
	set_zombie_var( "tesla_max_enemies_killed_upgraded", 15 );
	//set_zombie_var( "tesla_radius_start",		10000 );		//Reimagined-Expanded up from 300
	//set_zombie_var( "tesla_radius_decay",		20 );
	set_zombie_var( "tesla_head_gib_chance",	50 );
	set_zombie_var( "tesla_arc_travel_time",	0.5, true );
	set_zombie_var( "tesla_kills_for_powerup",	15 );
	set_zombie_var( "tesla_min_fx_distance",	128 );
	set_zombie_var( "tesla_network_death_choke",4 );

	level thread on_player_connect();
}


/** DOUBLETAP PRO ZOMBIE PENETRATION DAMAGE **/

//Thread called on player

zombie_bullet_penetration( zomb , args )
{
	//Get All zombies on map
	zombies = GetAiSpeciesArray( "axis", "all" );

	//Get player gun angle and position
	view_pos = self GetWeaponMuzzlePoint();
	view_angles = self GetTagAngles( "tag_flash" );

	zombies = GetAiSpeciesArray( "axis", "all" );
	zombies = get_array_of_closest( view_pos, zombies, undefined, undefined, level.THRESHOLD_DBT_MAX_DIST );
	if ( !isDefined( zombies ) )
		return;
	

	forward_view_angles = self GetWeaponForwardDir();
	
	//Filter array by invalid enemies
	for ( i = 0; i < zombies.size; i++ )
	{
		if(self.dbtp_penetrated_zombs >= level.THRESHOLD_DBT_TOTAL_PENN_ZOMBS)
			break;	//no more zombies can be penetrated

		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			// guy died on us
			//iprintln("died");
			continue;
		}
		
		/*
		if( !(zombies[i].animname=="zombie") )
		{
			//iprintln("not zombie");
			//continue;
		}
		*/
		
		if( ( IsDefined(zombies[i].dbtap_marked) && (zombies[i].dbtap_marked == self.entity_num) ) )
		{
			//iprintln("marked");
			continue;
		}
		
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared( view_pos, test_origin );
		if ( test_range_squared > level.THRESHOLD_DBT_MAX_DIST*level.THRESHOLD_DBT_MAX_DIST )
		{
			//iprintln("RANGE");
			break; // everything else in the list will be out of range
		}

		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if ( 0 > dot )
		{
			// guy's behind us
			//iprintln("behind");
			continue;
		}

		if ( !zombies[i] DamageConeTrace( view_pos, self ) && !BulletTracePassed( view_pos, test_origin, false, undefined ) && !SightTracePassed( view_pos, test_origin, false, undefined ) )
		{
			// guy can't actually be hit from where we are
			iprintln("trace not passed");
			continue;
		}
		
		self.dbtp_penetrated_zombs++;
		zombies[i].dbtap_marked = self.entity_num;
		zombies[i] thread process_dbt_penn_dmg( args );
	}

	
	self.dbtp_penetrated_zombs=0;
	zomb.dbtap_marked = -1;	//Not marked for damage for DBtap penetration by any player
}

	//Thread called on zombie
	process_dbt_penn_dmg( args )
	{
		dmg = maps\_zombiemode::actor_damage_override( args.inflictor, args.attacker, args.damage, args.flags, args.meansofdeath, args.weapon, args.vpoint, args.vdir, args.sHitLoc, args.modelIndex, args.psOffsetTime);
		self dodamage( dmg , self.origin, args.attacker );
		self.dbtap_marked = -1;
	}




//##########################

/** EXPLOSIVE EFFECTS **/

//Starts from _zombie_weap_crossbow.gsc -- unused
wait_projectile_impacts() {

	for(;;) {
	
		self waittill ( "projectile_impact", weaponName, position );
		grenade = spawn("script_model", position);
		iprintln("weapon impact: " + weaponName);
		
			switch( weaponName )
			{
				case "crossbow_explosive_upgraded_zm_x2":
					//Reimagined-Expanded - self is money bolt, want to play large explosion
					primaryWeapons = self GetWeaponsListPrimaries();
					for( i=0; i<primaryWeapons.size; i++) 
					{
						if(primaryWeapons[i]=="crossbow_explosive_upgraded_zm_x2") 
						{
							//							(exploding object, radius, time, player)
						level thread napalm_fire_effects( grenade, 80, 4, self );
						}
						
					}
					break;
					
				case "m72_law_upgraded_zm_x2":
					level thread napalm_fire_effects( grenade, 160, 4, self );
				break;
				case "china_lake_upgraded_zm_x2":
					level thread napalm_fire_effects( grenade, 40, 4, self );
				break;
			
		} //end switch

	}
}

explosive_arc_damage( source_enemy, player, arc_num )
{
	player endon( "disconnect" );
	
	player.tesla_enemies = undefined;
	player.tesla_enemies_hit = 1;
	player.tesla_powerup_dropped = false;
	player.tesla_arc_count = 0;


	//tesla_flag_hit( self, true );
	wait_network_frame();

	//Tesla start is 300 radius units, we'll star with 500
	enemies = tesla_get_enemies_in_area( self GetCentroid(), 1000, player );


	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i] thread explosive_do_damage( source_enemy, arc_num, player, 1);
	}
}


explosive_do_damage( source_enemy, arc_num, player, upgraded )
{
	player endon( "disconnect" );

	if ( arc_num > 1 )
	{
		time = RandomFloat( 0.2, 0.6 ) * arc_num;

		if(upgraded)
		{
			time /= 1.5;
		}

		wait time;
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}

	if ( !self.isdog )
	{
		if( self.has_legs )
		{
			self.deathanim = random( level._zombie_tesla_death[self.animname] );
		}
		else
		{
			self.deathanim = random( level._zombie_tesla_crawl_death[self.animname] );
		}
	}
	else
	{
		self.a.nodeath = undefined;
	}

	if( is_true( self.is_traversing))
	{
		self.deathanim = undefined;
	}


	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}


	// use the origin of the arc orginator so it pics the correct death direction anim
	origin = source_enemy.origin;
	

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}

	if(!self.isdog)
	{
		player maps\_zombiemode_score::player_add_points( "death", "", "" );
	}

}


//Explosive Fire Damage + FX _zombiemode_ai_napalm
napalm_fire_effects( grenadeOrAi , radius, time, attacker )
{
	
	
	trigger = spawn( "trigger_radius", grenadeOrAi.origin, 1, radius, 70 );
	if( isAi(grenadeOrAi)) {
		//detotae bomb where zombie died
	} else { //else we wait for the grenade to explode, in the case of crossbow projectile
		grenadeOrAi waittill("explode");
	}
	
	
	sound_ent = spawn( "script_origin", trigger.origin );
	sound_ent playloopsound( "evt_napalm_fire", 1 );
	PlayFx( level._effect["custom_large_explosion"], trigger.origin );
	PlayFX( level._effect["custom_large_fire"], trigger.origin );
					

	if(!isDefined(trigger))
	{
		return;
	}


	trigger.napalm_fire_damage = 40;


	trigger.napalm_fire_damage_type = "burned";
	trigger thread triggerCustomFireDamage(attacker);

	wait(time);
	trigger notify("end_custom_fire_effect");
	trigger Delete();

	if( isdefined( sound_ent ) )
	{
		sound_ent stoploopsound( 1 );
		wait(1);
		sound_ent delete();
	}
}


bonus_fire_damage( zomb , player, radius, time)
{

	//Set zomb on fire
	PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" );
	PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
	self playsound("evt_zombie_ignite");
	
	//Wait for guy to die
	origin = zomb.origin;
	for(;;) {
		if( !IsDefined( self ) || !IsAlive( self ) ) {
		break;
		}
		origin = zomb.origin;
		wait(0.05);
	}
	
	
	//Build trigger where zombie dies to fire
	trigger = spawn( "trigger_radius", origin, 1, radius, 70 );
	
	if(!isDefined(trigger))
	{
		return;
	}

	
	//Spawn fx on trigger
	sound_ent = spawn( "script_origin", trigger.origin );
	sound_ent playloopsound( "evt_napalm_fire", 1 );
	PlayFX( level._effect["custom_med_fire"], trigger.origin );

	trigger.napalm_fire_damage = 40;
	trigger.napalm_fire_damage_type = "hellfire";
	trigger thread triggerCustomFireDamage(player);

	wait(time);
	trigger notify("end_custom_fire_effect");
	trigger Delete();

	if( isdefined( sound_ent ) )
	{
		sound_ent stoploopsound( 1 );
		wait(1);
		sound_ent delete();
	}
}




triggerCustomFireDamage(attacker)
{
	self endon("end_custom_fire_effect");

	while(1)
	{
		self waittill( "trigger", guy );
		if(isplayer(guy))
		{
			if(is_player_valid(guy))
			{
				debounce = 500;
				if(!isDefined(guy.last_napalm_fire_damage))
				{
					guy.last_napalm_fire_damage = -1 * debounce;
				}
				if(guy.last_napalm_fire_damage + debounce < GetTime())
				{
					guy DoDamage( self.napalm_fire_damage, guy.origin, undefined, undefined, undefined );//"triggerhurt"
					guy.last_napalm_fire_damage = GetTime();
				}
			}
		}
		else if(!maps\_zombiemode::is_boss_zombie(self.animname))
		{
			guy thread maps\_zombiemode_ai_napalm::kill_with_fire(self.napalm_fire_damage_type, attacker);
		}
	}
}


/** FREEZE EFFECTS **/
bonus_freeze_damage( zomb, player, radius, time ) 
{
	
	PlayFxOnTag( level._effect[ "freezegun_damage_torso" ], zomb, "J_SpineUpper" );
	
	currentweapon = player GetCurrentWeapon();
	
	view_pos = player GetTagOrigin( "tag_flash" );
	view_angles = player GetTagAngles( "tag_flash" );
	Playfx( level._effect["trail_freezegun_ring_emit"], view_pos, AnglesToForward( view_angles ), AnglesToUp( view_angles ) );
	
	//Get zombies in cone
	zombies = freezegun_get_enemies_in_range();
	new_move_speed="walk";
	
	//Slow zombies
	for ( i = 0; i < zombies.size; i++ ) 
	{
		if ( is_true(zombies[i].zombie_move_speed_supersprint) )
		{
			zombies[i].zombie_move_speed_supersprint = false;
			zombies[i] maps\_zombiemode_spawner::set_zombie_run_cycle( new_move_speed );
		}
		else if ( zombies[i].zombie_move_speed != new_move_speed )
		{
			zombies[i] maps\_zombiemode_spawner::set_zombie_run_cycle( new_move_speed );
		}

		zombies[i].marked_for_freeze = true;
		zombies[i] thread unmark_frozen_zombie();
	}
		
}

//After 5 seconds, unmark zombies for freeze
unmark_frozen_zombie()
{
	wait(5);
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}

	if(isDefined(self.marked_for_freeze)) {
		self.marked_for_freeze = false;
		//make him run again as he thaws out
		self maps\_zombiemode_spawner::set_zombie_run_cycle( self.zombie_move_speed_original );
	}

}

//HERE_
freezegun_get_enemies_in_range() {
	
	inner_range = 100;
	outer_range = 300;
	cylinder_radius = 120;

	view_pos = self GetWeaponMuzzlePoint();

	zombies = GetAiSpeciesArray( "axis", "all" );
	zombies = get_array_of_closest( view_pos, zombies, undefined, undefined, (outer_range * 1.1) );
	if ( !isDefined( zombies ) )
		return;
	

	freezegun_inner_range_squared = inner_range * inner_range;
	freezegun_outer_range_squared = outer_range * outer_range;
	cylinder_radius_squared = cylinder_radius * cylinder_radius;

	forward_view_angles = self GetWeaponForwardDir();
	end_pos = view_pos + vector_scale( forward_view_angles, outer_range );
	
	validZombs = [];
	//Filter array by invalid enemies
	for ( i = 0; i < zombies.size; i++ )
	{
		
		if ( !IsDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
		{
			// guy died on us
			//iprintln("died");
			continue;
		}
		
		if( !(zombies[i].animname=="zombie") )
		{
			//iprintln("not zombie");
			continue;
		}
		
		if(IsDefined(zombies[i].marked_for_freeze) && zombies[i].marked_for_freeze )
		{
			//iprintln("marked for freeze");
			continue;
		}
		

		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared( view_pos, test_origin );
		if ( test_range_squared > freezegun_outer_range_squared )
		{
			return validZombs; // everything else in the list will be out of range
		}

		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if ( 0 > dot )
		{
			// guy's behind us
			continue;
		}

		radial_origin = PointOnSegmentNearestToPoint( view_pos, end_pos, test_origin );
		if ( DistanceSquared( test_origin, radial_origin ) > cylinder_radius_squared )
		{
			// guy's outside the range of the cylinder of effect
			continue;
		}

		if ( !zombies[i] DamageConeTrace( view_pos, self ) && !BulletTracePassed( view_pos, test_origin, false, undefined ) && !SightTracePassed( view_pos, test_origin, false, undefined ) )
		{
			// guy can't actually be hit from where we are
			continue;
		}

		zombies[i].marked_for_freeze = true;
		zombies[i].bonus_fx = true;
		validZombs[validZombs.size] = zombies[i];
	}
	
	return validZombs;
}



/** TESLA EFFECTS **/
tesla_arc_damage( source_enemy, player, distance, arcs )
{
	player endon( "disconnect" );
	
	player.tesla_enemies = undefined;
	player.tesla_enemies_hit = 1;
	player.tesla_powerup_dropped = false;
	player.tesla_arc_count = 0;
	arc_num = 1;


	tesla_flag_hit( self, true );
	wait_network_frame();
	
	enemies = tesla_get_enemies_in_area( self GetCentroid(), distance, player );
	tesla_flag_hit( enemies, true );

	self thread tesla_do_damage( source_enemy, 0, player, 1);
	for( i = 0; i < enemies.size; i++ )
	{
		if( i > arcs )
			return;
		
		if(enemies[i] == self) {
			arcs++; continue;
		}
		
		enemies[i] thread tesla_do_damage( source_enemy, arc_num, player, 1);
		arc_num++;
	}
}



tesla_get_enemies_in_area( origin, distance, player )
{
	/#
		level thread tesla_debug_arc( origin, distance );
	#/

	distance_squared = distance * distance;
	enemies = [];

	//Reimagined-Expanded always get the array please
	//if ( !IsDefined( player.tesla_enemies ) )
	
	player.tesla_enemies = GetAiSpeciesArray( "axis", "all" );
	player.tesla_enemies = get_array_of_closest( origin, player.tesla_enemies );

	zombies = player.tesla_enemies;

	if ( IsDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			 if ( !IsDefined( zombies[i] )  || !IsAlive( zombies[i] ) )
			{
				continue;
			}
			
			if( !maps\_zombiemode::is_boss_zombie(self.animname) )
			{
				//iprintln("boss zombie");
				continue;
			}

			test_origin = zombies[i] GetCentroid();

			
			if ( is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				continue;
			}
			
			if ( DistanceSquared( origin, test_origin ) > distance_squared )
			{
				continue;
			} 
			
			/* if ( IsDefined( zombies[i].zombie_tesla_hit ) && zombies[i].zombie_tesla_hit == true )
			{
				continue;
			}

			if ( !zombies[i] DamageConeTrace(origin, player) && !BulletTracePassed( origin, test_origin, false, undefined ) && !SightTracePassed( origin, test_origin, false, undefined ) )
			{
				iprintln("trace");
				continue;
			} */

			if ( is_true(zombies[i].humangun_zombie_1st_hit_response) )
			{
				continue;
			} 

			zombies[i].bonus_fx=true;
			zombies[i].marked_for_tesla=true;
			enemies[enemies.size] = zombies[i];
		}
	}

	return enemies;
}


tesla_flag_hit( enemy, hit )
{
	if( IsArray( enemy ) )
	{
		for( i = 0; i < enemy.size; i++ )
		{
			enemy[i].zombie_tesla_hit = hit;
		}
	}
	else
	{
		enemy.zombie_tesla_hit = hit;
	}
}


tesla_do_damage( source_enemy, arc_num, player, upgraded )
{
	player endon( "disconnect" );

	if ( arc_num > 1 )
	{
		time = RandomFloat( 0.2, 0.6 ) * arc_num;

		if(upgraded)
		{
			time /= 1.5;
		}

		wait time;
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}

	if ( !self.isdog )
	{
		if( self.has_legs )
		{
			self.deathanim = random( level._zombie_tesla_death[self.animname] );
		}
		else
		{
			self.deathanim = random( level._zombie_tesla_crawl_death[self.animname] );
		}
	}
	else
	{
		self.a.nodeath = undefined;
	}

	if( is_true( self.is_traversing))
	{
		self.deathanim = undefined;
	}

	if( source_enemy != self )
	{
		if ( player.tesla_arc_count > 3 )
		{
			wait_network_frame();
			player.tesla_arc_count = 0;
		}

		player.tesla_arc_count++;
		source_enemy tesla_play_arc_fx( self );
	}

	/*while ( player.tesla_network_death_choke > level.zombie_vars["tesla_network_death_choke"] )
	{
		debug_print( "TESLA: Choking Tesla Damage. Dead enemies this network frame: " + player.tesla_network_death_choke );
		wait( 0.05 );
	}*/

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}

	player.tesla_network_death_choke++;

	self.tesla_death = true;
	self tesla_play_death_fx( arc_num );

	// use the origin of the arc orginator so it pics the correct death direction anim
	origin = source_enemy.origin;
	if ( source_enemy == self || !IsDefined( origin ) )
	{
		origin = player.origin;
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}

	if ( IsDefined( self.tesla_damage_func ) )
	{
		self [[ self.tesla_damage_func ]]( origin, player );
		return;
	}
	else
	{
		self DoDamage( self.health + 666, origin, player );
	}

	if(!self.isdog)
	{
		player maps\_zombiemode_score::player_add_points( "death", "", "" );
	}

// 	if ( !player.tesla_powerup_dropped && player.tesla_enemies_hit >= level.zombie_vars["tesla_kills_for_powerup"] )
// 	{
// 		player.tesla_powerup_dropped = true;
// 		level.zombie_vars["zombie_drop_item"] = 1;
// 		level thread maps\_zombiemode_powerups::powerup_drop( self.origin );
// 	}
}


tesla_play_death_fx( arc_num )
{
	tag = "J_SpineUpper";
	fx = "tesla_shock";

	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	if ( arc_num > 1 )
	{
		fx = "tesla_shock_secondary";
	}

	if(arc_num==0) {
		PlayFxOnTag( level._effect["tesla_shock"], self, tag );
	}
	
	self playsound( "wpn_imp_tesla" );

	if ( IsDefined( self.tesla_head_gib_func ) && !self.head_gibbed )
	{
		[[ self.tesla_head_gib_func ]]();
	}
}


tesla_play_arc_fx( target )
{
	if ( !IsDefined( self ) || !IsDefined( target ) )
	{
		// TODO: can happen on dog exploding death
		wait( level.zombie_vars["tesla_arc_travel_time"] );
		return;
	}
	
	//iprintln("Self and target defined, is tesla_bolt defined: " + IsDefined(level._effect["tesla_bolt"]));

	tag = "J_SpineUpper";

	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	target_tag = "J_SpineUpper";

	if ( target.isdog )
	{
		target_tag = "J_Spine1";
	}

	origin = self GetTagOrigin( tag );
	target_origin = target GetTagOrigin( target_tag );
	distance_squared = level.zombie_vars["tesla_min_fx_distance"] * level.zombie_vars["tesla_min_fx_distance"];

	if ( DistanceSquared( origin, target_origin ) < distance_squared )
	{
		debug_print( "TESLA: Not playing arcing FX. Enemies too close." );
		return;
	}

	fxOrg = Spawn( "script_model", origin );
	fxOrg SetModel( "tag_origin" );

	fx = PlayFxOnTag( level._effect["tesla_bolt"], fxOrg, "tag_origin" );
	playsoundatposition( "wpn_tesla_bounce", fxOrg.origin );

	fxOrg MoveTo( target_origin, level.zombie_vars["tesla_arc_travel_time"] );
	fxOrg waittill( "movedone" );
	fxOrg delete();
}


tesla_debug_arc( origin, distance )
{
/#
	if ( GetDvarInt( #"zombie_debug" ) != 3 )
	{
		return;
	}

	start = GetTime();

	while( GetTime() < start + 3000 )
	{
		drawcylinder( origin, distance, 1 );
		wait( 0.05 );
	}
#/
}


is_tesla_damage( mod )
{
	//iprintln("Is weapon tesla: ");
	//return ( ( IsDefined( self.damageweapon ) && (self.damageweapon == "tesla_gun_zm" || self.damageweapon == "tesla_gun_upgraded_zm" || self.damageweapon == "tesla_gun_powerup_zm" || self.damageweapon == "tesla_gun_powerup_upgraded_zm") ) && ( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" ) );
	return ( ( IsDefined( self.damageweapon ) && (self.damageweapon == "tesla_gun_zm" || self.damageweapon == "tesla_gun_upgraded_zm" || self.damageweapon == "tesla_gun_powerup_zm" || self.damageweapon == "tesla_gun_powerup_upgraded_zm" || self.damageweapon == "knife_ballistic_upgraded_zm_x2")  )  );
}

enemy_killed_by_tesla()
{
	return ( IsDefined( self.tesla_death ) && self.tesla_death == true );

}


on_player_connect()
{
	for( ;; )
	{
		level waittill( "connecting", player );
		player thread tesla_sound_thread();
		//player thread tesla_pvp_thread();
		player thread tesla_network_choke();
	}
}


tesla_sound_thread()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" );

	for( ;; )
	{
		result = self waittill_any_return( "grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback" );

		if ( !IsDefined( result ) )
		{
			continue;
		}

		if( ( result == "weapon_change" || result == "grenade_fire" ) && (self GetCurrentWeapon() == "tesla_gun_zm" || self GetCurrentWeapon() == "tesla_gun_upgraded_zm" || self GetCurrentWeapon() == "tesla_gun_powerup_zm" || self GetCurrentWeapon() == "tesla_gun_powerup_upgraded_zm") )
		{
			self PlayLoopSound( "wpn_tesla_idle", 0.25 );
			//self thread tesla_engine_sweets();
		}
		else
		{
			self notify ("weap_away");
			self StopLoopSound(0.25);
		}
	}
}

tesla_engine_sweets()
{
	self endon( "disconnect" );
	self endon ("weap_away");

	while(1)
	{
		wait(randomintrange(7,15));
		self play_tesla_sound ("wpn_tesla_sweeps_idle");
	}
}



play_tesla_sound(emotion)
{
	self endon( "disconnect" );

	if(!IsDefined (level.one_emo_at_a_time))
	{
		level.one_emo_at_a_time = 0;
		level.var_counter = 0;
	}
	if(level.one_emo_at_a_time == 0)
	{
		level.var_counter ++;
		level.one_emo_at_a_time = 1;
		org = spawn("script_origin", self.origin);
		org LinkTo(self);
		org playsound (emotion, "sound_complete"+ "_"+level.var_counter);
		org waittill("sound_complete"+ "_"+level.var_counter);
		org delete();
		level.one_emo_at_a_time = 0;
	}
}

tesla_killstreak_sound()
{
	self endon( "disconnect" );

	//TUEY Play some dialog if you kick ass with the Tesla gun

	self maps\_zombiemode_audio::create_and_play_dialog( "kill", "tesla" );
	wait(3.5);
	level clientNotify ("TGH");
}


tesla_network_choke()
{
	self endon( "disconnect" );
	self endon( "death" );
	self waittill( "spawned_player" );

	self.tesla_network_death_choke = 0;

	for ( ;; )
	{
		wait_network_frame();
		wait_network_frame();
		self.tesla_network_death_choke = 0;
	}
}
