#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;


/*
	###############################
	HINT STRING GENERATOR
    ###############################
*/

generate_hint_title( hint_title, hint_text, time )
{
	if( !isdefined( time ) )
		time = 4;
    //Title
    title = NewClientHudElem( self );
	title.alignX = "center";
	title.alignY = "middle";
	title.horzAlign = "user_center";
	title.vertAlign = "user_top";
	title.foreground = true;
	title.font = "big";
	title.fontScale = 3.2;
	title.alpha = 0;
	title.color = (0.5, 0.0, 0.0);
	title SetText( hint_text );

    title.y += 100;

	title FadeOverTime( 1 );
	title.alpha = 1;

    wait(time);
    title FadeOverTime( 2 );
	title.alpha = 0;

	wait(2);

	title destroy_hud();
}

generate_hint( hint_code, hint_text, offset, wait_time )
{
    self endon( "death" );
	self endon( "disconnect" );

    if( isdefined( offset ) )
        y_offset = offset;
    else
        y_offset = 0;

	if( !isdefined( wait_time ) )
		wait_time = 4;


    //Bullets
	text = NewClientHudElem( self );
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "user_center";
	text.vertAlign = "user_top";
	text.foreground = true;
	text.font = "default";
	text.fontScale = 1.6;
	text.alpha = 0;
	text.color = ( 1.0, 1.0, 1.0 );
    if( IsDefined( hint_code ) )
		text SetText( hint_code );
    else
	    text SetText( hint_text );

	text.y += 120;
    text.y += y_offset;

	text FadeOverTime( 1 );
	text.alpha = 1;

	wait ( wait_time );
    text FadeOverTime( 1 );
	text.alpha = 0.5;

	wait 1;
	text destroy_hud();
}


/* PERK HINTS HANDLED IN _ZOMBIEMODE_FFOTD.CSC CLIENTSCRIPT */

