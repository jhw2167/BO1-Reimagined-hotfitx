#include maps\_utility;
#include common_scripts\utility;
/*
init()
{		
	place_babyjug();

	//place_divetonuke();
	//place_deadshot();	
	//place_marathon();		
	//place_martyrdom();	
	//place_extraammo();		
	//place_chugabud();
	//place_mulekick();
	//place_vulture();	
}

place_divetonuke(machine_origin,  machine_angles)
{
	//machine_origin = (11205.7, 3390.3, -657.9);
	//machine_angles = (0, 315, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_nuke_on" );
	perk.targetname = "vending_divetonuke";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_divetonuke";
	perk_trigger.script_noteworthy = "specialty_flakjacket";
	perk_trigger.script_sound = "mus_perks_phd_jingle";
	perk_trigger.script_label = "mus_perks_phd_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );

	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_deadshot(machine_origin,  machine_angles)
{
	//machine_origin = (10129.6, 1409.9, -528.9);
	//machine_angles = (0, 90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_ads_on" );
	perk.targetname = "vending_deadshot";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_deadshot";
	perk_trigger.script_noteworthy = "specialty_deadshot";
	perk_trigger.script_sound = "mus_perks_deadshot_jingle";
	perk_trigger.script_label = "mus_perks_deadshot_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";


	level waittill( "perk_moved" );

	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_marathon(machine_origin,  machine_angles)
{
	//machine_origin = (8034.5, 138.0, -707.9);
	//machine_angles = (0, -360, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_marathon_on" );
	perk.targetname = "vending_marathon";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_marathon";
	perk_trigger.script_noteworthy = "specialty_longersprint";
	perk_trigger.script_sound = "mus_perks_stamin_jingle";
	perk_trigger.script_label = "mus_perks_stamin_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );

	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_martyrdom(machine_origin,  machine_angles)
{
	//machine_origin = (9530.7, 500.4, -665.1);
	//machine_angles = (0, 180, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "p6_zm_vending_electric_cherry_off_on" );
	perk.targetname = "vending_electriccherry";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_electriccherry";
	perk_trigger.script_noteworthy = "specialty_bulletdamage";
	perk_trigger.script_sound = "mus_perks_cherry_jingle";
	perk_trigger.script_label = "mus_perks_cherry_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );
	
	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_extraammo(machine_origin,  machine_angles)
{
	//machine_origin = (8667.3, 3024.0, -715.0);
	//machine_angles = (0, 45, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "bo3_p7_zm_vending_widows_wine_on" );
	perk.targetname = "vending_widowswine";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_widowswine";
	perk_trigger.script_noteworthy = "specialty_bulletaccuracy";
	perk_trigger.script_sound = "mus_perks_widows_jingle";
	perk_trigger.script_label = "mus_perks_widows_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );
	
	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_chugabud(machine_origin,  machine_angles)
{
	//machine_origin = (11224.8, -975.8, -709.4);
	//machine_angles = (0, 26.9, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "p6_zm_vending_chugabud_on" );
	perk.targetname = "vending_chugabud";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_chugabud";
	perk_trigger.script_noteworthy = "specialty_extraammo";
	perk_trigger.script_sound = "mus_perks_whoswho_jingle";
	perk_trigger.script_label = "mus_perks_whoswho_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );
	
	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_mulekick(machine_origin,  machine_angles)
{
	//Reinaissance spawn
	//machine_origin = (8521.5, 3200.5, -667);
	//machine_angles = (0, 314.5, 0);

	//machine_origin = (9565, 327, -529);
	//machine_angles = (0, 90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk SetModel( "zombie_vending_three_gun_on" );
	perk.targetname = "vending_additionalprimaryweapon";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + ( 0, 0, 30 ), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_additionalprimaryweapon";
	perk_trigger.script_noteworthy = "specialty_additionalprimaryweapon";
	perk_trigger.script_sound = "mus_perks_mulekick_jingle";
	perk_trigger.script_label = "mus_perks_mulekick_sting";
	perk_clip = Spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );
	
	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}

place_vulture(machine_origin,  machine_angles)
{
	//machine_origin = (10714.4, 990.9, -661.4);
	//machine_angles = (0, -90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "bo2_zombie_vending_vultureaid_on" );
	perk.targetname = "vending_vulture";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_vulture";
	perk_trigger.script_noteworthy = "specialty_altmelee";
	perk_trigger.script_sound = "mus_perks_vulture_jingle";
	perk_trigger.script_label = "mus_perks_vulture_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";

	level waittill( "perk_moved" );
	
	perk delete();
	perk_trigger delete();
	perk_clip delete();
	bump_trigger delete();
}
*/

