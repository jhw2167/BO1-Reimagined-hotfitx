#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

init()
{
	place_babyjug();

	//level._effect[ "lightning_dog_spawn" ] = LoadFX( "maps/zombie/fx_zombie_dog_lightning_buildup" );
	//register_perk_spawn( ( -160, -528, 1 ), ( 0, 0, 0 ) );
	//register_perk_spawn( ( 443.7, 641.1, 144.1 ), ( 0, -180, 0 ) );
	//register_perk_spawn( ( 510.3, 645.9, 1.1 ), ( 0, -180, 0 ) );
	//register_perk_spawn( ( 170.8, 326.1, 145.1 ), ( 0, 0, 0 ) );


	/*	0
		truck, move over 5 for fatter model
		jug, PHD
	*/
	register_perk_spawn( ( -412.2, 150.4, 37.7 ), ( 5, -49, 0 ) );	

	/*	1
		truck, wall smoke
		jug, revive, DBT
	*/
	register_perk_spawn( ( -795, -91.5, -11 ), ( 0, 90, 0 ) );	

	/*	2
		back wall, up stairs, by stairs
		SPD, MUL
	*/
	register_perk_spawn( ( 241.2, 415, 145.5), ( 0, 90, 0) );

	/*	3
		under stairs, grass covered
		DBT, STM, WWN, QRV, PAP
		DBT -15x
	*/
	register_perk_spawn( ( 365, 515.5, 5), ( 0, 90, 0) ); //95

	/*	4
		far out by tree, spawn facing direction

		DST, WWN, SPD, PAP
	*/
	register_perk_spawn( ( -2097, -120, -129), ( 0, 71, 0) ); 

	/*	5
		Right next to window, yellow flame

		DBT, PHD, STM, ECH
		DBT -15x
	*/
	register_perk_spawn( ( 1070, 808 , 2), ( 0, 90, 0) ); //Maybe back X a bit

	/*	6
		Laying down in the grass, opposite spawn face

		JUG, VLT
	*/
	register_perk_spawn( ( 939, 25, 18 ), ( -19, -98, -65) ); //95

	/*	7
		By stairs

		PHD, WWN
	*/
	register_perk_spawn( ( 292, 27, 7 ), ( 0, 0, 0) );

	/*	8
		By Second truck, turned on its side

		ECH, STM
	*/
	register_perk_spawn( ( -534, -670 , -15 ), ( 86, -45, 0) );


	/*	9
		Behind first fence, between trucks

		VLT, ECH, PHD
	*/
	register_perk_spawn( ( -798, -320 , 0 ), ( 7.5, 0, 0) );

	/*	10
		Far side first fence, corner, right of initial outside area

		QRV, PAP, VLT
	*/
	register_perk_spawn( ( -525, 861 , -5 ), ( 0, 0, 0) );

	/*	11
		Upstairs, sandbag corner

		DS, PHD, STM
	*/
	register_perk_spawn( ( 995.6, 652, 146 ), ( 0, 220, 0) ); 

	/*
		12
		Downstairs, mule corner

		mule, speed, STM
	*/
	register_perk_spawn( ( -160, -528, 1 ), ( 0, 0, 0) );

	/*
		13
		Empty Road

		DST, VLT, PAP, PHD
	*/
	register_perk_spawn( ( 1254, -1174, 50 ), ( 0, 210, 0) );

	/*
		14
		Deep Forest

		JUG, MUL, WWN
	*/
	register_perk_spawn( ( 2571, 8, 153 ), ( 0, -55, 0) );

	//Available Options
	level.JUG_OPTS = array( 0, 1, 6, 14 );
	level.DTP_OPTS = array( 1, 3, 5 );
	level.SPD_OPTS = array( 2, 4, 12 );
	level.QRV_OPTS = array( 1, 3, 10, 12 );
	level.PHD_OPTS = array( 0, 5, 7, 11, 13 );
	level.DST_OPTS = array( 4, 11, 13 );
	level.STM_OPTS = array( 3, 5, 8, 11, 12 );

	level.VLT_OPTS = array( 6, 9, 10 );
	level.WWN_OPTS = array( 3, 4, 7, 14 );
	level.ECH_OPTS = array( 5, 8, 9 );
	level.MUL_OPTS = array( 2, 12, 14 );

	level.PAP_OPTS = array( 1, 3, 4, 10, 13 );

	level.loc_notes = array( "Truck, move over 5 for fatter model", "Truck, wall smoke", "Back wall, up stairs, by stairs",
			 "Under stairs, grass covered", "Far out by tree, spawn facing direction", "Right next to window, yellow flame",
			 "Laying down in the grass, opposite spawn face", "By stairs", "By Second truck, turned on its side", 
			  "Behind first fence, between trucks", "Far side first fence, corner, right of initial outside area", 
			  "Upstairs, sandbag corner", "Downstairs, mule corner", "Empty Road", "Deep Forest" );


	level thread randomize_perks_think();
	level thread handle_nacht_powerswitch();
}