generate_perk_hint( perkOrWeapon, specialHint )
{
    self endon( "death" );
	self endon( "disconnect" );
	
	if( GetDvarInt( "ui_hud_perk_hints") == 0 )
		return;

	if( is_true( self.superpower_active ) )
		return;

	if( !isdefined( specialHint ) )
		specialHint = false;


	if( perkOrWeapon == "rottweil72_upgraded_zm" )
	{
		perkOrWeapon = "specialty_pap_hellfire_onhit";
	}
	else if( perkOrWeapon == "dragunov_upgraded_zm_x2" ) 
	{
		perkOrWeapon = "specialty_pap_hellfire_onhit";
	}
	else if( perkOrWeapon == "spas_upgraded_zm_x2" ) {
		//nothing
	}
	else if( perkOrWeapon == "spectre_upgraded_zm_x2" ) {
		//nothing
	}
	else if( perkOrWeapon == "famas_upgraded_zm_x2" ) {
		//nothing
	}
	else if( perkOrWeapon == "uzi_upgraded_zm_x2" ) {
		//nothing
	}
	else if( perkOrWeapon == "mac11_upgraded_zm_x2" ) {
		//nothing
	}
	else if( perkOrWeapon == "ks23_upgraded_zm_x2" ) {
		//nothing
	}
	else if( is_in_array(level.ARRAY_HELLFIRE_WEAPONS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_pap_hellfire";
	}
	else if( is_in_array(level.ARRAY_SHEERCOLD_WEAPONS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_pap_sheer_cold";
	}
	else if( is_in_array(level.ARRAY_ELECTRIC_WEAPONS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_pap_shock_rounds";
	}
	else if( is_in_array(level.ARRAY_EXECUTE_WEAPONS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_pap_execute";
	}
	else if( is_in_array(level.ARRAY_BIGDMG_WEAPONS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_pap_big_damage";
	}
	else if( is_in_array(level.ARRAY_BIGHEADSHOTDMG_WEAPONS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_pap_big_headshot_damage";
	}
	else if( is_in_array(level.ARRAY_VALID_SHOTGUNS, perkOrWeapon))
	{
		perkOrWeapon = "specialty_shotgun_damage";
	}
	else if( is_in_array( level.ARRAY_VALID_SNIPERS, perkOrWeapon) )
	{
		//perkOrWeapon = "specialty_sniper_damage"; //Not necessary
	}
	//level.ARRAY_SIDEARMBONUS_WEAPONS
	else if( is_in_array(level.ARRAY_SIDEARMBONUS_WEAPONS, perkOrWeapon) )
	{
		perkOrWeapon = "specialty_sidearm_bonus";
	}
	else if( perkOrWeapon == "combat_knife_zm" || perkOrWeapon == "vorkuta_knife_sp" )
	{
		perkOrWeapon = "specialty_offhand_melee";
	}


	//iprintln( "check activated: " + perkOrWeapon );
	hintCode = perkOrWeapon;
	if( is_true( self.hints_activated[ hintCode ] ) )
		return;

	self.hints_activated[ hintCode ] = true;

	iprintln( "notify: " + hintCode );

	while( self.new_perk_hint ) {
		self waittill( "perk_hint_end" );
	}
	self.new_perk_hint = true;

	iprintln( "notify 2: " + hintCode );

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
	title.font = "big";
	title.fontScale = 1.6;
	title.alpha = 0;
	title.color = ( 1.0, 1.0, 1.0 );

    title.y += BASE_OFFSET;

	if( specialHint )
	{
		title.color = ( 0.5, 0, 0 );
		//title.y -= 20;
	}
		
   


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

	if( specialHint )
	{
		//text.color = ( 1.0, 0.95, 0 );
		//text.y -= 20;
	}
		
   

    /* SET APPROPRIATE HINT */
		switch( hintCode )
		{
		case "apocalypse":
		//\n- Zombies will respawn at full health if not killed quickly \n- Rounds will automatically start if you wait too long; with a break every 5 rounds \n- Damaging zombies gives less points; kills and headshots give more points \n- Points are rewarded for finishing a round quickly \n- Doors and upgrades are more expensive
			title SetText( &"REIMAGINED_APOCALYPSE_TITLE" );
			text SetText( &"REIMAGINED_APOCALYPSE_HINT" );
			break;

		case "apocalypse_rounds":
		//\n- Zombies will respawn at full health if not killed quickly \n- Rounds will automatically start if you wait too long; with a break every 5 rounds \n- Damaging zombies gives less points; kills and headshots give more points \n- Points are rewarded for finishing a round quickly \n- Doors and upgrades are more expensive
			title SetText( &"REIMAGINED_APOCALYPSE_ROUNDS_TITLE" );
			text SetText( &"REIMAGINED_APOCALYPSE_ROUNDS_HINT" );
			break;

		case "apocalypse_points":
		//\n- Zombies will respawn at full health if not killed quickly \n- Rounds will automatically start if you wait too long; with a break every 5 rounds \n- Damaging zombies gives less points; kills and headshots give more points \n- Points are rewarded for finishing a round quickly \n- Doors and upgrades are more expensive
			title SetText( &"REIMAGINED_APOCALYPSE_POINTS_TITLE" );
			text SetText( &"REIMAGINED_APOCALYPSE_POINTS_HINT" );
			break;

		case "babyjugg":
			title SetText( &"REIMAGINED_BABYJUGG_TITLE" );
			text SetText( &"REIMAGINED_BABYJUGG_HINT" );
			break;
		case "specialty_armorvest":
			if( level.apocalypse )
			{
				title SetText( &"REIMAGINED_JUG_PRK_TITLE" );
				text SetText( &"REIMAGINED_JUG_PRK_HINT" );
			}
			break;
		case "specialty_armorvest_upgrade":
			text SetText( &"REIMAGINED_JUG_PRO_HINT" );
			title SetText( &"REIMAGINED_JUG_PRO_TITLE" );
			break;

		case "specialty_quickrevive":
			text SetText( &"REIMAGINED_QRV_PRK_HINT" );
			title SetText( &"REIMAGINED_QRV_PRK_TITLE" );
			break;
			
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

		case "specialty_flakjacket":
			text SetText( &"REIMAGINED_PHD_PRK_HINT" );
			title SetText( &"REIMAGINED_PHD_PRK_TITLE" );
		
			break;
		case "specialty_flakjacket_upgrade":
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
			text SetText( &"REIMAGINED_PAP_HELLFIRE_HINT" );
			title SetText( &"REIMAGINED_PAP_HELLFIRE_TITLE" );
			break;

		case "specialty_pap_hellfire_onhit":
			text SetText( &"REIMAGINED_PAP_HELLFIRE_ONHIT_HINT" );
			title SetText( &"REIMAGINED_PAP_HELLFIRE_ONHIT_TITLE" );
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

		case "specialty_pap_execute":
			text SetText( &"REIMAGINED_PAP_EXECUTE_HINT" );
			title SetText( &"REIMAGINED_PAP_EXECUTE_TITLE" );
			break;

		case "specialty_shotgun_damage":
			text SetText( &"REIMAGINED_SHOTGUN_DAMAGE_HINT" );
			title SetText( &"REIMAGINED_\SHOTGUN_DAMAGE_TITLE" );
			break;

		case "specialty_sniper_damage":
			text SetText( &"REIMAGINED_SNIPER_DAMAGE_HINT" );
			title SetText( &"REIMAGINED_SNIPER_DAMAGE_TITLE" );
			break;

		case "specialty_sidearm_bonus":
			if( level.apocalypse )
			{
				text SetText( &"REIMAGINED_SIDEARM_DAMAGE_HINT" );
				title SetText( &"REIMAGINED_SIDEARM_DAMAGE_TITLE" );
			}
			break;
		case "specialty_offhand_melee":
			text SetText( &"REIMAGINED_OFFHAND_MELEE_HINT" );
			title SetText( &"REIMAGINED_OFFHAND_MELEE_TITLE" );
			break;

		case "free_perk_powerup":
			text SetText( &"REIMAGINED_FREE_PERK_HINT" );
			title SetText( &"REIMAGINED_FREE_PERK_TITLE" );
			break;

		case "superpower_powerup":
			text SetText( &"REIMAGINED_POWERUP_SUPERPOWER_HINT" );
			title SetText( &"REIMAGINED_POWERUP_SUPERPOWER_TITLE" );
			break;

		case "restock_powerup":
			text SetText( &"REIMAGINED_POWERUP_RESTOCK_HINT" );
			title SetText( &"REIMAGINED_POWERUP_RESTOCK_TITLE" );
			break;

		/* Specific Weapons */
		case "m1911_upgraded_zm":
			//Dont set if player is in last stand
			if( self maps\_laststand::player_is_in_laststand() )
			{
				self.hints_activated[ "m1911_upgraded_zm" ] = false;
				return;
			}
				
			text SetText( &"REIMAGINED_PAP_M1911_HINT" );
			title SetText( &"REIMAGINED_PAP_M1911_TITLE" );
			break;

		//for uzi
		case "uzi_upgraded_zm_x2":
			text SetText( &"REIMAGINED_PAP_UZIZI_HINT" );
			title SetText( &"REIMAGINED_PAP_UZIZI_TITLE" );
			break;

		//for famas
		case "famas_upgraded_zm_x2":
			text SetText( &"REIMAGINED_PAP_FAMAS_HINT" );
			title SetText( &"REIMAGINED_PAP_FAMAS_TITLE" );
			break;

		//for mac11
		case "mac11_upgraded_zm_x2":
			text SetText( &"REIMAGINED_PAP_MAC11_HINT" );
			title SetText( &"REIMAGINED_PAP_MAC11_TITLE" );
			break;

		//for ks23
		case "ks23_upgraded_zm_x2":
			text SetText( &"REIMAGINED_PAP_KS23_HINT" );
			title SetText( &"REIMAGINED_PAP_KS23_TITLE" );
			break;

		//for spas
		case "spas_upgraded_zm_x2":
			text SetText( &"REIMAGINED_PAP_SPAS_HINT" );
			title SetText( &"REIMAGINED_PAP_SPAS_TITLE" );
			break;

		case "zombie_type_red":
			text SetText( &"REIMAGINED_ZOMBIE_RED_HINT" );
			title SetText( &"REIMAGINED_ZOMBIE_RED_TITLE" );
			break;

		case "zombie_type_purple":
			text SetText( &"REIMAGINED_ZOMBIE_PURPLE_HINT" );
			title SetText( &"REIMAGINED_ZOMBIE_PURPLE_TITLE" );
			break;
		}

	text FadeOverTime( 1 );
	text.alpha = 1;

	title FadeOverTime( 1 );
	title.alpha = 1;

	wait_time = 7;

	if( specialHint )
		wait_time = 10;	

	wait( wait_time );
	self.new_perk_hint = false;
	self notify( "perk_hint_end" );


    title FadeOverTime( 2 );
	title.alpha = 0;

    text FadeOverTime( 2 );
	text.alpha = 0;

	if( returnVultureVision )
		self.vulture_vison_toggle = true;

	title destroy_hud();
	text destroy_hud();

	iprintln( "notify 3: " + hintCode );
}

wait_print( msg, data )
{
	flag_wait("begin_spawning");
	wait(5);
	if( isdefined( data ) )
	{
		iprintln( msg + " " + data );
	}
	else
	{
		iprintln( msg  + " undefined data");
	}
	
}

/*
	###############################
		X2 Weapon Names
	###############################
*/

/*

	REFERENCE          	WEAPON_SABERTOOTH
LANG_ENGLISH       	"Sabertooth"

REFERENCE          	SABERTOOTH_UPGRADED
LANG_ENGLISH       	"S-115 Dismemberer"

REFERENCE          	SABERTOOTH_UPGRADED
LANG_ENGLISH       	"S-339 Incinerator"

REFERENCE          	CROSSBOW_EXPLOSIVE_UPGRADED_X2
LANG_ENGLISH        "Deliverance"

REFERENCE          	KNIFE_BALLISTIC_UPGRADED_X2
LANG_ENGLISH        "Krauss Defibrillator"


REFERENCE          	KS23_UPGRADED
LANG_ENGLISH       	"KS-56"

REFERENCE          	KS23_UPGRADED_X2
LANG_ENGLISH       	"Shock Army Executioner"

REFERENCE          	SPAS_UPGRADED_X2
LANG_ENGLISH       	"Spas-M24"

REFERENCE          	HS10_UPGRADED_X2
LANG_ENGLISH        "Typhoid & Mary (Divorced)"



REFERENCE          	AK47_UPGRADED
LANG_ENGLISH       	"The Red Mist"

REFERENCE          	AK47_UPGRADED
LANG_ENGLISH       	"Blitzkrieg"

REFERENCE          	ENFIELD_UPGRADED
LANG_ENGLISH       	"WINFIELD"

REFERENCE          	ENFIELD_UPGRADED_X2
LANG_ENGLISH       	"Bullpup Penatrator"

REFERENCE          	AUG_UPGRADED_X2
LANG_ENGLISH        "Shock & AUG"

REFERENCE          	FAMAS_UPGRADED_X2
LANG_ENGLISH        "G16-G-Infinite"

REFERENCE          	FNFAL_UPGRADED_X2
LANG_ENGLISH        "FN Peacemaker"

REFERENCE          	G11_LPS_UPGRADED_X2
LANG_ENGLISH        "Gone-11"

REFERENCE          	GALIL_UPGRADED_X2
LANG_ENGLISH        "Winter's Wail"

REFERENCE          	COMMANDO_UPGRADED_X2
LANG_ENGLISH        "The Feast"



REFERENCE          	SPECTRE_UPGRADED_X2
LANG_ENGLISH        "Wraith"

REFERENCE          	PPSH_UPGRADED
LANG_ENGLISH       	"The Reaper"

REFERENCE          	PPSH_UPGRADED_X2
LANG_ENGLISH       	"YTE SLAYA"

REFERENCE          	UZI_UPGRADED
LANG_ENGLISH       	"Uzizi"

REFERENCE          	UZI_UPGRADED_X2
LANG_ENGLISH       	"Uzizi "

REFERENCE          	MAC11_UPGRADED
LANG_ENGLISH       	"Killer & Psycho"

REFERENCE          	MAC11_UPGRADED_X2
LANG_ENGLISH       	"Turmoil Twins"


REFERENCE          	ASP_UPGRADED
LANG_ENGLISH       	"Another Side Piece"

REFERENCE          	ASP_UPGRADED_X2
LANG_ENGLISH       	"PSA Death"

REFERENCE          	CZ75_DW_UPGRADED_X2
LANG_ENGLISH        "Silhouette and Gamble"

REFERENCE          	CZ75_UPGRADED_X2
LANG_ENGLISH        "Silhouette"

REFERENCE          	PYTHON_UPGRADED_X2
LANG_ENGLISH        "Cobra's Frenzy"


REFERENCE          	STONER63_UPGRADED
LANG_ENGLISH       	"Stoned69"

REFERENCE          	STONER63_UPGRADED_x2
LANG_ENGLISH       	"He Who is Without Sin"

REFERENCE          	HK21_UPGRADED_X2
LANG_ENGLISH        "H115 Oscillator"

REFERENCE          	RPK_UPGRADED_X2
LANG_ENGLISH        "Scorched Earch"

REFERENCE          	M60_UPGRADED
LANG_ENGLISH       	"Mega-60"

REFERENCE          	M60_UPGRADED_X2
LANG_ENGLISH       	"Big Daddy"



REFERENCE          	PSG1_UPGRADED
LANG_ENGLISH       	"Psychotic Salient Genius"

REFERENCE          	PSG1_UPGRADED_X2
LANG_ENGLISH       	"Serendipity"

REFERENCE          	L96A1_UPGRADED_X2
LANG_ENGLISH        "L115 Decimator"

REFERENCE          	DRAGUNOV_UPGRADED_X2
LANG_ENGLISH        "Zmei's Breath"


REFERENCE          	RAY_GUN_UPGRADED_X2
LANG_ENGLISH        "RAY_GUN_UPGRADED_X2"

REFERENCE          	CHINA_LAKE_UPGRADED_X2
LANG_ENGLISH        "CHINA_LAKE_UPGRADED_X2"


REFERENCE          	ROTTWEIL72_UPGRADED_X2
LANG_ENGLISH        "ROTTWEIL72_UPGRADED_X2"

REFERENCE          	ITHACA_UPGRADED_X2
LANG_ENGLISH        "Destroyer"

REFERENCE          	M14_UPGRADED_X2
LANG_ENGLISH        "M14_UPGRADED_X2"

REFERENCE          	M16_UPGRADED_X2
LANG_ENGLISH        "M16_UPGRADED_X2"

REFERENCE          	MP40_UPGRADED_X2
LANG_ENGLISH        "MP40_UPGRADED_X2"

REFERENCE          	MP5K_UPGRADED_X2
LANG_ENGLISH        "MP5K_UPGRADED_X2"

REFERENCE          	MPL_UPGRADED_X2
LANG_ENGLISH        "MPL_UPGRADED_X2"

REFERENCE          	PM63_UPGRADED_X2
LANG_ENGLISH        "PM63_UPGRADED_X2"

REFERENCE          	PM63_UPGRADED_X2
LANG_ENGLISH        "PM63_UPGRADED_X2"

REFERENCE          	AK74U_UPGRADED_X2
LANG_ENGLISH        "AK74U_UPGRADED_X2"

REFERENCE          	SHOTGUN_DOUBLE_BARRELED_UPGRADED
LANG_ENGLISH        "SHOTGUN_DOUBLE_BARRELED_UPGRADED"

REFERENCE          	FG42_UPGRADED_X2
LANG_ENGLISH        "FG42_UPGRADED_X2"

REFERENCE          	GEWEHR43_UPGRADED_X2
LANG_ENGLISH        "GEWEHR43_UPGRADED_X2"

REFERENCE          	KAR98K_UPGRADED_X2
LANG_ENGLISH        "KAR98K_UPGRADED_X2"

REFERENCE          	M1A1CARBINE_UPGRADED_X2
LANG_ENGLISH        "M1A1CARBINE_UPGRADED_X2"

REFERENCE          	SHOTGUN_UPGRADED_X2
LANG_ENGLISH        "SHOTGUN_UPGRADED_X2"

REFERENCE          	STG-44_UPGRADED
LANG_ENGLISH        "STG-44_UPGRADED"

REFERENCE          	THOMPSON_UPGRADED_X2
LANG_ENGLISH        "THOMPSON_UPGRADED_X2"

REFERENCE          	TYPE100_SMG_UPGRADED_X2
LANG_ENGLISH        "TYPE100_SMG_UPGRADED_X2"


REFERENCE          	BAR_UPGRADED
LANG_ENGLISH        "THE STANDARD"

REFERENCE          	M1GARAND_UPGRADED
LANG_ENGLISH        "BULLPUP T31"

REFERENCE          	SPRINGFIELD_UPGRADED
LANG_ENGLISH        "WINTERFIELD"

REFERENCE          	MAKAROV_UPGRADED
LANG_ENGLISH        "PM Standartnyy"




*/

/*
	method: getWeaponUiName

	description: Returns the weapon name for the given weapon using the weapon file's string
	and the number of PaP metadata

*/
getWeaponUiName( weapon )
{

	if( IsDefined( self.packapunch_weapons[ weapon ] ) )
	{
		//if substring allready contains _x2, nothing
		if( isSubStr( weapon, "_x2" ) )	{
			//nothing
		}
		else if( self.packapunch_weapons[ weapon ] > 1 )
		{
			weapon += "_x2";
		}
	}

	
	wepName = "";
	switch( weapon )
	{
		case "sabertooth_upgraded_zm_x2":
			wepName = "S-339 Disintegrator";
		break;

		case "crossbow_explosive_upgraded_zm_x2":
			wepName = "Deliverance";
		break;

		case "knife_ballistic_upgraded_zm_x2":
			wepName = "Krauss Defibrillator";
		break;
		
		case "ks23_upgraded_zm_x2":
			wepName = "Shock Army Exterminator";
		break;

		case "spas_upgraded_zm_x2":
			wepName = "Spontaneity";
		break;

		case "hs10_upgraded_zm_x2":
			wepName = "Typhoid & Mary (Divorced)";
		break;

		case "ak47_upgraded_zm_x2":
			wepName = "Blitzkrieg";
		break;

		case "enfield_upgraded_zm_x2":
			wepName = "Bullpup Penetrator";
		break;

		case "aug_acog_mk_upgraded_zm_x2":
			wepName = "Shock & AUG";
		break;

		case "famas_upgraded_zm_x2":
			wepName = "G16-G-Infinite";
		break;

		case "fnfal_upgraded_zm_x2":
			wepName = "The Peacemaker";
		break;

		case "g11_lps_upgraded_zm_x2":
			wepName = "Gone-11";
		break;

		case "galil_upgraded_zm_x2":
			wepName = "Winter's Wail";
		break;

		case "commando_upgraded_zm_x2":
			wepName = "The Feast";
		break;


		case "spectre_upgraded_zm_x2":
			wepName = "Wraith";
		break;

		case "kiparis_upgraded_zm_x2":
			wepName = "Little John";
		break;

		case "ppsh_upgraded_zm_x2":
			wepName = "Y0TE SLAYA";
		break;

		case "uzi_upgraded_zm_x2":
			type = level.WEAPON_UZI_TYPES[ self.weap_options["uzi_upgraded_zm_x2"] ];
			wepName = "Uzizi " + type;
		break;

		case "mac11_upgraded_zm_x2":
			wepName = "Turmoil Twins";
		break;

		case "asp_upgraded_zm_x2":
			wepName = "PSA Death";
		break;

		case "cz75_dw_upgraded_zm_x2":
			wepName = "Silhouette and Gamble";
		break;

		case "cz75_upgraded_zm_x2":
			wepName = "Silhouette";
		break;

		case "python_upgraded_zm_x2":
			wepName = "Cobra's Frenzy";
		break;

		case "makarov_upgraded_zm_x2":
			wepName = "Winter's Uzhas";
		break;

		case "hk21_upgraded_zm_x2":
			//wepName = "H115 Oscillator";
		break;

		case "rpk_upgraded_zm_x2":
			//wepName = "Scorched Earth";
		break;

		case "m60_upgraded_zm_x2":
			wepName = "Big Daddy";
		break;

		case "stoner63_upgraded_zm_x2":
			wepName = "He Who is Without Sin";
		break;

		case "psg1_upgraded_zm_x2":
			wepName = "Serendipity";
		break;

		case "l96a1_upgraded_zm_x2":
			wepName = "L115 Decimator";
		break;

		case "dragunov_upgraded_zm_x2":
			wepName = "Zmei's Breath";
		break;

		//Knives
		case "knife_zm":
			if( self.knife_index == level.VALUE_WPN_INDEX_BOWIE)
				wepName = "Bowie Knife";
			else if( self.knife_index == level.VALUE_WPN_INDEX_SICKLE)
				wepName = "Sickle";
		break;
	
		case "combat_knife_zm":
			if( self.knife_index == level.VALUE_WPN_INDEX_BOWIE)
				wepName = "Bowie Knife";
			else if( self.knife_index == level.VALUE_WPN_INDEX_SICKLE)
				wepName = "Sickle";

	}

	//iprintln( "DYNAMIC NAME: " + wepName );

	return wepName;
}


//player_play_temporary_fx( "powerup_on_solo", "tag_flash", fowardDir, 2 )
//turn the above into a function
player_play_temporary_fx( fxName, tagOnPlayer, time, offset, angleOffset, time ) 
{
	if(!isdefined( time ) ) 
		time = 2;

	if(!isdefined( offset ) ) 
		offset = (0,0,0);

	if(!isdefined( angleOffset ) )
		angleOffset = (0,0,0);

	model = Spawn( "script_model", self GetTagOrigin( tagOnPlayer ) );
	model setModel( "tag_origin" );
	model LinkTo( self, "tag_origin", offset, angleOffset );
	//model LinkTo( self, "tag_flash" );

	PlayFXOnTag( level._effect[ fxName ], model, "tag_origin" );
	wait( time );
	if( isdefined( model ) ) model delete();
}
			

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
	//sanchez_challenge_tomb
	object SetModel( "sanchez_challenge_tomb" );
	//object SetModel( "t6_wpn_zmb_perk_bottle_jugg_world" );
	//object SetModel( "t5_weapon_sabretooth_world" );
  	//object SetModel( "char_ger_zombeng_body1_1" );

	/*
	object SetModel( "p_glo_propanetank_thin" );
	wait(1);
	object SetModel( "p_jun_dollytanks" );
	wait(1);
	object SetModel( "p_rus_chemtank_med" );
	wait(1);
	object SetModel( "zombie_tank" );
	wait(1);
	object SetModel( "zombie_vending_sleight" );
	wait(1);
	object SetModel( "p_a51_fueltank_01" );
	*/
	//object SetModel( "zombie_vending_doubletap2" );
	//object SetModel( "zombie_vending_revive" );
	//object SetModel( "zombie_vending_nuke" );
	//object SetModel( "zombie_vending_marathon" );
	//object SetModel( "zombie_vending_ads" );
	//object SetModel( "zombie_vending_three_gun" );
	//object SetModel( "p6_zm_vending_chugabud" );
	//object SetModel( "p6_zm_vending_electric_cherry_off" );
	//object SetModel( "bo2_zombie_vending_vultureaid" );
	//object SetModel( "bo3_p7_zm_vending_widows_wine_off" );


	//object.angles = angles + (0, 180, 0);
	object.angles = VectorToAngles(forward_view_angles);

	iprintlnbold("Configured object");

	wait(1);

	level.editing = array("x", "y", "z", "theta", "ro", "phi");
	level.fidelities = array(5, 10, 45);

    while(1)
    {
		/*
			q - return obj to player
			e - edit obj position and angles
				v - change editing index: x, y, z, theta, ro, phi
						- theta - like a clock
						- ro - roll

						- z - up/downm
				c - change fidelity index: 1, 5, 10, 45
				f - moves into editing mode, must press enter once to exit
					f - adjust value up
					r - adjust value down

			enter, exit fine tuning, return object to player

		*/

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
			count = 0;
			show = 30;
			//Edit objects position and angles
			i = 0; // Editing Index
    		j = level.fidelities.size-1; //fidelities index
			iprintlnbold("Tuning: " + level.editing[i] + " : " + level.fidelities[j]);
			
			while(1)
			{
				//every 10 counts display the print statement
				if(count % show == 0)
				{
					iprintlnbold("Tuning: " + level.editing[i] + " : " + level.fidelities[j]);
				}
				count++;

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

				if(self buttonPressed("f"))
				{
					iprintlnbold("Editing: ");
					temp = self editObject( object, i, j );
					object.origin = temp.origin;
					object.angles = temp.angles;

					iprintln("pos: " + object.origin);
					iprintln("ang: " + object.angles);
				}
				
				wait(0.2);

				if(self buttonPressed("ENTER"))
					break;
				
				
			}
			
			
			iprintlnbold("object position: " + object.origin);
			iprintlnbold("object angles: " + object.angles);
		}

		//iprintln("no input");
        wait 0.1;
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
		
		wait(1);

		if(self buttonPressed("r"))
		{
			iprintln("UP");
			struct adjust( editing, level.fidelities[j] );
			//wait(0.05);
			return struct;
		}
			
		if(self buttonPressed("f"))
		{
			iprintln("DOWN");
			struct adjust( editing, -1 * level.fidelities[j] );
			//wait(0.05);
			return struct;
		}


		if(self buttonPressed("ENTER"))
		{
			iprintlnbold("Returning struct");
			return struct;
		}
		
		
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
   	ZOMBIE UTILITY
	###############################
*/

/*
	get_upgraded_weapon_string
	ugrade_weapon_string
	string_weapon_upgrade

*/

get_upgraded_weapon_string( weapon )
{
	if( IsDefined( self.packapunch_weapons[ weapon ] ) )
	{
		//if substring allready contains _x2, then exit for loop
		if( isSubStr( weapon, "_x2" ) )	{
			//nothing
		}
		else if( self.packapunch_weapons[ weapon ] > 1 )
		{
			weapon += "_x2";
		}
	}

	return weapon;
}

get_base_weapon_string( base_wep ) 
{
	//iprintln( "base_wep: " + base_wep );
	if( IsSubStr( base_wep, "_x2" ) )
		base_wep = GetSubStr( base_wep, 0, base_wep.size - "_x2".size );

	if( IsSubStr( base_wep, "_upgraded" ) )
		base_wep = GetSubStr( base_wep, 0, base_wep.size - "upgraded_zm".size ) + "_zm";

	return base_wep;	
}


/*
	###############################
    GENERAL UTILITY
	###############################
*/

checkObjectInPlayableArea( object )
{
	playable_area = getentarray("player_volume","script_noteworthy");
	for (i = 0; i < playable_area.size; i++)
	{
		if (object IsTouching(playable_area[i])) {
			return true;
		}
	}
	return false;
}

//Get next index in array
get_next_index( pos, dir, size )
{
	if( dir > 0)
	{
		while( dir > 0)
		{
			pos++;
			if( pos >= size )
				pos = 0;
			dir--;
		}
		
	}
	else
	{
		while( dir < 0)
		{
			pos--;
			if( pos < 0 )
				pos = size - 1;
			dir++;
		}
	}

	return pos;
}

/*
wait_print( msg, data )
	{
		flag_wait("begin_spawning");
		iprintln( msg );
		
		if( IsDefined( data ) )
		{
			iprintln( data );
		}
		
	}
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


generate_completed_hint( claimReward )
{
	self endon( "disconnect" );

	text = NewClientHudElem( self );
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "user_center";
	text.vertAlign = "user_bottom";
	text.foreground = true;
	text.font = "default";
	text.fontScale = 1.6;
	text.alpha = 1;
	text.color = ( 0.0, 1.0, 0.0 );
	text SetText( "Complete!" );
	text.y -= 150;

	//Put another text below that asks to claim reward
	rewardText = undefined;
	if( is_true( claimReward ) && !is_true( level.rewardInProgress ) )
	{
		rewardText = NewClientHudElem( self );
		rewardText.alignX = "center";
		rewardText.alignY = "middle";
		rewardText.horzAlign = "user_center";
		rewardText.vertAlign = "user_bottom";
		rewardText.foreground = true;
		rewardText.font = "default";
		rewardText.fontScale = 1.2;
		rewardText.alpha = 1;
		rewardText.color = ( 1.0, 1.0, 1.0 );
		rewardText SetText( "Press ^3[{+activate}]^7 to claim your reward." );
		rewardText.y -= 100;
	}

	wait 0.05;
	text destroy_hud();
	if( isdefined( rewardText ) ) 
		rewardText destroy_hud();
}


/** CHALLENGE METHOD HELPERS **/


//sanchez_challenge_tomb

start_challenges()
{
	PreCacheModel( "sanchez_challenge_tomb" );
	//flag_wait( "all_players_connected" );
	level waittill( "challenges_configured" );
	//flag_wait( "challenges_configured");

	//level thread level_reset_zombie_hashes();

	origin = ( 0, 0, 0 );
	angles = ( 0, 0, 0 );
	rewardDrop = (30, 0, 0);
	switch( level.script )
	{
		case "zombie_theater":	//alley
			origin = (-1150, -140, 0);
			//origin = ( 180, -473.2, 320.1 );	//pap
			angles = ( 10, 0, 0 );
			rewardDrop = (-100, 0, 0);
			break;

		case "zombie_pentagon": //center lab halllway
			//origin = ( -2283.8, 1871.6, -511.9 );
			//angles = ( 0, 270, 0 );
			//-466, 1567, -307 -- 1580 was to far to guard rail
			//8 45, 0
			origin = ( -480, 1576, -307 );	//top guard rail main room
			angles = ( 14, -40, 0 );
			rewardDrop = (-50, 15, 0);
			break;
			
		case "zombie_cosmodrome":
			//origin = ( 411.4, 87.6, -303.9 );
			//angles = ( 0, 270, 0 );
			//-2461 2130 -75
			origin = ( -2450, 2110, -75 );
			angles = ( 8, 90, 0 );
			rewardDrop = (0, -100, 0);
			break;
			
		case "zombie_coast": // by light house
			//origin = ( -331.6, 877.1, 255.1 ); idk
			origin = ( -315 , 1085, 485 ); //near lighthouse
			angles = ( 8, 45, 0 );
			rewardDrop = (-60, -50, 0);
			break;
			
		case "zombie_temple": //opposite jug side
			//origin = ( 194.5, -532.1, -339.9 );
			//angles = ( 0, 266, 0 );
			iprintln("AWAITING TOMB SET" );
			iprintln("Level jugg spot: " + level.juggSpot );
			iprintln("Level jugg origin: " + level.juggOrigin );
			iprintln("Level jugg origin2: " + level.juggOrigin[0] );
			cartside = false;
			if( level.juggSpot == "CART")
				cartside = false;
			else if( level.juggSpot == "TRAP" )
				cartside = true;
			else {	//jugg in center
				if( randomint(2) == 1 )
					cartside = true;
			}

			if( cartside )
			{
				origin = ( 850, -2016, -180.9 ); //minecart side
				angles = (12, 262, 0 );
				rewardDrop = (0, 100, 0);

			} else {
				origin = ( -1900.5, -2107, -207 ); //trap side
				angles = ( 10, -90, 0 );
				rewardDrop = (0, 100, 0);
			}
			
			break;
			
		case "zombie_moon":	//outside spawn
			origin = ( 558, 367, -225 );
			angles = ( 10, 90, 0 );
			rewardDrop = (0, 90, 20);
			break;
			
		case "zombie_cod5_prototype":
			//origin = ( -188.1, 1109.4, 144.1 ); stairs
			//angles = ( 0, 90, 0 );
			origin = ( 173, 592.5, 138.1 ); //help room sawed off
			angles = ( 6, 90, 0 );			//slight lean against wall
			rewardDrop = (0, -100, 0);
			break;
			
		case "zombie_cod5_asylum":
			//origin = ( -721.8, -43.6, 64.1 ); bottom power room
			//angles = ( 0, 90, 0 );
			origin = ( -136, -601, 215 ); //to left of power
			//50 45 20
			angles = ( 50, -45, 20 );
			rewardDrop = (-100, 0, 30);
			break;
			
		case "zombie_cod5_sumpf":
			origin = ( 10115, 1240, -535 );	//next to spawn, zipline room
			//origin = ( 9545, 577.1, -528.9 );	//spawnroom
			angles = ( 8, 180, 0 );
			rewardDrop = (100, 0, 0);
			break;
			
		case "zombie_cod5_factory":
			//origin = ( 337, 535.9, -2.9 );
			origin = ( 245, -910, 48 );
			angles = ( 8, 270, 0 );
			rewardDrop = (0, 100, 0);
			break;
	}
	model = Spawn( "script_model", origin );
	model.angles = angles;
	model SetModel( "sanchez_challenge_tomb" );
	level.challenge_tomb = model;
	level.challenge_tomb.rewardOrigin = model.origin + rewardDrop;

	level thread challenge_tomb_think();

	players = getplayers();
	while( true )
	{
		players_complete = true;
		for( i = 0; i < players.size; i ++ )
		{
			if( !is_true( players[i].all_challenges_completed ) )
			{
				players_complete = false;
				break;
			}
		}
		if( players_complete ) {
			break;
		}
		wait 0.05;
	}

	trigger = Spawn( "trigger_radius_use", level.challenge_tomb.origin + ( 0, 0, 30 ), 0, 20, 70 );
	if(level.round_number < level.VALUE_ENDGAME_ROUND ) {
		trigger SetCursorHint( "HINT_NOICON" );
		trigger SetHintString( &"REIMAGINED_ENDGAME_ROUND_REQUIREMENT", level.VALUE_ENDGAME_ROUND );
	}

	trigger = Spawn( "trigger_radius_use", model.origin + ( 0, 0, 30 ), 0, 20, 70 );
	trigger SetCursorHint( "HINT_NOICON" );
	trigger SetHintString( &"REIMAGINED_ENDGAME_BUY_STRING", level.VALUE_ENDGAME_BUY_COST );

	wait 1;
	level notify( "buyable_ending_ready" );
	
	while( true )
	{
		trigger waittill( "trigger", player );
		if( player in_revive_trigger() || !is_player_valid( player ) || player.score < level.VALUE_ENDGAME_BUY_COST )
		{
			player PlaySound( "deny" );
			player maps\_zombiemode_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}
		play_sound_at_pos( "purchase", player.origin );
		player maps\_zombiemode_score::minus_to_player_score( 50000 );
		break;
	}

	wait 1;

	trigger Delete();
	level.beat_the_game = true;
	level notify( "end_game" );
}

delete_on_disconnect( player )
{
	player waittill( "disconnect" );
	self Delete();
}

challenge_tomb_think()
{
	level endon( "end_game" );
	wait 2;
	players = getplayers();
	for ( i = 0; i < players.size; i++ ) {
		players[i] thread player_watch_challenges();
	}

}


/*
	Relevant hooks:
	self.challengeData.zombieDamageHook
	self.challengeData.playerLocationHook

	Challenge indices:
	0 - press X to start
	1 - primary weapon kills
	2 - survive round in location
	3 - specialty kills (headshots, one shot, damage)
	4 - niche weapon kills
	5 - Survive until round 25
	6 - challenges 6-10


	//useful
	maps/_zombiemode_zone_manager.gsc:96:player_in_zone( zone_name )

*/

setInvisibleToAll() {
	players = getplayers();
	for ( i = 0; i < players.size; i++ ) {
		self SetInvisibleToPlayer( players[i] );
	}
}

player_watch_challenges()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	challenges = SpawnStruct();
	challenges.primaryType = array_randomize( level.ARRAY_WEAPON_PRIMARY_TYPES )[0];
	challenges.nicheType = array_randomize( level.ARRAY_WEAPON_NICHE_TYPES )[0];
	challenges.locations = array();
	randomArr = array_randomize( level.ARRAY_CHALLENGE_LOCATIONS );
	for(i=0;i<3;i++) {
		if(i==randomArr.size) break;
		challenges.locations[i] = randomArr[i];
	}

	challenges.current = 0;
	challenges.claimed = 0;
	challenges.completed = 0;
	challenges.completedArray = array(false, false, false, false, false, false, false, false, false, false, false);
	challenges.rewardsClaimed = array(false, false, false, false, false, false, false, false, false, false, false);
	self.challengeData = challenges;

	trigger = Spawn( "trigger_radius_use", level.challenge_tomb.origin + ( 0, 0, 30 ), 0, 20, 70 );
	trigger setInvisibleToAll();
	trigger SetVisibleToPlayer( self );
	trigger SetCursorHint( "HINT_NOICON" );
	trigger thread delete_on_disconnect( self );
	
	//self thread debug_challenges_complete(3, 5);

	//while(true) 
	{
		if(challenges.completed == 0) {
			self challenge_initChallenge( trigger );	//block
			self thread player_watch_challenge_hintStrings( trigger );
		} 

		self thread player_watch_challenge_rewards( trigger );

		if(challenges.completed < 5) {
			self thread challenge_watch_classKills();
			self thread challenge_watch_locationSurvive();
			self thread challenge_watch_specialtyKills();
			self thread challenge_watch_nicheChallenge();
		}

		while(challenges.completed < 5 || challenges.claimed < 4 ) {
			wait(5);
		}

		while(challenges.completed >= 5) {

			if(level.round_number >= level.VALUE_MIDGAME_ROUND) {
				challenges.completed = 6;
				break;
			}
			level waittill( "start_of_round" );
		}

		iprintln("Midgame reached, starting endgame challenges");
		if(challenges.completed < 11) {
			self thread challenge_watch_nicheDamageRound();
			self thread challenge_watch_specialtyKillsHard();
			self thread challenge_watch_sequentialLocationKills();
			self thread challenge_watch_scaledCombinedKills();
		}

		while(challenges.completed < 10 ) {
			wait(5);
		}

	}

	self.all_challenges_completed = true;
	trigger Delete();

}

//watch_hints
player_watch_challenge_hintStrings( trigger )
{
	level endon( "buyable_ending_ready" );

	challenges = self.challengeData;
	challenges.hintStrings = array();

	medal_1 = level.challenge_tomb GetTagOrigin( "tag_medal_1" );
	medal_2 = level.challenge_tomb GetTagOrigin( "tag_medal_2" );
	medal_3 = level.challenge_tomb GetTagOrigin( "tag_medal_3" );
	medal_4 = level.challenge_tomb GetTagOrigin( "tag_medal_4" );

	primaryName = level.ARRAY_WEAPON_TYPES_NAMES[ challenges.primaryType ];
	secondaryName = level.ARRAY_WEAPON_TYPES_NAMES[ challenges.nicheType ];

	while( challenges.completed < 11  )
	{
		if( self IsTouching( trigger ) && self maps\_laststand::is_facing( level.challenge_tomb ) )
		{
			firstLevelChallenges = challenges.current < 6;

			view_pos = self GetWeaponMuzzlePoint();
			forward_view_angles = self GetWeaponForwardDir();
			end_pos = view_pos + vector_scale( forward_view_angles, 10000 );
			radial_origin_1 = PointOnSegmentNearestToPoint( view_pos, end_pos, medal_1 );
			radial_origin_2 = PointOnSegmentNearestToPoint( view_pos, end_pos, medal_2 );
			radial_origin_3 = PointOnSegmentNearestToPoint( view_pos, end_pos, medal_3 );
			radial_origin_4 = PointOnSegmentNearestToPoint( view_pos, end_pos, medal_4 );
			distance_1 = DistanceSquared( medal_1, radial_origin_1 );
			distance_2 = DistanceSquared( medal_2, radial_origin_2 );
			distance_3 = DistanceSquared( medal_3, radial_origin_3 );
			distance_4 = DistanceSquared( medal_4, radial_origin_4 );

			if( challenges.completed == 4 && challenges.claimed == 4 ) {
				challenges.current = -1;
				trigger SetHintString( &"REIMAGINED_MIDGAME_ROUND_REQUIREMENT", level.VALUE_MIDGAME_ROUND );
				wait 0.05;
				continue;
			} else {
				//iprintln("Triggering first challenges " + firstLevelChallenges);
			}

			locations = "[";
				
					for(i=0;i<challenges.locations.size;i++) {
						locations += level.ARRAY_ZONE_NAMES[ challenges.locations[i] ];
						if(i < challenges.locations.size - 1) {
							locations += ", ";
						}
					}
			locations += "]";

			if( distance_1 < distance_2 && distance_1 < distance_3 && distance_1 < distance_4 )
			{
					//iprintln( "1 " + level.VALUE_CHALLENGE_PRIMARY_TYPE_KILLS + " | " + challenges.primaryType + " | " + challenges.primaryTypeKills );
				if( firstLevelChallenges ) 
				{
					challenges.current = 1;
					trigger SetHintString( &"REIMAGINED_CHALLENGE_CLASS_KILLS_HINT", level.VALUE_CHALLENGE_CLASS_TYPE_KILLS,
					 primaryName, secondaryName, challenges.classTypeKills , level.VALUE_CHALLENGE_CLASS_TYPE_KILLS );
					if( challenges.completedArray[1] ) 
						self thread generate_completed_hint( !challenges.rewardsClaimed[1] );
				} else {
					challenges.current = 6;

				}
				
			}
			if( distance_2 < distance_1 && distance_2 < distance_3 && distance_2 < distance_4 )
			{
				if( firstLevelChallenges ) 
				{
					challenges.current = 2;
					
					trigger SetHintString( &"REIMAGINED_CHALLENGE_LOCATIONS_SURVIVE_HINT", 1, locations );
					if( challenges.completedArray[2] ) 
						self thread generate_completed_hint( !challenges.rewardsClaimed[2] );
				} else {
					challenges.current = 7;

				}
			}
			if( distance_3 < distance_1 && distance_3 < distance_2 && distance_3 < distance_4 )
			{ 
				if( firstLevelChallenges ) 
				{
					challenges.current = 3;
					specialtyType = challenges.specialtyType;
					round = challenges.specialtyChallengeStartRound;
					if(specialtyType == "HEADSHOTS") {
						total = level.VALUE_CHALLENGE_SPECIALTY_KILLS_PER_ROUND*round;
						trigger SetHintString( &"REIMAGINED_CHALLENGE_TOTAL_HEADSHOTS_HINT", total, challenges.specialtyKills, total );
					} else if(specialtyType == "ONESHOTS") {
						total = level.VALUE_CHALLENGE_SPECIALTY_KILLS_PER_ROUND*round;
						trigger SetHintString( &"REIMAGINED_CHALLENGE_TOTAL_ONESHOTS_HINT", total, challenges.specialtyKills, total );
					} else if(specialtyType == "DAMAGE") {
						total = niceDmgString( level.VALUE_CHALLENGE_SPECIALTY_TOTAL_DAMAGE_PER_ROUND*round );
						partial = niceDmgString( challenges.specialtyDamage );
						trigger SetHintString( &"REIMAGINED_CHALLENGE_TOTAL_DAMAGE_HINT", total, partial, total );
					} else if(specialtyType == "POINTS") {
						total = niceDmgString( level.VALUE_CHALLENGE_SPECIALTY_TOTAL_POINTS_PER_ROUND*round );
						partial = niceDmgString( challenges.specialtyPoints );
						trigger SetHintString( &"REIMAGINED_CHALLENGE_TOTAL_POINTS_HINT", total, partial, total );
					}

					if( challenges.completedArray[3] ) 
						self thread generate_completed_hint( !challenges.rewardsClaimed[3] );

				} else {
					challenges.current = 8;

				}
			}
			if( distance_4 < distance_1 && distance_4 < distance_2 && distance_4 < distance_3 )
			{
				if( firstLevelChallenges ) 
				{
					challenges.current = 4;
					specialtyType = challenges.nicheChallengeType;
					if( !isDefined( specialtyType ) ) {
						trigger SetHintString( &"REIMAGINED_CHALLENGE_LOCKED_HINT");
					}
					else if(specialtyType == "KILLS") {
						total = level.VALUE_CHALLENGE_NICHE_TYPE_KILLS;
						trigger SetHintString( &"REIMAGINED_CHALLENGE_TOTAL_NICHE_KILLS_LOCATION_HINT",
						total, secondaryName, locations, challenges.nicheTypeKills, total );
					} else if(specialtyType == "DAMAGE") {
						total = niceDmgString( level.VALUE_CHALLENGE_NICHE_TYPE_DAMAGE );
						partial = niceDmgString( challenges.nicheTypeDamage );
						trigger SetHintString( &"REIMAGINED_CHALLENGE_TOTAL_NICHE_DAMAGE_LOCATION_HINT", 
						total, secondaryName, locations, partial, total );
					} else {
						trigger SetHintString( "NOT WORKING" );
					}
					if( challenges.completedArray[4] ) 
						self thread generate_completed_hint( !challenges.rewardsClaimed[4] );

				} else {
					challenges.current = 9;

					if( challenges.completedArray[9] ) 
						self thread generate_completed_hint( !challenges.rewardsClaimed[9] );
				}
				
			}
		}
		else {
			challenges.current = -1;
			trigger SetHintString( "" );
		}
		wait 0.05;
		
	}

}

	
	//no format method, use % and divide to put commas in the number
	niceDmgString( dmg ) {
		strDmg = "";
		if( dmg >= 1000000 ) {
			millions = dmg / 1000000;
			strDmg += millions + ",";
			dmg = dmg % 1000000;
			
			// Pad thousands section with leading zeros
			thousands = dmg / 1000;
			if( thousands < 100 ) {
				strDmg += "0";
			}
			if( thousands < 10 ) {
				strDmg += "0";
			}
			strDmg += thousands + ",";
			dmg = dmg % 1000;
		}
		else if( dmg >= 1000 ) {
			thousands = dmg / 1000;
			strDmg += thousands + ",";
			dmg = dmg % 1000;
		}
		
		// Pad ones section with leading zeros if there were higher sections
		if( strDmg != "" ) {
			if( dmg < 100 ) {
				strDmg += "0";
			}
			if( dmg < 10 ) {
				strDmg += "0";
			}
		}
		strDmg += dmg;
		return strDmg;
	}


player_watch_challenge_rewards( trigger ) {
	challenges = self.challengeData;

	level endon( "end_game" );
	self endon( "disconnect" );

	while( challenges.completed < 11 ) 
	{
		if( challenges.current == -1 ) {
			wait 0.1;
			continue;
		}

		trigger waittill( "trigger", player );
		
		if( player in_revive_trigger() || !is_player_valid( player ) ) continue;
		index = challenges.current;
		wait(0.25);
		level level_player_claim_reward( player, index);
		wait 1.5;
	}
}


/**

	Headshot eyes
	Challenge Complete feedback
	Challenge Complete on board
	pistol kills not working

	baby speed - fast reload on empty mag or for wall weapons
	baby double tap - 50% more damage on first 3 shots of each mag, 1st shot for single shot weapons
	baby mule - free mag of ammo each round for one weapon

*/


//** ORDERED CHALLEGNES - self is challenging player
challenge_initChallenge( trigger )
{
	//watch for player to hit start trigger on challenge board
	trigger SetHintString( "Hold ^3[{+activate}]^7 to Start Challenges" );
	challenge_tomb = level.challenge_tomb;

	while(true) 
	{
		trigger waittill( "trigger", player );

		if( player != self ) continue;
		if( player in_revive_trigger() || !is_player_valid( player ) ) {
			player PlaySound( "deny" );
			player maps\_zombiemode_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}

		play_sound_at_pos( "purchase", player.origin );
		break;
	}

	challenges = self.challengeData;

	trigger SetHintString( "" );
	self.challengeData.completed++;
	self.challengeData.completedArray[0] = true;
	self notify( "challenge_complete" );
}

/* 
		1. Weapon Class - SMG, LMG, AR, Shotgun, Sidearm
		2. Location - survive a round without leaving
		3. Challenge kills - headshots, damage, kills, location, points from specific weapon
		4.  Niche class survive - Explosive, melee, dual wield, semi auto
		5. Location + weapon class kills
		6. Reach rd 25

		Two sets of 4, one before r25, one after

		1. Weapon Class kills - SMG, LMG, AR, Shotgun, Sidearm
		2. Location - survive a round without leaving
		3. Challenge kills - headshots, damage, kills, location, points from specific weapon
		4.  Niche class kills - Explosive, melee, dual wield, magic

		//We anticipate several set hooks to hook into
		- zombie damage hook - fires when zombie is damaged by this player (player ~(zombie, weapon, damage, hitloc) )
		- player location hook - fires when player enters a new location (player ~( zoneName ) )

*/

//index 1
challenge_watch_primaryKills( weaponType ) 
{
	level endon( "end_game" );

	self.challengeData.primaryTypeKills = 0;
	self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_primaryKills;

	while( true ) {
		if( self.challengeData.primaryTypeKills >= level.VALUE_CHALLENGE_PRIMARY_TYPE_KILLS ) {
			break;
		}
		wait 1;
	}

	self.challengeData.zombieDamageHook = undefined;
	//self.challengeData.completed++;
	//self.challengeData.completedArray[1] = true;
	self notify( "challenge_complete" );
}

challenge_damageHook_validate_primaryKills(zombie, weapon, damage, hitloc) 
{
	if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;
	//check if the weapon matches, and the damage is sufficient to kill the zombie
	wepArray = level.ARRAY_WEAPON_TYPES[ self.challengeData.primaryType ];
	if( is_in_array( wepArray, weapon) ) {
		//iprintln( " Primary weapon " + weapon + " matched for challenge " + self.challengeData.primaryType );
		if( damage>= zombie.health ) {
			level.zombie_deaths[zombie.zombie_hash] = true;
			self.challengeData.primaryTypeKills++;
			return true;
		}
	}

	return false;
}

challenge_watch_nicheKills()
{
	level endon( "end_game" );

	self.challengeData.nicheTypeKills = 0;
	self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_secondaryKills;

	while( true ) {
		if( self.challengeData.nicheTypeKills >= level.VALUE_CHALLENGE_NICHE_TYPE_KILLS ) {
			break;
		}
		wait 1;
	}

	self.challengeData.zombieDamageHook = undefined;
	//self.challengeData.completed++;
	//self.challengeData.completedArray[4] = true;
	self notify( "challenge_complete" );
}


challenge_damageHook_validate_secondaryKills(zombie, weapon, damage, hitloc) 
{
	if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;

	wepArray = level.ARRAY_WEAPON_TYPES[ self.challengeData.nicheType ];
	if( is_in_array( wepArray, weapon) ) {
		if( damage >= zombie.health ) {
			//iprintln( " Niche weapon " + weapon + " matched for challenge " );
			self.challengeData.nicheTypeKills++;
			return true;
		}
	}

	return false;
}

challenge_damageHook_validate_classKills(zombie, weapon, damage, hitloc) 
{
	if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;

	if( self challenge_damageHook_validate_primaryKills( zombie, weapon, damage, hitloc ) ) {
		self.challengeData.classTypeKills++;
		return true;
	}
	if( self challenge_damageHook_validate_secondaryKills( zombie, weapon, damage, hitloc ) ) {
		self.challengeData.classTypeKills++;
		return true;
	}



	return false;
}

challenge_watch_classKills()
{
	level endon( "end_game" );

	self.challengeData.classTypeKills = 0;
	self.challengeData.primaryTypeKills = 0;
	self.challengeData.nicheTypeKills = 0;
	self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_classKills;

	while( true ) {
		if( self.challengeData.classTypeKills >= level.VALUE_CHALLENGE_CLASS_TYPE_KILLS ) {
			break;
		}
		wait 1;
	}

	self.challengeData.zombieDamageHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[1] = true;
	self notify( "challenge_complete" );
}


//Index 2: Location survive
challenge_watch_locationSurvive()
{
	level endon( "end_game" );

	self.challengeData.playerLocationHook = ::challenge_zoneUpdateHook_validate_locationSurvive;
	while( true ) {

		level waittill( "start_of_round" );
		self.challengeData.locationSurviveRound = true;
		level waittill( "end_of_round" );

		//iprintln("Completed round survive check " + self.challengeData.locationSurviveRound );
		if( self.challengeData.locationSurviveRound ) {
			break;
		}
	}

	self.challengeData.playerLocationHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[2] = true;
	self notify( "challenge_complete" );
}


challenge_zoneUpdateHook_validate_locationSurvive( zoneName ) 
{
	if(level.zombie_total <= 1) return self.challengeData.locationSurviveRound;	//little buffer for players

	locationsArray = self.challengeData.locations;
	if( !is_in_array( locationsArray, zoneName ) ) {
		//iprintln("Player left zone " + zoneName);
		self.challengeData.locationSurviveRound = false;
		return false;
	}

	return true;
}



//Index 3: Specialty kills OneShots, headshots, damage, points
challenge_watch_specialtyKills()
{
	level endon( "end_game" );

	challenges = self.challengeData;
	specialtyType = array_randomize( level.ARRAY_CHALLENGE_SPECIALTIES )[0];
	//specialtyType = "HEADSHOTS";
	//if primary type is a sniper or shotgun, change headshots to one shots
	if( specialtyType == "HEADSHOTS" ) {
		if( challenges.primaryType == "SNIPER" || challenges.primaryType == "SHOTGUN" ) {
			specialtyType = "ONESHOTS";
		}
	}

	if(specialtyType == "HEADSHOTS") {
		self.challengeData.specialtyZombieDamageHook = ::challenge_damageHook_validate_specialtyHeadshots;
	} else if(specialtyType == "ONESHOTS") {
		self.challengeData.specialtyZombieDamageHook = ::challenge_damageHook_validate_specialtyOneShots;
	} else if(specialtyType == "DAMAGE") {
		self.challengeData.specialtyZombieDamageHook = ::challenge_damageHook_validate_specialtyDamage;
	} else if(specialtyType == "POINTS") {
		self.challengeData.pointsHook = ::challenge_pointsHook_validate_specialtyPoints;
	}
	
	challenges.specialtyType = specialtyType;
	challenges.specialtyKills = 0;
	challenges.specialtyDamage = 0;
	challenges.specialtyPoints = 0;

	start_round = level.round_number;
	while( true ) {

		//goes up until first two challenges are
		if(challenges.completed < 3 ) {
			start_round = level.round_number;
			challenges.specialtyChallengeStartRound = start_round;
		}
			
		if( challenges.specialtyKills >= level.VALUE_CHALLENGE_SPECIALTY_KILLS_PER_ROUND * start_round ) {
			break;
		}

		if( challenges.specialtyDamage >= level.VALUE_CHALLENGE_SPECIALTY_TOTAL_DAMAGE_PER_ROUND * start_round ) {
			break;
		}

		if( challenges.specialtyPoints >= level.VALUE_CHALLENGE_SPECIALTY_TOTAL_POINTS_PER_ROUND * start_round ) {
			break;
		}

		wait 1;
	}

	self.challengeData.specialtyZombieDamageHook = undefined;
	self.challengeData.pointsHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[3] = true;
	self notify( "challenge_complete" );
}
	
	challenge_damageHook_validate_specialtyHeadshots( zombie, weapon, damage, sHitLoc ) 
	{
		if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;

		//iprintln(" Specialty headshot check " + weapon + " loc " +  sHitLoc + " dmg " + damage + " health " + zombie.health );
		if( damage > zombie.health ) {
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") {
				self.challengeData.specialtyKills++;
				return true;
			}
		}
		return false;
	}

	challenge_damageHook_validate_specialtyOneShots( zombie, weapon, damage, hitloc ) 
	{
		if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;
			//must be a one shot kill
		if( (damage >= zombie.max_health) && (zombie.health > (zombie.max_health-100) ))  {
			self.challengeData.specialtyKills++;
			return true;
		}
		return false;
	}

	challenge_damageHook_validate_specialtyDamage( zombie, weapon, damage, hitloc ) 
	{
		if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;
			//take min of zombie.health and damage
		dmg = damage;
		if( damage > zombie.health )
			dmg = zombie.health;
		self.challengeData.specialtyDamage += dmg;
		return true;
	}

	challenge_pointsHook_validate_specialtyPoints( event, points, mod, zombie ) 
	{
		switch( event )
		{
			case "death":
			case "ballistic_knife_death":
			case "damage_light":
			case "damage_ads":
			case "damage":
			self.challengeData.specialtyPoints += points;
			break;
		}
	}


//Index 4: watch niche challenge:
challenge_watch_nicheChallenge()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	while(self.challengeData.completed < 4) {
		self waittill( "challenge_complete" );
	}

	nicheChallengeTypes = level.ARRAY_CHALLENGE_NICHE_CHALLENGES;
	challenges = self.challengeData;
	index = randomInt(2);

	if(challenges.specialtyType == "ONESHOTS" || challenges.specialtyType == "HEADSHOTS" ) {
		index = 1;	//force damage challenge
	} else if (challenges.specialtyType == "DAMAGE" ) {
		index = 0;	//force kills challenge
	}

	nicheChallengeType = nicheChallengeTypes[ index ];
	self.challengeData.nicheChallengeType = nicheChallengeType;

	if(nicheChallengeType == "KILLS") {
		self.challengeData.nicheTypeKills = 0;
		self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_nicheKills_location;
	} else if(nicheChallengeType == "DAMAGE") {
		self.challengeData.nicheTypeDamage = 0;
		self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_nicheDamage_location;
	}

	while( true ) {

		if( self.challengeData.nicheTypeKills >= level.VALUE_CHALLENGE_NICHE_TYPE_KILLS ) {
			break;
		}

		if( self.challengeData.nicheTypeDamage >= level.VALUE_CHALLENGE_NICHE_TYPE_DAMAGE ) {
			break;
		}
		wait 1;
	}

	self.challengeData.zombieDamageHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[4] = true;
	self notify( "challenge_complete" );
}

	challenge_damageHook_validate_nicheKills_location(zombie, weapon, damage, hitloc) 
	{
		nicheKillRes = challenge_damageHook_validate_secondaryKills(zombie, weapon, damage, hitloc);
		if( nicheKillRes ) {
			locationsArray = self.challengeData.locations;
			currentZone = self maps\_zombiemode_zone_manager::player_in_zone( self );
			if( is_in_array( locationsArray, currentZone ) ) {
				self.challengeData.nicheTypeKills++;
				return true;
			}
		}
		return false;
	}

	challenge_damageHook_validate_nicheDamage_location(zombie, weapon, damage, hitloc) 
	{
		nicheDamageRes = challenge_damageHook_validate_secondaryDamage(zombie, weapon, damage, hitloc);
		if( nicheDamageRes ) {
			locationsArray = self.challengeData.locations;
			if( is_in_array( locationsArray, self.current_zone ) ) {
				dmg = damage;
				if( damage > zombie.health ) dmg = zombie.health;
				self.challengeData.nicheTypeDamage += dmg;
				return true;
			}
		}
		return false;
	}

	challenge_damageHook_validate_secondaryDamage(zombie, weapon, damage, hitloc) 
	{
		wepArray = level.ARRAY_WEAPON_TYPES[ self.challengeData.nicheType ];
		if( is_in_array( wepArray, weapon) ) {
			dmg = damage;
			if( damage > zombie.health ) dmg = zombie.health;
			self.challengeData.nicheTypeDamage += dmg;
			return true;
		}

		return false;
	}



//Index 6: Secondary Weapon Damage Round
challenge_watch_nicheDamageRound()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	challenges = self.challengeData;
	challenges.totalRoundDamage = 0;
	challenges.nicheRoundDamage = 0;
	challenges.nicheDamageRoundComplete = false;

	self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_nicheDamageRound;

	while( true ) {
		level waittill( "start_of_round" );
		challenges.totalRoundDamage = 0;
		challenges.nicheRoundDamage = 0;
		challenges.nicheDamageRoundComplete = false;

		level waittill( "end_of_round" );

		// Check if 80% of damage was from niche weapon
		if( challenges.totalRoundDamage > 0 ) {
			required_damage = int( challenges.totalRoundDamage * level.VALUE_CHALLENGE_NICHE_CLASS_ZOMBIE_DAMAGE_THRESHOLD );
			if( challenges.nicheRoundDamage >= required_damage ) {
				challenges.nicheDamageRoundComplete = true;
				break;
			}
		}
	}

	self.challengeData.zombieDamageHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[6] = true;
	self notify( "challenge_complete" );
}

challenge_damageHook_validate_nicheDamageRound(zombie, weapon, damage, hitloc)
{
	if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;

	// Calculate actual damage dealt
	dmg = damage;
	if( damage > zombie.health )
		dmg = zombie.health;

	// Check if weapon is niche type
	challenges.totalRoundDamage += dmg;
	if( is_in_array( level.ARRAY_WEAPON_TYPES[ self.challengeData.nicheType ], weapon) ) {
		self.challengeData.nicheRoundDamage += dmg;
		return true;
	}

	return false;
}


//Index 7: Constrained Kills (4 variants)
challenge_watch_specialtyKillsHard()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	challenges = self.challengeData;
	
	// Randomly select constraint type
	challenges.constraintType = array_randomize( level.ARRAY_CHALLENGE_SPECIALTIES_HARD )[0];
	
	challenges.specialtyKills = 0;

	switch( challenges.constraintType )
	{
		case "PERKS":
			self.challengeData.specialtyZombieDamageHook = ::challenge_validate_constraint_perks;
			break;

		case "WALLGUN":
			self.challengeData.specialtyZombieDamageHook = ::challenge_validate_constraint_wall;
			break;

		case "NOPAP":
			self.challengeData.specialtyZombieDamageHook = ::challenge_validate_constraint_nopap;
			break;

		case "ZOMBIE_TYPES":
			self.challengeData.specialtyZombieDamageHook = ::challenge_validate_constraint_zombie_types;
			break;
	}

	while( true ) {
		if( challenges.specialtyKills >= level.VALUE_CHALLENGE_SPECIALTIES_HARD_TOTAL_KILLS ) {
			break;
		}
		wait 1;
	}

	self.challengeData.zombieDamageHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[7] = true;
	self notify( "challenge_complete" );
}

	challenge_validate_constraint_perks( zombie, weapon, damage, hitloc ) {
		if(damage < zombie.health) return false;
		if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;
		if( self.num_perks <= level.VALUE_CHALLENGE_SPECIALTIES_HARD_PERK_LIMIT ) 
			self.challengeData.specialtyKills++;
		return true;
	}

	challenge_validate_constraint_wall(  zombie, weapon, damage, hitloc ) {
		if(damage < zombie.health) return false;
		if( is_in_array( level.ARRAY_WALL_WEAPONS, weapon ) ) {
			self.challengeData.specialtyKills++;
			return true;
		}
		return false;
	}

	challenge_validate_constraint_nopap( zombie, weapon, damage, hitloc ) {
		if(damage < zombie.health) return false;
		primaries = self GetWeaponsListPrimaries();
		for( i = 0; i < primaries.size; i++ ) {
			if( IsSubStr( primaries[i], "upgraded" ) ) {
				return false;
			}
		}
		self.challengeData.specialtyKills++;
		return true;
	}

	challenge_validate_constraint_zombie_types( zombie, weapon, damage, hitloc ) {
		if(damage < zombie.health) return false;
		if( IsDefined( zombie.zombie_type ) && zombie.zombie_type != "normal" ) {
			self.challengeData.specialtyKills++;
			return true;
		}
		return false;
	}

//Index 8: Sequential Location Kills
challenge_watch_sequentialLocationKills()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	challenges.lastKillZoneIndex = -1;
	
	challenges = self.challengeData;
	challenges.locationKillCounts = array( 0, 0, 0 );
	challenges.lastKillZoneIndex = undefined;

	self.challengeData.zombieKillHook = ::challenge_damageHook_validate_sequentialLocationKills;

	while( true ) {
		wait 1;
		if( challenges.locationKillCounts[0] < level.VALUE_CHALLENGE_CONSECUTIVE_LOCATION_KILLS ) {
			continue;
		}
		if( challenges.locationKillCounts[1] < level.VALUE_CHALLENGE_CONSECUTIVE_LOCATION_KILLS ){
			continue;
		}
		if( challenges.locationKillCounts[2] < level.VALUE_CHALLENGE_CONSECUTIVE_LOCATION_KILLS ) {
			continue;
		}
		break;
	}

	self.challengeData.zombieKillHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[8] = true;
	self notify( "challenge_complete" );
}