/*
==============================================================
==============================================================
==============================================================
		NEW CODE
==============================================================
==============================================================
==============================================================

*/

printHelper( a, b, c, d, e, f)
{
	if( !IsDefined( a ) )
		a = "";
	
	if( !IsDefined( b ) )
		b = "";

	if( !IsDefined( c ) )
		c = "";

	if( !IsDefined( d ) )
		d = "";

	if( !IsDefined( e ) )
		e = "";
	
	if( !IsDefined( f ) )
		f = "";
	
	iprintln( a + " " + b + " " + c + " " + d + " " + e + " " + f );
}

remove_set_perks( trigger )
{
	clip = undefined;
	model = undefined;

	trigger = GetEnt( trigger.script_noteworthy, "script_noteworthy" );
	//wait_print( "Trigger: ", trigger.script_noteworthy );
	machine = GetEntArray( trigger.target, "targetname" );
	for( i = 0; i < machine.size; i ++ )
	{
		//machine[i] Delete();
		//continue;
		if( IsDefined( machine[i].script_noteworthy ) && machine[i].script_noteworthy == "clip" )
		{
			clip = machine[i];
		}
		else
		{
			model = machine[i];
		}
	}
	//trigger Delete();
	
	anchor = Spawn( "script_model", model.origin );
	anchor.angles = model.angles;
	anchor SetModel( "tag_origin" );
	clip EnableLinkTo();
	clip LinkTo( anchor );
	trigger EnableLinkTo();
	trigger LinkTo( anchor );
	//model.origin = ( 9565, 327, -529 );
	model.origin = ( 0, 0, -9999 );
	model.angles = ( 0, 90, 0 );
	anchor.origin = model.origin;
	anchor.angles = model.angles;
	
}

init()
{
	//level._effect[ "lightning_dog_spawn" ] = LoadFX( "maps/zombie/fx_zombie_dog_lightning_buildup" );
	level.pap_locations =[];
	for( i = 0; i < 4; i ++ ) {
		loc = GetEnt( "random_vending_start_location_"+i, "script_noteworthy" );
		level.pap_locations[ i ] = loc;
		register_perk_spawn( loc.origin, loc.angles );
	}

	vending_machines = GetEntArray( "zombie_vending", "targetname" );
	for( i = 0; i < vending_machines.size; i ++ )
	{
		remove_set_perks( vending_machines[i] );
	}

	place_babyjug();
	exitEarly = false;
	if( exitEarly )
	{

	}
	else
	{

	//zombie_
	//spawn_perk( "zombie_vending_jugg", "zombie_vending", "vending_jugg", "specialty_armorvest", "mus_perks_jugganog_jingle", "mus_perks_jugganog_sting" );
	//spawn_perk( "zombie_vending_sleight", "zombie_vending", "vending_sleight", "specialty_fastreload", "mus_perks_speed_jingle", "mus_perks_speed_sting" );
	//spawn_perk( "zombie_vending_doubletap2", "zombie_vending", "vending_doubletap", "specialty_rof", "mus_perks_doubletap_jingle", "mus_perks_doubletap_sting" );
	//spawn_perk( "zombie_vending_revive", "zombie_vending", "vending_revive", "specialty_quickrevive", "mus_perks_revive_jingle", "mus_perks_revive_sting" );		

	spawn_perk( "zombie_vending_nuke_on", "zombie_vending", "vending_divetonuke", "specialty_flakjacket", "mus_perks_phd_jingle", "mus_perks_phd_sting" );
	spawn_perk( "zombie_vending_marathon_on", "zombie_vending", "vending_marathon", "specialty_longersprint", "mus_perks_stamin_jingle", "mus_perks_stamin_sting" );
	spawn_perk( "zombie_vending_ads_on", "zombie_vending", "vending_deadshot", "specialty_deadshot", "mus_perks_deadshot_jingle", "mus_perks_deadshot_sting" );
	spawn_perk( "zombie_vending_three_gun_on", "zombie_vending", "vending_additionalprimaryweapon", "specialty_additionalprimaryweapon", "mus_perks_mulekick_jingle", "mus_perks_mulekick_sting" );
	//spawn_perk( "p6_zm_vending_chugabud", "zombie_vending", "vending_chugabud", "specialty_extraammo", "mus_perks_whoswho_jingle", "mus_perks_whoswho_sting" );
	spawn_perk( "p6_zm_vending_electric_cherry_on", "zombie_vending", "vending_electriccherry", "specialty_bulletdamage", "mus_perks_cherry_jingle", "mus_perks_cherry_sting" );
	spawn_perk( "bo2_zombie_vending_vultureaid_on", "zombie_vending", "vending_vulture", "specialty_altmelee", "mus_perks_vulture_jingle", "mus_perks_vulture_sting" );
	spawn_perk( "bo3_p7_zm_vending_widows_wine_on", "zombie_vending", "vending_widowswine", "specialty_bulletaccuracy", "mus_perks_widows_jingle", "mus_perks_widows_sting" );
	spawn_perk( "zombie_vending_packapunch_on", "zombie_vending_upgrade", "vending_packapunch", "specialty_weapupgrade", "mus_perks_packa_jingle", "mus_perks_packa_sting" );
	//level._solo_revive_machine_expire_func = ::solo_quick_revive_disable;
	level thread randomize_perks_think();

	}
}

