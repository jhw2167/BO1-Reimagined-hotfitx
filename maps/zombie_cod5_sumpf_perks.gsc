#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;


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
	level thread watch_randomize_vending_machines();
}

watch_randomize_vending_machines()
{
	self endon( "end_game" );


	//self thread watch_hanging_zombie_eye_glow();
	while( true )
	{
		//rounds_until_swap = randomintrange( 1, 4 );
		rounds_until_swap = 1;
		iprintln( "Rounds until vending machines swap: " + rounds_until_swap );
		for( i = 0; i < rounds_until_swap; i++ )
		{
			event = self waittill_any_return( "end_of_round", "shino_force_swap");
			if( event == "shino_force_swap" )
				break;
			
		}
		
		//iprintln( "Randomizing vending machines" );
		self notify( "perks_swapping" );
		//wait( 7 );
	}

}

watch_hanging_zombie_eye_glow()
{
	self endon( "end_game" );

	//get all assets
	flag_wait("begin_spawning");
	//ents = GetEntArray( "script_model", "classname" );
	ents = GetEntArray( "player", "classname" );

	iprintln( "ents.size: " + ents.size );
	player = GetPlayers()[0];
	
	falso = false;
	while( falso )
	{
		for( i = 0; i < ents.size; i ++ )
		{
			if( !IsDefined(ents[i].origin ))
				continue;
			//Check models within 1000 units of player
			closeEnough = maps\_zombiemode::checkDist(player.origin, ents[i].origin, 100);

			if( !closeEnough )
			{
				//iprintln( "Model: " + ents[i].model );
				//iprintln( "---" );
				wait( 0.1 );
				continue;
			}

			iprintln( "Model: " + ents[i].model );
			iprintln( "Targetname: " + ents[i].targetname );
			iprintln( "Target: " + ents[i].target );
			iprintln( "---" );
			wait( 0.1 );
		}

		wait( 5 ); 
		
	}

	for( i = 0; i < 10000; i++ )
	{
		//ent = GetEntByNum( i );
		ent = undefined;
		if( !IsDefined( ent ) )
		{
			iprintln( "Ent not defined: " + i );
			continue;
		}
			
		iprintln( "Ent Data for: " + i  );
		iprintln( "oRIGIN: " + ent.origin );
		iprintln( "Model: " + ent.model );
		iprintln( "Targetname: " + ent.targetname );
		iprintln( "Target: " + ent.target );
		iprintln( "---" );
		wait( 0.1 );
	}

}


