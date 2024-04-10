#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

swap_quick_revive( vending_machines )
{
	trigger = undefined;
	clip = undefined;
	model = undefined;
	for( i = 0; i < vending_machines.size; i ++ )
	{
		if( vending_machines[i].script_noteworthy == "specialty_quickrevive" )
		{
			trigger = vending_machines[i];
			break;
		}
	}
	machine = GetEntArray( trigger.target, "targetname" );
	for( i = 0; i < machine.size; i ++ )
	{
		if( IsDefined( machine[i].script_noteworthy ) && machine[i].script_noteworthy == "clip" )
		{
			clip = machine[i];
		}
		else
		{
			model = machine[i];
		}
	}
	anchor = Spawn( "script_model", model.origin );
	anchor.angles = model.angles;
	anchor SetModel( "tag_origin" );
	clip EnableLinkTo();
	clip LinkTo( anchor );
	trigger EnableLinkTo();
	trigger LinkTo( anchor );
	model.origin = ( 9565, 327, -529 );
	model.angles = ( 0, 90, 0 );
	anchor.origin = model.origin;
	anchor.angles = model.angles;
	level._solo_revive_machine_expire_func = ::solo_quick_revive_disable;
}

solo_quick_revive_disable()
{
	self Unlink();
	self trigger_off();
}

randomize_vending_machines()
{

	/*
	for( i = 0; i < vending_machines.size; i ++ )
	{
		origin = start_locations[i].origin;
		angles = start_locations[i].angles;
		machine = vending_machines[i] get_vending_machine( start_locations[i] );
		start_locations[i].origin = origin;
		start_locations[i].angles = angles;
		machine.origin = origin;
		machine.angles = angles;
		machine Hide();
		vending_machines[i] trigger_on();
	}
	*/

	//level thread watch_randomized_vending_machines();
	//level.perk_randomization_on = [];
	//level.vulture_perk_custom_map_check = ::hide_waypoint_until_perk_spawned;
}

	watch_randomized_vending_machines()
	{
		level endon("end_game");

		start_locations[0] = GetEnt( "random_vending_start_location_0", "script_noteworthy" );
		start_locations[1] = GetEnt( "random_vending_start_location_1", "script_noteworthy" );
		start_locations[2] = GetEnt( "random_vending_start_location_2", "script_noteworthy" );
		start_locations[3] = GetEnt( "random_vending_start_location_3", "script_noteworthy" );

		level.start_locations = [];
		level.start_locations[ level.start_locations.size ] = start_locations[0].origin;
		level.start_locations[ level.start_locations.size ] = start_locations[1].origin;
		level.start_locations[ level.start_locations.size ] = start_locations[2].origin;
		level.start_locations[ level.start_locations.size ] = start_locations[3].origin;
		
		while(1)
		{
			iprintln( "seting up random vendings" );
			vending_machines = GetEntArray( "zombie_vending", "targetname" );

			vending_machines = array_randomize( vending_machines );

			new_shino_perks = [];
			for( i = 0; i < vending_machines.size; i++ )
			{
				iprintln( "testing new perk: " + vending_machines[i].target );
				
				if( is_in_array( level.ARRAY_SHINO_PERKS_AVAILIBLE, vending_machines[i].target ) )
					continue;
				
				iprintln( "Can spawn perk!"  );
				machine = vending_machines[i] get_vending_machine( start_locations[i] );

				machine.origin = start_locations[i].origin;
				machine.angles = start_locations[i].angles;
				machine Hide();

				if( is_true( level.ARRAY_SHINO_ZONE_OPENED[i] ) )
					vending_randomization_effect( i );
						
				new_shino_perks[ i ] = vending_machines[i].target;
				
				if( i >= 3 ) //only 4 perks at a time on shino
					break;
			}

			OFF_MAP = SpawnStruct();
			OFF_MAP.origin = (0,0,0);
			OFF_MAP.angles = (0,0,0);
			for( i = 0; i < vending_machines.size; i++ )
			{
				if( is_in_array( new_shino_perks, vending_machines[i].target ) )
				{
					iprintln( "new perk available: " + new_shino_perks[i] );
					level.ARRAY_SHINO_PERKS_AVAILIBLE[ i ] = new_shino_perks[i];
					continue;
				}
				
				machine = vending_machines[i] get_vending_machine( OFF_MAP );

				machine.origin = OFF_MAP.origin;
				machine.angles = OFF_MAP.angles;
				machine Hide();

			}

			level waittill("between_round_over");
			iprintln( "between round over trigered" );
		}
	}



