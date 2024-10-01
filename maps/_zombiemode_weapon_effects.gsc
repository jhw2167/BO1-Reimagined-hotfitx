#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_reimagined_utility;
#include maps\_zombiemode_net;

#using_animtree( "generic_human" );

//Reimagined-Expanded - _zombiemode_effects.gsc custom file for isolating weapon effects for x2 PaP weapons
init()
{
	//These effects always included
	//level._effect["tesla_bolt"]				= loadfx( "maps/zombie/fx_zombie_tesla_bolt_secondary" );
	level._effect["fx_electric_cherry_shock"] = loadfx( "electric_cherry/fx_electric_cherry_shock" );
	level._effect["tesla_bolt"] = level._effect["fx_electric_cherry_shock"];
	
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
	set_zombie_var( "tesla_radius_start",		10000 );		//Reimagined-Expanded up from 300
	set_zombie_var( "tesla_radius_decay",		20 );
	set_zombie_var( "tesla_head_gib_chance",	50 );
	set_zombie_var( "tesla_arc_travel_time",	0.5, true );
	set_zombie_var( "tesla_kills_for_powerup",	15 );
	set_zombie_var( "tesla_min_fx_distance",	128 );
	set_zombie_var( "tesla_network_death_choke",4 );
}

hasProPerk( perk ) {
	return self.PRO_PERKS[ perk ];
}


/** Weapon Effects **/

/*
	Method: handle_double_pap_uzi
	Parameters:
		self - player

	Description:
		Handles the effects of the double PaP Uzi weapon
			self.
*/	
handle_double_pap_uzi( cost )
{

	UZI_WEAPON = "uzi_upgraded_zm_x2";
	current_type = self.weap_options["uzi_upgraded_zm_x2"];

	//Choose new type from following:
	// level.WEAPON_UZI_TYPES = array( "", "Flame", "Freeze", "Shock", "Pestilence" );

	//Build array of valid keys
	keys = [];
	for( i = 1; i < level.WEAPON_UZI_TYPES.size; i++ ) {
		if( i != current_type )
			keys[keys.size] = i;
	}

	new_type = keys[randomInt(keys.size)];
	self.weap_options["uzi_upgraded_zm_x2"] = new_type;

	level.ARRAY_HELLFIRE_WEAPONS = array_remove( level.ARRAY_HELLFIRE_WEAPONS, UZI_WEAPON );
	level.ARRAY_SHEERCOLD_WEAPONS = array_remove( level.ARRAY_SHEERCOLD_WEAPONS, UZI_WEAPON );
	level.ARRAY_ELECTRIC_WEAPONS = array_remove( level.ARRAY_ELECTRIC_WEAPONS, UZI_WEAPON );
	level.ARRAY_POISON_WEAPONS = array_remove( level.ARRAY_POISON_WEAPONS, UZI_WEAPON );

	switch( level.WEAPON_UZI_TYPES[new_type] ) 
	{
		case "Flame":
			level.ARRAY_HELLFIRE_WEAPONS[level.ARRAY_HELLFIRE_WEAPONS.size] = UZI_WEAPON;
			break;
		case "Freeze":
			level.ARRAY_SHEERCOLD_WEAPONS[level.ARRAY_SHEERCOLD_WEAPONS.size] = UZI_WEAPON;
			break;
		case "Shock":
			level.ARRAY_ELECTRIC_WEAPONS[level.ARRAY_ELECTRIC_WEAPONS.size] = UZI_WEAPON;
			break;
		case "Pestilence":
			level.ARRAY_POISON_WEAPONS[level.ARRAY_POISON_WEAPONS.size] = UZI_WEAPON;
			break;

		default:
			iprintln("Invalid uzi weapon type");
			break;
	}

	//Refund the player half the cost of the weapon
	self maps\_zombiemode_score::add_to_player_score( int(cost / 2), true);

	return new_type;
}


/** DOUBLETAP PRO ZOMBIE PENETRATION DAMAGE **/

//Thread called on player

