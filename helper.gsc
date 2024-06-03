/*

    Copilot, we are going to reformat the following code.

    // Pistols
	add_zombie_weapon( "m1911_zm",					"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "python_zm",					"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				2200,	"pistol",			"",		undefined );
	add_zombie_weapon( "cz75_zm",					"cz75_upgraded_zm",						&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );

	//	Weapons - SMGs
	add_zombie_weapon( "ak74u_zm",					"ak74u_upgraded_zm",					&"REIMAGINED_WEAPON_AK74U",					1200,		"smg",				"",		undefined );
	add_zombie_weapon( "mp5k_zm",					"mp5k_upgraded_zm",						&"ZOMBIE_WEAPON_MP5K",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "mp40_zm",					"mp40_upgraded_zm",						&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "mpl_zm",					"mpl_upgraded_zm",						&"ZOMBIE_WEAPON_MPL",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "pm63_zm",					"pm63_upgraded_zm",						&"ZOMBIE_WEAPON_PM63",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "spectre_zm",				"spectre_upgraded_zm",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );

	//	Weapons - Dual Wield
	add_zombie_weapon( "cz75dw_zm",					"cz75dw_upgraded_zm",					&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

	//	Weapons - Shotguns
	add_zombie_weapon( "ithaca_zm",					"ithaca_upgraded_zm",					&"ZOMBIE_WEAPON_ITHACA",				1500,		"shotgun",			"",		undefined );
	add_zombie_weapon( "spas_zm",					"spas_upgraded_zm",						&"ZOMBIE_WEAPON_SPAS",					2000,		"shotgun",			"",		undefined );
	add_zombie_weapon( "rottweil72_zm",				"rottweil72_upgraded_zm",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,		"shotgun",			"",		undefined );
	add_zombie_weapon( "hs10_zm",					"hs10_upgraded_zm",						&"ZOMBIE_WEAPON_HS10",					50,			"shotgun",			"",		undefined );

	//	Weapons - Semi-Auto Rifles
	add_zombie_weapon( "m14_zm",					"m14_upgraded_zm",						&"ZOMBIE_WEAPON_M14",					500,		"rifle",			"",		undefined );

	//	Weapons - Burst Rifles
	add_zombie_weapon( "m16_zm",					"m16_gl_upgraded_zm",					&"ZOMBIE_WEAPON_M16",					1200,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "g11_lps_zm",				"g11_lps_upgraded_zm",					&"ZOMBIE_WEAPON_G11",					900,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "famas_zm",					"famas_upgraded_zm",					&"ZOMBIE_WEAPON_FAMAS",					50,			"burstrifle",		"",		undefined );

	//	Weapons - Assault Rifles
	add_zombie_weapon( "aug_acog_zm",				"aug_acog_mk_upgraded_zm",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
	add_zombie_weapon( "galil_zm",					"galil_upgraded_zm",					&"ZOMBIE_WEAPON_GALIL",					100,	"assault",			"",		undefined );
	add_zombie_weapon( "commando_zm",				"commando_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );
	add_zombie_weapon( "fnfal_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					100,	"burstrifle",		"",		undefined );

	//	Weapons - Sniper Rifles
	//add_zombie_weapon( "dragunov_zm",				"dragunov_upgraded_zm",					&"ZOMBIE_WEAPON_DRAGUNOV",				2500,		"sniper",			"",		undefined );
	add_zombie_weapon( "l96a1_zm",					"l96a1_upgraded_zm",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );

	//	Weapons - Machineguns
	add_zombie_weapon( "rpk_zm",					"rpk_upgraded_zm",						&"ZOMBIE_WEAPON_RPK",					4000,		"mg",				"",		undefined );
	add_zombie_weapon( "hk21_zm",					"hk21_upgraded_zm",						&"ZOMBIE_WEAPON_HK21",					50,		"mg",				"",		undefined );

	// Grenades
	add_zombie_weapon( "frag_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			1000,	"grenade",			"",		undefined );
	add_zombie_weapon( "sticky_grenade_zm", 		undefined,								&"ZOMBIE_WEAPON_STICKY_GRENADE",		1000,	"grenade",			"",		undefined );
	add_zombie_weapon( "claymore_zm", 				undefined,								&"ZOMBIE_WEAPON_CLAYMORE",				1000,	"grenade",			"",		undefined );

	// Rocket Launchers
	add_zombie_weapon( "m72_law_zm", 				"m72_law_upgraded_zm",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined );
	add_zombie_weapon( "china_lake_zm", 			"china_lake_upgraded_zm",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined );

	// Special
 	add_zombie_weapon( "zombie_cymbal_monkey",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"monkey",			"",		undefined );
 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );

 	add_zombie_weapon( "tesla_gun_zm",			"tesla_gun_upgraded_zm",				&"ZOMBIE_WEAPON_TESLA", 				10,		"tesla",			"",		undefined );

 	add_zombie_weapon( "thundergun_zm",				"thundergun_upgraded_zm",				&"ZOMBIE_WEAPON_THUNDERGUN", 			10,		"thunder",			"",		undefined );
 	add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );
 	add_zombie_weapon( "knife_ballistic_sickle_zm",	"knife_ballistic_sickle_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",	"",		undefined );

 	add_zombie_weapon( "freezegun_zm",				"freezegun_upgraded_zm",				&"ZOMBIE_WEAPON_FREEZEGUN", 			10,		"freezegun",		"",		undefined );

 	add_zombie_weapon( "zombie_black_hole_bomb",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"gersh",			"",		undefined );
 	add_zombie_weapon( "zombie_nesting_dolls",		undefined,								&"ZOMBIE_WEAPON_NESTING_DOLLS", 		2000,	"dolls",	"",		undefined );
	add_zombie_weapon( "bo3_zm_widows_grenade",		undefined,								&"REIMAGINED_WINE_GRENADES", 		2000,	"webnades",	"",		undefined );

 	add_zombie_weapon( "ak47_zm",					"ak47_ft_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );
 	add_zombie_weapon( "stoner63_zm",				"stoner63_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"mg",			"",		undefined );
 	//add_zombie_weapon( "psg1_zm",					"psg1_upgraded_zm",						&"ZOMBIE_WEAPON_COMMANDO",				100,	"sniper",			"",		undefined );
 	add_zombie_weapon( "ppsh_zm",					"ppsh_upgraded_zm",						&"ZOMBIE_WEAPON_COMMANDO",				100,	"smg",			"",		undefined );

 	add_zombie_weapon( "molotov_zm", 				undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			250,	"grenade",			"",		undefined );

 	add_zombie_weapon( "combat_knife_zm",			undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
 	add_zombie_weapon( "combat_bowie_knife_zm",		undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
 	add_zombie_weapon( "combat_sickle_knife_zm",	undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"sickle",			"",		undefined );
	add_zombie_weapon( "rebirth_hands_sp",					undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
	add_zombie_weapon( "vorkuta_knife_sp",					undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );

 	add_zombie_weapon( "falling_hands_zm",			undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );


	//Double PaP weapons
	//************************************************************************************************************************
	//Add zombie weapon in	
	add_zombie_weapon( "python_upgraded_zm",					"python_upgraded_zm_x2",					&"ZOMBIE_WEAPON_PYTHON",				2200,	"pistol",			"",		undefined );
	add_zombie_weapon( "cz75_upgraded_zm",					"cz75_upgraded_zm_x2",						&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "m1911_upgraded_zm",					"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );

	//	Weapons - SMGs
	//add_zombie_weapon( "ak74u_upgraded_zm",					"ak74u_upgraded_zm_x2",					&"REIMAGINED_WEAPON_AK74U",					1200,		"smg",				"",		undefined );
	//add_zombie_weapon( "mp5k_upgraded_zm",					"mp5k_upgraded_zm_x2",						&"ZOMBIE_WEAPON_MP5K",					1000,		"smg",				"",		undefined );
	//add_zombie_weapon( "mp40_upgraded_zm",					"mp40_upgraded_zm_x2",						&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
	//add_zombie_weapon( "mpl_upgraded_zm",					"mpl_upgraded_zm_x2",						&"ZOMBIE_WEAPON_MPL",					1000,		"smg",				"",		undefined );
	//add_zombie_weapon( "pm63_upgraded_zm",					"pm63_upgraded_zm_x2",						&"ZOMBIE_WEAPON_PM63",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "spectre_upgraded_zm",				"spectre_upgraded_zm_x2",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );

	//	Weapons - Dual Wield
	add_zombie_weapon( "cz75dw_upgraded_zm",					"cz75dw_upgraded_zm_x2",					&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

	//	Weapons - Shotguns
	//add_zombie_weapon( "ithaca_upgraded_zm",					"ithaca_upgraded_zm_x2",					&"ZOMBIE_WEAPON_ITHACA",				1500,		"shotgun",			"",		undefined );
	add_zombie_weapon( "spas_upgraded_zm",					"spas_upgraded_zm_x2",						&"ZOMBIE_WEAPON_SPAS",					2000,		"shotgun",			"",		undefined );
	//add_zombie_weapon( "rottweil72_upgraded_zm",				"rottweil72_upgraded_zm_x2",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,		"shotgun",			"",		undefined );
	add_zombie_weapon( "hs10_upgraded_zm",					"hs10_upgraded_zm_x2",						&"ZOMBIE_WEAPON_HS10",					50,			"shotgun",			"",		undefined );

	//	Weapons - Semi-Auto Rifles
	//add_zombie_weapon( "m14_upgraded_zm",					"m14_upgraded_zm_x2",						&"ZOMBIE_WEAPON_M14",					500,		"rifle",			"",		undefined );

	//	Weapons - Burst Rifles
	//add_zombie_weapon( "m16_upgraded_zm",					"m16_gl_upgraded_zm_x2",					&"ZOMBIE_WEAPON_M16",					1200,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "g11_lps_upgraded_zm",				"g11_lps_upgraded_zm_x2",					&"ZOMBIE_WEAPON_G11",					900,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "famas_upgraded_zm",					"famas_upgraded_zm_x2",					&"ZOMBIE_WEAPON_FAMAS",					50,			"burstrifle",		"",		undefined );

	//	Weapons - Assault Rifles
	add_zombie_weapon( "aug_acog_mk_upgraded_zm",				"aug_acog_mk_upgraded_zm_x2",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
	add_zombie_weapon( "galil_upgraded_zm",					"galil_upgraded_zm_x2",					&"ZOMBIE_WEAPON_GALIL",					100,	"assault",			"",		undefined );
	add_zombie_weapon( "commando_upgraded_zm",				"commando_upgraded_zm_x2",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );
	add_zombie_weapon( "fnfal_upgraded_zm",					"fnfal_upgraded_zm_x2",					&"ZOMBIE_WEAPON_FNFAL",					100,	"burstrifle",		"",		undefined );

	//	Weapons - Sniper Rifles
	add_zombie_weapon( "l96a1_upgraded_zm",					"l96a1_upgraded_zm_x2",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );

	//	Weapons - Machineguns
	add_zombie_weapon( "rpk_upgraded_zm",					"rpk_upgraded_zm_x2",						&"ZOMBIE_WEAPON_RPK",					4000,		"mg",				"",		undefined );
	add_zombie_weapon( "hk21_upgraded_zm",					"hk21_upgraded_zm_x2",						&"ZOMBIE_WEAPON_HK21",					50,		"mg",				"",		undefined );

	// Rocket Launchers
	//add_zombie_weapon( "m72_law_upgraded_zm", 				"m72_law_upgraded_zm_x2",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined );
	//add_zombie_weapon( "china_lake_upgraded_zm", 			"china_lake_upgraded_zm_x2",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined );

	// Special
 	add_zombie_weapon( "crossbow_explosive_upgraded_zm",		"crossbow_explosive_upgraded_zm_x2",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_upgraded_zm",		"knife_ballistic_upgraded_zm_x2",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_upgraded_zm",	"knife_ballistic_upgraded_zm_x2",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );
 	add_zombie_weapon( "knife_ballistic_sickle_upgraded_zm",	"knife_ballistic_upgraded_zm_x2",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",	"",		undefined );

 	add_zombie_weapon( "ak47_ft_upgraded_zm",					"ak47_ft_upgraded_zm_x2",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );
 	add_zombie_weapon( "stoner63_upgraded_zm",				"stoner63_upgraded_zm_x2",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"mg",			"",		undefined );
 	//add_zombie_weapon( "psg1_upgraded_zm",					"psg1_upgraded_zm_x2",						&"ZOMBIE_WEAPON_COMMANDO",				100,	"sniper",			"",		undefined );
 	add_zombie_weapon( "ppsh_upgraded_zm",					"ppsh_upgraded_zm_x2",						&"ZOMBIE_WEAPON_COMMANDO",				100,	"smg",			"",		undefined );

    //WaW weapons
    
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_kar98k", "zombie_kar98k_upgraded", 						&"WAW_ZOMBIE_WEAPON_KAR98K_200", 				200,	"rifle");
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_type99_rifle", "",					&"WAW_ZOMBIE_WEAPON_TYPE99_200", 			    200,	"rifle" );

	// Semi Auto
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_gewehr43", "zombie_gewehr43_upgraded",						&"WAW_ZOMBIE_WEAPON_GEWEHR43_600", 				600,	"rifle" );
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_m1carbine","zombie_m1carbine_upgraded",						&"WAW_ZOMBIE_WEAPON_M1CARBINE_600",				600,	"rifle" );
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_m1garand", "zombie_m1garand_upgraded" ,						&"WAW_ZOMBIE_WEAPON_M1GARAND_600", 				600,	"rifle" );

	maps\_zombiemode_weapons::add_zombie_weapon( "stielhandgranate", "", 						&"WAW_ZOMBIE_WEAPON_STIELHANDGRANATE_250", 		1000,	"grenade", "", 1000 );
	maps\_zombiemode_weapons::add_zombie_weapon( "mine_bouncing_betty", "", &"WAW_ZOMBIE_WEAPON_SATCHEL_2000", 2000 );
	// Scoped
	maps\_zombiemode_weapons::add_zombie_weapon( "kar98k_scoped_zombie", "", 					&"WAW_ZOMBIE_WEAPON_KAR98K_S_750", 				750,	"sniper");

	// Full Auto
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_stg44", "zombie_stg44_upgraded", 							    &"WAW_ZOMBIE_WEAPON_STG44_1200", 				1200, "mg" );
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_thompson", "zombie_thompson_upgraded", 							&"WAW_ZOMBIE_WEAPON_THOMPSON_1200", 			1200, "mg" );
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_type100_smg", "zombie_type100_smg_upgraded", 						&"WAW_ZOMBIE_WEAPON_TYPE100_1000", 				1000, "mg" );

	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_fg42", "zombie_fg42_upgraded", 							&"WAW_ZOMBIE_WEAPON_FG42_1500", 				1500,	"mg" );


	// Shotguns
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_doublebarrel", "zombie_doublebarrel_upgraded", 						&"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_1200", 		1200, "shotgun");
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_doublebarrel_sawed", "", 			    &"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_SAWED_1200", 	1200, "shotgun");
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_shotgun", "zombie_shotgun_upgraded",							&"WAW_ZOMBIE_WEAPON_SHOTGUN_1500", 				1500, "shotgun");

	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_bar", "zombie_bar_upgraded", 						&"WAW_ZOMBIE_WEAPON_BAR_1800", 					1800,	"mg" );

	// Bipods
	maps\_zombiemode_weapons::add_zombie_weapon( "zombie_bar_bipod", 	"",					&"WAW_ZOMBIE_WEAPON_BAR_BIPOD_2500", 			2500,	"mg" );

    Here are the weapons sorted by "type" category:

    Type,assault,0,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
aug_acog_zm,1,Shock & Aug,STD,Shock Rounds,,
commando_zm,1,The Feast,TRUE,Execute,,
famas_zm,1,G16-GL-Infinite,STD,Ammo Rfegen,,
fnfal_zm,1,FN EPC WIN,STD,Big Headshot,,
g11_lps_zm,1,Gone11,STD,Boss Damage,,
galil_zm,1,Winters Wail,TRUE,Sheercold,,
END
END
Type,launcher,2,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
china_lake_zm,1,0,STD,,,
m72_law_zm,1,0,STD,Freeze Fx,,
END
Type,melee,3,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
rebirth_hands_sp,1,,,,,
sickle_knife_zm,1,,,,,
bowie_knife_zm,1,,,,,
combat_bowie_knife_zmcombat_knife_zmcombat_sickle_knife_zmvorkuta_knife_spknife_ballistic_bowie_zmknife_ballistic_sickle_zmknife_ballistic_zmknife_zm,1,,,,,
punch_zm,1,punch_fast_zm,STD,Faster melee,,
END
Type,mg,4,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
rpk_zm,1,Scored Earth,TRUE,Hellfire,,
stoner63_zm,1,He Who Is Without Sin,STD,Big Damage & Shock,,
hk21_zm,1,H1015 Oscillator,TRUE,Sheercold,,
END
Type,new,6,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
ak47_zm,1,Blitzkrieg,STD,Hellfire,,
enfield,1,,TRUE,Big Damage,,
m60,1,Big Daddy,STD,Shock,,
asp,Another Side Piece,PSA Death,STD,Hellfire,,
,1,,,,,
,1,,,,,
END
Type,shotgun,7,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
spas_zm,1,Razzle Dazzle,STD,Cycle,,
hs10_zm,1,1001 Dead Zombies,TRUE,Big Ammo,,
END
Type,sidearm,8,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
python_zm,1,Cobra's Frenzy,STD,Execute,,
m1911_zm,1,,STD,,,
cz75_zm,1,Silouhette,TRUE,Shock,,
cz75dw_zm,1,Silouhette & Gamble,STD,Shock,,
cz75lh_zm,1,,STD,Hellfire,,
,1,,,,,
END
Type,smg,9,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
spectre_zm,1,Wraith,STD,Sheercold,,
ppsh_zm,Grim Reaper,Grim Fate,TRUE,Hellfire,,
END
Type,wall,12,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
rottweil72_zm,Hades,Hades,STD,,,
mp40_zm,The Afterburner,Heatsink,STD,,,
ak74u_zm,Ak74-Fu2,Ak74-2F2U,STD,,,
m16_zm,Skullcrusher,Skullbasher,STD,,,
m14_zm,Mnesia,Remembrance,STD,,,
ithaca_zm,Raid,Bedlam,STD,,,
kar98k_scoped_zombie,Armageddon,Armageddon,STD,,,
mp5k_zm,MP115-Kollider,MP115-Kolliderx2,STD,,,
mpl_zm,MPL-LF,MPL-LFG,STD,,,
pm63_zm,Tokyo & Rose,Honeymoon,STD,,,
END
END
,10 is Blank,,,,,
Type,sniper,10,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
dragunov_zm,D115 Dissasembler,Draguns Breath,TRUE,Hellfire,,
l96a1_zm,1,L115 Decimator,STD,Big Headshot,,
psg1_zm,psg2,SerEND
ipity,STD,Big Damage,,
END
Type,special,11,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
freezegun_zmray_gun_zmshrink_ray_zmtesla_gun_powerup_zmtesla_gun_zmthundergun_zmcrossbow_explosive_zmEND
Type,waw,13,,,,
Weapon,Upgrade,x2,x2 Type,Bonus,,
zombie_bar,1,The Standard,,,,
zombie_doublebarrel,1,24 Bore Long Range,,,,
zombie_doublebarrel_sawed,1,24 Bore Long Range,,,,
zombie_fg42,1,FG 420 Impeller,,,,
zombie_gewehr43,1,G115 Compressor,,,,
zombie_kar98k,1,FG 420 Impeller,,,,
zombie_m1carbine,1,Widdershins RC-1,,,,
zombie_m1garand,1,Bullpup T31,,,,
zombie_shotgun,1,Gut Shot,,,,
zombie_springfield,1,Winterfield,,,,
zombie_stg44,1,Spatz-447,,,,
zombie_thompson,1,Gibs-o-matic,,,,
zombie_type100_smg,1,1001 Samuris,,,,
zombie_type99_rifle,1,,,,,
END

	
*/