//Reimagined-Expanded, will need to edit with vulture aid
hide_waypoint_until_perk_spawned( struct )
{
	if( IsDefined( struct.perk_to_check ) )
	{
		perk = struct.perk_to_check;
		switch( perk )
		{
			case "specialty_deadshot":
			//case "specialty_quickrevive":
			case "specialty_bulletdamage":
			case "specialty_altmelee":
				return false;
		}
		return !is_true( level.perk_randomization_on[ perk ] );
	}
	return false;
}


spawn_perk_machine_location( perk )
{
	vending_machines = GetEntArray( "zombie_vending", "targetname" );
	for( i = 0; i < vending_machines.size; i ++ )
	{
		if( vending_machines[i].script_noteworthy == perk )
		{
			machine = GetEnt( vending_machines[i].target, "targetname" );
			model = Spawn( "script_model", machine.origin );
			model.angles = machine.angles;
			model SetModel( "tag_origin" );
			return model;
		}
	}
	return undefined;
}

get_vending_machine( start_location )
{
	machine = undefined;
	machine_array = GetEntArray( self.target, "targetname" );
	for( i = 0; i < machine_array.size; i ++ )
	{
		if( !IsDefined( machine_array[i].script_noteworthy ) || machine_array[i].script_noteworthy != "clip" )
		{
			machine = machine_array[i];
		}		
	}
	if( !IsDefined( machine ) )
	{
		return;
	}
	machine.origin = start_location.origin;
	machine.angles = start_location.angles;
	self EnableLinkTo();
	self LinkTo( start_location );
	iprintln( self.target + " linked to position: " + start_location.origin ); 
	return machine;
}

activate_vending_machine( machine, origin, entity )
{
	level notify( "master_switch_activated" );
	iprintln( "activate_vending_machine: " + machine );

	switch( machine )
	{
		case "zombie_vending_jugg_on":
			level thread maps\_zombiemode_perks::turn_jugger_on();
			break;

		case "zombie_vending_doubletap_on":
			level thread maps\_zombiemode_perks::turn_doubletap_on();
			break;

		case "zombie_vending_sleight_on":
			level thread maps\_zombiemode_perks::turn_sleight_on();
			break;

		case "zombie_vending_marathon_on":
			level thread maps\_zombiemode_perks::turn_marathon_on();
			break;

		case "zombie_vending_three_gun_on":
			level thread maps\_zombiemode_perks::turn_additionalprimaryweapon_on();
			break;

		case "zombie_vending_ads_on":
			level thread maps\_zombiemode_perks::turn_deadshot_on();
			break;

		case "zombie_vending_nuke_on":
			level thread maps\_zombiemode_perks::turn_divetonuke_on();
			break;

		case "p6_zm_vending_electric_cherry_on":
			level thread maps\_zombiemode_perks::turn_electriccherry_on();
			break;

		case "bo2_zombie_vending_vultureaid_on":
			level thread maps\_zombiemode_perks::turn_vulture_on();
			break;

		case "bo3_p7_zm_vending_widows_wine_on":
			level thread maps\_zombiemode_perks::turn_widowswine_on();
			break;

		case "pack-a-punch":
			//level thread maps\_zombiemode_perks::turn_PackAPunch_on();
			break;

		default:
			iprintln( "activate_vending_machine: " + machine + " not found" );
			break;
	}

	level notify( "juggernog_on" ); //tuirns all perks on

	play_vending_vo( machine, origin );	
}