place_babyjug()
{
	machine_origin = (308, 241, 62);
	machine_angles = (0, 280, 0);
	bottle = Spawn( "script_model", machine_origin );
	bottle.angles = machine_angles;
	bottle setModel( "t6_wpn_zmb_perk_bottle_jugg_world" );

	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 0), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_babyjugg";
	perk_trigger.script_noteworthy = "specialty_extraammo";

}

register_perk_spawn( origin, angles )
{
	if( !IsDefined( level.perk_spawn_location ) )
	{
		level.perk_spawn_location = [];
	}
	perk_clip = Spawn( "script_model", origin );
	perk_clip.angles = angles;
	perk_clip SetModel( "collision_geo_64x64x64" );
	perk_clip Hide();
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	struct = SpawnStruct();
	struct.origin = origin;
	struct.angles = angles;
	level.perk_spawn_location[ level.perk_spawn_location.size ] = struct;
}

spawn_perk( model, spawnPointIndex, targetname, target, perk, jingle, sting )
{
	if( spawnPointIndex < 0 )	
		return;
	
	iprintln( "Spawning " + model + " at " + spawnPointIndex + " loc:" + level.loc_notes[ spawnPointIndex ] );

	/* Adjustments */

	//If doubletap is in position 3 or 5, move it back 10 units
	if( model == "zombie_vending_doubletap2" )
	{
		origin = level.perk_spawn_location[ spawnPointIndex ].origin;
		level.perk_spawn_location[ spawnPointIndex ].origin = ( origin[0] - 15, origin[1], origin[2] );
	}

	/* ############ */

	//machine = Spawn( "script_model", ( 0, 0, -9999 ) );
	machine = Spawn( "script_model", level.perk_spawn_location[ spawnPointIndex ].origin );
	machine.angles = level.perk_spawn_location[ spawnPointIndex ].angles;
	machine SetModel( model );
	machine.targetname = target;
	trigger = Spawn( "trigger_radius_use", machine.origin + ( 0, 0, 30 ), 0, 20, 70 );
	trigger.targetname = targetname;
	trigger.target = target;
	trigger.script_noteworthy = perk;
	trigger.script_sound = jingle;
	trigger.script_label = sting;

	
	if( spawnPointIndex == 12 || spawnPointIndex == 11 ) {
		//If perk is in position inside the map, skip this and never turn off
	}
	else
	{
		trigger thread watch_perk_off( machine, model, perk, machine.targetname );
	}
		
}

/*
	Methods: watch_perk_off

	Descr: 
		- Turns perks on when radio is active
		- Turns perks off when radio is inactive
			- Reverts hint string to default
			- Sets off model back

		- self is trigger
*/

watch_perk_off( machine, model, perk, machinetargetname )
{
	level endon( "intermission" );

	firstTime = true;
	while( 1 )
	{
		while( !IsDefined( level.radio_activated) ) {
			wait( 0.1 );
		}


		while( !level.radio_activated ) {
			wait( 0.1 );
		}

		if( firstTime ) {
			firstTime = false;
			continue;
		}

		activate_zombie_vending( model );
		self maps\zombie_cod5_sumpf_perks::set_perk_buystring( perk );

		while( level.radio_activated ) {
			wait( 0.1 );
		}

		//Turn perk off
		level notify( machinetargetname + "_off" );
		self SetHintString( &"ZOMBIE_NEED_POWER" );
		machine SetModel( model );	
	}
	
}

