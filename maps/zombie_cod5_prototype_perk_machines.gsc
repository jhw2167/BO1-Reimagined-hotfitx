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
		jug, revive, DTP
	*/
	register_perk_spawn( ( -800, -111.5, -11 ), ( 0, 90, 0 ) );	

	/*	2
		back wall, up stairs, by stairs
		SPD, MUL
	*/
	register_perk_spawn( ( 241.2, 415, 145.5), ( 0, 90, 0) );

	/*	3
		under stairs, grass covered
		DST, STM, WWN, QRV, PAP
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

		QRV, DBTP, VLT
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
	level.DTP_OPTS = array( 3, 5, 12 );
	level.SPD_OPTS = array( 2, 4, 12 );
	level.QRV_OPTS = array( 1, 3, 10 );
	level.PHD_OPTS = array( 0, 5, 7, 11, 13 );
	level.DST_OPTS = array( 3, 4, 11, 13 );
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
		while( (visited[ choice ] > -1) && tries < MAX_TRIES && choice != 0 ) 
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

solo_quick_revive_disable()
{
	self Unlink();
	self trigger_off();
}
//*/