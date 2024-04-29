#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;


/*
	###############################
	HINT STRING GENERATOR
    ###############################
*/

generate_hint_title( hint_title, hint_text )
{
    //Title
    title = NewClientHudElem( self );
	title.alignX = "center";
	title.alignY = "middle";
	title.horzAlign = "user_center";
	title.vertAlign = "user_top";
	title.foreground = true;
	title.font = "boldFont";
	title.fontScale = 3.2;
	title.alpha = 0;
	title.color = (0.5, 0.0, 0.0);
	title SetText( hint_text );

    title.y += 120;

	title FadeOverTime( 1 );
	title.alpha = 1;

    wait 4;
    title FadeOverTime( 4 );
	title.alpha = 0;

	title destroy_hud();
}

generate_hint( hint_code, hint_text, offset, font_size )
{
    self endon( "death" );
	self endon( "disconnect" );

    if( isdefined( offset ) )
        y_offset = offset;
    else
        y_offset = 0;

	if( !isdefined( font_size ) )
		font_size = 1.6;


    //Bullets
	text = NewClientHudElem( self );
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "user_center";
	text.vertAlign = "user_top";
	text.foreground = true;
	text.font = "default";
	text.fontScale = font_size;
	text.alpha = 0;
	text.color = ( 1.0, 1.0, 1.0 );
    if( IsDefined( hint_code ) )
		text SetText( hint_code );
    else
	    text SetText( hint_text );

	text.y += 140;
    text.y += y_offset;

	text FadeOverTime( 1 );
	text.alpha = 1;

	wait 4;
    text FadeOverTime( 2 );
	wait 1;
	text.alpha = 0;

	text destroy_hud();
}


/* PERK HINTS HANDLED IN _ZOMBIEMODE_FFOTD.CSC CLIENTSCRIPT */