place_babyjug()
{
	machine_origin = (10570, 809, -479);
	machine_angles = (60, 0, 78);
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
	perk_clip SetModel( "collision_geo_64x64x256" );
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

spawn_perk( model, targetname, target, perk, jingle, sting )
{
	if( !IsDefined( level.extra_vending_model_info ) )
	{
		level.extra_vending_model_info = [];
	}

	size = level.extra_vending_model_info.size;
	level.extra_vending_model_info[ size ] = model;
	machine = Spawn( "script_model", ( 0, 0, -9999 ) );
	machine.angles = ( 0, 0, 0 );
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
	level endon("end_game");
	level endon("intermission");

	//Wait for perk door to open


	level.perk_randomization_on = [];
	//level.vulture_perk_custom_map_check = ::hidden_perk_waypoints;
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	vending_triggers = array_combine( vending_triggers, GetEntArray( "zombie_vending_upgrade", "targetname" ) );
	vending_triggers = array_remove( vending_triggers, GetEnt( "vending_babyjugg", "target" ) );
	
	shino_zones_opened = array(0, 0, 0, 0);
	last_perks = [];
	while( true )
	{
		
		curr_perks = [];
		perk_list = array_randomize( vending_triggers );
		//perk_list = vending_triggers;
		//for( i = perk_list.size-1; i > -1; i-- )
		for( i = 0; i < perk_list.size; i ++ )
		{
			machine_array = GetEntArray( perk_list[i].target, "targetname" );

			if( !IsDefined(machine_array) )
			{
				continue;
			}

			machine = undefined;
			
			for( j = 0; j < machine_array.size; j ++ )
			{
				if( IsDefined( machine_array[j].script_noteworthy ) && machine_array[j].script_noteworthy == "clip" )
					continue;
				machine = machine_array[j];
			}
			if( !IsDefined( machine ) )
				iprintln( "machine not found for: " + perk_list[i].target );

			//iprintln("2 Machine: " + perk_list[i].target );

			perk = perk_list[i].script_noteworthy;
			if( is_in_array( last_perks, perk ) || curr_perks.size >= 4 )
			{
				continue;
			}
			else
			{

				index = curr_perks.size;
				curr_perks[ index ] = perk;
				level.ARRAY_SHINO_PERKS_AVAILIBLE[ index ] = perk_list[i].target;	//vending_###
				
				if( !shino_zones_opened[ index ])
					continue;
				
				thread maps\zombie_cod5_sumpf_perks::vending_randomization_effect( index );
				
			}
		}

		last_perks = curr_perks;
		
		level waittill( "perks_swapping" );

		while( flag( "pack_machine_in_use" ) )
		{
			wait 0.05;
		}
		wait( 1.5 );

		for( i = 0; i < 4; i ++ ) { shino_zones_opened[i] = level.ARRAY_SHINO_ZONE_OPENED[i]; }

		for( i = 0; i < level.perk_spawn_location.size; i ++ ) {
			level thread hellhound_spawn_fx( level.perk_spawn_location[i].origin );
		}

		//Reset Triggers
		for( i = 0; i < perk_list.size; i ++ )
		{
			//iprintln( "Resetting: " + perk_list[i].target );

			machine_array = GetEntArray( perk_list[i].target, "targetname" );
			machine = undefined;
			for( j = 0; j < machine_array.size; j ++ )
			{
				if( IsDefined( machine_array[j].script_noteworthy ) && machine_array[j].script_noteworthy == "clip" )
					continue;
				machine = machine_array[j];
			}
			if( !IsDefined( machine ) )
				continue;
			
			machine.origin = ( 0, 0, -9999 );
			machine.angles = ( 0, 0, 0 );		
		}

		wait 1.5;

		level.pap_moving = undefined;
	}
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