/*
	Methods: activate_zombie_vending

	Descr: Activates the specified vending machine, turning on the perk
		- Calls the appropriate method to turn on the perk
		- If the model is not found, prints an error message
*/

activate_zombie_vending( model )
{
	switch( model )
	{
		case "zombie_vending_revive":
			level thread maps\_zombiemode_perks::turn_revive_on();
			break;

		case "zombie_vending_jugg":
			level thread maps\_zombiemode_perks::turn_jugger_on();
			break;

		case "zombie_vending_doubletap2":
		case "zombie_vending_doubletap":
			level thread maps\_zombiemode_perks::turn_doubletap_on();
			break;

		case "zombie_vending_sleight":
			level thread maps\_zombiemode_perks::turn_sleight_on();
			break;

		case "zombie_vending_marathon":
			level thread maps\_zombiemode_perks::turn_marathon_on();
			break;

		case "zombie_vending_three_gun":
			level thread maps\_zombiemode_perks::turn_additionalprimaryweapon_on();
			break;

		case "zombie_vending_ads":
			level thread maps\_zombiemode_perks::turn_deadshot_on();
			break;

		case "zombie_vending_nuke":
			level thread maps\_zombiemode_perks::turn_divetonuke_on();
			break;

		case "p6_zm_vending_electric_cherry":
			level thread maps\_zombiemode_perks::turn_electriccherry_on();
			break;

		case "bo2_zombie_vending_vultureaid":
			level thread maps\_zombiemode_perks::turn_vulture_on();
			break;

		case "bo3_p7_zm_vending_widows_wine":
			level thread maps\_zombiemode_perks::turn_widowswine_on();
			break;

		case "zombie_vending_packapunch":
			level thread maps\_zombiemode_perks::turn_PackAPunch_on();
			break;

		default:
			iprintln( "activate_zombie_vending: " + model + " not found" );
			break;
	}

}

///*

randomize_perks_think()
{


	/*
		Write an algorithm that choices a random number from each array, ensure there are no duplicates chosen
		then spawn the perks in the order of the random numbers

		Start with mule since he only has 2 options

		palcements - perk[0] will be placed at placements[0] which corresponds to a relevant perk register spawn
		visited - 
	*/

	data = array( level.MUL_OPTS, level.JUG_OPTS, level.DTP_OPTS, level.VLT_OPTS,
  				  level.SPD_OPTS, level.QRV_OPTS, level.DST_OPTS, level.WWN_OPTS,
				  level.ECH_OPTS, level.PAP_OPTS, level.PHD_OPTS, level.STM_OPTS );


	//Default Options
	placements = [];
	visited = [];
	total_placements = 15;
	for( i = 0; i < total_placements; i++ ) 
	{
		placements[ i ] = -1;	//only 11 perks + pap
		visited[ i ] = -1;		//15 nodes could be visited
	}


	MAX_TRIES = 10;
	for( i = 0; i < data.size; i++ ) 
	{
		tries = 0;
		choice = array_randomize( data[ i ] )[0];
		while( (visited[ choice ] > -1) && tries < MAX_TRIES ) 
		{
			choice = array_randomize( data[ i ] )[0];
			tries++;
		}
		if( tries >= MAX_TRIES )
		{
			iprintln( "Failed to randomize perk " + i );
		}
		else
		{
			visited[ choice ] = i;
			placements[ i ] = choice;
		}
		
	}

	j = 0;

	spawn_perk( "zombie_vending_three_gun", placements[j] , "zombie_vending", "vending_additionalprimaryweapon", "specialty_additionalprimaryweapon", "mus_perks_mulekick_jingle", "mus_perks_mulekick_sting" ); j++;
	spawn_perk( "zombie_vending_jugg", placements[j], "zombie_vending", "vending_jugg", "specialty_armorvest", "mus_perks_jugganog_jingle", "mus_perks_jugganog_sting" ); j++;
	spawn_perk( "zombie_vending_doubletap2", placements[j], "zombie_vending", "vending_doubletap", "specialty_rof", "mus_perks_doubletap_jingle", "mus_perks_doubletap_sting" ); j++;
	spawn_perk( "bo2_zombie_vending_vultureaid", placements[j], "zombie_vending", "vending_vulture", "specialty_altmelee", "mus_perks_vulture_jingle", "mus_perks_vulture_sting" ); j++;
	spawn_perk( "zombie_vending_sleight", placements[j], "zombie_vending", "vending_sleight", "specialty_fastreload", "mus_perks_speed_jingle", "mus_perks_speed_sting" ); j++;
	spawn_perk( "zombie_vending_revive", placements[j], "zombie_vending", "vending_revive", "specialty_quickrevive", "mus_perks_revive_jingle", "mus_perks_revive_sting" ); j++;
	spawn_perk( "zombie_vending_ads", placements[j], "zombie_vending", "vending_deadshot", "specialty_deadshot", "mus_perks_deadshot_jingle", "mus_perks_deadshot_sting" ); j++;
	
	spawn_perk( "bo3_p7_zm_vending_widows_wine_off", placements[j], "zombie_vending", "vending_widowswine", "specialty_bulletaccuracy", "mus_perks_widows_jingle", "mus_perks_widows_sting" ); j++;
	spawn_perk( "p6_zm_vending_electric_cherry_off", placements[j], "zombie_vending", "vending_electriccherry", "specialty_bulletdamage", "mus_perks_cherry_jingle", "mus_perks_cherry_sting" ); j++;
	
	spawn_perk( "zombie_vending_packapunch", placements[j], "zombie_vending_upgrade", "vending_packapunch", "specialty_weapupgrade", "mus_perks_packa_jingle", "mus_perks_packa_sting" ); j++;
	spawn_perk( "zombie_vending_nuke", placements[j], "zombie_vending", "vending_divetonuke", "specialty_flakjacket", "mus_perks_phd_jingle", "mus_perks_phd_sting" ); j++;
	spawn_perk( "zombie_vending_marathon", placements[j], "zombie_vending", "vending_marathon", "specialty_longersprint", "mus_perks_stamin_jingle", "mus_perks_stamin_sting" ); j++;

}