activate_vending_machine( machine, origin, entity, script_noteworthy )
{
	iprintln( "activate_vending_machine: " + machine );
	//wait 4;

	switch( machine )
	{
		case "zombie_vending_revive_on":
			level thread maps\_zombiemode_perks::turn_revive_on();
			level notify("revive_on");
			break;

		case "zombie_vending_jugg_on":
			level thread maps\_zombiemode_perks::turn_jugger_on();
			level notify("juggernog_on");
			break;

		case "zombie_vending_doubletap2_on":
		case "zombie_vending_doubletap_on":
			level thread maps\_zombiemode_perks::turn_doubletap_on();
			level notify("doubletap_on");
			break;

		case "zombie_vending_sleight_on":
			level thread maps\_zombiemode_perks::turn_sleight_on();
			level notify("sleight_on");
			break;

		case "zombie_vending_marathon_on":
			level thread maps\_zombiemode_perks::turn_marathon_on();
			level notify("marathon_on");
			break;

		case "zombie_vending_three_gun_on":
			level thread maps\_zombiemode_perks::turn_additionalprimaryweapon_on();
			level notify("additionalprimaryweapon_on");
			break;

		case "zombie_vending_ads_on":
			level thread maps\_zombiemode_perks::turn_deadshot_on();
			level notify("deadshot_on");
			break;

		case "zombie_vending_nuke_on":
			level thread maps\_zombiemode_perks::turn_divetonuke_on();
			level notify("divetonuke_on");
			break;

		case "p6_zm_vending_electric_cherry_on":
			level thread maps\_zombiemode_perks::turn_electriccherry_on();
			level notify("electriccherry_on");
			break;

		case "bo2_zombie_vending_vultureaid_on":
			level thread maps\_zombiemode_perks::turn_vulture_on();
			level notify("vulture_on");
			break;

		case "bo3_p7_zm_vending_widows_wine_on":
			level thread maps\_zombiemode_perks::turn_widowswine_on();
			level notify("widowswine_on");
			break;

		case "zombie_vending_packapunch_on":
			level thread maps\_zombiemode_perks::turn_PackAPunch_on();
			level notify("Pack_A_Punch_on");
			break;

		default:
			iprintln( "activate_vending_machine: " + machine + " not found" );
			break;
	}

	if( IsDefined( script_noteworthy ) )
	{
		level notify( script_noteworthy + "_power_on" );
	}
	else
	{
		iprintln( "script_noteworthy not defined for: " + machine );
	}
	
	wait 3;
	level notify ("zombie_vending_spawned");

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

		case "zombie_vending_doubletap2_on":
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
	vending_triggers = array_combine( vending_triggers, GetEntArray( "zombie_vending_upgrade", "targetname" ) );
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
		if( vending_triggers[i].target == level.ARRAY_SHINO_PERKS_AVAILIBLE[ index ] )
		{
			trigInd = i;
			break;
		}
		
	}
	
	machine.origin = level.perk_spawn_location[ index ].origin;
	machine.angles = level.perk_spawn_location[ index ].angles;

	PlaySoundAtPosition( "rando_start", machine.origin );
	origin = machine.origin;
	//iprintln( "At location: " + origin );
	//iprintln( "Trigger origin: " + vending_triggers[trigInd].origin );
	
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

	perk_trigger = Spawn( "trigger_radius_use", machine.origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger UseTriggerRequireLookAt();
	perk_trigger SetHintString( &"ZOMBIE_NEED_POWER" );
	perk_trigger SetCursorHint( "HINT_NOICON" );
	thread activate_vending_machine( true_model, origin, machine, vending_triggers[trigInd].script_noteworthy );

	wait 3;

	perk_trigger.script_noteworthy = vending_triggers[trigInd].script_noteworthy;
	perk_trigger set_perk_buystring( vending_triggers[trigInd].script_noteworthy );

	level.pap_moving = false;
	level waittill( "perks_swapping" );
	level.pap_moving = true;
	perk_trigger Delete();

}