challenge_damageHook_validate_sequentialLocationKills(zombie, weapon, damage, hitloc)
{
	if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;
	
	// Must be a kill
	if( damage < zombie.health )
		return false;

	challenges = self.challengeData;
	current_zone = self.current_zone;
	
	if( !IsDefined( current_zone ) )
		return false;

	// Find which location index the current zone corresponds to
	location_index = -1;
	for( i = 0; i < challenges.locations.size; i++ ) {
		if( challenges.locations[i] == current_zone ) {
			location_index = i;
			break;
		}
	}

	// Not in an assigned location
	if( location_index == -1 ) {
		challenges.lastKillZoneIndex = -1;
		return false;
	}
	else if( challenges.lastKillZoneIndex == location_index ) {
		challenges.locationKillCounts[location_index]++;	
		return true;
	}
	else {
		challenges.locationKillCounts[location_index] = 1;
		challenges.lastKillZoneIndex = location_index;
		return true;
	}
}


//Index 9: Scaled Combined Kills
challenge_watch_scaledCombinedKills()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	// Wait until challenges 6-8 are complete
	while(self.challengeData.completed < 8) {
		self waittill( "challenge_complete" );
	}

	challenges = self.challengeData;
	
	// Lock the round number for scaling
	challenges.primaryTypeKills = 0;
	challenges.nicheTypeKills = 0;

	self.challengeData.zombieDamageHook = ::challenge_damageHook_validate_scaledKills;
	challenges.weaponClassCarnargeTotal = level.VALUE_CHALLENGE_TYPE_KILLS_PER_ROUND_LATE * level.round_number;

	while( true ) {
		total_kills = challenges.primaryTypeKills + challenges.nicheTypeKills;
		if( total_kills >= challenges.weaponClassCarnargeTotal ) {
			break;
		}
		wait 1;
	}

	self.challengeData.zombieDamageHook = undefined;
	self.challengeData.completed++;
	self.challengeData.completedArray[9] = true;
	self notify( "challenge_complete" );
}

