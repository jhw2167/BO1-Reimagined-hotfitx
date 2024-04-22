#include maps\_utility;
#include common_scripts\utility;

init()
{
	place_babyjug();

	place_divetonuke();
	place_deadshot();	
	place_marathon();		
	place_martyrdom();	
	place_extraammo();	
	//place_chugabud();		
	place_mulekick();	
	place_vulture();
	place_packapunch();
}


place_babyjug()
{
	machine_origin = (1405, 51, 183);
	machine_angles = (10, 0, 0);
	bottle = Spawn( "script_model", machine_origin );
	bottle.angles = machine_angles;
	bottle setModel( "t6_wpn_zmb_perk_bottle_jugg_world" );

	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 0), 0, 270, 600 );
	perk_trigger.targetname = "zombie_vending";
	perk_trigger.target = "vending_babyjugg";
	perk_trigger.script_noteworthy = "specialty_extraammo";

}

place_packapunch()
{
	machine_origin = (335, 18.25, 55.26);
	level.pap_origin = machine_origin;
	machine_angles = (0, 90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_packapunch" );
	perk.targetname = "vending_packapunch";
	perk_trigger = Spawn( "trigger_radius_use", machine_origin + (0 , 0, 30), 0, 20, 70 );
	perk_trigger.targetname = "zombie_vending_upgrade";
	perk_trigger.target = "vending_packapunch";
	perk_trigger.script_noteworthy = "specialty_weapupgrade";
	perk_trigger.script_sound = "mus_perks_packa_jingle";
	perk_trigger.script_label = "mus_perks_packa_sting";
	perk_clip = spawn( "script_model", machine_origin );
	perk_clip.angles = machine_angles;
	perk_clip SetModel( "collision_geo_64x64x256" );
	perk_clip Hide();
	bump_trigger = Spawn( "trigger_radius", machine_origin, 0, 35, 64 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "fly_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
}

place_divetonuke()
{
	machine_origin = (-608.2, -326.0, 226.1);
	machine_angles = (0, 90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_nuke" );
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
}

place_deadshot()
{
	machine_origin = (-778.439, 1.64091, 226.125);
	machine_angles = (0, -180, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_ads" );
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
}

place_marathon()
{
	machine_origin = (140.4, 471.4, 221.9);
	machine_angles = (0, -360, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "zombie_vending_marathon" );
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
}

place_martyrdom()
{
	machine_origin = (1169.64, 622.181, 56.5353);
	machine_angles = (0, -90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "p6_zm_vending_electric_cherry_off" );
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
}

place_extraammo()
{
	//Reinaissance
	//machine_origin = (1481.5, 64.1, 61.8);
	//machine_angles = (0, -180, 0);

	machine_origin = (428, -408, 56);
	machine_angles = (0, 180, 0);

	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "bo3_p7_zm_vending_widows_wine_off" );
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
}

place_chugabud()
{
	machine_origin = (225.3, -748.5, 218.6);
	machine_angles = (0, -90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "p6_zm_vending_chugabud" );
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
}

place_mulekick()
{
	machine_origin = (-91, 540, 64);
	machine_angles = (0, 90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk SetModel( "zombie_vending_three_gun" );
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
}

place_vulture()
{
	machine_origin = (640.4, 847.3, 226.1);
	machine_angles = (0, -90, 0);
	perk = Spawn( "script_model", machine_origin );
	perk.angles = machine_angles;
	perk setModel( "bo2_zombie_vending_vultureaid" );
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
}


/*
	###############################
	PRO PERK PLACER

*/


/*
	Enter visualizer
	self is player placing the object
*/
start_properk_placer()
{
	iprintlnbold("Starting Pro Perk Placer");
	
	r=150;
	z=10;
	//angles = self GetPlayerAngles(); 
	//offset = (r*sin(angles[1]), r*cos(angles[1]), z);
	forward_view_angles = self GetWeaponForwardDir();
	offset = vector_scale(forward_view_angles, r);

	iprintlnbold("Forward view angles: " + forward_view_angles);
	iprintlnbold("self: " + self.origin);
	iprintlnbold("Offset: " + offset);

	new_pos = self.origin + offset;
	iprintln("new pos: " + new_pos );
	object = Spawn( "script_model", new_pos);
	object SetModel( "bo3_p7_zm_vending_widows_wine_on" );
	//object.angles = angles + (0, 180, 0);
	object.angles = VectorToAngles(forward_view_angles);

	iprintlnbold("Configured object");

	wait(1);

	level.editing = array("x", "y", "z", "theta", "ro", "phi");
	level.fidelities = array(5, 10, 45);

    while(1)
    {

		if( self buttonPressed("q") )
		{
			//Return object to player
			forward_view_angles = self GetWeaponForwardDir();
			offset = vector_scale(forward_view_angles, r);

			object.origin = self.origin + offset;
			object.angles = VectorToAngles(forward_view_angles);
			object.angles += (0, -90, 0);
			iprintlnbold("Returning object to player");
			wait(1);
			continue;
		}

		if( self buttonPressed("e") )
		{
			//Edit objects position and angles
			i = 0; // Editing Index
    		j = level.fidelities.size-1; //fidelities index
			
			while(1)
			{
				if(self buttonPressed("v"))
				{
					i++;
					if(i >= level.editing.size)
						i = 0;
					editing = level.editing[i];
					iprintlnbold("Editing: " + editing);
					wait( 0.5 );
					continue;
				}

				if(self buttonPressed("c"))
				{
					j++;
					if(j >= level.fidelities.size)
						j = 0;
					iprintlnbold("Fidelity: " + level.fidelities[j]);
					wait( 0.5 );
					continue;
				}

				if(self buttonPressed("e"))
				{
					temp = self editObject( object, i, j );
					object.origin = temp.origin;
					object.angles = temp.angles;

					iprintln("pos: " + object.origin);
					iprintln("ang: " + object.angles);
				}

				if(self buttonPressed("ENTER"))
					break;
				
				wait(0.2);
			}
			
			
			iprintlnbold("object position: " + object.origin);
			iprintlnbold("object angles: " + object.angles);
		}

        wait 0.5;
    }
}


editObject( object, i, j )
{

	editing = level.editing[i];

	struct = SpawnStruct();
	struct.origin = object.origin;
	struct.angles = object.angles;
	//iprintlnbold("Begining position: " + object.origin);
	//iprintlnbold("Begining angles: " + object.angles);

	while(1)
	{
		
		
			
		if(self buttonPressed("f"))
		{
			iprintln("DOWN");
			struct adjust( editing, -1 * level.fidelities[j] );
			//wait(0.05);
			return struct;
		}

		if(self buttonPressed("r"))
		{
			iprintln("UP");
			struct adjust( editing, level.fidelities[j] );
			//wait(0.05);
			return struct;
		}

		if(self buttonPressed("ENTER"))
		{
			iprintlnbold("Returning struct");
			return struct;
		}
		
		
		wait(0.05);
	}


}

adjust( editing, adj )
{
	angles = self.angles;
	new_angles = (0,0,0);
	iprintlnbold("Adjusting: " + editing + " by " + adj);

	//editing = "none";
	//self.origin += (10, 0, 0);
	//self.angles += (10, 0, 0);

	switch(editing)
	{
		case "x":
			self.origin += (adj, 0, 0);
			break;
		case "y":
			self.origin += (0, adj, 0);
			break;
		case "z":
			self.origin += (0, 0, adj);
			break;
		case "theta":
		iprintln("Adjusting theta " + adj);
		iprintln("current theta " + angles[0]);
			if(angles[0] + adj > 180 )
			{
				diff = (angles[0] + adj) - 180;
				self.angles += (-180 + diff, 0, 0);
			}
			else if(angles[0] - adj < -180)
			{
				diff = (angles[0] + adj) + 180;
				self.angles += ( 180 - diff, 0, 0);
			}
			else
				self.angles += (adj, 0, 0);
			break;
		case "ro":
		iprintln("Adjusting roll " + adj);
		iprintln("current roll " + angles[1]);
			if(angles[1] + adj > 180 )
			{
				diff = (angles[1] + adj) - 180;
				self.angles += (0, -180 + diff, 0);
			}
			else if(angles[1] - adj < -180)
			{
				diff = (angles[1] + adj) + 180;
				self.angles += (0, 180 - diff, 0);
			}
			else
				self.angles += (0, adj, 0);
			break;
		case "phi":
		iprintln("Adjusting pitch " + adj);
		iprintln("current pitch " + angles[2]);
			if(angles[2] + adj > 180 )
			{
				diff = (angles[2] + adj) - 180;
				self.angles += (0, 0, -180 + diff);
			}
			else if(angles[2] - adj < -180)
			{
				diff = (angles[2] + adj) + 180;
				self.angles += (0, 0, 180 - diff);
			}
			else
				self.angles += (0, 0, adj);
			break;

		default:
			break;
	}

	iprintlnbold("New position: " + self.origin);
	iprintlnbold("New angles: " + self.angles);


}

/*
Adjust(args)
{
    adj *= dir;
}




	###############################
*/