/**************************
    Melee
**************************/

//Base
add_zombie_weapon( "combat_knife_zm",			undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
add_zombie_weapon( "combat_bowie_knife_zm",		undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
add_zombie_weapon( "combat_sickle_knife_zm",	undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"sickle",			"",		undefined );

add_zombie_weapon( "rebirth_hands_sp",					undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
add_zombie_weapon( "vorkuta_knife_sp",					undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );
add_zombie_weapon( "falling_hands_zm",			undefined,								&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		50,		"bowie",			"",		undefined );

//Upgrade - none

//Total: 6 base, 0 upgraded = 6
/***** END MELEE *****/


/**************************
    Grenades
**************************/

//Base

add_zombie_weapon( "frag_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			1000,	"grenade",			"",		undefined );
add_zombie_weapon( "sticky_grenade_zm", 		undefined,								&"ZOMBIE_WEAPON_STICKY_GRENADE",		1000,	"grenade",			"",		undefined );
add_zombie_weapon( "claymore_zm", 				undefined,								&"ZOMBIE_WEAPON_CLAYMORE",				1000,	"grenade",			"",		undefined );

add_zombie_weapon( "zombie_cymbal_monkey",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"monkey",			"",		undefined );
add_zombie_weapon( "zombie_black_hole_bomb",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"gersh",			"",		undefined );
add_zombie_weapon( "zombie_nesting_dolls",		undefined,								&"ZOMBIE_WEAPON_NESTING_DOLLS", 		2000,	"dolls",	"",		undefined );

add_zombie_weapon( "bo3_zm_widows_grenade",		undefined,								&"REIMAGINED_WINE_GRENADES", 		2000,	"webnades",	"",		undefined );

//Waw
add_zombie_weapon( "molotov_zm", 				undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			250,	"grenade",			"",		undefined );
add_zombie_weapon( "stielhandgranate", "", 						&"WAW_ZOMBIE_WEAPON_STIELHANDGRANATE_250", 		1000,	"grenade", "", 1000 );
add_zombie_weapon( "mine_bouncing_betty", "", &"WAW_ZOMBIE_WEAPON_SATCHEL_2000", 2000 );

//Upgrade - none

//Total: 6 base, 0 upgraded = 10
/***** END GRENADES *****/

/**************************
        MGs
**************************/

//Base
add_zombie_weapon( "rpk_zm",					"rpk_upgraded_zm",						&"ZOMBIE_WEAPON_RPK",					4000,		"mg",				"",		undefined );
add_zombie_weapon( "stoner63_zm",				"stoner63_upgraded_zm",					&"ZOMBIE_WEAPON_STONER63",				4000,		"mg",				"",		undefined );
add_zombie_weapon( "hk21_zm",					"hk21_upgraded_zm",						&"ZOMBIE_WEAPON_HK21",					4000,		"mg",				"",		undefined );


//Upgrade
add_zombie_weapon( "rpk_upgraded_zm",					"rpk_upgraded_zm_x2",					&"ZOMBIE_WEAPON_RPK",					4000,		"mg",				"",		undefined );
add_zombie_weapon( "stoner63_upgraded_zm",				"stoner63_upgraded_zm",				&"ZOMBIE_WEAPON_STONER63",				4000,		"mg",				"",		undefined );
add_zombie_weapon( "hk21_upgraded_zm",					"hk21_upgraded_zm_x2",					&"ZOMBIE_WEAPON_HK21",					4000,		"mg",				"",		undefined );

//Total: 3 base, 3 upgraded, 2 x2 = 8
/***** END MGS *****/


/**************************
    Assault Rifles - includes Burstrifles
**************************/

//Base 
add_zombie_weapon( "aug_acog_zm",				"aug_acog_mk_upgraded_zm",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
add_zombie_weapon( "galil_zm",					"galil_upgraded_zm",					&"ZOMBIE_WEAPON_GALIL",					1000,	"assault",			"",		undefined );
add_zombie_weapon( "commando_zm",				"commando_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				1000,	"assault",			"",		undefined );
add_zombie_weapon( "fnfal_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					1000,	"burstrifle",			"",		undefined );
add_zombie_weapon( "g11_lps_zm",				"g11_lps_upgraded_zm",					&"ZOMBIE_WEAPON_G11",					900,	"burstrifle",			"",		undefined );
add_zombie_weapon( "famas_zm",					"famas_upgraded_zm",					&"ZOMBIE_WEAPON_FAMAS",					50,		"burstrifle",			"",		undefined );

//Upgrade
add_zombie_weapon( "aug_acog_mk_upgraded_zm",				"aug_acog_mk_upgraded_zm",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
add_zombie_weapon( "galil_upgraded_zm",					"galil_upgraded_zm_x2",					&"ZOMBIE_WEAPON_GALIL",					1000,	"assault",			"",		undefined );
add_zombie_weapon( "commando_upgraded_zm",				"commando_upgraded_zm_x2",					&"ZOMBIE_WEAPON_COMMANDO",				1000,	"assault",			"",		undefined );
add_zombie_weapon( "fnfal_upgraded_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					1000,	"burstrifle",			"",		undefined );
add_zombie_weapon( "g11_lps_upgraded_zm",				"g11_lps_upgraded_zm",					&"ZOMBIE_WEAPON_G11",					900,	"burstrifle",			"",		undefined );
add_zombie_weapon( "famas_upgraded_zm",					"famas_upgraded_zm",					&"ZOMBIE_WEAPON_FAMAS",					50,		"burstrifle",			"",		undefined );

//Total: 6 base, 6 upgraded, 2 x2 = 14
/***** END ASSAULT RIFLES *****/

/**************************
    Shotguns
**************************/

//Base
add_zombie_weapon( "spas_zm",					"spas_upgraded_zm",						&"ZOMBIE_WEAPON_SPAS",					2000,		"shotgun",			"",		undefined );
add_zombie_weapon( "hs10_zm",					"hs10_upgraded_zm",						&"ZOMBIE_WEAPON_HS10",					50,			"shotgun",			"",		undefined );

//Upgrade
add_zombie_weapon( "spas_upgraded_zm",					"spas_upgraded_zm_x2",						&"ZOMBIE_WEAPON_SPAS",					2000,		"shotgun",			"",		undefined );
add_zombie_weapon( "hs10_upgraded_zm",					"hs10_upgraded_zm_x2",						&"ZOMBIE_WEAPON_HS10",					50,			"shotgun",			"",		undefined );

//Total: 2 base, 2 upgraded, 2 x2 = 6
/***** END SHOTGUNS *****/


/**************************
    SMGs
**************************/

//Base
add_zombie_weapon( "spectre_zm",				"spectre_upgraded_zm",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );
add_zombie_weapon( "ppsh_zm",					"ppsh_upgraded_zm",						&"ZOMBIE_WEAPON_PPSh",					1000,		"smg",				"",		undefined );

//Upgrade
add_zombie_weapon( "spectre_upgraded_zm",				"spectre_upgraded_zm",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );
add_zombie_weapon( "ppsh_upgraded_zm",					"ppsh_upgraded_zm_x2",						&"ZOMBIE_WEAPON_PPSh",					1000,		"smg",				"",		undefined );

//Total: 2 base, 2 upgraded, 1 x2 = 5
/***** END SMGs *****/


/**************************
    Sidearms
**************************/

//Base
add_zombie_weapon( "python_zm",				"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				2200,	"pistol",			"",		undefined );
add_zombie_weapon( "m1911_zm",				"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
add_zombie_weapon( "cz75_zm",				"cz75_upgraded_zm",						&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );
add_zombie_weapon( "cz75dw_zm",				"cz75dw_upgraded_zm",					&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

//Upgrade
add_zombie_weapon( "python_upgraded_zm",				"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				2200,	"pistol",			"",		undefined );
add_zombie_weapon( "m1911_upgraded_zm",				"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
add_zombie_weapon( "cz75_upgraded_zm",				"cz75_upgraded_zm_x2",					&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );
add_zombie_weapon( "cz75dw_upgraded_zm",				"cz75dw_upgraded_zm",				&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

//Total: 4 base, 4 upgraded, 1 x2 = 9
/***** END SIDEARMS *****/

/**************************
    Snipers
**************************/

//Base
add_zombie_weapon( "l96a1_zm",					"l96a1_upgraded_zm",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );
add_zombie_weapon( "dragunov_zm",				"dragunov_upgraded_zm",					&"ZOMBIE_WEAPON_DRAGUNOV",				2500,		"sniper",			"",		undefined );
add_zombie_weapon( "psg1_zm",					"psg1_upgraded_zm",						&"ZOMBIE_WEAPON_PSG1",					2500,		"sniper",			"",		undefined );

//Upgrade
add_zombie_weapon( "l96a1_upgraded_zm",					"l96a1_upgraded_zm",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );
add_zombie_weapon( "dragunov_upgraded_zm",				"dragunov_upgraded_zm_x2",					&"ZOMBIE_WEAPON_DRAGUNOV",				2500,		"sniper",			"",		undefined );
add_zombie_weapon( "psg1_upgraded_zm",					"psg1_upgraded_zm",						&"ZOMBIE_WEAPON_PSG1",					2500,		"sniper",			"",		undefined );

//Total: 3 base, 3 upgraded, 1 x2 = 7
/***** END SNIPERS *****/

/**************************
    Launchers
**************************/

//Base
add_zombie_weapon( "m72_law_zm", 				"m72_law_upgraded_zm",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined );
add_zombie_weapon( "china_lake_zm", 			"china_lake_upgraded_zm",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined );

//Upgrade - upgraded launchers get ammo back
add_zombie_weapon( "m72_law_upgraded_zm", 				"m72_law_upgraded_zm",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined );
add_zombie_weapon( "china_lake_upgraded_zm", 			"china_lake_upgraded_zm",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined );

//Total: 2 base, 2 upgraded = 4
/***** END LAUNCHERS *****/


/**************************
    Wall
**************************/

//Base
add_zombie_weapon( "rottweil72_zm",					"rottweil72_upgraded_zm",					&"ZOMBIE_WEAPON_ROTTWEIL72",			500,		"shotgun",			"",		undefined );
add_zombie_weapon( "m14_zm",					"m14_upgraded_zm",						&"ZOMBIE_WEAPON_M14",					500,		"rifle",			"",		undefined );
add_zombie_weapon( "mp5k_zm",					"mp5k_upgraded_zm",						&"ZOMBIE_WEAPON_MP5K",					1000,		"smg",				"",		undefined );
add_zombie_weapon( "mpl_zm",					"mpl_upgraded_zm",						&"ZOMBIE_WEAPON_MPL",					1000,		"smg",				"",		undefined );
add_zombie_weapon( "pm63_zm",					"pm63_upgraded_zm",						&"ZOMBIE_WEAPON_PM63",					1000,		"smg",				"",		undefined );

add_zombie_weapon( "ithaca_zm",					"ithaca_upgraded_zm",					&"ZOMBIE_WEAPON_ITHACA",				1500,		"shotgun",			"",		undefined );
add_zombie_weapon( "mp40_zm",					"mp40_upgraded_zm",						&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
add_zombie_weapon( "ak74u_zm",					"ak74u_upgraded_zm",					&"ZOMBIE_WEAPON_AK74U",					1200,		"smg",				"",		undefined );
add_zombie_weapon( "m16_zm",					"m16_gl_upgraded_zm",					&"ZOMBIE_WEAPON_M16",					1200,		"burstrifle",		"",		undefined );


//Upgrade
add_zombie_weapon( "rottweil72_upgraded_zm",				"rottweil72_upgraded_zm",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,		"shotgun",			"",		undefined );
add_zombie_weapon( "m14_upgraded_zm",					"m14_upgraded_zm",					&"ZOMBIE_WEAPON_M14",					500,		"rifle",			"",		undefined );
add_zombie_weapon( "mp5k_upgraded_zm",					"mp5k_upgraded_zm",					&"ZOMBIE_WEAPON_MP5K",					1000,		"smg",				"",		undefined );
add_zombie_weapon( "mpl_upgraded_zm",					"mpl_upgraded_zm",					&"ZOMBIE_WEAPON_MPL",					1000,		"smg",				"",		undefined );
add_zombie_weapon( "pm63_upgraded_zm",					"pm63_upgraded_zm",					&"ZOMBIE_WEAPON_PM63",					1000,		"smg",				"",		undefined );

add_zombie_weapon( "ithaca_upgraded_zm",					"ithaca_upgraded_zm",				&"ZOMBIE_WEAPON_ITHACA",				1500,		"shotgun",			"",		undefined );
add_zombie_weapon( "mp40_upgraded_zm",					"mp40_upgraded_zm",					&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
add_zombie_weapon( "ak74u_upgraded_zm",					"ak74u_upgraded_zm",				&"ZOMBIE_WEAPON_AK74U",					1200,		"smg",				"",		undefined );
add_zombie_weapon( "m16_gl_upgraded_zm",					"m16_gl_upgraded_zm",				&"ZOMBIE_WEAPON_M16",					1200,		"burstrifle",		"",		undefined );

//Total: 9 base, 9 upgraded = 18
/***** END WALL *****/

/**************************
    WAW
**************************/

//Base
add_zombie_weapon( "zombie_bar",				"zombie_bar_upgraded",					&"WAW_ZOMBIE_WEAPON_BAR_1800",			1800,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_doublebarrel",		"zombie_doublebarrel_upgraded",			&"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_1200",	1200,		"shotgun",			"",		undefined );
add_zombie_weapon( "zombie_doublebarrel_sawed",	"zombie_doublebarrel_sawed_upgraded",	&"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_SAWED_1200",	1200,		"shotgun",			"",		undefined );
add_zombie_weapon( "zombie_fg42",				"zombie_fg42_upgraded",					&"WAW_ZOMBIE_WEAPON_FG42_1500",			1500,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_gewehr43",			"zombie_gewehr43_upgraded",				&"WAW_ZOMBIE_WEAPON_GEWEHR43_600",		600,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_kar98k",			"zombie_kar98k_upgraded",				&"WAW_ZOMBIE_WEAPON_KAR98K_200",		200,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_m1carbine",			"zombie_m1carbine_upgraded",			&"WAW_ZOMBIE_WEAPON_M1CARBINE_600",		600,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_m1garand",			"zombie_m1garand_upgraded",				&"WAW_ZOMBIE_WEAPON_M1GARAND_600",		600,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_shotgun",			"zombie_shotgun_upgraded",				&"WAW_ZOMBIE_WEAPON_SHOTGUN_1500",		1500,		"shotgun",			"",		undefined );
add_zombie_weapon( "zombie_springfield",		"zombie_springfield_upgraded",			&"WAW_ZOMBIE_WEAPON_SPRINGFIELD_200",	200,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_stg44",				"zombie_stg44_upgraded",				&"WAW_ZOMBIE_WEAPON_STG44_1200",		1200,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_thompson",			"zombie_thompson_upgraded",				&"WAW_ZOMBIE_WEAPON_THOMPSON_1200",		1200,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_type100_smg",		"zombie_type100_smg_upgraded",			&"WAW_ZOMBIE_WEAPON_TYPE100_1000",		1000,		"mg",				"",		undefined );

//Upgrade
/*
add_zombie_weapon( "zombie_bar_upgraded",		"zombie_bar_upgraded",					&"WAW_ZOMBIE_WEAPON_BAR_1800",			1800,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_doublebarrel_upgraded",	"zombie_doublebarrel_upgraded",			&"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_1200",	1200,		"shotgun",			"",		undefined );
add_zombie_weapon( "zombie_doublebarrel_sawed_upgraded",	"zombie_doublebarrel_sawed_upgraded",	&"WAW_ZOMBIE_WEAPON_DOUBLEBARREL_SAWED_1200",	1200,		"shotgun",			"",		undefined );
add_zombie_weapon( "zombie_fg42_upgraded",		"zombie_fg42_upgraded",					&"WAW_ZOMBIE_WEAPON_FG42_1500",			1500,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_gewehr43_upgraded",	"zombie_gewehr43_upgraded",				&"WAW_ZOMBIE_WEAPON_GEWEHR43_600",		600,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_kar98k_upgraded",	"zombie_kar98k_upgraded",				&"WAW_ZOMBIE_WEAPON_KAR98K_200",		200,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_m1carbine_upgraded",	"zombie_m1carbine_upgraded",			&"WAW_ZOMBIE_WEAPON_M1CARBINE_600",		600,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_m1garand_upgraded",	"zombie_m1garand_upgraded",				&"WAW_ZOMBIE_WEAPON_M1GARAND_600",		600,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_shotgun_upgraded",	"zombie_shotgun_upgraded",				&"WAW_ZOMBIE_WEAPON_SHOTGUN_1500",		1500,		"shotgun",			"",		undefined );
add_zombie_weapon( "zombie_springfield_upgraded",	"zombie_springfield_upgraded",			&"WAW_ZOMBIE_WEAPON_SPRINGFIELD_200",	200,		"rifle",			"",		undefined );
add_zombie_weapon( "zombie_stg44_upgraded",		"zombie_stg44_upgraded",				&"WAW_ZOMBIE_WEAPON_STG44_1200",		1200,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_thompson_upgraded",	"zombie_thompson_upgraded",				&"WAW_ZOMBIE_WEAPON_THOMPSON_1200",		1200,		"mg",				"",		undefined );
add_zombie_weapon( "zombie_type100_smg_upgraded",	"zombie_type100_smg_upgraded",			&"WAW_ZOMBIE_WEAPON_TYPE100_1000",		1000,		"mg",				"",		undefined );
*/

//Total: 13 base, 0 upgraded = 13

/***** END WAW *****/

/**************************
    Special
**************************/

    //Base
    add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
    add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );
    //add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );
    //add_zombie_weapon( "knife_ballistic_sickle_zm",	"knife_ballistic_sickle_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",	"",		undefined );


    //Base WW
 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );
 	add_zombie_weapon( "tesla_gun_zm",			"tesla_gun_upgraded_zm",				&"ZOMBIE_WEAPON_TESLA", 				10,		"tesla",			"",		undefined );
 	add_zombie_weapon( "thundergun_zm",				"thundergun_upgraded_zm",				&"ZOMBIE_WEAPON_THUNDERGUN", 			10,		"thunder",			"",		undefined );
 	
 	add_zombie_weapon( "freezegun_zm",				"freezegun_upgraded_zm",				&"ZOMBIE_WEAPON_FREEZEGUN", 			10,		"freezegun",		"",		undefined );

//Upgrade - No Double upgrades for specials except for crossbow
add_zombie_weapon( "crossbow_explosive_upgraded_zm",		"crossbow_explosive_upgraded_zm_x2",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
add_zombie_weapon( "knife_ballistic_upgraded_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"bowie",	"",		undefined );

//Total: 2 base, 2 upgraded, 1 x2 = 5 + ( 4 WW )
/***** END SPECIAL *****/



/**************************
    New
**************************/
add_zombie_weapon( "ak47_zm",					"ak47_ft_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				1000,	"assault",			"",		undefined );
//add_zombie_weapon( "enfield",					"enfield",								&"ZOMBIE_WEAPON_COMMANDO",				1000,	"assault",			"",		undefined );
//add_zombie_weapon( "m60",						"m60",									&"ZOMBIE_WEAPON_COMMANDO",				1000,	"mg",				"",		undefined );
//add_zombie_weapon( "asp",						"asp",									&"ZOMBIE_WEAPON_COMMANDO",				1000,	"assault",			"",		undefined );

//Total: 4 base, 0 upgraded = 4
/***** END NEW *****/



/*
    SUMMARY
    melee: 6
    grenades: 10
    MGs: 8
    Assault Rifles: 14
    Shotguns: 6
    SMGs: 5
    Sidearms: 9
    Snipers: 7
    Launchers: 4
    Wall: 18
    WAW: 13
    Special: 5
    New: 4
    TOTAL: 99

*/