play_vending_vo( machine, origin )
{
	players = GetPlayers();
	players = get_array_of_closest( origin, players, undefined, undefined, 512 );
	player = undefined;
	for( i = 0; i < players.size; i ++ )
	{
		if( SightTracePassed( players[i] GetEye(), origin, false, undefined ) )
		{
			player = players[i];
			break;
		}
	}
	if( !IsDefined( player ) )
	{
		return;
	}
	switch( machine )
	{
		case "zombie_vending_jugg_on":
			player thread maps\_zombiemode_audio::create_and_play_dialog( "level", "jugga" );
			break;

		case "zombie_vending_doubletap_on":
			player thread maps\_zombiemode_audio::create_and_play_dialog( "level", "doubletap" );
			break;

		case "zombie_vending_revive_on":
			player thread maps\_zombiemode_audio::create_and_play_dialog( "level", "revive" );
			break;

		case "zombie_vending_sleight_on":
			player thread maps\_zombiemode_audio::create_and_play_dialog( "level", "speed" );
			break;
	}
}

vending_randomization_effect( index )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	level.ARRAY_SHINO_ZONE_OPENED[ index ] = true;
	iprintln( "vending_randomization_effect zone opened: " + index );

	iprintln( "Trying to spawn perk: " + level.ARRAY_SHINO_PERKS_AVAILIBLE[ index ] );
	machine_array = GetEntArray( level.ARRAY_SHINO_PERKS_AVAILIBLE[ index ], "targetname" );

	machine = undefined;
	for( j = 0; j < machine_array.size; j ++ )
	{
		if( IsDefined( machine_array[j].script_noteworthy ) && machine_array[j].script_noteworthy == "clip" )
			continue;
		machine = machine_array[j];
	}

	if( !IsDefined( machine ) )
		iprintln( "machine not found for: " + level.ARRAY_SHINO_PERKS_AVAILIBLE[ index ] );
	
	machine Hide();
	
	triggers = GetEntArray( machine.targetname, "target" );
	trigInd = 0;

	for( i = 0; i < vending_triggers.size; i ++ )
	{
		if( vending_triggers[i].target == machine.targetname )
		{
			trigInd = i;
			vending_triggers[i] EnableLinkTo();
			vending_triggers[i] LinkTo( machine );
			break;
		}
		
	}
	
	machine.origin = level.perk_spawn_location[ index ].origin;
	machine.angles = level.perk_spawn_location[ index ].angles;

	PlaySoundAtPosition( "rando_start", machine.origin );
	origin = machine.origin;
	iprintln( "At location: " + origin );
	iprintln( "Where is trigger: " + triggers[trigInd] );
	
	if( level.vending_model_info.size > 1 )
	{
		PlayFXOnTag( level._effect[ "zombie_perk_start" ], machine, "tag_origin" );
		PlaySoundAtPosition( "rando_perk", machine.origin );
	}
	else
	{
		PlayFXOnTag( level._effect[ "zombie_perk_4th" ], machine, "tag_origin" );
		PlaySoundAtPosition( "rando_perk", machine.origin );
	}

	true_model = machine.model;
	machine Show();
	level thread play_sound_2D( "perk_lottery" );
	tag_fx = Spawn( "script_model", machine.origin + ( 0, 0, 40 ) );
	tag_fx SetModel( "tag_origin" );
	tag_fx LinkTo( machine );
	machine MoveTo( origin + ( 0, 0, 40 ), 5, 3, 0.5 );
	machine Vibrate( machine.angles, 2, 1, 4 );
	modelindex = 0;
	level.vending_model_info = array_combine( level.vending_model_info, level.extra_vending_model_info );
	for( i = 0; i < 30; i ++ )
	{                             
		wait 0.15;
		if( level.vending_model_info.size > 1 )
		{
			while( !IsDefined( level.vending_model_info[ modelindex ] ) )
			{
				modelindex ++;
				if( modelindex == 12 )
				{
					modelindex = 0;
				}
			}
			modelname = level.vending_model_info[ modelindex ];
			machine SetModel( modelname );
			PlayFXOnTag( level._effect[ "zombie_perk_flash" ], tag_fx, "tag_origin" );
			modelindex ++;
			if( modelindex == 12 )
			{
				modelindex = 0;
			}
		}
	}
	machine SetModel( true_model );
	machine MoveTo( origin, 0.3, 0.3, 0 );
	PlayFXOnTag( level._effect[ "zombie_perk_end" ], machine, "tag_origin" );
	PlaySoundAtPosition( "perks_rattle", machine.origin );
	activate_vending_machine( true_model, origin, machine );

}