set_perk_buystring( script_notetworthy )
{
	if( script_notetworthy == "specialty_weapupgrade" )
	{
		iprintln( "specialty_weapupgrade return" );
		self thread maps\_zombiemode_perks::vending_weapon_upgrade();
		wait 0.1;
		level notify("Pack_A_Punch_on");
		//self SetHintString( &"REIMAGINED_PERK_PACKAPUNCH", 1000, 2000 );
		
		return;
	}
		

	cost = level.zombie_vars["zombie_perk_cost"];
	switch( script_notetworthy )
	{
	case "specialty_armorvest_upgrade":
	case "specialty_armorvest":
		cost = 2500;
		break;

	case "specialty_quickrevive_upgrade":
	case "specialty_quickrevive":
		cost = 1500;
		break;

	case "specialty_fastreload_upgrade":
	case "specialty_fastreload":
		cost = 3000;
		break;

	case "specialty_rof_upgrade":
	case "specialty_rof":
		cost = 2000;
		break;

	case "specialty_endurance_upgrade":
	case "specialty_endurance":
		cost = 2000;
		break;

	case "specialty_flakjacket_upgrade":
	case "specialty_flakjacket":
		cost = 2000;
		break;

	case "specialty_deadshot_upgrade":
	case "specialty_deadshot":
		cost = 2000; // WW (02-03-11): Setting this low at first so more people buy it and try it (TEMP)
		break;

	case "specialty_additionalprimaryweapon_upgrade":
	case "specialty_additionalprimaryweapon":
		cost = 4000;
		break;

	case "specialty_bulletdamage_upgrade":	//Cherry
	case "specialty_bulletdamage":
		cost = 2500;
		break;

	case "specialty_altmelee_upgrade":	//Vulture
	case "specialty_altmelee":
		cost = 3000;
		break;

	case "specialty_bulletaccuracy_upgrade":	//wine
	case "specialty_bulletaccuracy":
		cost = 3000;
		break;

	}


	upgrade_perk_cost = level.VALUE_PERK_PUNCH_COST;
	if(level.expensive_perks)
		upgrade_perk_cost = level.VALUE_PERK_PUNCH_EXPENSIVE_COST;

	switch( script_notetworthy )
	{
		case "specialty_armorvest_upgrade":
		case "specialty_armorvest":
			self SetHintString( &"REIMAGINED_PERK_JUGGERNAUT", cost, upgrade_perk_cost );
			break;

		case "specialty_quickrevive_upgrade":
		case "specialty_quickrevive":
			self SetHintString( &"REIMAGINED_PERK_QUICKREVIVE", cost, upgrade_perk_cost );
			break;

		case "specialty_fastreload_upgrade":
		case "specialty_fastreload":
			self SetHintString( &"REIMAGINED_PERK_FASTRELOAD", cost, upgrade_perk_cost );
			break;

		case "specialty_rof_upgrade":
		case "specialty_rof":
			self SetHintString( &"REIMAGINED_PERK_DOUBLETAP", cost, upgrade_perk_cost );
			break;

		case "specialty_endurance_upgrade":
		case "specialty_endurance":
			self SetHintString( &"REIMAGINED_PERK_MARATHON", cost, upgrade_perk_cost );
			break;

		case "specialty_flakjacket_upgrade":
		case "specialty_flakjacket":
			self SetHintString( &"REIMAGINED_PERK_DIVETONUKE", cost, upgrade_perk_cost );
			break;

		case "specialty_deadshot_upgrade":
		case "specialty_deadshot":
			self SetHintString( &"REIMAGINED_PERK_DEADSHOT", cost, upgrade_perk_cost );
			break;

		case "specialty_additionalprimaryweapon_upgrade":
		case "specialty_additionalprimaryweapon":
			self SetHintString( &"REIMAGINED_PERK_MULEKICK", cost, upgrade_perk_cost );
			break;

		case "specialty_extraammo_upgrade":
		case "specialty_extraammo":
			self SetHintString( &"REIMAGINED_PERK_CHUGABUD", cost, upgrade_perk_cost );
			break;

		case "specialty_bulletdamage_upgrade":
		case "specialty_bulletdamage":
			self SetHintString( &"REIMAGINED_PERK_CHERRY", cost, upgrade_perk_cost );
			break;

		case "specialty_altmelee_upgrade":
		case "specialty_altmelee":
			self SetHintString( &"REIMAGINED_PERK_VULTURE", cost, upgrade_perk_cost );
			break;

		case "specialty_bulletaccuracy_upgrade":
		case "specialty_bulletaccuracy":
			self SetHintString( &"REIMAGINED_PERK_WIDOWSWINE", cost, upgrade_perk_cost );
			break;

		case "specialty_stockpile_upgrade":
		case "specialty_stockpile":
			self SetHintString( &"REIMAGINED_PERK_BANDOLIER", cost, upgrade_perk_cost );
			break;

		case "specialty_scavanger_upgrade":
		case "specialty_scavanger":
			self SetHintString( &"REIMAGINED_PERK_TIMESLIP", cost, upgrade_perk_cost );
			break;
	}

	self thread maps\_zombiemode_perks::watch_perk_trigger( script_notetworthy, cost, upgrade_perk_cost );

}