/*
	Method: handle_nacht_powerswitch
	Tags: Natch, power, power_switch, nach_power_switch

	Desc: Spawns power switch at specified location, player turns it on, they are teleported outside 
		to try and get some perks
		- Lasts 10 seconds, then TP back in
		- Switch used once per round
		- Switch reset to off after each round

*/
handle_nacht_powerswitch()
{
	//PreCacheModel( "zombie_power_lever_handle" );

	flag_wait("begin_spawning");

	wait(5);
	iprintln( "Spawning power switch" );

	/*
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );

	//print out size of weapon spawns
	iprintln( "Weapon Spawns: " + weapon_spawns.size );

	//Spawn power switch
	wep_spawn = array_randomize( weapon_spawns )[0];
	spawn_loc = wep_spawn.origin;
	iprintln( "Chosen switch loc: " + wep_spawn.zombie_weapon_upgrade );
	spawn_loc = (-170, -306, 67);
	trigger = Spawn( "trigger_radius_use", spawn_loc , 0, 20, 70 );
	power_panel = Spawn( "script_model", spawn_loc - (0, 0, 20) );
	power_panel SetModel( "p6_zm_buildable_pswitch_body" );
	//power_panel SetModel( "zombie_vending_jugg" );

	power_switch = Spawn( "script_model", spawn_loc );
	//power_switch SetModel( "p6_zm_buildable_pswitch_lever" );
	power_switch SetModel( "zombie_power_lever_handle" );
	
	
	trigger sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	trigger SetCursorHint( "HINT_NOICON" );

	trigger waittill("trigger",user);
	//master_switch rotatepitch(90,1);
	power_switch rotateroll(-90,.3);
	*/

	/* Spawn powerup light on the radios */

	radio_locs = array( 
		//( 78, -496, 40 )
		( -194, 898, 36 )
		//, ( 0, 0, 0 ) 
		);

	tp_locs = array( ( -655, 79, 10 ) 
					,( -585, -1242, 0 )
					,( 719, -722, 0 ) 
					,( 1686, 259, 0 )
					);

	while(1)
	{

		level waittill("start_of_round");
		dev = is_true( level.dev_only );
		if( level.round_number < 10 && !dev )
			continue;

		wait_time = 1;
		if( !dev )
		{
			wait_time = RandomIntRange( 10, 30 );
		}

		wait( wait_time );

		spawn_loc = array_randomize( radio_locs )[0];
		trigger = Spawn( "trigger_radius_use", spawn_loc , 0, 20, 70 );
		trigger sethintstring(&"REIMAGINED_NACHT_POWER");
		trigger SetCursorHint( "HINT_NOICON" );

		level.radio_activated = false;
		level thread play_radio_fx( spawn_loc );
		
		trigger waittill("trigger", player);
		trigger Delete();

		level.radio_activated = true;
		level notify( "juggernog_on" );	//turns all perks on

		/*	Teleport player	*/
		player do_player_teleport( array_randomize( tp_locs )[0] );

		//level notify( "perks_swapping" );
		level.radio_activated = false;
		

	}

	

	//power_switch waittill("rotatedone");
	//playfx(level._effect["switch_sparks"] ,getstruct("switch_fx","targetname").origin);

}