generate_perk_hint( perk )
{
    self endon( "death" );
	self endon( "disconnect" );
	
	if( GetDvarInt( "ui_hud_perk_hints") == 0 )
		return;

	if( self.superpower_active )
		return;

	if( is_in_array(level.ARRAY_HELLFIRE_WEAPONS, perk))
	{
		perk = "specialty_pap_hellfire";
	}
	else if( is_in_array(level.ARRAY_SHEERCOLD_WEAPONS, perk))
	{
		perk = "specialty_pap_sheer_cold";
	}
	else if( is_in_array(level.ARRAY_ELECTRIC_WEAPONS, perk))
	{
		perk = "specialty_pap_shock_rounds";
	}
	else if( is_in_array(level.ARRAY_BIGDMG_WEAPONS, perk))
	{
		perk = "specialty_pap_big_damage";
	}
	else if( is_in_array(level.ARRAY_BIGHEADSHOTDMG_WEAPONS, perk))
	{
		perk = "specialty_pap_big_headshot_damage";
	}
	else if( is_in_array(level.ARRAY_VALID_SHOTGUNS, perk))
	{
		perk = "specialty_shotgun_damage";
	}

	if( is_true( self.hints_activated[ perk ] ) )
		return;

	self notify( "perk_hint_end" );

	self.hints_activated[ perk ] = true;

	iprintLn( "notify: " + perk );

	wait( 1 );

	returnVultureVision = false;
	if( self.vulture_vison_toggle )
	{
		self.vulture_vison_toggle = false;
		returnVultureVision = true;
	}
		
	BASE_OFFSET = -100;

    //Title
    title = NewClientHudElem( self );
	title.alignX = "center";
	title.alignY = "middle";
	title.horzAlign = "user_center";
	title.vertAlign = "user_bottom";
	title.foreground = true;
	title.font = "boldFont";
	title.fontScale = 1.6;
	title.alpha = 0;
	title.color = ( 1.0, 1.0, 1.0 );

    title.y += BASE_OFFSET;


    //Bullets
	text = NewClientHudElem( self );
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "user_center";
	text.vertAlign = "user_bottom";
	text.foreground = true;
	text.font = "default";
	text.fontScale = 1.2;
	text.alpha = 0;
	text.color = ( 1.0, 1.0, 1.0 );

	text.y += BASE_OFFSET;
    text.y += 20;
   

    /* SET APPROPRIATE HINT */
		switch( perk )
		{
			//case "specialty_armorvest":
		case "specialty_armorvest_upgrade":
			text SetText( &"REIMAGINED_JUG_PRO_HINT" );
			title SetText( &"REIMAGINED_JUG_PRO_TITLE" );
			break;

		//case "specialty_quickrevive":
		case "specialty_quickrevive_upgrade":
			text SetText( &"REIMAGINED_QRV_PRO_HINT" );
			title SetText( &"REIMAGINED_QRV_PRO_TITLE" );
			break;

		//case "specialty_fastreload":
		case "specialty_fastreload_upgrade":
			text SetText( &"REIMAGINED_SPD_PRO_HINT" );
			title SetText( &"REIMAGINED_SPD_PRO_TITLE" );
			break;

		case "specialty_rof":
			text SetText( &"REIMAGINED_DBT_PRK_HINT" );
			title SetText( &"REIMAGINED_DBT_PRK_TITLE" );
			break;
		case "specialty_rof_upgrade":
			text SetText( &"REIMAGINED_DBT_PRO_HINT" );
			title SetText( &"REIMAGINED_DBT_PRO_TITLE" );
			break;

		//case "specialty_endurance":
		case "specialty_endurance_upgrade":
			text SetText( &"REIMAGINED_STM_PRO_HINT" );
			title SetText( &"REIMAGINED_STM_PRO_TITLE" );
			break;

		case "specialty_flakjacket_upgrade":
		//case "specialty_flakjacket":
			text SetText( &"REIMAGINED_PHD_PRO_HINT" );
			title SetText( &"REIMAGINED_PHD_PRO_TITLE" );
			break;

		case "specialty_deadshot":
			text SetText( &"REIMAGINED_DST_PRK_HINT" );
			title SetText( &"REIMAGINED_DST_PRK_TITLE" );
			break;
		case "specialty_deadshot_upgrade":
			text SetText( &"REIMAGINED_DST_PRO_HINT" );
			title SetText( &"REIMAGINED_DST_PRO_TITLE" );
			break;

		case "specialty_additionalprimaryweapon_upgrade":
		//case "specialty_additionalprimaryweapon":
			text SetText( &"REIMAGINED_MUL_PRO_HINT" );
			title SetText( &"REIMAGINED_MUL_PRO_TITLE" );
			break;
		case "specialty_bulletdamage":
			text SetText( &"REIMAGINED_ECH_PRK_HINT" );
			title SetText( &"REIMAGINED_ECH_PRK_TITLE" );
			break;
		case "specialty_bulletdamage_upgrade":	//Cherry
		
			text SetText( &"REIMAGINED_ECH_PRO_HINT" );
			title SetText( &"REIMAGINED_ECH_PRO_TITLE" );
			break;
		case "specialty_altmelee":
			text SetText( &"REIMAGINED_VLT_PRK_HINT" );
			title SetText( &"REIMAGINED_VLT_PRK_TITLE" );
			break;

		case "specialty_altmelee_upgrade":	//Vulture
			text SetText( &"REIMAGINED_VLT_PRO_HINT" );
			title SetText( &"REIMAGINED_VLT_PRO_TITLE" );
			break;

		case "specialty_bulletaccuracy":
			text SetText( &"REIMAGINED_WWN_PRK_HINT" );
			title SetText( &"REIMAGINED_WWN_PRK_TITLE" );
			break;

		case "specialty_bulletaccuracy_upgrade":	//wine
			text SetText( &"REIMAGINED_WWN_PRO_HINT" );
			title SetText( &"REIMAGINED_WWN_PRO_TITLE" );
			break;

		case "specialty_pap_hellfire":
			text SetText( &"PAP_HELLFIRE_HINT" );
			title SetText( &"PAP_HELLFIRE_TITLE" );
			break;

		case "specialty_pap_sheer_cold":
			text SetText( &"REIMAGINED_PAP_SHEER_COLD_HINT" );
			title SetText( &"REIMAGINED_PAP_SHEER_COLD_TITLE" );
			break;

		case "specialty_pap_shock_rounds":
			text SetText( &"REIMAGINED_PAP_SHOCK_ROUNDS_HINT" );
			title SetText( &"REIMAGINED_PAP_SHOCK_ROUNDS_TITLE" );
			break;

		case "specialty_pap_big_damage":
			text SetText( &"REIMAGINED_PAP_BIG_DAMAGE_HINT" );
			title SetText( &"REIMAGINED_PAP_BIG_DAMAGE_TITLE" );
			break;

		case "specialty_pap_big_headshot_damage":
			text SetText( &"REIMAGINED_PAP_BIG_HEADSHOT_DAMAGE_HINT" );
			title SetText( &"REIMAGINED_PAP_BIG_HEADSHOT_DAMAGE_TITLE" );
			break;

		case "specialty_shotgun_damage":
			text SetText( &"REIMAGINED_SHOTGUN_DAMAGE_HINT" );
			title SetText( &"REIMAGINED_\SHOTGUN_DAMAGE_TITLE" );
			break;
		}

	text FadeOverTime( 1 );
	text.alpha = 1;

	title FadeOverTime( 1 );
	title.alpha = 1;

	self waittill_notify_or_timeout( "perk_hint_end", 7 );
	iprintLn( "Ending hint" );

    title FadeOverTime( 2 );
	title.alpha = 0;

    text FadeOverTime( 2 );
	text.alpha = 0;

	if( returnVultureVision )
		self.vulture_vison_toggle = true;

	title destroy_hud();
	text destroy_hud();
}

/*



*/

/*
	###############################
	PRO PERK PLACER
    ###############################
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
	object SetModel( "p6_zm_vending_electric_cherry_off" );
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
	###############################
    GENERAL UTILITY
	###############################
*/


wait_print( msg, data )
	{
		flag_wait("begin_spawning");
		iprintLn( msg );
		
		if( IsDefined( data ) )
		{
			iprintln( data );
		}
		
	}

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