zombie_bullet_penetration( zomb , args, bonus_penn )
{
	if(!IsDefined(bonus_penn))
		bonus_penn = 1;
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
	pre_count = -3;	//Zombies penetrated by the game engine
	for ( i = 0; i < zombies.size; i++ )
	{
		if(self.dbtp_penetrated_zombs >= level.THRESHOLD_DBT_TOTAL_PENN_ZOMBS * bonus_penn) {
			//iprintln("Zombie penetration limit reached");
			break;	//no more zombies can be penetrated
		}
			

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

		if ( !zombies[i] DamageConeTrace( view_pos, self ) || !BulletTracePassed( view_pos, test_origin, false, undefined ) )
		{
			// guy can't actually be hit from where we are
			//iprintln("trace not passed");
			continue;
		}

		//Calculate unit vector between player and zombie
		unit_vector = VectorNormalize( test_origin - view_pos );

		//For each unit of distance between player and zombie, check if there is a zombie within that range
				//Unit of distance: level.VALUE_DBT_UNITS
				//Penn distance: level.VALUE_DBT_PENN_DIST
				//Max distance: level.THRESHOLD_DBT_MAX_DIST

		dist_sq = DistanceSquared( zomb.origin, zombies[i].origin );
		j = level.VALUE_DBT_UNITS;
		j_sqrd = j*j;
		while( j_sqrd < dist_sq ) 
		{
			//Scale unit vector by dist
			scaled_vector = vector_scale( unit_vector, j );
			//Add to zomb position
			test_pos = zomb.origin + scaled_vector;
			//Check if there is a zombie within that range
			if( checkDist( zombies[i].origin, test_pos, level.VALUE_DBT_PENN_DIST ) ) {
				break;
			}
			j+=level.VALUE_DBT_UNITS;
			j_sqrd = j*j;
		}
 
		if( j*j >= dist_sq ) {
			continue;
		}

		//iprintln("Penn zombie " + pre_count + " PENN ZOMBS " + self.dbtp_penetrated_zombs);
		if(pre_count < 0) {
			pre_count++;
			continue;
		}
		pre_count++;

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

	watch_place_bottle(origin)
	{
		machine_angles = (0, 135, 0);
		bottle = Spawn( "script_model", origin );
		bottle.angles = machine_angles;
		bottle setModel( "t6_wpn_zmb_perk_bottle_jugg_world" );

		wait(5);
		bottle Delete();
	}




//##########################

/** EXPLOSIVE EFFECTS **/


checkDist(a, b, distance )
{
	return maps\_zombiemode::checkDist( a, b, distance );
}


//Starts from _zombie_weap_crossbow.gsc
wait_projectile_impacts() {

	for(;;) 
	{
	
		self waittill ( "grenade_fire", grenade, weaponName, parent );
		
			switch( weaponName )
			{
				case "explosive_bolt_upgraded_zm":
					//Reimagined-Expanded - self is money bolt, want to play large explosion
					primaryWeapons = self GetWeaponsListPrimaries();
					for( i=0; i<primaryWeapons.size; i++) 
					{
						weapon = self get_upgraded_weapon_string( primaryWeapons[i] );
						if( weapon == "crossbow_explosive_upgraded_zm_x2" ) 
						{
							self thread handle_crossbow_x2_bolt( grenade );
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

/*
	Method: handle_crossbow_x2_bolt

	Descrp: The crossbow bolt lasts 12 seconds and plays a napalm exlposion every 3 seconds

	params: self is player

*/
handle_crossbow_x2_bolt( grenade )
{

	TOTAL_CROSSBOW_TIME = 12;
	blast_interval = 3.9;

	grenadeFinishPos = grenade.origin;
	level thread napalm_fire_effects( grenade, 396, 2, self, 3 );
	grenade waittill("explode");
	
	while( TOTAL_CROSSBOW_TIME > 0 )
	{
		explosionSource = Spawn( "script_origin", grenadeFinishPos );
		explosionSource SetModel( "tag_origin" );
		explosionSource thread maps\_zombiemode_weap_crossbow::crossbow_monkey_bolt( self );
		level thread napalm_fire_effects( explosionSource, 396, 3, self, 3 );
		wait( blast_interval );
		explosionSource notify( "explode" );
		TOTAL_CROSSBOW_TIME -= blast_interval;
	}
	
}

explosive_arc_damage( zomb , dmg, radius, time )
{

	self endon( "disconnect" );
	

	//Tesla start is 300 radius units, we'll star with 500
	enemies = get_array_of_closest( zomb.origin, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, radius );


	for( i = 0; i < enemies.size; i++ )
	{
		//source object must have origin
		if(!IsDefined(self.explosive_marked) || !self.explosive_marked) 
		{
			self.explosive_marked = true;
			enemies[i] thread explosive_do_damage( dmg, zomb, radius, self );
		}
		
	}
}


explosive_do_damage( dmg, source, radius, player )
{
	player endon( "disconnect" );

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}
	inner_radius = radius/2;

	if( checkDist(self.origin, source.origin, radius / 2) )
		self doDamage( dmg, self.origin, player );
	else if( checkDist(self.origin, source.origin, radius) )
		self doDamage( dmg / 2, self.origin, player );
	else 
		self.explosive_marked = false;

	wait(0.5);
	self.explosive_marked = false;

}


//Explosive Fire Damage + FX _zombiemode_ai_napalm
napalm_fire_effects( grenadeOrAi , radius, time, attacker, fxTime )
{
	
	
	trigger = Spawn( "trigger_radius", grenadeOrAi.origin, 1, radius, 70 );
	if( isAi(grenadeOrAi)) {
		//detotae bomb where zombie died
	} else { //else we wait for the grenade to explode, in the case of crossbow projectile
		iprintln("Waiting for grenade to explode -- napalm_fire_effects");
		grenadeOrAi waittill("explode");
	}
	
	grenadeOrAi Delete();
	
	sound_ent = spawn( "script_origin", trigger.origin );
	sound_ent playloopsound( "evt_napalm_fire", 1 );
	fxModel = Spawn( "script_model", trigger.origin );
	fxModel SetModel( "tag_origin" );
	PlayFxOnTag( level._effect["custom_large_explosion"], fxModel, "tag_origin" );
	PlayFxOnTag( level._effect["custom_large_fire"], fxModel, "tag_origin" );
	//PlayFX( level._effect["custom_large_fire"], trigger.origin );
	
	self thread cleanupFx( fxModel, fxTime );

	if(!isDefined(trigger))
	{
		sound_ent delete();
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

cleanupFx( fxModel, fxTime )
{
	wait(fxTime);
	fxModel Delete();
}

bonus_fire_damage( zomb , player, radius, time)
{
	// \give ak47_ft_upgraded_zm_x2
	// \give rottweil72_upgraded_zm
	if( !isDefined( radius ) )
		radius = 0;

	if( !isDefined( self ) 
		|| !IsAlive( self ) 
		|| self.animname == "zombie_dog"
		|| is_true( self.burned )
		) {
		//Dead or in water
		return;
	}

	if( is_true( self.in_water ) )
	{
		self.burned = false;
		return;
	}

	//Set zomb on fire
	self.burned = true;
	PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" );
	PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
	self playsound("evt_zombie_ignite");
	
	//Wait for guy to die
	self thread delayed_bonus_fire_damage( player );

	origin = self.origin;
	while( IsAlive( self ) ) 
	{	
		origin = self.origin;
		if( !IsDefined( self ) )
			return;
		wait(0.1);
	}
	
	
	//Build trigger where zombie dies to fire
	trigger = spawn( "trigger_radius", origin, 1, radius, 70 );
	
	if(!isDefined(trigger) || radius == 0)
	{
		trigger Delete();
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

delayed_bonus_fire_damage( player )
{
	time=0;
	inc = level.THRESHOLD_HELLFIRE_KILL_TIME / 16;
	while( time < level.THRESHOLD_HELLFIRE_KILL_TIME )
	{
		if( !IsDefined( self ) || !IsAlive( self ) || is_true( self.in_water ) )
			return;
			
		self DoDamage( int( self.maxHealth / 16 ), self.origin );	
		time+=inc;
		wait(inc);
	}
	
	self DoDamage( self.maxHealth + 1000, self.origin, player );	
}



triggerCustomFireDamage(attacker)
{
	self endon("end_custom_fire_effect");

	while(1)
	{
		self waittill( "trigger", guy );

		if( !IsDefined( guy ) || !IsAlive( guy ) )
			continue;

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
		else if( IsDefined( guy.animname ) && guy.animname == "zombie" )
		{
			guy thread bonus_fire_damage( guy, attacker, 2, 2 );
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
		
		// \give galil_upgraded_zm_x2
		// \give spectre_upgraded_zm_x2
	
	PlayFxOnTag( level._effect[ "freezegun_damage_torso" ], zomb, "J_SpineUpper" );
	
	currentweapon = player GetCurrentWeapon();
	
	view_pos = player GetTagOrigin( "tag_flash" );
	view_angles = player GetTagAngles( "tag_flash" );
	Playfx( level._effect["trail_freezegun_ring_emit"], view_pos, AnglesToForward( view_angles ), AnglesToUp( view_angles ) );
	
	//Get zombies in cone
	zombies = freezegun_get_enemies_in_range();
	new_move_speed="walk";

		total_sheercold_time = level.THRESHOLD_SHEERCOLD_ZOMBIE_THAW_TIME;
		if( player hasProPerk(level.DBT_PRO) )
			total_sheercold_time *= 2;
	
	//Slow zombies
	for ( i = 0; i < zombies.size; i++ ) 
	{
		zombies[i] thread slow_zombie_over_time( total_sheercold_time, new_move_speed);
	}
		
}

	slow_zombie_over_time( duration, new_move_speed )
	{
		if( !isDefined( self ) || !IsAlive( self ) )
			return;

		if( !isDefined( new_move_speed ) )
			new_move_speed = "walk";

		if( !IsDefined( duration )  )
			duration = 60;

		if ( is_true(self.zombie_move_speed_supersprint) )
		{
			self.zombie_move_speed_supersprint = false;
			self maps\_zombiemode_spawner::set_zombie_run_cycle( new_move_speed );
			self.marked_for_freeze = true;
		}
		else if ( self.zombie_move_speed != new_move_speed )
		{
			self maps\_zombiemode_spawner::set_zombie_run_cycle( new_move_speed );
			self.marked_for_freeze = true;
		}

		self thread unmark_frozen_zombie( duration );
	}

	//After a few seconds, unmark zombies for freeze
	unmark_frozen_zombie( zombie_thaw_time )
	{
		if( !IsDefined(self) || !IsDefined( zombie_thaw_time ) )
			return;

		//Use while loop to wait for the time to pass
		interval = 0.5;
		while( zombie_thaw_time > 0 )
		{
			wait( interval );
			zombie_thaw_time -= interval; 
			condition = ( zombie_thaw_time > 0 ) || !IsDefined( self ) || !IsAlive( self );
		}

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
	self endon( "death" );
	
	arc_num = 1;

	//wait_network_frame();
	
	enemies = tesla_get_enemies_in_area( source_enemy.origin, distance, player );
	if( !self.marked_for_tesla )
	{
		source_enemy thread unmark_for_tesla( level.THRESHOLD_TESLA_SHOCK_TIME );
		source_enemy thread tesla_do_damage( source_enemy, 0, player, 1);
	}
	else
	{
		source_enemy thread tesla_play_death_fx( arc_num );
	}
		
	
	for( i = 0; i < enemies.size; i++ )
	{
		if( enemies[i].marked_for_tesla )
		{
			enemies[i] thread tesla_play_death_fx( arc_num );
			continue;
		}

		if( arc_num > arcs ) {
			break;
		}
		
		if(enemies[i] == source_enemy) {
			continue;
		}
		
		enemies[i] thread tesla_do_damage( source_enemy, arc_num, player, 1);
		enemies[i] thread unmark_for_tesla( level.THRESHOLD_TESLA_SHOCK_TIME );
		arc_num++;
	}
	
}

unmark_for_tesla( time )
{
	wait( time );
	if( IsDefined( self ) && IsAlive( self ) )
		self.marked_for_tesla = false;
}



tesla_get_enemies_in_area( origin, distance, player )
{
	distance_squared = distance * distance;
	enemies = [];
	
	zombies = get_array_of_closest( origin, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, distance );

	if ( IsDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			 if ( !IsDefined( zombies[i] )  || !IsAlive( zombies[i] ) || zombies[i].marked_for_tesla )
			{
				//iprintln("dead zombie");
				continue;
			}
			
			if( maps\_zombiemode::is_boss_zombie( zombies[i].animname ) )
			{
				continue;
			}

			
			if ( is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				//iprintln("bullet shield zombie");
				continue;
			}
			
			
			if ( DistanceSquared( origin, zombies[i].origin ) > distance_squared )
			{
				//iprintln("out of range zombie");
				continue;
			} 
			
			if ( IsDefined( zombies[i].zombie_tesla_hit ) && zombies[i].zombie_tesla_hit == true )
			{
				//iprintln("tesla zombie");
				continue;
			}

			zombies[i].bonus_fx=true;
			enemies[enemies.size] = zombies[i];
		}
	}

	return enemies;
}


tesla_do_damage( source_enemy, arc_num, player, upgraded )
{
	player endon( "disconnect" );

	if ( arc_num > 1 )
	{
		time = RandomFloat( 0.2, 0.6 ) * arc_num;
		time /= 1.5;

		wait time;
	}

	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		// guy died on us
		return;
	}


	if( source_enemy != self )
	{
		source_enemy tesla_play_arc_fx( self );
	}

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

	dmg = self.health + 666;
	if( arc_num > 0)
		dmg = level.THRESHOLD_MAX_ZOMBIE_HEALTH / arc_num;

	if( self.health <= dmg ) 
	{
		self thread maps\_zombiemode_perks::electric_cherry_death_fx();

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
	}
	else 
	{

		self thread maps\_zombiemode_perks::electric_cherry_stun();
		self thread maps\_zombiemode_perks::electric_cherry_shock_fx();

	}

	self.marked_for_tesla=true;
	self DoDamage( dmg , origin, player );


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
	//fx = "tesla_shock";
	fx = "fx_electric_cherry_shock";

	// \give knife_ballistic_upgraded_zm_x2
	// \give aug_acog_mk_upgraded_zm_x2
	// \give cz75_upgraded_zm_x2

	if ( self.isdog )
	{
		tag = "J_Spine1";
	}

	//iprintln("Play texla death fx");
	PlayFxOnTag( level._effect[fx], self, tag );

	
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

	PlayFxOnTag( level._effect["tesla_bolt"], fxOrg, "tag_origin" );
	playsoundatposition( "wpn_tesla_bounce", fxOrg.origin );

	fxOrg MoveTo( target_origin, level.zombie_vars["tesla_arc_travel_time"] );
	fxOrg waittill( "movedone" );
	fxOrg delete();
}