challenge_damageHook_validate_scaledKills(zombie, weapon, damage, hitloc)
{
	if( !IsDefined(zombie) || zombie.health <= 0 || !IsAlive(zombie)) return false;
	
	// Must be a kill
	if( damage < zombie.health )
		return false;

	challenges = self.challengeData;
	kills_to_add = 1;

	if( is_in_array( self.challengeData.locations, self.current_zone ) ) {
		kills_to_add = 2;
	}

	// Check if kill with primary type weapon
	if( is_in_array( level.ARRAY_WEAPON_TYPES[ challenges.primaryType ], weapon ) ) {
		challenges.primaryTypeKills += kills_to_add;
		return true;
	}

	// Check if kill with niche type weapon
	if( is_in_array( level.ARRAY_WEAPON_TYPES[ challenges.nicheType ], weapon ) ) {
		challenges.nicheTypeKills += kills_to_add;
		return true;
	}
}
















level_reset_zombie_hashes() 
{
	level endon( "end_game" );

	players = getplayers();
	while( true ) {
		level waittill( "start_of_round" );
		level.zombie_deaths = [];
	}
}


//Hooks
damage_hook( zombie, weapon, damage, hitloc ) 
{
	//if self or zombie is not defined, return, set defaults for all other values
	if( !is_player_valid( self ) || !isDefined( zombie ) )
		return;

	if( !isDefined(weapon) )
		weapon = self GetCurrentWeapon();
	
	if( !isDefined(damage) )
		damage = 1;

	if( !isDefined(hitloc) )
		hitloc = "body";

	if( IsDefined( self.challengeData.zombieDamageHook ) ) {
		self [[ self.challengeData.zombieDamageHook ]] ( zombie, weapon, damage, hitloc );
	}

	//iprintln("Specialty zombie damage hook is defined: " + IsDefined( self.challengeData.specialtyZombieDamageHook ) );
	if( IsDefined( self.challengeData.specialtyZombieDamageHook ) ) {
		self [[ self.challengeData.specialtyZombieDamageHook ]] ( zombie, weapon, damage, hitloc );
	}
}