play_radio_fx( spawn_loc )
{
	while( !level.radio_activated )
	{
		model = Spawn( "script_model", spawn_loc );
		model setModel( "tag_origin" );
		//PlayFXOnTag( level._effect["powerup_on_solo"], model, "tag_origin" );
		PlayFx( level._effect["powerup_grabbed_solo"], spawn_loc );
		wait( .5 );

		model Delete();

		wait(2);
	}

}

do_player_teleport( loc )
{
	destination = SpawnStruct();

	destination.origin = loc;
	destination.angles = self.angles;

	respawn = SpawnStruct();
	respawn.origin = self.origin + (0, 0, 5);


	level.pap_moving = false;
	//self.ignoreme = true;
	self maps\_zombiemode_weap_black_hole_bomb::black_hole_teleport( destination, true );	

	wait(15);

	//while pap in use, dont tp
	while( flag("pack_machine_in_use") ) {
		wait 0.5;
	}

	level.pap_moving = true;

	respawn.angles = self GetPlayerAngles();

	self maps\_zombiemode_weap_black_hole_bomb::black_hole_teleport( respawn, true );
	self VisionSetNaked( level.zombie_visionset, 0.5 );
	wait 0.5;
	//self.ignoreme = false;
	//wait(2);

}	

perk_swap_fx( perk )
{
	level waittill( "perks_swapping" );
	level.perk_randomization_on[ perk ] = false;
	fake_perk = Spawn( "script_model", self.origin );
	fake_perk.angles = self.angles;
	fake_perk SetModel( self.model );
	self.origin = ( 0, 0, -9999 );
	self.angles = ( 0, 0, 0 );
	direction = fake_perk.origin;
	direction = ( direction[1], direction[0], 0 );
	if( direction[1] < 0 || ( direction[0] > 0 && direction[1] > 0 ) )
	{
		direction = ( direction[0], direction[1] * -1, 0 );
	}
	else if( direction[0] < 0 )
	{
		direction = ( direction[0] * -1, direction[1], 0 );
	}
	fake_perk PlaySound( "zmb_box_move" );
	fake_perk MoveTo( fake_perk.origin + ( 0, 0, 40 ), 3 );
	fake_perk Vibrate( direction, 10, 0.5, 5 );
	fake_perk waittill( "movedone" );
	PlayFX( level._effect[ "poltergeist" ], fake_perk.origin );
	PlaySoundAtPosition( "zmb_box_poof", fake_perk.origin );
	fake_perk Delete();
}

//*
hellhound_spawn_fx( origin )
{
	//PlayFX( level._effect[ "lightning_dog_spawn" ], origin );
	PlaySoundAtPosition( "zmb_hellhound_prespawn", origin );
	wait 1.5;
	PlaySoundAtPosition( "zmb_hellhound_bolt", origin );
	Earthquake( 0.5, 0.75, origin, 1000 );
	PlayRumbleOnPosition( "explosion_generic", origin );
	PlaySoundAtPosition( "zmb_hellhound_spawn", origin );
}

//*/