zone_update_hook( zoneName ) {
	if( IsDefined( self.challengeData.playerLocationHook ) ) {
		self [[ self.challengeData.playerLocationHook ]] ( zoneName );
	}
	return true;
}

points_hook( event, player_points, mod, zombie ) {
	if( IsDefined( self.challengeData.pointsHook ) ) {
		self [[ self.challengeData.pointsHook ]] ( event, player_points, mod, zombie );
	}
	return false;
}

//here 
//rewards level thread - called on level so 1 reward claimed at a time
#using_animtree( "generic_human" );
level_player_claim_reward( player, rewardIndex )
{
	level endon( "end_game" );

	claimed = player.challengeData.rewardsClaimed;
	if( rewardIndex < 0 || rewardIndex >= claimed.size ) {
		player PlaySound( "deny" );
		return false;
	}
	
	if( is_true( claimed[ rewardIndex ] ) ) {
		player PlaySound( "deny" );
		return false;
	}

	
	if( is_true( level.rewardInProgress) ) {
		player PlaySound( "deny" );
		return false;
	}

	if( !player.challengeData.completedArray[ rewardIndex ] ) {
		player PlaySound( "deny" );
		return false;
	}

	level.rewardInProgress = true;

	powerup = undefined;
	useDrop = false;
	switch( rewardIndex ) 
	{
		case 0:	// begin challenges
			break;
		case 1:	//perk drop
			powerup = rewardPerkDrop();
			useDrop = true;
			break;
		case 2:	//5k points
			powerup = rewardPointsDrop( 5000 );
			useDrop = true;
			break;
		case 3:	//Restock
			powerup = rewardRestockDrop();
			useDrop = true;
			break;
		case 4:	//pap teleport
			player.melee_upgrade = true;
			view_angles = player GetPlayerAngles();
			forwardDir = AnglesToForward( view_angles )*25;
			//player player_play_temporary_fx( "powerup_on", "tag_flash", 2, forwardDir, (0,0,0) );

			player thread maps\_zombiemode_perks::do_knuckle_crack_impl( false );
			//player animscripted( "meleeanim", player.origin, player.angles, %stand_2_melee_1, "normal", undefined, 1 );
			playfx( level._effect["thundergun_smoke_cloud"], player.origin+(0,10,0), AnglesToForward( view_angles ), AnglesToUp( view_angles ) );
			playfx( level._effect["thundergun_knockdown_ground"], player.origin+(0,10,0), AnglesToForward( view_angles ), AnglesToUp( view_angles ) );
			useDrop = false;
			break;
	}

	if( useDrop ) {
		iprintln("Waiting for powerup pickup " + rewardIndex + "-index " +  isDefined( powerup ) );
		if( isDefined( powerup ) ) {
			player.challengeData.rewardsClaimed[ rewardIndex ] = true;
			player.challengeData.claimed++;
		}
	} else {
		player.challengeData.rewardsClaimed[ rewardIndex ] = true;
		player.challengeData.claimed++;
	}
	wait(1);
	level.rewardInProgress = false;
	return true;
}

	rewardPerkDrop() 
	{
		level endon( "end_game" );
		return maps\_zombiemode_powerups::specific_powerup_drop( "free_perk",
		level.challenge_tomb.rewardOrigin, true, undefined, true );
	}

	rewardPointsDrop( points ) 
	{
		level endon( "end_game" );
		level.setBonusPowerupPoints = points;
		return maps\_zombiemode_powerups::specific_powerup_drop( "bonus_points_player",
		level.challenge_tomb.rewardOrigin  , true, undefined, true );
	}

	rewardRestockDrop() 
	{
		level endon( "end_game" );
		return maps\_zombiemode_powerups::specific_powerup_drop( "restock",
		level.challenge_tomb.rewardOrigin , true, undefined, true );
	}



load_zone_names() {

	level.ARRAY_ZONE_NAMES = array();
	
	// Nacht Der Untoten
	load_name( "ZOMBIE_COD5_PROTOTYPE_START_ZONE", "Start" );
	load_name( "ZOMBIE_COD5_PROTOTYPE_BOX_ZONE", "Help Room" );
	load_name( "ZOMBIE_COD5_PROTOTYPE_UPSTAIRS_ZONE", "Upstairs" );
	
	// Verruckt
	load_name( "ZOMBIE_COD5_ASYLUM_WEST_DOWNSTAIRS_ZONE", "Dentist Office" );
	load_name( "ZOMBIE_COD5_ASYLUM_WEST2_DOWNSTAIRS_ZONE", "Morgue" );
	load_name( "ZOMBIE_COD5_ASYLUM_NORTH_DOWNSTAIRS_ZONE", "North Downstairs Room" );
	load_name( "ZOMBIE_COD5_ASYLUM_SOUTH_UPSTAIRS_ZONE", "South Balcony" );
	load_name( "ZOMBIE_COD5_ASYLUM_SOUTH2_UPSTAIRS_ZONE", "Showers" );
	load_name( "ZOMBIE_COD5_ASYLUM_POWER_UPSTAIRS_ZONE", "Power" );
	load_name( "ZOMBIE_COD5_ASYLUM_KITCHEN_UPSTAIRS_ZONE", "Kitchen" );
	load_name( "ZOMBIE_COD5_ASYLUM_NORTH_UPSTAIRS_ZONE", "North Balcony" );
	load_name( "ZOMBIE_COD5_ASYLUM_NORTH2_UPSTAIRS_ZONE", "North Upstairs Room" );
	
	// Shi No Numa
	load_name( "ZOMBIE_COD5_SUMPF_CENTER_BUILDING_UPSTAIRS", "Center Building Upstairs" );
	load_name( "ZOMBIE_COD5_SUMPF_CENTER_BUILDING_UPSTAIRS_BUY", "Center Building Zipline" );
	load_name( "ZOMBIE_COD5_SUMPF_CENTER_BUILDING_COMBINED", "Center Building Downstairs" );
	load_name( "ZOMBIE_COD5_SUMPF_NORTHWEST_OUTSIDE", "Outside Fishing Hut" );
	load_name( "ZOMBIE_COD5_SUMPF_NORTHWEST_BUILDING", "Fishing Hut" );
	load_name( "ZOMBIE_COD5_SUMPF_SOUTHWEST_OUTSIDE", "Outside Comm Room" );
	load_name( "ZOMBIE_COD5_SUMPF_SOUTHWEST_BUILDING", "Comm Room" );
	load_name( "ZOMBIE_COD5_SUMPF_NORTHEAST_OUTSIDE", "Outside Doctor's Quarters" );
	load_name( "ZOMBIE_COD5_SUMPF_NORTHEAST_BUILDING", "Doctor's Quarters" );
	load_name( "ZOMBIE_COD5_SUMPF_SOUTHEAST_OUTSIDE", "Outside Storage" );
	load_name( "ZOMBIE_COD5_SUMPF_SOUTHEAST_BUILDING", "Storage" );
	
	// Der Riese
	load_name( "ZOMBIE_COD5_FACTORY_RECEIVER_ZONE", "Mainframe" );
	load_name( "ZOMBIE_COD5_FACTORY_OUTSIDE_WEST_ZONE", "Outside Warehouse" );
	load_name( "ZOMBIE_COD5_FACTORY_OUTSIDE_EAST_ZONE", "Outside Laboratory" );
	load_name( "ZOMBIE_COD5_FACTORY_OUTSIDE_SOUTH_ZONE", "Courtyard" );
	load_name( "ZOMBIE_COD5_FACTORY_WNUEN_ZONE", "Laboratory" );
	load_name( "ZOMBIE_COD5_FACTORY_WNUEN_BRIDGE_ZONE", "Bridge Laboratory Side" );
	load_name( "ZOMBIE_COD5_FACTORY_BRIDGE_ZONE", "Bridge Warehouse Side" );
	load_name( "ZOMBIE_COD5_FACTORY_TP_EAST_ZONE", "Teleporter A" );
	load_name( "ZOMBIE_COD5_FACTORY_TP_WEST_ZONE", "Teleporter B" );
	load_name( "ZOMBIE_COD5_FACTORY_TP_SOUTH_ZONE", "Teleporter C" );
	load_name( "ZOMBIE_COD5_FACTORY_WAREHOUSE_TOP_ZONE", "Upper Warehouse" );
	load_name( "ZOMBIE_COD5_FACTORY_WAREHOUSE_BOTTOM_ZONE", "Warehouse" );
	
	// Kino Der Toten
	load_name( "ZOMBIE_THEATER_FOYER_ZONE", "Lobby" );
	load_name( "ZOMBIE_THEATER_FOYER2_ZONE", "Lobby Hallway" );
	load_name( "ZOMBIE_THEATER_CREMATORIUM_ZONE", "Crematorium" );
	load_name( "ZOMBIE_THEATER_ALLEYWAY_ZONE", "Alley" );
	load_name( "ZOMBIE_THEATER_WEST_BALCONY_ZONE", "Boiler Room" );
	load_name( "ZOMBIE_THEATER_STAGE_ZONE", "Stage" );
	load_name( "ZOMBIE_THEATER_THEATER_ZONE", "Theater" );
	load_name( "ZOMBIE_THEATER_DRESSING_ZONE", "Dressing Room" );
	load_name( "ZOMBIE_THEATER_DINING_ZONE", "Dining Room" );
	load_name( "ZOMBIE_THEATER_VIP_ZONE", "VIP Lounge" );
	
	// FIVE
	load_name( "ZOMBIE_PENTAGON_CONFERENCE_LEVEL1", "Conference Room" );
	load_name( "ZOMBIE_PENTAGON_HALLWAY_LEVEL1", "Hallway" );
	load_name( "ZOMBIE_PENTAGON_WAR_ROOM_ZONE_TOP", "Upper War Room" );
	load_name( "ZOMBIE_PENTAGON_WAR_ROOM_ZONE_NORTH", "North War Room" );
	load_name( "ZOMBIE_PENTAGON_WAR_ROOM_ZONE_SOUTH", "South War Room" );
	load_name( "ZOMBIE_PENTAGON_CONFERENCE_LEVEL2", "Panic Room" );
	load_name( "ZOMBIE_PENTAGON_WAR_ROOM_ZONE_ELEVATOR", "Bottom Elevator" );
	load_name( "ZOMBIE_PENTAGON_LABS_ELEVATOR", "Bottom Elevator" );
	load_name( "ZOMBIE_PENTAGON_LABS_HALLWAY1", "South Labs" );
	load_name( "ZOMBIE_PENTAGON_LABS_HALLWAY2", "North Labs" );
	load_name( "ZOMBIE_PENTAGON_LABS_ZONE3", "Weapon Testing" );
	load_name( "ZOMBIE_PENTAGON_LABS_ZONE2", "Pig Research" );
	load_name( "ZOMBIE_PENTAGON_LABS_ZONE1", "Morgue" );
	
	// Ascension
	load_name( "ZOMBIE_COSMODROME_CENTRIFUGE_ZONE", "Centrifuge" );
	load_name( "ZOMBIE_COSMODROME_CENTRIFUGE_ZONE2", "Upper Centrifuge" );
	load_name( "ZOMBIE_COSMODROME_ACCESS_TUNNEL_ZONE", "Stairs" );
	load_name( "ZOMBIE_COSMODROME_STORAGE_ZONE", "Storage Hallway" );
	load_name( "ZOMBIE_COSMODROME_STORAGE_ZONE2", "Storage" );
	load_name( "ZOMBIE_COSMODROME_STORAGE_LANDER_ZONE", "Storage Lander" );
	load_name( "ZOMBIE_COSMODROME_BASE_ENTRY_ZONE", "Base Entry Lander" );
	load_name( "ZOMBIE_COSMODROME_CENTRIFUGE2POWER_ZONE", "Centrifuge Building" );
	load_name( "ZOMBIE_COSMODROME_BASE_ENTRY_ZONE2", "Power Building" );
	load_name( "ZOMBIE_COSMODROME_POWER_BUILDING", "Upper Power Building" );
	load_name( "ZOMBIE_COSMODROME_POWER_BUILDING_ROOF", "Power Building Roof" );
	load_name( "ZOMBIE_COSMODROME_ROOF_CONNECTOR_ZONE", "Roof Connector Area" );
	load_name( "ZOMBIE_COSMODROME_NORTH_CATWALK_ZONE3", "Catwalk Lander" );
	load_name( "ZOMBIE_COSMODROME_NORTH_PATH_ZONE", "Outside Launch Area" );
	load_name( "ZOMBIE_COSMODROME_UNDER_ROCKET_ZONE", "Launch Area" );
	load_name( "ZOMBIE_COSMODROME_CONTROL_ROOM_ZONE", "Control Room" );
	
	// Call of the Dead
	load_name( "ZOMBIE_COAST_BEACH_ZONE", "Beach" );
	load_name( "ZOMBIE_COAST_START_ZONE", "Lighthouse Cove" );
	load_name( "ZOMBIE_COAST_SHIPBACK_FAR_ZONE", "Ship Stern" );
	load_name( "ZOMBIE_COAST_SHIPBACK_NEAR_ZONE", "Ship Gangway" );
	load_name( "ZOMBIE_COAST_SHIPBACK_NEAR2_ZONE", "Ship Sun Deck" );
	load_name( "ZOMBIE_COAST_SHIPBACK_LEVEL3_ZONE", "Ship Bridge" );
	load_name( "ZOMBIE_COAST_SHIPFRONT_NEAR_ZONE", "Ship Main Deck" );
	load_name( "ZOMBIE_COAST_SHIPFRONT_BOTTOM_ZONE", "Ship Cargo Hold" );
	load_name( "ZOMBIE_COAST_SHIPFRONT_FAR_ZONE", "Ship Forecastle" );
	load_name( "ZOMBIE_COAST_SHIPFRONT_STORAGE_ZONE", "Ship Storage" );
	load_name( "ZOMBIE_COAST_SHIPFRONT_2_BEACH_ZONE", "Ship Path" );
	load_name( "ZOMBIE_COAST_BEACH_ZONE2", "Cave" );
	load_name( "ZOMBIE_COAST_RESIDENCE_ROOF_ZONE", "Lighthouse Station Roof" );
	load_name( "ZOMBIE_COAST_RESIDENCE1_ZONE", "Lighthouse Station" );
	load_name( "ZOMBIE_COAST_LIGHTHOUSE1_ZONE", "Lighthouse Level 1 & 2" );
	load_name( "ZOMBIE_COAST_LIGHTHOUSE2_ZONE", "Lighthouse Level 3" );
	load_name( "ZOMBIE_COAST_CATWALK_ZONE", "Lighthouse Level 4" );
	load_name( "ZOMBIE_COAST_START_CAVE_ZONE", "Lighthouse Extension" );
	load_name( "ZOMBIE_COAST_START_BEACH_ZONE", "Lagoon" );
	load_name( "ZOMBIE_COAST_REAR_LAGOON_ZONE", "Boathouse" );
	
	// Shangri La
	load_name( "ZOMBIE_TEMPLE_TEMPLE_START_ZONE", "Temple" );
	load_name( "ZOMBIE_TEMPLE_PRESSURE_PLATE_ZONE", "Minecart Area" );
	load_name( "ZOMBIE_TEMPLE_CAVE_TUNNEL_ZONE", "Minecart Tunnel" );
	load_name( "ZOMBIE_TEMPLE_CAVES1_ZONE", "Waterslide Exit" );
	load_name( "ZOMBIE_TEMPLE_CAVES2_ZONE", "Turntable" );
	load_name( "ZOMBIE_TEMPLE_CAVES3_ZONE", "Body Bags" );
	load_name( "ZOMBIE_TEMPLE_POWER_ROOM_ZONE", "Water Wheels" );
	load_name( "ZOMBIE_TEMPLE_CAVES_WATER_ZONE", "Water Cave" );
	load_name( "ZOMBIE_TEMPLE_WATERFALL_LOWER_ZONE", "Waterfall" );
	load_name( "ZOMBIE_TEMPLE_WATERFALL_TUNNEL_ZONE", "Waterfall Tunnel" );
	load_name( "ZOMBIE_TEMPLE_WATERFALL_TUNNEL_A_ZONE", "Waterfall Tunnel" );
	load_name( "ZOMBIE_TEMPLE_WATERFALL_UPPER_ZONE", "Upper Waterfall" );
	load_name( "ZOMBIE_TEMPLE_WATERFALL_UPPER1_ZONE", "Mud Pit" );
	
	// Moon
	load_name( "ZOMBIE_MOON_NML_ZONE", "No Man's Land" );
	load_name( "ZOMBIE_MOON_BRIDGE_ZONE", "Receiving Bay" );
	load_name( "ZOMBIE_MOON_WATER_ZONE", "Launch Area" );
	load_name( "ZOMBIE_MOON_CATA_LEFT_START_ZONE", "Upper Tunnel 6" );
	load_name( "ZOMBIE_MOON_CATA_LEFT_MIDDLE_ZONE", "Lower Tunnel 6" );
	load_name( "ZOMBIE_MOON_GENERATOR_ZONE", "M.P.D." );
	load_name( "ZOMBIE_MOON_CATA_RIGHT_START_ZONE", "Upper Tunnel 11" );
	load_name( "ZOMBIE_MOON_CATA_RIGHT_MIDDLE_ZONE", "Middle Tunnel 11" );
	load_name( "ZOMBIE_MOON_CATA_RIGHT_END_ZONE", "Lower Tunnel 11" );
	load_name( "ZOMBIE_MOON_GENERATOR_EXIT_EAST_ZONE", "Laboratories" );
	load_name( "ZOMBIE_MOON_ENTER_FOREST_EAST_ZONE", "Upper Laboratories" );
	load_name( "ZOMBIE_MOON_TOWER_ZONE_EAST", "Teleporter Area" );
	load_name( "ZOMBIE_MOON_TOWER_ZONE_EAST2", "Outside Biodome" );
	load_name( "ZOMBIE_MOON_FOREST_ZONE", "Biodome" );
}

load_name( zone, common ) {
	zone = "reimagined_" + tolower( zone );
	level.ARRAY_ZONE_NAMES[ zone ] = common;
}

debug_challenges_complete(waitTime, completed) 
{
	wait(waitTime*2);
	iprintln("DEBUG: Completing all challenges for player");
	for(i=0; i<completed; i++) {
		self.challengeData.completedArray[i] = true;
		self notify( "challenge_complete" );
		self.challengeData.completed++;
		wait(waitTime);
	}
	
}