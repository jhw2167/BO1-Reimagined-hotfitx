#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_music;
#include maps\_zombiemode_utility;
#include maps\_busing;
#include maps\_zombiemode_reimagined_utility;

#using_animtree( "generic_human" );

main()
{
	set_gamemode();

	level.max_mines = 30;

	level.player_too_many_weapons_monitor = true;
	level.player_too_many_weapons_monitor_func = ::player_too_many_weapons_monitor;
	level.player_out_of_playable_area_monitor = false;
	level._dontInitNotifyMessage = 1;

	// put things you'd like to be able to turn off in here above this line
	level thread maps\_zombiemode_ffotd::main_start();

	level.zombiemode = true;
	level.reviveFeature = false;
	level.contextualMeleeFeature = false;
	level.swimmingFeature = false;
	level.calc_closest_player_using_paths = true;
	level.zombie_melee_in_water = true;
	level.put_timed_out_zombies_back_in_queue = true;
	level.use_alternate_poi_positioning = true;
	SetDvar( "zombie_pause", "0" );		//zombie pause was being innit to 1 instead

	//Reimagined Expanded options
	level.user_options =GetDvarInt("zombie_custom_options");
	level.apocalypse=GetDvarInt("zombie_apocalypse");

	/*
		***
		Should not be set until we know user options was opened
		***

	level.alt_bosses=GetDvarInt("zombie_alt_bosses");
	level.expensive_perks=GetDvarInt("zombie_exp_perks");
	level.tough_zombies=GetDvarInt("zombie_tough_zombies");
	level.zombie_types=GetDvarInt("zombie_types");
	level.total_perks=GetDvarInt("zombie_perk_limit");
	level.bo2_perks=GetDvarInt("zombie_bo2_perks");
	level.extra_drops=GetDvarInt("zombie_extra_drops");
	level.weapon_fx=GetDvarInt("zombie_weapon_effects");

	level.starting_round=GetDvarInt("zombie_round_start");
	level.server_cheats=GetDvarInt("reimagined_cheat");
	*/

	//Overrides	
	/* 									*/
	level.zombie_ai_limit_override=1;	///allowed on map
	level.starting_round_override=1;	///
	level.starting_points_override=100000;	///
	//level.drop_rate_override=50;		/// //Rate = Expected drops per round
	//level.zombie_timeout_override=1;	///
	//level.spawn_delay_override=0.5;			///
	level.server_cheats_override=true;	///
	//level.calculate_amount_override=16;	///per round
	level.apocalypse_override=false;		///
	level.classic_override=false;		///
	level.alt_bosses_override=false;		///
	//level.override_give_all_perks=true;	///
	level.override_bo2_perks=true;		///
	//level.rolling_kill_all_interval=12;	///
	level.dev_only=true;					///*/

	setApocalypseOptions();

	//for tracking stats
	level.zombie_health = 150;
	level.zombies_timeout_spawn = 0;
	level.zombies_timeout_playspace = 0;
	level.zombies_timeout_undamaged = 0;
	level.zombie_player_killed_count = 0;
	level.zombie_trap_killed_count = 0;
	level.zombie_pathing_failed = 0;
	level.zombie_breadcrumb_failed = 0;
	level.mapname = Tolower( GetDvar( #"mapname" ) );
	level.script = level.mapname;
	level.ARRAY_ZOMBIEMODE_PLAYER_COLORS = array("white", "blue", "yellow", "green");

	//level.zombie_visionset = "zombie_neutral";

	if(GetDvar("anim_intro") == "1")
	{
		level.zombie_anim_intro = 1;
	}
	else
	{
		level.zombie_anim_intro = 0;
	}

	precache_shaders();
	precache_models();

	PrecacheItem( "frag_grenade_zm" );
	PrecacheItem( "claymore_zm" );
	PrecacheItem( "falling_hands_zm" );

	//difficulty
	level.skill_override = 1;
	maps\_gameskill::setSkill(undefined,level.skill_override);

	level.disable_player_damage_knockback = true;

	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;

	init_dvars();
	init_mutators();
	init_strings();
	init_levelvars();
	init_animscripts();
	init_sounds();
	init_shellshocks();
	init_flags();
	init_client_flags();

	//Reimagined-Expanded -- Set Up Options and GameType

	level reimagined_init_level();

	register_offhand_weapons_for_level_defaults();

	//Limit zombie to 24 max, must have for network purposes
	if ( !isdefined( level.zombie_ai_limit ) )
	{
		//Reimagined-Expanded - raised from 24 to 40
		level.zombie_ai_limit = 32;
		SetAILimit( 32 );	//allows zombies to spawn in as some were just killed
	}

	

	init_fx();
	//maps\_zombiemode_ability::init();

	// load map defaults
	maps\_zombiemode_load::main();

	// Initialize the zone manager above any scripts that make use of zone info
	maps\_zombiemode_zone_manager::init();

	//maps\_zombiemode_grief::init();

	// Call the other zombiemode scripts
	maps\_zombiemode_audio::audio_init();
	maps\_zombiemode_claymore::init();
	maps\_zombiemode_weapons::init();
	maps\_zombiemode_equipment::init();
	maps\_zombiemode_blockers::init();
	maps\_zombiemode_spawner::init();
	maps\_zombiemode_powerups::init();
	maps\_zombiemode_perks::init();
	maps\_zombiemode_user::init();
	maps\_zombiemode_weap_cymbal_monkey::init();
	maps\_zombiemode_weap_freezegun::init();
	maps\_zombiemode_weapon_effects::init();	//Reimagined-Expanded
	maps\_zombiemode_weap_tesla::init();
	maps\_zombiemode_weap_thundergun::init();
	maps\_zombiemode_weap_crossbow::init();
//Z2	TEMP DISABLE DURING INTEGRATION
	maps\_zombiemode_bowie::bowie_init();
//	maps\_zombiemode_betty::init();
//	maps\_zombiemode_timer::init();
//	maps\_zombiemode_auto_turret::init();
	//maps\_zombiemode_protips::pro_tips_initialize();
	maps\_zombiemode_traps::init();
	maps\_zombiemode_weapon_box::init();
	/#
	maps\_zombiemode_devgui::init();
	#/

	//Reimagined-Expanded -- set up zombie blood powerup
	maps\sb_bo2_zombie_blood_powerup::init();

	init_function_overrides();

	// ww: init the pistols in the game so last stand has the importance order
	level thread last_stand_pistol_rank_init();

	//thread maps\_zombiemode_rank::init();

	// These MUST be threaded because they contain waits
	//level thread maps\_zombiemode_deathcard::init();
	//level thread maps\_zombiemode_money::init();
	level thread [[level.Player_Spawn_func]]();
	level thread onPlayerConnect();
	level thread post_all_players_connected();

	init_utility();
	maps\_utility::registerClientSys("zombify");	// register a client system...
	init_anims(); 	// zombie ai and anim inits

	if( isDefined( level.custom_ai_type ) )
	{
		for( i = 0; i < level.custom_ai_type.size; i++ )
		{
			[[ level.custom_ai_type[i] ]]();
		}
	}

	if( level.mutators[ "mutator_friendlyFire" ] )
	{
		SetDvar( "friendlyfire_enabled", "1" );
	}

	initZombieLeaderboardData();
	initializeStatTracking();

	if ( GetPlayers().size <= 1 )
	{
		incrementCounter( "global_solo_games", 1 );
	}
	else if( level.systemLink )
	{
		incrementCounter( "global_systemlink_games", 1 );
	}
	else if ( GetDvarInt( #"splitscreen_playerCount" ) == GetPlayers().size )
	{
		incrementCounter( "global_splitscreen_games", 1 );
	}
	else // coop game
	{
		incrementCounter( "global_coop_games", 1 );
	}

	// Fog in splitscreen
	if( IsSplitScreen() )
	{
		set_splitscreen_fog( 350, 2986.33, 10000, -480, 0.805, 0.715, 0.61, 0.0, 10000 );
	}

	/#
	init_screen_stats();
	level thread update_screen_stats();
	#/

	level thread maps\_zombiemode_ffotd::main_end();

	// No longer needed, uses inf client systems
	// registerClientSys("hud");

	level thread box_weapon_changes();
}

post_all_players_connected()
{
	flag_wait( "all_players_connected" );
/#
	execdevgui( "devgui_zombie" );
#/
	println( "sessions: mapname=", level.script, " gametype zom isserver 1 player_count=", get_players().size );


	maps\_zombiemode_score::init();
	level difficulty_init();

	//thread zombie_difficulty_ramp_up();

	// DCS 091610: clear up blood patches when set to mature.
	level thread clear_mature_blood();

	// Start the Zombie MODE!
	level thread end_game();

	//Reimagined-Expanded -- Set Up Players bonus player perk fx
	level reimagined_init_player_depedent_values();
	players = get_players();
	for(i=0;i<players.size;i++) 
	{
		players[i] reimagined_init_player();
		players[i] init_hitmarkers();

		players[i] thread watch_player_hellfire();
		players[i] thread watch_player_sheercold();
		players[i] thread watch_player_electric();
		players[i] thread watch_player_shotgun_attrition();
		players[i] thread maps\_zombiemode_weapon_effects::wait_projectile_impacts();

		players[i] thread watch_player_weapon_special_bonuses();


		if( level.apocalypse )
			players[i] thread watch_player_perkslots();
	}
	



	if(!level.zombie_anim_intro)
	{
		level thread round_start();
	}
	level thread players_playing();

	//chrisp - adding spawning vo
	//level thread spawn_vo();

	//add ammo tracker for VO
	level thread track_players_ammo_count();

	//level thread prevent_near_origin();

	DisableGrenadeSuicide();

	level.startInvulnerableTime = GetDvarInt( #"player_deathInvulnerableTime" );
// 	level.global_damage_func		= maps\_zombiemode_spawner::zombie_damage;
// 	level.global_damage_func_ads	= maps\_zombiemode_spawner::zombie_damage_ads;

	// TESTING
	//	wait( 3 );
	//	level thread intermission();
	//	thread testing_spawner_bug();

	if(!IsDefined(level.music_override) )
	{
		level.music_override = false;
	}


	level thread disable_character_dialog();

	level thread timer_hud();

	level thread enemies_remaining_hud();

	level thread watch_faulty_rounds();

	level thread sidequest_hud();
}


init_hitmarkers() 
{

	self.hud_damagefeedback = newClientHUDElem( self );
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback SetShader( "specialty_bo4hitmarker_white", 24, 24 );
	//self.hud_damagefeedback SetShader( "specialty_juggernaut_zombies", 24, 24 );

	self.hud_damagefeedback_death = newClientHUDElem( self );
	self.hud_damagefeedback_death.horzAlign = "center";
	self.hud_damagefeedback_death.vertAlign = "middle";
	self.hud_damagefeedback_death.x = -12;
	self.hud_damagefeedback_death.y = -12;
	self.hud_damagefeedback_death.alpha = 0;
	self.hud_damagefeedback_death.archived = true;
	self.hud_damagefeedback_death SetShader( "specialty_bo4hitmarker_red__", 24, 24 );
}

reimagined_init_player_depedent_values()
{
	//players_count, total_players, count_players
	if( !isDefined(level.players_size) )
		level.players_size = GetPlayers().size;

	level.THRESHOLD_MAX_ZOMBIE_HEALTH = level.THRESHOLD_MAX_ZOMBIE_HEALTH 
		* level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ level.players_size ];

	
	//level.VALUE_DESPAWN_ZOMBIES_UNDAMGED_TIME_MAX = 32 - 2*level.players_size;
	if ( isDefined( level.zombie_timeout_override ) )
		level.VALUE_DESPAWN_ZOMBIES_UNDAMGED_TIME_MAX = level.zombie_timeout_override;

	//Map Specific

	//Shino
	level.THRESHOLD_SHINO_SWAMPLIGHT_EXPIRATION_TIME = 60 - (level.players_size * 12);

	//Der Riese
	for(i=0; i< level.players_size; i++)  {
		level.ARRAY_FACTORY_SPECIAL_DOG_HEALTH_FACTOR[i] = 2.5 + i*0.75;
	}

	//Real time late iniatialized variables

	switch( level.mapname )
	{
		case "zombie_cod5_prototype":
		case "zombie_cod5_asylum":
		case "zombie_cod5_sumpf":
		case "zombie_cod5_factory":
			level._effect["divetonuke_groundhit"] = level._effect["betty_explode"];
			break;
		case "zombie_theater":
		case "zombie_pentagon":
    		level._effect["divetonuke_groundhit"] = level._effect[ "dog_gib" ];
			break;
		case "zombie_cosmodrome":
    	case "zombie_coast":
    	case "zombie_temple":
		case "zombie_moon":
			break;
		
	}
}

/*
	//options
	//init level
	//init options

	//apocalypse options

*/
reimagined_init_level()
{
	//init-level
	level.VALUE_MAX_AVAILABLE_PERKS = 15;


	//Zombie Values
	level.VALUE_NORMAL_ZOMBIE_REDUCE_HEALTH_SCALAR = 0.03;
	level.VALUE_NORMAL_ZOMBIE_REDUCE_HEALTH_SCALAR_START_ROUND = 8;

	level.THRESHOLD_ZOMBIE_PLAYER_BONUS_HEALTH_ROUND = 5;

	level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ 0 ] = 1.00;
	level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ 1 ] = 1.00;
	level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ 2 ] = 1.20;
	level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ 3 ] = 1.35;
	level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ 4 ] = 1.50;

	level.THRESHOLD_MAX_ZOMBIE_HEALTH = 1000000;
	level.VALUE_ZOMBIE_HEALTH_PORTION_R15 = 0.015;	//1.5% of max health
	level.VALUE_ZOMBIE_HEALTH_PORTION_R20 = 0.05; 	//5% of max health
	level.VALUE_ZOMBIE_HEALTH_PORTION_R30 = 0.25; 	//35% of max health
	level.VALUE_ZOMBIE_HEALTH_PORTION_R40 = 0.50; 	//50% of max health
	level.VALUE_ZOMBIE_HEALTH_PORTION_R50 = 0.80; 	//80% of max health

	level.SUPER_SPRINTER_SPEED = 70;
	level.TERROR_SPEED = 140;

	level.VALUE_ZOMBIE_HASH_MAX=10000;		// Zombies are given "hash" as an identifier

	level.THRESHOLD_NOVA_CRAWLER_MAX_PORTION = 0.20;	//20% of zombies can be nova crawlers

	//Apocalypse Auto round tick forward values
	level.VALUE_APOCALYPSE_ROUND_TICK_TIME_EARLY = 30;	//Seconds between zombies thresholds
	level.VALUE_APOCALYPSE_ROUND_TICK_TIME_MED = 50;	//Seconds between zombies thresholds rounds
	level.VALUE_APOCALYPSE_ROUND_TICK_TIME_LATE = 150;	//Seconds between zombies thresholds rounds -- not used, using RoundNumber
	
	level.THRESHOLD_MAX_APOCALYSE_ROUND = 35;	//After this round, round times are a function of how fast you kill zombies
	level.VALUE_APOCALYPSE_WAIT_ROUNDS = 5;			//Every 5 rounds, get a wait
	level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS = [];
	level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS = [];
	level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS = [];

	level.ARRAY_QUICK_KILL_BONUS_POINTS = [];
	level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS = [];

	level.QUICK_KILL_BONUS_OVERRIDE = 0;	//allows us to turn off quick kill bonus
	//level.QUICK_KILL_NEGATIVE_BONUS_OVERRIDE = 0;

	for(i=0;i <= level.THRESHOLD_MAX_APOCALYSE_ROUND; i++) 
	{
		level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[i] = 10000000; //No threshold, theoretical max
		if( i < 5 ) {
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = 45;				//time in seconds
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 250;

			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 0;
			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 0;
		}
		else if( i < 10 ) {
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = 70;				//time in seconds
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 500;

			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 25;
			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 10;
		}
		else if( i < 15 ) {
			level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[i] = 10;
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = level.VALUE_APOCALYPSE_ROUND_TICK_TIME_EARLY;
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 500;

			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 25;
			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 20;
		}
		else if( i < 20 ) {
			level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[i] = 15;
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = level.VALUE_APOCALYPSE_ROUND_TICK_TIME_MED;
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 1000;

			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 50;
			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 30;
		} 
		else if( i < 25 ) {
			level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[i] = i;
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = level.VALUE_APOCALYPSE_ROUND_TICK_TIME_MED;
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 1000;

			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 75;
			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 40;
		}
		else if( i < 30 ) {
			level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[i] = i;
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = i;
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 2000;

			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 150;
			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 50;
		} 
		else {
			level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[i] = i;
			level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[i] = i;
			level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[i] = 2000;

			level.ARRAY_QUICK_KILL_NEGATIVE_BONUS_POINTS[i] = 50;
			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = 200;
		}
			
		if( isdefined(level.QUICK_KILL_BONUS_OVERRIDE) )
			level.ARRAY_QUICK_KILL_BONUS_POINTS[i] = level.QUICK_KILL_BONUS_OVERRIDE;	//allows us to turn off quick kill bonus
	}
		

	//Zombie values
	level.ARRAY_VALID_STANDARD_ZOMBIES = array( "zombie", "quad_zombie", "zombie_dog" );

	level.VALUE_HORDE_SIZE = 100; 			/// none in early rounds
	level.VALUE_HORDE_DELAY = 10;			// Mini horde delays during between rounds
	level.THRESHOLD_ZOMBIE_AI_LIMIT = 32;

	level.VALUE_APOCALYPSE_ZOMBIE_DEATH_POINTS = 75;	//up from 75, down from 100

	level.VALUE_ZOMBIE_DAMAGE_POINTS_LOW = 5;
	level.LIMIT_ZOMBIE_DAMAGE_POINTS_ROUND_LOW = 5000; //before this round awward damage_points_low

	level.VALUE_ZOMBIE_DAMAGE_POINTS_MED = 5;
	level.LIMIT_ZOMBIE_DAMAGE_POINTS_ROUND_MED = 15;	//before this round awward damage_points_med

	level.VALUE_ZOMBIE_DAMAGE_POINTS_HIGH = 1;
	//level.LIMIT_ZOMBIE_DAMAGE_POINTS_ROUND_HIGH = 1000;

	level.VALUE_ZOMBIE_DAMAGE_POINTS_RESPAWN = 1;

	level.VALUE_ZOMBIE_DOG_HEALTH_PORTION = 0.6;			//dogs have 60% of normal zombie health

	level.zombie_round_cluster_size = 1;
	level.VALUE_ZOMBIE_SPAWN_CLUSTER_CHANCE = 20;			//20% chance of spawning a cluster of zombies
	level.VALUE_ZOMBIE_SPAWN_CLUSTER_SIZE_MAX = 6;			//largest cluster is 6 zombies
	level.THRESHOLD_ZOMBIE_SPAWN_CLUSTER_TOTAL_ENEMIES_MAX = 20;	//If more than _ zombies on map don't cluster spawn
	level.THRESHOLD_ZOMBIE_SPAWN_CLUSTER_TOTAL_ENEMIES_MIN = 0;		//If less than _ zombies on map don't cluster spawn
	level.THRESHOLD_ZOMBIE_SPAWN_CLUSTER_ASSUME_MAX_ENEMIES = 24;	//Assuming only 24 zombs total can be on map
	level.VALUE_ZOMBIE_SPAWN_DELAY = 9.5;
	//level.ARRAY_VALUES["zombie_spawn_delay"] = 4.5;		

	level.THRESHOLD_MIN_ZOMBIES_DESPAWN_OFF_NUMBER_EARLY = 2;
	level.THRESHOLD_MIN_ZOMBIES_DESPAWN_OFF_NUMBER = 5;
	level.STRING_MIN_ZOMBS_REMAINING_NOTIFY = "MIN_ZOMBS_REMAINING_NOTIFY";		//level message when < 5 zombies remain
	level.VALUE_DESPAWN_ZOMBIES_UNDAMGED_TIME_MAX=24;

	level.VALUE_DESPAWN_ZOMBIES_UNDAMGED_RADIUS = 128;
	level.ARRAY_VALID_DESPAWN_ZOMBIES= array("zombie", "quad_zombie");
	
	level.VALUE_ZOMBIE_QUICK_KILL_BONUS = 25;	//25 points per zombie killed before it despawns
	level.VALUE_ZOMBIE_QUICK_KILL_ROUND_INCREMENT = 5; //goes up every 5 rounds
	level.VALUE_ZOMBIE_QUICK_KILL_ROUND_START = 5;

	level.VALUE_SLOW_ZOMBIE_ATTACK_ANIM_TIME = 1;
	level.THREHOLD_SLOW_ZOMBIE_ATTACK_ANIM_ROUND_MAX = 0;

	level.VALUE_PLAYER_DOWNED_PENALTY = 25;	//Multiplied by num players - 1
	level.VALUE_PLAYER_DOWNED_PENALTY_INTERVAL = 3; //POSTs every 2.5 seconds
	level.VALUE_PLAYER_DOWNED_BLEEDOUT_TIME = 120;	//Player has 125 seconds to be revived


	level.THRESHOLD_ZOMBIE_RANDOM_DROP_ROUND = 7; //equal or greater than, only "random" drops after this round
	level.VALUE_ZOMBIE_RANDOM_DROP_EARLY_SCALER = 1.2;	//Increment increases by 20% after each drop

	//These are (expected drops per round * 10), so "10" is 1 drop expected per round,
	//	 8 is 0.8 drops expected per round 
	level.VALUE_ZOMBIE_DROP_RATE_GREEN_NORMAL = 12;			//between 0-1000)
	level.VALUE_ZOMBIE_DROP_RATE_GREEN = 10;			//between 0-1000)
	level.VALUE_ZOMBIE_DROP_RATE_BLUE = 6; //6;		//between 0-1000)	
	level.VALUE_ZOMBIE_DROP_RATE_RED = 4;		//between 0-1000)
	level.rand_drop_rate = [];

		if( isDefined(level.drop_rate_override) ) {
			level.VALUE_ZOMBIE_DROP_RATE_GREEN_NORMAL = level.drop_rate_override*10;
			level.VALUE_ZOMBIE_DROP_RATE_GREEN = level.drop_rate_override*10;
			level.VALUE_ZOMBIE_BLUE_DROP_RATE_BLUE = level.drop_rate_override*100;
			level.VALUE_ZOMBIE_RED_DROP_RATE_RED = level.drop_rate_override*10;
		}

	level.VALUE_ZOMBIE_DROP_INCREMENT = 0.3;
	level.THRESHOLD_ZOMBIE_DROP_INCREMENT_START_ROUND = 11;


	level.THRESHOLD_MAX_DROPS = 6;	//Max Drops allowed per round. Protects against bugs

	level.THRESHOLD_MAX_POINTS_CARPENTER = 2000;
	level.THRESHOLD_MAX_POINTS_NUKE = 4800;

	//Boss Zombies
	level.THRESHOLD_DIRECTOR_LIVES=10;

	level.VALUE_THIEF_HEALTH_SCALAR = 16;	//this many times avg zombie max health of this round
	level.VALUE_THIEF_HEALTH_SCALAR_PAP_BONUS = 1.5;	//Thief gets 50% more health per each player with PaP weapon
	level.VALUE_THIEF_HEALTH_SCALAR_x2_BONUS = 2.0;	//Thief gets 100% more health per each player with PaP weapon

	//Weapon Pap
	level.VALUE_PAP_COST = 5000;
	level.VALUE_PAP_EXPENSIVE_COST = 10000;
	level.VALUE_PAP_X2_COST = 20000;
	level.VALUE_PAP_X2_EXPENSIVE_COST = 40000;

	level.VALUE_PAP_BONFIRE_COST = 1000;
	level.VALUE_PAP_EXPENSIVE_BONFIRE_COST = 5000;
	level.VALUE_PAP_X2_BONFIRE_COST = 10000;
	level.VALUE_PAP_X2_EXPENSIVE_BONFIRE_COST = 20000;
	
	level.VALUE_PERK_PUNCH_COST = 20000;
	level.VALUE_PERK_PUNCH_EXPENSIVE_COST = 40000;


	//Weapon Consts
	level.VALUE_WPN_INDEX_BOWIE = 1;
	level.VALUE_WPN_INDEX_SICKLE = 2;
	

	//PERK CONSTANTS

	level.ARRAY_VALID_PERKS = array(
		level.JUG_PRK,
		level.QRV_PRK,
		level.SPD_PRK,
		level.DBT_PRK,
		level.STM_PRK,
		level.PHD_PRK,
		level.DST_PRK,
		level.MUL_PRK,
		level.ECH_PRK,
		level.VLT_PRK,
		level.WWN_PRK
	 );
	 // "specialty_extraammo", 			//babyjugg

	level.ARRAY_VALID_PRO_PERKS = array(
		level.QRV_PRO,
		level.JUG_PRO,
		level.SPD_PRO,
		level.DBT_PRO,
		level.STM_PRO,
		level.PHD_PRO,
		level.DST_PRO,
		level.MUL_PRO,
		level.ECH_PRO,
		level.VLT_PRO,
		level.WWN_PRO
	);

	//CSC Perk HUD Info
	level.HUD_ANIM_BASE_STRING_MUL = "hud_mule_wep";
	level.HUD_ANIM_BASE_STRING_STMPRO = "stamina_ghost";
	level.HUD_ANIM_BASE_STRING_VLT = "vulture_hud";

	//CSC Perk Action Info
	//level.ARRAY_HUD_ANIM_BASE_STRINGS[ level.VLT_PRK ] = "minor_drop";

	/*	####################
			PERK EFFECTS
		####################
	*/

	//Damage over time, type, for poison and shock
	level.VALUE_DAMAGETYPE_DOT = "MOD_DOT";
	level.VALUE_DAMAGETYPE_SHOCK = "MOD_SHOCK";

	//Babyjug
	level.VALUE_BABYJUG_COST = 1000;
	level.VALUE_BABYJUG_EXP_COST = 2000;

	//Stamina
	level.VALUE_STAMINA_PRO_SPRINT_WINDOW = 2; //After player melees, 2s to sprint and activate ghost
	level.TOTALTIME_STAMINA_PRO_GHOST = 3; //3 seconds
	level.COOLDOWN_STAMINA_PRO_GHOST = 12; 	//8s
	level.VALUE_STAMINA_PRO_GHOST_RANGE = 800; //After player melees, 2s to sprint and activate ghost

	//PHD
	level.TOTALTIME_PHD_PRO_COLLISIONS = 2; //2 seconds
	level.VALUE_PHD_PRO_COLLISIONS_RANGE = 200; //Turn off collisions within 200 units
	level.VALUE_PHD_MIN_DAMAGE = 30000; //Damage to zombies
	level.VALUE_PHD_MAX_DAMAGE = 60000; //Damage to zombies
	level.VALUE_PHD_PRO_DAMAGE_SCALER = 3.5;
	level.VALUE_PHD_PRO_RADIUS_SCALER = 1.2; //times larger than original radius

	level.VALUE_PHD_PRO_EXPLOSION_BONUS_DMG_SCALE = 4;
	level.VALUE_PHD_PRO_EXPLOSION_BONUS_RANGE_SCALE = 2;

	level.VALUE_PHD_PRO_HELLFIRE_BONUS_RANGE_SCALE = 2;
	level.VALUE_PHD_PRO_HELLFIRE_BONUS_TIME_SCALE = 2;

	level.VALUE_PHD_EXPL_BONUS_POINTS = 25;

	//Speed
	level.COOLDOWN_SPEED_PRO_RELOAD = 2.0;

	//Deadshot
	level.CONDITION_DEADSHOT_PRO_WEAKPOINTS = array( "head", "helmet", "neck");
	level.VALUE_DEADSHOT_PRO_WEAKPOINT_STACK = 0.05;

	//Double Tap
	level.VALUE_DBT_DAMAGE_BONUS = 1.5;
	level.VALUE_DBT_PRO_DAMAGE_BONUS = 2.0;
	level.VALUE_DBT_UNITS = 5;
	level.VALUE_DBT_PENN_DIST = 20;
	level.THRESHOLD_DBT_MAX_DIST = 1000; //50*20=
	level.THRESHOLD_DBT_TOTAL_PENN_ZOMBS = 6;

	//Quick Revive
	level.VALUE_QRV_PRO_REVIVE_RADIUS_MULTIPLIER = 2;
	level.VALUE_QRV_PRO_REVIVE_ZOMBIEBLOOD_TIME = 10;

	//Jugg
	level.VALUE_JUGG_PRO_MAX_HEALTH = 325;

	//	-- BO2 Perks

	//Cherry
	level.VALUE_CHERRY_SHOCK_RELOAD_FX_TIME = 2;
	level.VALUE_CHERRY_SHOCK_RANGE = 196;
	level.VALUE_CHERRY_SHOCK_DMG = 65536; 	//2^16=65536
	level.VALUE_CHERRY_SHOCK_SHORT_COOLDOWN = 4;
	level.VALUE_CHERRY_SHOCK_LONG_COOLDOWN = 32;
	level.VALUE_CHERRY_SHOCK_MAX_ENEMIES = 8;
	level.VALUE_CHERRY_SHOCK_MIN_ENEMIES = 2;

	level.VALUE_CHERRY_PRO_DEFENSE_COOLDOWN = 30;	//cooldown for cherry defense
	level.VALUE_CHERRY_PRO_SCALAR = 16/10;	//scales range, damage, max enemies by ~2

	//Vulture
	level.THRESHOLD_VULTURE_BONUS_AMMO_PICKUP_RANGE = 64;
	level.VALUE_VULTURE_BONUS_MELEE_POINTS = 40;				//Up from 25
	level.VALUE_VULTURE_BONUS_AMMO_CLIP_FRACTION = 0.03;
	level.VALUE_VULTURE_PRO_BONUS_AMMO_CLIP_FRACTION = 0.05;
	level.VALUE_VULTURE_MIN_AMMO_BONUS = 5;
	level.VALUE_VULTURE_MAX_AMMO_BONUS = 20;
	level.VALUE_VULTURE_PRO_SCALE_AMMO_BONUS = 2;

	level.VALUE_VULTURE_BONUS_AMMO_SPAWN_CHANCE = 55;//40;			//1-1000, 4% chance per zombie per player with vulture
	level.VALUE_VULTURE_BONUS_DROP_TIME = 60;					//60 seconds
	level.VALUE_VULTURE_BONUS_DROP_DELAY_TIME = 15;				//15 seconds
	//level.count_vulture_fx_drops_round								//See pre-round
	level.VALUE_VULTURE_PRO_POWERUP_RETRIGGER_TIME = 30;

	//Blacklist
	level.ARRAY_VULTURE_INVALID_AMMO_WEAPONS = array(
		"microwavegundw_upgraded_zm",
		"microwavegundw_zm",
		"tesla_gun_powerup_upgraded_zm",
		"tesla_gun_powerup_zm",
		"tesla_gun_upgraded_zm",
		"tesla_gun_zm",
		"thundergun_upgraded_zm",
		"thundergun_zm",
		"ray_gun_upgraded_zm",
		"ray_gun_zm",
		"starburst_ray_gun_zm",
		"freezegun_upgraded_zm",
		"freezegun_zm",
		"shrink_ray_upgraded_zm",
		"shrink_ray_zm",
		"sniper_explosive_bolt_upgraded_zm",
		"sniper_explosive_bolt_zm",
		"m72_law_zm" , 
		"china_lake_zm" ,
		"crossbow_explosive_zm",
		"crossbow_explosive_upgraded_zm",
		"crossbow_explosive_upgraded_zm_x2",
		"sniper_explosive_zm",
		"sniper_explosive_upgraded_zm",
		"explosivbe_bolt_zm",
		"explosivbe_bolt_upgraded_zm",
		"sabertooth_zm",
		"sabertooth_upgraded_zm",
		"humangun_zm",
		"humangun_upgraded_zm",
		"m1911_upgraded_zm",
		"asp_upgraded_zm",
		"asp_upgraded_zm_x2",
		//Add all combnat knives and fists
		"knife_zm",
		"combat_knife_zm",
		"combat_knife_upgraded_zm",
		"bowie_knife_zm",
		"combat_bowie_knife_zm",
		"sickle_knife_zm",
		"combat_sickle_knife_zm",
		"rebirth_hands_sp",
		"vorkuta_knife_sp",
		"knife_ballistic_zm",
		"knife_ballistic_upgraded_zm",
		"knife_ballistic_upgraded_zm_x2",
		//Misc
		"claymore_zm",
		"spikemore_zm",
		"frag_grenade_zm",
		"zombie_knuckle_crack",

		//Grenades
		"frag_grenade_zm",
		"sticky_grenade_zm",
		"bo3_zm_widows_grenade",
		"zombie_black_hole_bomb",
		"zombie_quantum_bomb"

		);

	//Vulture HUD Values
	level.VALUE_VULTURE_HUD_DIST_CUTOFF_VERY_FAR = 3072;
	level.VALUE_VULTURE_HUD_DIST_FAR = 1024;
	level.VALUE_VULTURE_HUD_DIST_MED = 512;
	level.VALUE_VULTURE_HUD_DIST_CLOSE = 256;
	level.VALUE_VULTURE_HUD_DIST_CUTOFF = 192;

	level.VALUE_VULTURE_HUD_DIM_VERY_FAR = 16;
	level.VALUE_VULTURE_HUD_DIM_FAR = 16;
	level.VALUE_VULTURE_HUD_DIM_MED = 64;
	level.VALUE_VULTURE_HUD_DIM_CLOSE = 128;

	level.VALUE_VULTURE_HUD_ALPHA_VERY_FAR = .35;
	level.VALUE_VULTURE_HUD_ALPHA_FAR = .4;
	level.VALUE_VULTURE_HUD_ALPHA_MED = .3;
	level.VALUE_VULTURE_HUD_ALPHA_CLOSE = .2;

	level.VALUE_VULTURE_MACHINE_ORIGIN_OFFSET = 20;
	level.THRESHOLD_VULTURE_FOV_HUD_DOT = 0.1;

	level.VALUE_VULTURE_ROUND_START_ZOMBIE_IMMUNITY = 15;

	//Wine
	//level.THRESHOLD_WIDOWS_ZOMBIE_CLOSE_HUD_DIST = 768;
	//level.THRESHOLD_WIDOWS_ZOMBIE_CLOSE_HUD_DIST = 512;
	level.THRESHOLD_WIDOWS_ZOMBIE_CLOSE_HUD_DIST = 384;
	level.THRESHOLD_WIDOWS_ZOMBIE_CLOSE_HUD_BEHIND_DIST = 96;
	level.THRESHOLD_WIDOWS_ZOMBIE_CLOSE_HUD_VERTICAL_CUTOFF = 10;

	level.THRESHOLD_WIDOWS_BEHIND_HUD_DOT = 0;
	level.VALUE_WIDOWS_ZOMBIE_CLOSE_HUD_COOLDOWN = 7;
	level.VALUE_WIDOWS_ZOMBIE_CLOSE_HUD_ONTURN_COOLDOWN = 3;
	level.VALUE_WIDOWS_ZOMBIE_CLOSE_HUD_HEAVY_COOLDOWN = 15;

	level.THRESHOLD_WIDOWS_COUNT_ZOMBS_HEAVY_WARNING = 3;
	level.VALUE_WIDOWS_PLAYER_FOV_SHRINK = 120;

	level.ARRAY_WIDOWS_VALID_POISON_POINTS = array( "J_Shoulder_LE", "J_Shoulder_RI",
													"J_Elbow_LE", "J_Elbow_RI",
													"J_Hip_LE", "J_Hip_RI",
													"J_Knee_LE", "J_Knee_RI");

	level.ARRAY_WIDOWS_POISON_CHANCES_BY_BULLET = [];
	POISON_MAX=20;
	for(i=0; i< POISON_MAX; i++)  
	{
		if( i < (POISON_MAX / 2) ) 
			level.ARRAY_WIDOWS_POISON_CHANCES_BY_BULLET[i] = 0.05;
		else
			level.ARRAY_WIDOWS_POISON_CHANCES_BY_BULLET[i] = 0.1;
	}
	level.ARRAY_WIDOWS_POISON_CHANCES_BY_BULLET[ POISON_MAX ] = 1;

	level.ARRAY_WIDOWS_VALID_POISON_ZOMBIES = array( "zombie", "quad_zombie" );
	level.THRESHOLD_WIDOWS_MAX_POISON_POINTS = 50;
	level.THRESHOLD_WIDOWS_POISON_MIN_HEALTH_FRACTION = 1.0/2.0;
	level.THRESHOLD_WIDOWS_POISON_MAX_TIME = 8;
	level.THRESHOLD_WIDOWS_PRO_POISON_MIN_HEALTH_FRACTION = 1.0/3.0;
	level.THRESHOLD_WIDOWS_PRO_POISON_MAX_TIME = 15;

	level.VALUE_WIDOWS_GRENADE_MAX = 4;
	level.VALUE_WIDOWS_GRENADE_EXPLODE_TIME = 60;
	level.VALUE_WIDOWS_GRENADE_TRIGGER_RANGE = 80;
	level.VALUE_WIDOWS_GRENADE_EXPLOSION_RANGE = 300;
	level.VALUE_WIDOWS_GRENADE_EXPLOSION_DAMAGE = 300;

	level.VALUE_WIDOWS_ZOMBIE_WAIT_WEBBED_TIME = 1;
	level.VALUE_WIDOWS_ZOMBIE_WEBBED_TIME = 10;

	
	//Bullet Effects
	level.VALUE_PAP_WEAPON_BONUS_DAMAGE = 1.2;

	level.ARRAY_VALID_SNIPERS = array("psg1_upgraded_zm_x2", "l96a1_upgraded_zm_x2", "dragunov_upgraded_zm_x2",
				 			"psg1_upgraded_zm", "l96a1_upgraded_zm", "dragunov_upgraded_zm",
							 "psg1_zm", "l96a1_zm", "dragunov_zm" );
	level.VALUE_SNIPER_PENN_BONUS = 2;

	level.ARRAY_EXPLOSIVE_WEAPONS = array("m1911_upgraded_zm", "china_lake_zm", "m72_law_zm", "asp_upgraded_zm");

	//Also include unupgraded weapons e.g. m14_zm
	level.ARRAY_WALL_WEAPONS = array( "m14_zm", "mpl_zm", "mp5k_zm", "mp40_zm", "ak74u_zm", "pm63_zm",
									 "rottweil72_zm", "m16_gl_zm", "gl_m16_zm", "ithaca_zm",
							"m14_upgraded_zm", "mpl_upgraded_zm", "mp5k_upgraded_zm", "mp40_upgraded_zm", 
							"ak74u_upgraded_zm", "pm63_upgraded_zm", "rottweil72_upgraded_zm", "m16_gl_upgraded_zm",
							"gl_m16_upgraded_zm", "ithaca_upgraded_zm", "bar_upgraded_zm", "m1garand_upgraded_zm", "springfield_upgraded_zm"
	);

	level.ARRAY_ELECTRIC_WEAPONS = array("ak74u_upgraded_zm_x2", "aug_acog_mk_upgraded_zm_x2",
							 "cz75_upgraded_zm_x2", "cz75lh_upgraded_zm_x2", "stoner63_upgraded_zm_x2");
	level.THRESHOLD_ELECTRIC_BULLETS = 5;
	level.THRESHOLD_TESLA_SHOCK_TIME = 3;

	level.ARRAY_SHEERCOLD_WEAPONS = array("hk21_upgraded_zm_x2", "galil_upgraded_zm_x2", "spectre_upgraded_zm_x2",
							 	"makarov_upgraded_zm_x2");
	level.RANGE_SHEERCOLD_DIST = 256;
	level.THRESHOLD_SHEERCOLD_DIST = 100;
	level.THRESHOLD_SHEERCOLD_ACTIVE_TIME = 2;
	level.THRESHOLD_SHEERCOLD_ZOMBIE_THAW_TIME = 3;

	level.ARRAY_HELLFIRE_WEAPONS = array("ak47_ft_upgraded_zm_x2", "rpk_upgraded_zm_x2", "ppsh_upgraded_zm_x2",
							 "rottweil72_upgraded_zm", "cz75dw_upgraded_zm_x2", "sabertooth_upgraded_zm_x2");
	level.THRESHOLD_HELLFIRE_TIME = 1.8;		//Player holds trigger for 1.6 seconds to activate Hellfire
	level.THRESHOLD_HELLFIRE_KILL_TIME = 4;		//Hellfire kills in 4 seconds
	level.VALUE_HELLFIRE_RANGE = 25;
	level.VALUE_HELLFIRE_TIME = 1.2;			//Hellfire lasts while on the ground

	level.ARRAY_POISON_WEAPONS = array();	//Uzi added dynamically

	level.VALUE_AMMOTYPE_BONUS_DAMAGE = 1.25;


	level.VALUE_EXPLOSIVE_BASE_DMG = 30000;
	level.VALUE_EXPLOSIVE_UPGD_DMG_SCALE = 4;

	level.VALUE_EXPLOSIVE_BASE_RANGE = 250;
	level.VALUE_EXPLOSIVE_UPGD_RANGE_SCALE = 2;

	level.VALUE_SHOTGUN_DMG_ATTRITION = 0.10;
	level.VALUE_MAX_SHOTGUN_ATTRITION = 16;	//1.1^16=5x max 5x damage
	level.ARRAY_VALID_SHOTGUNS = array("ithaca_zm", "spas_zm", "rottweil72_zm", "hs10_zm",
									 "zombie_doublebarrel", "zombie_doublebarrel_upgraded", "zombie_shotgun", "zombie_shotgun_upgraded",
									 "ithaca_upgraded_zm", "spas_upgraded_zm", "rottweil72_upgraded_zm", "hs10_upgraded_zm",
									 "ithaca_upgraded_zm_x2", "spas_upgraded_zm_x2", "rottweil72_upgraded_zm_x2", "hs10_upgraded_zm_x2",
									 "ks23_zm", "ks23_upgraded_zm", "ks23_upgraded_zm_x2",
									 "aug_acog_mk_upgraded_zm", "aug_acog_mk_upgraded_zm_x2", "mk_aug_upgraded_zm"
									 );

	level.ARRAY_BIGDMG_WEAPONS = array( "commando_upgraded_zm_x2", "stoner63_upgraded_zm_x2", "m60_upgraded_zm_x2" );
	level.ARRAY_BIGHEADSHOTDMG_WEAPONS = array( "fnfal_upgraded_zm_x2", "m14_upgraded_zm", "psg1_upgraded_zm_x2", "l96a1_upgraded_zm_x2" );
	level.ARRAY_SIDEARMBONUS_WEAPONS = array( "cz75_zm", "cz75_upgraded_zm", "cz75_upgraded_zm_x2",
											"cz75_dw_zm", "cz75_dw_upgraded_zm", "cz75_dw_upgraded_zm_x2",
											 "python_zm", "python_upgraded_zm", "python_upgraded_zm_x2",
											 "makarov_zm", "makarov_upgraded_zm", "makarov_upgraded_zm_x2",
											 "asp_zm", "asp_upgraded_zm", "asp_upgraded_zm_x2"
											);

	level.ARRAY_EXECUTE_WEAPONS = array( "python_upgraded_zm_x2", "enfield_upgraded_zm_x2", "skorpionlh_upgraded_zm" );
	level.THRESHOLD_EXECUTE_ZOMBIE_HEALTH = 0.34 * level.THRESHOLD_MAX_ZOMBIE_HEALTH;


	//WEAPON VARIABLES
	level.WEAPON_SABERTOOTH_RANGE = 160;

	//Uzi
	level.WEAPON_UZI_TYPES = array( "", "Flame", "Freeze", "Shock", "Pestilence" );


	//MISCELLANEOUS EFFECTS
	level.VALUE_ZOMBIE_BLOOD_TIME = 30;
	level.VALUE_ZOMBIE_KNOCKDOWN_TIME = 1.5;
	level.ARRAY_VALID_ZOMBIE_KNOCKDOWN_WEAPONS = array( "rebirth_hands_sp", "vorkuta_knife_sp" );

	//Real Time Variables
	level.zombie_dog_total = 0;

	level.respawn_queue = [];
	level.respawn_queue_locked = false;
	level.respawn_queue_num = 0;
	level.respawn_queue_unlocks_num = 0;

	level.is_pap_available = false;

	level.drop_rate_adjustment = 0;

	level.stack_player_superpower = false;				//Allows multiple superpower stacking

	//Real Time Perk Variables
	level.vulture_using_perk_variable_locations = false;
	level.vulture_track_current_pap_spot = undefined;	//undefined when not in map
	level.vulture_track_current_powerups = [];
	level.vulture_is_upgraded_drop = false;				//When player has upgraded vulture, drop time extended
	level.vulture_waypoint_structs = [];
	level.vulture_waypoint_structs_update = false;


	//MISC
	level.VALUE_BASE_ORIGIN = (-10000, -10000, -10000);

	//Maps

	//Natch
	level.THRESHOLD_NACHT_PERKS_ENABLED_ROUND = 5;

	//Veruktd
	level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS = [];
	
	level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS[0] = Spawn( "script_model", (737, -490, 64)); //Spawn1
	level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS[1] = Spawn( "script_model", (760, -73, 64)); //Spawn2
	level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS[2] = Spawn( "script_model", (514, 970, 226)); //Corner Vultures
	level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS[3] = Spawn( "script_model", (-678, -145, 64)); //Downstairs power
	level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS[4] = Spawn( "script_model", (-200, -350, 226)); //Upper Balcony

	for(i=0;i<5;i++)  {
		level.ARRAY_VERUKT_PAP_DROP_SPAWN_LOCATIONS[i] SetModel( "tag_origin" );
	}

	level.THRESHOLD_VRKT_ELECTRAP_DROP_HACK_RADIUS = 88;
	level.MAP_VRKT_POWERUP_HACKS = [];

	
	level.MAP_VRKT_POWERUP_HACKS["insta_kill"] = "double_points";
	level.MAP_VRKT_POWERUP_HACKS["double_points"] = "carpenter";
	level.MAP_VRKT_POWERUP_HACKS["carpenter"] = "nuke";
	level.MAP_VRKT_POWERUP_HACKS["nuke"] = "insta_kill";

	level.MAP_VRKT_POWERUP_HACKS["tesla"] = "full_ammo";
	level.MAP_VRKT_POWERUP_HACKS["full_ammo"] = "free_perk";

	level.MAP_VRKT_POWERUP_HACKS["fire_sale"] = "restock";
	level.MAP_VRKT_POWERUP_HACKS["restock"] = "fire_sale";


	//Shino

	//level.ARRAY_SHINO_TARGETNAME_PERKS = valid_vending = ["vending_jugg", "vending_doubletap", "vending_revive", "vending_sleight", "vending_divetonuke", "vending_deadshot", "vending_marathon", "vending_electriccherry", "vending_widowswine", "vending_chugabud", "vending_additionalprimaryweapon", "vending_vulture"];
	level.ARRAY_SHINO_PERKS_AVAILIBLE = array("", "", "", ""); //babyjug never valid
	level.ARRAY_SHINO_ZONE_OPENED = [];

	//DER RIESE
	level.VALUE_FACTORY_SPECIAL_DOG_SPAWN_CHANCE = 20;	//20% chance of spawning a dog
	//level.VALUE_FACTORY_SPECIAL_DOG_SPAWN_CHANCE = 100;	//20% chance of spawning a dog
	level.THRESHOLD_FACTORY_MAX_ATTEMPTS_SPECIAL_DOG_SPAWN = 3;
	level.THRESHOLD_FACTORY_MIN_ROUNDS_BETWEEN_SPECIAL_DOG_SPAWN = 2;
	level.VALUE_FACTORY_SPECIAL_DOG_DEATH_STREAK_HEALTH_INC = 1.5;	//50% health bump per times killed in a row
	level.ARRAY_FACTORY_SPECIAL_DOG_HEALTH_FACTOR = [];
	
	//Kino, theater
	level.VALUE_ENGINEER_ZOMBIE_SPAWN_ROUNDS_PER_SPAWN = 3;	//3 rounds between spawns


	//Pentagon, five
	level.VALUE_PENTAGON_ROUNDS_BETWEEN_GAS = 3;
	level.ARRAY_PENTAGON_GAS_LOCS = array( 
		//(-579, 2611, 71),	//dev
		//(-648, 4101, -705), //obselete pig room

		(-567, 4059, -656), 
		(-695, 4305, -657),	//pig room

		(-913, 3856, -652),	//bowie room
		(-1022, 3486, -659) );

	level.THRESHOLD_PENTAGON_CRAWLERS_FILL_TANK_MIN = 5;
	level.THRESHOLD_PENTAGON_CRAWLERS_FILL_TANK_MAX = 8;
	level.THRESHOLD_PENTAGON_CRAWLERS_FILL_TANK_RANGE = 196;

	level.THRESHOLD_PENTAGON_GAS_LONG_TIMEOUT = 90;
	level.THRESHOLD_PENTAGON_GAS_SHORT_TIMEOUT = 30;

	//Cosmodrome
	level.VALUE_ZOMBIE_COSMODROME_MONKEY_DISABLE_PRO_PERK_TIME = 30;

	//Coast
	level.VALUE_COAST_DIRECTOR_BOSS_HEALTH_FACTOR = 0.5;
	level.VALUE_COAST_SCAVENGER_ROUND_SCALING_FACTOR = 0.5;

	//Temple
	level.THRESHOLD_ZOMBIE_TEMPLE_SPECIAL_ZOMBIE_ROUND = 5;
	level.THRESHOLD_ZOMBIE_TEMPLE_SPECIAL_ZOMBIE_RATE = 33;		//1-1000, 3.2% chance per zombie
	level.THRESHOLD_ZOMBIE_TEMPLE_SPECIAL_ZOMBIE_MAX = 5;


	if( level.no_bosses ) {
		level.THRESHOLD_ZOMBIE_TEMPLE_SPECIAL_ZOMBIE_ROUND = 100000; //No special zombies
	}

	//Moon
	level.ARRAY_MOON_VALID_NML_PERKS = array( level.SPD_PRK, level.JUG_PRK );


	//Map Specific values
	level.ARRAY_FREE_PERK_HINTS = [];

	switch (Tolower(GetDvar(#"mapname")))
{
    case "zombie_cod5_prototype":
        break;
    case "zombie_cod5_asylum":
		level.ARRAY_FREE_PERK_HINTS["zombie_cod5_asylum"] = "Shock, Drop, & Reroll!";
		level.pap_used = false;
        break;
    case "zombie_cod5_sumpf":
		level.VALUE_VULTURE_HUD_DIST_CUTOFF_VERY_FAR *= 1.5;
		level.ARRAY_FREE_PERK_HINTS["zombie_cod5_sumpf"] = "Swamp Lights!";
		level.ARRAY_SWAMPLIGHTS_POS = [];
		
		level.ARRAY_SWAMPLIGHTS_POS["comm_room"][0] = (7969, -455, -707);
		level.ARRAY_SWAMPLIGHTS_POS["comm_room"][1] = (8521, -230, -724);
		level.ARRAY_SWAMPLIGHTS_POS["comm_room"][2] = (9304, -768, -707);

		level.ARRAY_SWAMPLIGHTS_POS["storage"][0] = (11852, -851, -706);
		level.ARRAY_SWAMPLIGHTS_POS["storage"][1] = (10951, -279, -716);
		level.ARRAY_SWAMPLIGHTS_POS["storage"][2] = (11329, -174, -740);

		level.ARRAY_SWAMPLIGHTS_POS["doctor_hut"][0] = (11439, 1604, -743);
		level.ARRAY_SWAMPLIGHTS_POS["doctor_hut"][1] = (10788, 2145, -723);
		level.ARRAY_SWAMPLIGHTS_POS["doctor_hut"][2] = (10775, 3186, -696);

		level.ARRAY_SWAMPLIGHTS_POS["fishing_hut"][0] = (9188, 1490, -652);
		level.ARRAY_SWAMPLIGHTS_POS["fishing_hut"][1] = (8184, 2343, -677);
		level.ARRAY_SWAMPLIGHTS_POS["fishing_hut"][2] = (9026, 3068, -742);

		level.THRESHOLD_SHINO_SWAMPLIGHT_KILL_RADIUS = 64;
		
        break;
    case "zombie_cod5_factory":
		level.ARRAY_FREE_PERK_HINTS["zombie_cod5_factory"] = "Fluffy!";
		level.special_dog_spawn = false;
		level.last_special_dog_spawn = 0;
		level.special_dog_killstreak = 0;	//number of times in a row the special dog has been killed
        break;
    case "zombie_theater":
		//level.ARRAY_FREE_PERK_HINTS["zombie_theater"] = "The 6";
        break;
    case "zombie_pentagon":
		level.ARRAY_FREE_PERK_HINTS["zombie_pentagon"] = "The 6";
		//level._override_quad_explosion = maps\zombie_pentagon::pentagon_overide_quad_explosion; needs to be done from "pentagon" map files
		level.pentagon_gas_point = undefined;
        break;
    case "zombie_cosmodrome":
		level.ARRAY_FREE_PERK_HINTS["zombie_cosmodrome"] = "October 24, 1960";
        break;
    case "zombie_coast":
		level.ARRAY_FREE_PERK_HINTS["zombie_coast"] = "Regicide!";
        break;
    case "zombie_temple":
		level.ARRAY_FREE_PERK_HINTS["zombie_temple"] = "One Max Ammo and a Bullet";
        break;
    case "zombie_moon":
		level.VALUE_VULTURE_HUD_DIST_CUTOFF_VERY_FAR *= 1.5;
		//level.ARRAY_FREE_PERK_HINTS["zombie_moon"] = " 'Decompression in Tunnel 6' ";
        break;
}


}


reimagined_init_player()
{
	//init-player
	self.lives = 3;

	self.gross_points = 500;
	self.gross_possible_points = 500;
	self.spent_points = 0;
	self.kill_tracker = 0;

	self.hints_activated = [];
	self.perk_bumps_activated = [];
	self.new_perk_hint = false;
	
	//Default all are 0, 1 is pap, 2 is x2 pap, more...
	self.packapunch_weapons = [];
	self.weapon_taken_by_losing_additionalprimaryweapon = [];

	//Weapons
	self.weap_options = [];
	self.weap_options["uzi_upgraded_zm_x2"] = 0;

	self.bullet_hellfire = false;
	self.bullet_sheercold = false;
	self.bullet_electric = false;
	self.bullet_poison = false;
	self.bullet_isolate = false;


	//Bleedout
	self SetClientDvar( "player_lastStandBleedoutTime", level.VALUE_PLAYER_DOWNED_BLEEDOUT_TIME );

	
	//Perk Stuff
	self.purchased_perks = [];
	self.perk_slots = level.max_perks;
	self.perk_hud_queue_num = 0;
	self.perk_hud_queue_unlocks_num = 0;
	self.perk_hud_queue_locked = false;
	self.qrevive_return_perk = undefined;	//special quick revive bonus

	//Standard Perks
	self UnsetPerk("specialty_armorvest");
	self UnsetPerk("specialty_quickrevive");
	self UnsetPerk("specialty_fastreload");
	self UnsetPerk("specialty_rof");
	self UnsetPerk("specialty_endurance");
	self UnsetPerk("specialty_flakjacket");
	self UnsetPerk("specialty_deadshot");
	self UnsetPerk("specialty_additionalprimaryweapon");
	self UnsetPerk("specialty_extraammo");		//babyjugg
	self UnsetPerk("specialty_bulletdamage");		//cherry
	self UnsetPerk("specialty_altmelee");				//Vulture
	self UnsetPerk("specialty_bulletaccuracy");				//Widows wine

	self.PRO_PERKS = [];
	self.PRO_PERKS[ level.JUG_PRO ] = false;
	self.PRO_PERKS[ level.QRV_PRO ] = false;
	self.PRO_PERKS[ level.SPD_PRO ] = false;
	self.PRO_PERKS[ level.DBT_PRO ] = false;
	self.PRO_PERKS[ level.STM_PRO ] = false;
	self.PRO_PERKS[ level.PHD_PRO ] = false;
	self.PRO_PERKS[ level.DST_PRO ] = false;
	self.PRO_PERKS[ level.MUL_PRO ] = false;
	self.PRO_PERKS[ level.ECH_PRO ] = false;
	self.PRO_PERKS[ level.VLT_PRO ] = false;
	self.PRO_PERKS[ level.WWN_PRO ] = false;

	self.PERKS_DISABLED = [];
	self.PERKS_DISABLED[ level.JUG_PRK ] = false;
	self.PERKS_DISABLED[ level.QRV_PRK ] = false;
	self.PERKS_DISABLED[ level.SPD_PRK ] = false;
	self.PERKS_DISABLED[ level.DBT_PRK ] = false;
	self.PERKS_DISABLED[ level.STM_PRK ] = false;
	self.PERKS_DISABLED[ level.PHD_PRK ] = false;
	self.PERKS_DISABLED[ level.DST_PRK ] = false;
	self.PERKS_DISABLED[ level.MUL_PRK ] = false;
	self.PERKS_DISABLED[ level.ECH_PRK ] = false;
	self.PERKS_DISABLED[ level.VLT_PRK ] = false;
	self.PERKS_DISABLED[ level.WWN_PRK ] = false;

	self.PERKS_DISABLED[ level.JUG_PRO ] = false;
	self.PERKS_DISABLED[ level.QRV_PRO ] = false;
	self.PERKS_DISABLED[ level.SPD_PRO ] = false;
	self.PERKS_DISABLED[ level.DBT_PRO ] = false;
	self.PERKS_DISABLED[ level.STM_PRO ] = false;
	self.PERKS_DISABLED[ level.PHD_PRO ] = false;
	self.PERKS_DISABLED[ level.DST_PRO ] = false;
	self.PERKS_DISABLED[ level.MUL_PRO ] = false;
	self.PERKS_DISABLED[ level.ECH_PRO ] = false;
	self.PERKS_DISABLED[ level.VLT_PRO ] = false;
	self.PERKS_DISABLED[ level.WWN_PRO ] = false;

	self.PERKS_FLASHING = [];
	self.PERKS_FLASHING[ level.JUG_PRK ] = false;
	self.PERKS_FLASHING[ level.QRV_PRK ] = false;
	self.PERKS_FLASHING[ level.SPD_PRK ] = false;
	self.PERKS_FLASHING[ level.DBT_PRK ] = false;
	self.PERKS_FLASHING[ level.STM_PRK ] = false;
	self.PERKS_FLASHING[ level.PHD_PRK ] = false;
	self.PERKS_FLASHING[ level.DST_PRK ] = false;
	self.PERKS_FLASHING[ level.MUL_PRK ] = false;
	self.PERKS_FLASHING[ level.ECH_PRK ] = false;
	self.PERKS_FLASHING[ level.VLT_PRK ] = false;
	self.PERKS_FLASHING[ level.WWN_PRK ] = false;

	self.PERKS_FLASHING[ level.JUG_PRO ] = false;
	self.PERKS_FLASHING[ level.QRV_PRO ] = false;
	self.PERKS_FLASHING[ level.SPD_PRO ] = false;
	self.PERKS_FLASHING[ level.DBT_PRO ] = false;
	self.PERKS_FLASHING[ level.STM_PRO ] = false;
	self.PERKS_FLASHING[ level.PHD_PRO ] = false;
	self.PERKS_FLASHING[ level.DST_PRO ] = false;
	self.PERKS_FLASHING[ level.MUL_PRO ] = false;
	self.PERKS_FLASHING[ level.ECH_PRO ] = false;
	self.PERKS_FLASHING[ level.VLT_PRO ] = false;
	self.PERKS_FLASHING[ level.WWN_PRO ] = false;

	
	//Zombies
	self.previous_zomb_attacked_by=0;

	//Perk Values
	self.speedcola_swap_timeout = 10;	//Dont timeout any weaponswaps until SPD_PRO

	self.cherry_sequence = 0;
	self.cherry_defense = true;

	self.vulture_had_perk = false;
	self.vulture_vison_toggle = true;

	self.widows_cancel_warning = false;
	self.widows_heavy_warning_cooldown = false;

	//Weapon Variables
	self.knife_index = 0;
	
	//Perk player variables
	self.weakpoint_streak=0;
	self.dbtp_penetrated_zombs=0;
	self.shotgun_attrition=1;

	//Items and drops
	self.zombie_vars[ "zombie_powerup_zombie_blood_time" ] = 0;
	self.superpower_active = false;

	//Threads
	self thread wait_set_player_visionset();
	if( is_true( level.dev_only ) )
		self thread watch_player_dev_utility();


	//These need to be redone on respawn after death
	self thread watch_player_button_press();
	self thread watch_player_current_weapon();
	level.cowards_down_func = ::player_cowards_down;

	//iprintln(" User options: " + level.user_options + " Max Perks: " + level.max_perks);
}

//watch_utility
watch_player_dev_utility()
{
	//iprintln("Jump utility");

	level.do_kill_all = true;
	if(  IsDefined(level.rolling_kill_all_interval)  && level.do_kill_all )
	{
		self thread kill_all_utility_rolling( level.rolling_kill_all_interval );
	}
	else {
		level.rolling_kill_all_interval = 0;
	}

	rolling_print_utility = true;	
	if( rolling_print_utility )
	{
		self thread print_utility_rolling( 60 );
	}
	

	dev_only = true;
	while(1)
	{
		if( self buttonPressed("k")  && dev_only)
		{

			if( level.rolling_kill_all_interval > 0 )
			{
				if( level.do_kill_all ) {
				level.do_kill_all = false;
				iprintln("Kill all off");
				wait( 1 );
				} else {
					level.do_kill_all = true;
					self thread kill_all_utility_rolling( level.rolling_kill_all_interval );
				}
			}

			self kill_all_utility();

		}

		if( self buttonPressed("i")  && dev_only)
		{
			//get_vending_utility();
			//print_info_utility();
			//self maps\zombie_cod5_factory_teleporter::player_teleporting( 1, self, false );
		}

		if( self buttonPressed("q")  && dev_only)
		{
			//_zombiemode_reimagined_utility
			self.ignoreme = true;
			start_properk_placer();
		}


		wait(0.5);
	}
}

	print_info_utility()
	{	
		//Print all origins in: level.enemy_dog_spawns
		/*
		
		for(i=0;i<level.enemy_dog_spawns.size;i++)
		{
			iprintln( level.enemy_dog_spawns[i].origin );
		}
		*/

		iprintln("Dog Spawns: " + level.enemy_dog_locations.size);
		for(i=0;i<level.enemy_dog_locations.size;i++)
		{
			iprintln( level.enemy_dog_locations[i].origin );
		}

		iprintln("finished info: " );
	}

	get_vending_utility()
	{
		iprintln( "Deleting old perks " );
		vending_triggers = GetEntArray( "zombie_vending", "targetname" );

		level notify("juggernog_on");
		
		iprintln( "Size " + vending_triggers.size );
		for( j = 0; j < vending_triggers.size; j ++ )
		{
			machine_array = GetEntArray( vending_triggers[j].target, "targetname" );
			iprintln( "Perk exisits " + vending_triggers[j].target  );
			for( i = 0; i < machine_array.size; i ++ )
			{
				iprintln( "Machine exisits " + machine_array[i].targetname  );
				//machine_array[j] delete();
			}

			//vending_triggers[j] delete();
		}
	}

	/*

		Name: kill_all_utility_rolling

		Description:
			- Take 1 parameter "interval" and after each interval call kill_all_utility
			- While loop should take level.rolling_kill_all as true
			- If level.rolling_kill_all is false, break the loop

	*/

	kill_all_utility_rolling( interval )
	{
		while( level.do_kill_all )
		{
			self kill_all_utility();
			wait( interval );
		}
	}


	kill_all_utility()
	{
		//kill all utility
		//iprintln("kill all");
		useEffect = "";
		zombies = GetAiSpeciesArray( "axis", "all" );
		for(i=0;i<zombies.size;i++)
		{
			isBossZombie = is_boss_zombie( zombies[i].animname );
			isSpecialZombie = is_special_zombie( zombies[i].animname );
			isQuadZombie = zombies[i].animname == "quad_zombie";

			skipKill = false;
			if( isBossZombie ) {
				skipKill = true;
			}
			else if( isSpecialZombie ) {
				skipKill = true;
			}
			else if( isQuadZombie ) {
				skipKill = true;
			}

			if( !skipKill )
			{
				//Name: DoDamage( <health>, <source position>, <attacker>, <destructible_piece_index>, <means of death>, <hitloc> )

				switch( useEffect )
				{
					case "fire":
						zombies[i] thread maps\_zombiemode_weapon_effects::bonus_fire_damage( zombies[i], getPlayers()[0], 20, level.VALUE_HELLFIRE_TIME);
						break;
					case "freeze":
						zombies[i] thread maps\_zombiemode_weapon_effects::bonus_freeze_damage( zombies[i], getPlayers()[0], 200, 2 );
						wait( 0.1 );
						zombies[i] DoDamage( zombies[i].health + 666, zombies[i].origin, self );
						break;
					case "shock":
						zombies[i] thread maps\_zombiemode_weapon_effects::tesla_arc_damage( zombies[i], getPlayers()[0], 200 );
						break;
					default:
						zombies[i] DoDamage( zombies[i].health + 666, zombies[i].origin, self );
				}

				
			}
			
		}

		iprintln("Origin: " + self.origin);

	}

	/*

		Name: print_utility_rolling

		Description:
			- Take 1 parameter "interval" and after each interval print the message
			- While loop should take level.rolling_kill_all as true
			- If level.rolling_kill_all is false, break the loop
			

	*/

	print_utility_rolling( interval )
	{
		maxes = [];
		while( 1 )
		{

			/* 
				#1 COUNT ENTITIES 
			*/
			entity = Spawn( "script_model", (0, 0, 0) );
			iprintln( "Total entities: " + entity GetEntityNumber() );
			recent_string = "";
			size = maxes.size;
			maxes[size] = entity GetEntityNumber();
			for( i = 0; i < maxes.size; i++ ) {
				if( size - i < 0 )
					break;
				recent_string = recent_string + " " + maxes[size - i];
			}
			//iprintln( "History: " + recent_string );
			entity delete();

			wait( 2 );

			/* 
				#2 Refill stock ammo of primary weapon
				//RESTOCK, give_ammo, max_ammo give_max
			*/

			//level thread maps\_zombiemode_powerups::full_ammo_powerup_implementation( undefined, getPlayers()[0], -1 );

			wait( interval );
		}
	}


	

wait_set_player_visionset()
{
	flag_wait( "begin_spawning" );
	
	if(IsDefined(level.zombie_visionset)) 
	{
		//self VisionSetNaked( level.zombie_visionset, 0.5 );
	} else {
		//self VisionSetNaked( "zombie_neutral", 0.5 );
	}

	wait 5;

	//Overide give perks
	if( is_true(level.override_give_all_perks) ) {
		self give_pro_perks( true );
	}

	//self maps\zombie_cosmodrome::offhand_weapon_give_override( "zombie_black_hole_bomb" );

	//Print entitity number and random char
	//iprintln( "Entity Number: " + self.entity_num);

	if( is_true( level.dev_only ) )
	{
		//GIVE PERKS
		//self maps\_zombiemode_perks::returnPerk( level.JUG_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.DBT_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.STM_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.SPD_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.VLT_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.VLT_PRK );
		//self maps\_zombiemode_perks::returnPerk( level.PHD_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.DST_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.MUL_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.ECH_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.WWN_PRO );
		//self maps\_zombiemode_perks::returnPerk( level.QRV_PRO );

		//self maps\_zombiemode_perks::returnPerk( level.QRV_PRK );
		self maps\_zombiemode_perks::returnPerk( level.JUG_PRK );
		//self maps\_zombiemode_perks::returnPerk( level.SPD_PRK );
		//self maps\_zombiemode_perks::returnPerk( level.DBT_PRK );

		//give knife_ballistic_upgraded_zm_x2
	}
	//self.ignoreme = true;

	/*
	/give sabertooth_zm
	/give famas_upgraded_zm
	/give m60_upgraded_zm
	/give enfield_zm
	/give uzi_upgraded_zm
	/give ks23_zm
	/give psg1_zm
	/give knife_ballistic_upgraded_zm
	/give stoner_zm
	//DO G11

	*/
	
	//wait( 5 );
	

	/*
	stored_weapon_info = GetArrayKeys( level.zombie_weapons );
	iprintln( "CALLING THE WEAPONS " );
	iprintln( "Stored Weapons: " + stored_weapon_info.size );
	iprintln( "ak47: " + level.zombie_weapons["ak47_zm"].weapon_name );
	iprintln( "ak47: " + level.zombie_weapons["ak47_zm"].upgrade_name );
	iprintln( "ak47: " + level.zombie_include_weapons[ "ak47_zm" ] );

	iprintln( "asp: " + level.zombie_weapons["asp_zm"].weapon_name );
	iprintln( "asp: " + level.zombie_weapons["asp_zm"].upgrade_name );
	iprintln( "asp: " + level.zombie_include_weapons[ "asp_zm" ] );
	*/

	/*
	for( i = 0; i < stored_weapon_info.size; i++ )
	{
		iprintln( "Weapon: " + level.zombie_weapons[stored_weapon_info[i]].weapon_name );
		iprintln( "Upgrade: " + level.zombie_weapons[stored_weapon_info[i]].upgrade_name );
		iprintln( "Weapon: " + level.zombie_include_weapons[ stored_weapon_info[i] ] );
	}
	*/
			

	/*
	for( i = 0; i < level.ARRAY_SHINO_PERKS_AVAILIBLE.size; i++ ) {
		iprintln( "Perk: " + level.ARRAY_SHINO_PERKS_AVAILIBLE[ i ] );
	}
	*/

	//setup a while loop to wait for zombies to spawn
	//get the ai species array and check size to see if we can transform zombie to engineer
	//if we can, then we can spawn the boss
	//if we can't, then we wait for the next round to spawn the boss

	zombies = [];
	while(1)
	{
		wait(1);
		//iprintln( "Waiting for zombies to spawn" );
		zombies = GetAiSpeciesArray( "axis", "zombie" );
		if( zombies.size > 0 )
			break;
		
	}
	
	spawned_boss = true && is_true( level.dev_only );
	if( spawned_boss )
	{
		//iprintln( "Spawning boss zombie" );
		trigger_name = "trigger_teleport_pad_0";
		core = getent( trigger_name, "targetname" );
		pad = getent( core.target, "targetname" );
		location = pad.origin - ( 0, 0, 40);
		//location = (-1567,1341,174);	//2
		//location = (-962,-619,75); 		//0
		//location += ( 0, 0, 10);
		zombie = zombies[0];
		zombie thread maps\_zombiemode_ai_boss::zmb_engineer( location );
		
	}

}

watch_player_button_press()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_game");

	//Must wait to start watching for button presses
	if(!flag("round_restarting"))
	{
		wait_network_frame();
	}
	
	wait(2);

	//Pre trigger hack
	self handle_swap_melee();
	wait( 0.2 );
	self handle_swap_melee();
	self SwitchToWeapon( self GetWeaponsListPrimaries()[0] );

	while(1)
	{
		/* MELEE SWAP */
		if( self is_action_slot_pressed() )
		{
			wep = self GetCurrentWeapon();
			validWep = ( wep == "vorkuta_knife_sp" || isSubStr( wep, "combat_" ) );
			while( validWep )
			{
				wait 0.1;
				wep = self GetCurrentWeapon();
				validWep = ( wep == "vorkuta_knife_sp" || isSubStr( wep, "combat_" ) );

				if( self is_action_slot_pressed() )
				{
					self handle_swap_melee();
					wait 0.5;
					break;
				}
				
			}
			
		}


		/* APOCALYPSE SCOREBOARD */
		if( level.apocalypse )
		{
			isHost = (self GetEntityNumber() == 0);
			
			if(  self buttonPressed( "TAB" ) )
			{
				if( self UseButtonPressed() || isHost )
				{
					self player_handle_scoreboard("TAB");
					wait(0.1);
				}
			}

			if( self buttonPressed( "BUTTON_BACK" ) )
			{
				if( self UseButtonPressed() || isHost )
				{
					self player_handle_scoreboard("BUTTON_BACK");
					wait(0.1);
				}
			}
		}
		
		wait 0.1;
		//wait(1);
	}
}

	is_action_slot_pressed()
	{

		//if( self ActionSlotTwoButtonPressed() )
			//return true;

		if( self AdsButtonPressed() )
			return true;

		
		//PC
		//if( self buttonPressed( "7" ))
			//return true;

		//XBOX
		//if( self buttonPressed( "DPAD_DOWN" ))
			//return true;

		
		return false;
	}

		
		
	handle_swap_melee()
	{
		
		primary_weapon = self GetWeaponsListPrimaries()[0];
		if( isDefined( primary_weapon ) )
			self SwitchToWeapon( primary_weapon );

		old_knife = self.current_melee_weapon;
		new_knife = self.offhand_melee_weapon;

		if( new_knife == "rebirth_hands_sp" )
		{
			new_equipment = "combat_" + old_knife;
			old_equipment = "vorkuta_knife_sp";
		}
		else
		{
			//Take knife equipment, now your primary
			new_equipment = "vorkuta_knife_sp";
			old_equipment = "combat_" + new_knife;
		
		}

		//iprintln( "Old Knife: " + old_knife + " New Knife: " + new_knife );
		self TakeWeapon( old_knife );
		self GiveWeapon( new_knife, self.knife_index );

		self TakeWeapon( old_equipment );
		self GiveWeapon( new_equipment, self.knife_index );

		self SetActionSlot(2, "weapon", new_equipment );
		self SetActionSlot(4, "weapon", old_equipment );
		self set_player_melee_weapon( new_knife );

		self.current_melee_weapon = new_knife;
		self.offhand_melee_weapon = old_knife;

		if( isDefined( primary_weapon ) )
			self SwitchToWeapon( new_equipment );

	}

/* Handle particular button press */
	player_handle_scoreboard( button )
	{
		self thread player_apocalypse_stats( "apocalypse_stats_end" );
		while( self buttonPressed( button ) )
		{
			wait 0.05;
		}

		self notify( "apocalypse_stats_end" );
	}


/*
	Watch Changes in player's current weapon
	- Certain weapon effects are triggered by the current weapon
	- Player weapon name dyanmically set in hud due to doube PaP complexities
*/
watch_player_current_weapon()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_game");

	weapName = self GetCurrentWeapon();
	while(1)
	{
		/* Update Weapon Name in UI */

		self waittill("weapon_change");
		weapName = self GetCurrentWeapon();

		ui_weapon_name = self maps\_zombiemode_reimagined_utility::getWeaponUiName( weapName );
		self SetClientDvar( "ui_playerWeaponName", ui_weapon_name );
	

	}
}


//self thread player_cowards_down();


//*
player_cowards_down()
{
	if( level.players_size == 1 )
	{
		return;
	}

	self endon("end_game");
	self endon("death");
	self endon("fake_death");


	//Title
    title = NewClientHudElem( self );
	title.alignX = "center";
	title.alignY = "middle";
	title.horzAlign = "user_center";
	title.vertAlign = "user_bottom";
	title.foreground = true;
	title.font = "objective";
	title.fontScale = 1.6;
	title.alpha = 0;
	title.color = ( 1.0, 1.0, 1.0 );

    title.y -= 100;

	//Text
	title SetText( &"REIMAGINED_COWARDS_DOWN" );

	title FadeOverTime( 1 );
	title.alpha = 1;

	self.cowards_down = false;
	self watch_player_cowards_down();
	
	title FadeOverTime( 2 );
	title.alpha = 0;
	wait(1);

	self.cowards_down = false;
	title Destroy();
}

	watch_player_cowards_down()
	{
		self endon("end_game");
		self endon("bled_out");
		self endon("player_revived");
		self endon("death");
		self endon("fake_death");

		//Wait and check every 0.5 second for player holding Activate
		while(1)
		{
			wait(0.5);
			if(self UseButtonPressed())
			{
				self.cowards_down = true;
				break;
			}
		}

	}

//*/


//Reimagined-Expanded -- check of obj is in range
checkDist( a, b, distance)
{
	vars_defined = isDefined(a) && isDefined(b) && isDefined(distance);
	if( !vars_defined )
	{
		//iprintln("checkDist for distance: " + distance + " is undefined" );
		return false;
	}
		

	if( DistanceSquared( a, b ) < distance * distance )
		return true;
	else
		return false;
}

getZombiesInRange( range, type )
{
	if(!isDefined(type))
		type = "all";
	//type = "all", "zombie", "zombie_dog"
	zombies = GetAiSpeciesArray( "axis", type );
	zombies_in_range = [];
	for(i=0;i<zombies.size;i++)
	{
		if( checkDist( self.origin, zombies[i].origin, range ) )
			zombies_in_range[zombies_in_range.size] = zombies[i];
	}
	return zombies_in_range;
}


setZombiePlayerCollisionOff( player, totalTime, dist, endon_str )
{

	condition = true;
	time = 0;
	while(time < totalTime)
	{
		while( condition ) 
		{
			self SetPlayerCollision( 0 );
			condition = isDefined( self ) && ( IsAlive( self ) ) && checkDist( player.origin, self.origin, dist ) ;
			time += 0.1;
			wait( 0.1 );
		}
		time += 0.1;
		wait( 0.1 );
		condition = isDefined( self ) && ( IsAlive( self ) ) && checkDist( player.origin, self.origin, dist ) ;
	}

	self SetPlayerCollision( 1 );
}


//Reimagined-Expanded Weapon Effect!

//Eletric effect triggers on random bullets E(x) = 5 / clip
watch_player_electric()
{
	self.bullet_electric = false;

	while(1)
	{
		og_weapon = self getcurrentweapon();
		weapon = self get_upgraded_weapon_string( og_weapon );
		if( is_in_array( level.ARRAY_ELECTRIC_WEAPONS, weapon) )
		{
			//iprintln( "Current weap: " + og_weapon  );
			self watch_electric_trigger( og_weapon );
		}
		resp = self waittill_any_return( "weapon_switch_complete", "reload" );
		self.bullet_electric = false;
		wait(0.1);
	}
}

	watch_electric_trigger( weapon )
	{
		self endon("weapon_switch");
		self endon("reload_start");

		clip_size = WeaponClipSize( weapon );
		total_eletric_bullets = level.THRESHOLD_ELECTRIC_BULLETS;
		if( self hasProPerk(level.DBT_PRO) )
			total_eletric_bullets *= 2;

		//Get 4 random numbers between 0 and clip_size
		random_numbers = [];
		for(i=0;i<total_eletric_bullets;i++) {
			random_numbers[i] = randomInt( clip_size );
		}

		while(1)
		{
			self.bullet_electric = false;
			if( is_in_array( random_numbers, (self GetWeaponAmmoClip( weapon )) ) ) {
				self.bullet_electric = true;
			}
				
			//iprintln( "Current ammo: " + self GetWeaponAmmoClip( weapon ) );
			wait(0.5);
		}

		
	}

//Hellfire triggers after 2 seconds of holding down fire button
watch_player_hellfire()
{
	self.bullet_hellfire = false;

	while(1)
	{
		weapon = self getcurrentweapon();
		weapon = self get_upgraded_weapon_string( weapon );
		if( is_in_array( level.ARRAY_HELLFIRE_WEAPONS , weapon) )
		{
			self watch_hellfire_trigger();
			self.bullet_hellfire = false;
		}

		resp = self waittill_any_return( "weapon_switch_complete", "reload" );
		self.bullet_hellfire = false;
		wait(0.1);
	}
}

	watch_hellfire_trigger()
	{
		iprintln("watch_hellfire_trigger");
		self endon("weapon_switch");
		self endon("reload_start");

	
		if( isDefined(self.buttonpressed_attack) )
			self.buttonpressed_attack = false;

		//Reduce level.THRESHOLD_HELLFIRE_TIME by half if player has pro DBT
		total_hellfire_time = level.THRESHOLD_HELLFIRE_TIME;
		if( self hasProPerk(level.DBT_PRO) )
			total_hellfire_time = total_hellfire_time - 0.6;

		while(1)
		{
			time = 0;
			while( self AttackButtonPressed() )
			{
				if( self.is_reloading )
					break;
				
				if( time >= total_hellfire_time )
				{
					self.bullet_hellfire = true;
				}
				time += 0.05;	
				wait(0.05);

			}
			self.bullet_hellfire = false;
			wait(0.1);
		}

	}

//Reimagined-Expanded Weapon Effect!
watch_player_sheercold()
{
	self.bullet_sheercold = false;
	while(1)
	{
		weapon = self getcurrentweapon();
		weapon = self get_upgraded_weapon_string( weapon );
		if( is_in_array(level.ARRAY_SHEERCOLD_WEAPONS, weapon) )
		{
			self watch_sheercold_trigger();
			self waittill("weapon_switch_complete");
			self.bullet_sheercold = false;
		}
		wait(0.1);
	}
}


	watch_sheercold_trigger()
	{
		self endon("weapon_switch");

		//Same thing as above with level.sheercold_active_time
		total_sheercold_time = level.THRESHOLD_SHEERCOLD_ACTIVE_TIME;
		if( self hasProPerk(level.DBT_PRO) )
			total_sheercold_time *= 2;

		while(1)
		{
			zombies = getZombiesInRange( level.THRESHOLD_SHEERCOLD_DIST );
			//If one of these zombies is !self.marked_for_freeze, then self.bullet_sheercold = true
			for(i=0;i<zombies.size;i++)
			{
				if( !zombies[i].marked_for_freeze ) {
					self.bullet_sheercold = true;
					break;
				}
			}
			if( self.bullet_sheercold )
				wait( level.THRESHOLD_SHEERCOLD_ACTIVE_TIME );
				
			wait(0.1);
			self.bullet_sheercold=false;
		}

		
	}


//Do more damage with shotguns the more rounds you have one

watch_player_shotgun_attrition()
{
	level waittill( "begin_spawning" );

	while(1)
	{
		//Get all players weapons and check if they are a shotgun
		player_weapons = self GetWeaponsList();
		hasShotgun = false;
		for(i=0;i<player_weapons.size;i++)
		{
			weapon = player_weapons[i];
			if( is_in_array(level.ARRAY_VALID_SHOTGUNS, weapon) && (self.shotgun_attrition < level.VALUE_MAX_SHOTGUN_ATTRITION) ) {
				self.shotgun_attrition *= (1+level.VALUE_SHOTGUN_DMG_ATTRITION);
				hasShotgun = true;
				break;
			} 
		}

		if( !hasShotgun )
			self.shotgun_attrition = 1;
		
		//wait til round over
		level waittill( "start_of_round" );

		//If player using PaP, then wait 5 seconds
		while( flag( "pack_machine_in_use" ) ) {
			wait(1);
		}
	}
}


/*

	Watch player weapon for special bonuses
	- famas_x2 - regenerates ammo over time
	- Uzizi_x2 - has elemental effects, no action here
	- spas_x2  - each time player reloads, they get a new elemental bonus
	- spectre_x2 - When less than 6 zombies around, player gets x2 damage boost, less than 3, x4
	- mk_aug - always electric
	- asp_x2 - triggers nuke
	- dragunov_x2 - hellfire on hit
	- ak47 ft - hellfire on hit
	- sabertooth - george runs away from player
*/

watch_player_weapon_special_bonuses()
{

	while(1)
	{
		//Get all players weapons and check if they are a shotgun
		weapon = self GetCurrentWeapon();
		weapon = self get_upgraded_weapon_string( weapon );
		
		//iprintln( "Do Hint! " + weapon );
		self thread generate_perk_hint( weapon );

		switch( weapon )
		{
			
			//Ballistic knife and upgraded version
			case "knife_ballistic_upgraded_zm":
			case "knife_ballistic_zm":
				//self watch_ballistic_knife(); not needed
				break;

			case "famas_upgraded_zm_x2":
				self watch_famas_x2();
				break;
			case "uzi_upgraded_zm_x2":
				//Nothing
				break;
			case "spas_upgraded_zm_x2":
				self watch_spas_x2();
				self.bullet_hellfire = false;
				self.bullet_sheercold = false;
				self.bullet_electric = false;
				break;
			case "spectre_upgraded_zm_x2":
				self watch_spectre_x2();
				self.bullet_isolate = false;
				break;

			case "mk_aug_upgraded_zm":
				self watch_mk_aug();
				self.bullet_electric = false;
				break;

			case "asp_upgraded_zm_x2":
				self watch_asp_x2();
				break;

			case "dragunov_upgraded_zm_x2":
				iprintln( "Watch hellfire: " + weapon );
				self watch_dragunov_ak47_x2();
				self.bullet_hellfire = false;
				break;

			case "sabertooth_zm":
			case "sabertooth_upgraded_zm":
			case "sabertooth_upgraded_zm_x2":
			//if the map is zombie coast
			 	self watch_sabertooth();
				break;
		}

		if( is_in_array( level.ARRAY_VALID_SNIPERS, weapon) )
			self watch_global_sniper_damage();
		
		wait(0.5);
	}

}

		/*
			method: watch_ballistic_knife

			Descr: Check index of players weapon if it matches self.knife_index,
			if it doesnt, give the player the new weapon
		*/
		watch_ballistic_knife()
		{
			self endon("weapon_switch");
			
			//Check if player has ballistic knife
			weapon = self GetCurrentWeapon();
			//index = self GetModelIndex( weapon );
			//isSubStr( weapon, "knife_ballistic" )
			if( isSubStr( weapon, "knife_ballistic" ) )
			{
				//self TakeWeapon( weapon );
				//self GiveWeapon( weapon, self.knife_index );
			}
			//wait(10);
		
		}

		/*
			- Whenever a sniper is fired, 10 dmg is done to all zombies on the map
		*/
		watch_global_sniper_damage()
		{
			self endon("weapon_switch");

			wep = self GetCurrentWeapon();
			while(1)
			{
				self waittill("weapon_fired");
				zombies = getZombiesInRange( 99999 );
				for(i=0;i<zombies.size;i++) 
				{
					if( is_boss_zombie( zombies[i].animname ) )
						continue;

					zombies[i] DoDamage( 10, zombies[i].origin );
				}
			}
		}


		/*
			- While stock ammo is less than max ammo, regenerate ammo each 0.25 seconds
			- base rate is 25% chance of 1 ammo each tick
			- if player has DBT_PRO, add 10% chance
			- if player is below 90 stock ammo, add 10% chance
		*/
		watch_famas_x2()
		{
			self endon("weapon_switch");
			self endon("reload_start");
			wep = "famas_upgraded_zm";	//x2 weapon file doesnt actually exist

			stock = self GetWeaponAmmoStock( wep );
			while( stock < WeaponMaxAmmo( wep ) )
			{

				baseRate = 10;

				if( self hasProPerk(level.DBT_PRO) )
					baseRate -= 2;

				if( stock < 181 )
					baseRate -= 2;

				if( stock < 91 )
					baseRate -= 3;

				stock = self GetWeaponAmmoStock( wep );
				if( randomInt( baseRate ) == 0 )
					self SetWeaponAmmoStock( wep, stock+1);

				wait(0.1);
			}
			
			

		}

		/*
			- Each time player reloads, they get a new elemental bonus
			- 10% chance of hellfire, 10% chance of sheercold, 10% chance of electric
			- If player has DBT_PRO, add 10% chance
		*/
		watch_spas_x2()
		{
			self endon("weapon_switch");

			wep = "spas_upgraded_zm";	//x2 weapon file doesnt actually exist
			maxClip = WeaponClipSize( wep );

			threshold = 6;
			if( self hasProPerk(level.DBT_PRO) )
				threshold += 2;

		
			while(1)
			{
				
				self.bullet_hellfire = false;
				self.bullet_sheercold = false;
				self.bullet_electric = false;

				//Wait until half clip is left to give bonus ammo type
				currentClip = self GetWeaponAmmoClip( wep );
				if(  threshold < currentClip ) {
					wait(0.1);
					continue;
				}
				
				typesArray = array( "hellfire", "electric", "sheercold", "none" );
				typeString = typesArray[ randomInt( typesArray.size ) ];
				switch( typeString )
				{
					case "hellfire":
						self.bullet_hellfire = true;
						break;
					case "sheercold":
						self.bullet_sheercold = true;
						break;
					case "electric":
						self.bullet_electric = true;
						break;
				}

				iprintln("New Elemental Bonus: " + typeString);

				self waittill("reload"); //end of reload
				
			}

		}
	

		/*
			- Aug Masterkey is always electric
		*/
		watch_mk_aug()
		{
			self endon("weapon_switch_complete");
			//Only on souble upgraded aug
			baseAug = self get_upgraded_weapon_string( "aug_acog_mk_upgraded_zm" );
			if( !IsSubStr( baseAug, "_x2" ) ) {
				//mk_aug_upgraded_zm
				self waittill("weapon_switch");
				return;
			}
				
			while(1)
			{
				self.bullet_electric = true;
				wait(0.1);
			}
		}


		/*
			- Wraith up to 4x damage bonus on isolated zombies

		*/
		watch_spectre_x2()
		{
			self endon("weapon_switch");

			wep = "spectre_upgraded_zm_x2";	//x2 weapon file doesnt actually exist
			while(1)
			{

				self.bullet_hellfire = false;
				self.bullet_sheercold = false;
				self.bullet_electric = false;

				//Get all zombies in range
				zombies = getZombiesInRange( 384 );
				if( zombies.size < 3 )
					self.bullet_isolate = true;
				else
					self.bullet_isolate = false;

					wait(0.1);
			}
		}


		/*
			- ASP triggers nuke thread
		*/
		watch_asp_x2()
		{
			self endon("weapon_switch");

			wep = "asp_upgraded_zm_x2";	//x2 weapon file doesnt actually exist
			stock = self GetWeaponAmmoStock( wep );
			while( stock > 0 )
			{
				stock = self GetWeaponAmmoStock( wep );
				if( self AttackButtonPressed() )
				{
					drop_item = SpawnStruct();
					drop_item.origin = self GetWeaponMuzzlePoint();
					drop_item.fx = "misc/fx_zombie_mini_nuke_hotness";
					level thread maps\_zombiemode_powerups::nuke_powerup( drop_item, self, false );
					self SetWeaponAmmoStock( wep, stock-1);
					wait(4);
				}
				wait(0.1);
			}
			
		}

		/*
			- Dragunov gets permanent hellfire
			- AK47 underbarrel gets permanent hellfire
		*/
		watch_dragunov_ak47_x2()
		{
			self endon("weapon_switch_complete");

			
			while(1)
			{
				self.bullet_hellfire = true;
				wait(0.1);
			}
		}


		/*
			- Sabertooth makes George run away from player
		*/
		watch_sabertooth()
		{
			self endon("weapon_switch");
			wep = "sabertooth_upgraded_zm";	//x2 weapon file doesnt actually exist
			
			/* Special Stuff for George */
			
			if( level.mapname != "zombie_coast" || !isDefined( level.director_zombie ) )
				return;

			//Check director failsages
			zomb = level.director_zombie;

			//iprintln( "3: " );
			wait(1);
			while(1)
			{
				self waittill("weapon_fired");
				wait(0.1);

				if( !IsDefined( zomb.pointIndexToRunTo ) )
				{	
					if( is_true( zomb.performing_activation ) || is_true( zomb.finish_anim ) || is_true( zomb.on_break ) ||
						is_true( zomb.is_traversing ) || is_true( zomb.nuke_react ) || is_true( zomb.leaving_level ) ||
						is_true( zomb.entering_level ) || is_true( zomb.defeated ) || is_true( zomb.is_sliding ) ||
						is_true( zomb.water_scream )  || is_true( zomb.ground_hit ) || is_true( zomb.solo_last_stand ) ||
						is_true( zomb.is_angry ) || is_true( zomb.is_activated ) 
					)
					continue;
				}

			
				if( checkDist( self.origin, zomb.origin, 512 ) )
				{

					iprintln( "Triggered" );

					if( checkDist( self.origin, zomb.origin, 128 ) )
					{
						zomb.pointIndexToRunTo = undefined;
						zomb notify( "director_aggro" );
						continue;
					}
					

					zomb maps\_zombiemode_ai_director::director_run_to_exit( self );
					zomb.pointIndexToRunTo = undefined;
					//wait(1);
				}
					
			}
			//END WHILE

		}





watch_player_perkslots()
{
	while(1)
	{
		level waittill( "start_of_round" );

		self waittill( "player_downed");

		self.perk_slots-- ;

		if( self.perk_slots < level.max_perks )
			self.perk_slots = level.max_perks;
		
	}

}


/*
	"weapon" is "base weapon" that is going to be upgraded by PaP

	1. Player given standard _zm weapon, _zm, _upgraded and x2 set to 0
	2. Player given _upgraded weapon, _upgraded and x2 set to 1
	3. Player given _x2 weapon, _upgraded and x2 set to 2

	4. Player replaces _upgraded weapon with other _zm box weapon


*/
handle_player_packapunch(weapon, didUpgrade)
{
	//iprintln("handle_player_packapunch: " + weapon + " ");
	
	if( !isDefined(weapon) )
		return;

	if( !isDefined(didUpgrade) )
		didUpgrade = false;

	state = 0;
	upgraded_weapon_x2 = "";
	upgraded_weapon = "";
	base_weapon = "";

	isWawWeapon = IsSubStr( weapon, "zombie_" );
	isUpgraded = IsSubStr( weapon, "_upgraded" );
	isDoubleUpgraded = IsSubStr( weapon, "_x2" );

	upgradedWeaponString = "";

	
	if( isWawWeapon )
	{
		if( isUpgraded )
			upgraded_weapon = weapon;
		else
			upgraded_weapon = level.zombie_weapons[weapon].upgrade_name;
	}
	else
	{
		if( isDoubleUpgraded )
			upgraded_weapon = GetSubStr( weapon, 0, weapon.size - "_x2".size );
		else if( isUpgraded )
			upgraded_weapon = weapon;
		else
			upgraded_weapon = level.zombie_weapons[weapon].upgrade_name;
	}


	if( !didUpgrade )
	{
		/*****
		Player just given weapon
		*****/
		if( isDoubleUpgraded )
			state = 2;
		else if( isUpgraded )
			state = 1;
		else
			state = 0;

	}
	else
	{
		/*****
		Player just upgraded weapon
		*****/
		if( isDoubleUpgraded )
			state = 2;
		else if( isUpgraded && didUpgrade )
			state = 2;
		else if( isUpgraded )
			state = self.packapunch_weapons[ upgraded_weapon ] + 1;
		else
			state = 1;
	}

	if( is_in_array( level.ARRAY_EXPLOSIVE_WEAPONS, weapon) )
	{
		//ASP is allowed to be upgraded again
		if( weapon == "asp_upgraded_zm" && didUpgrade )
			state = 2;
		else
			state = 1;
		
	}
	
	self.packapunch_weapons[upgraded_weapon] = state;
	self.packapunch_weapons[upgraded_weapon + "_x2"] = state;
	
	//iprintln("handle_player_packapunch: " + weapon + " " + upgraded_weapon + " " + state);

}

	
//##############################################

zombiemode_melee_miss()
{
	if( isDefined( self.enemy.curr_pay_turret ) )
	{
		self.enemy doDamage( GetDvarInt( #"ai_meleeDamage" ), self.origin, self, undefined, "melee", "none" );
	}
}

/*------------------------------------
chrisp - adding vo to track players ammo
------------------------------------*/
track_players_ammo_count()
{
	self endon("disconnect");
	self endon("death");

	wait(5);

	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
	        if(!IsDefined (players[i].player_ammo_low))
	        {
		        players[i].player_ammo_low = 0;
	        }
	        if(!IsDefined(players[i].player_ammo_out))
	        {
		        players[i].player_ammo_out = 0;
	        }

			weap = players[i] getcurrentweapon();
			//iprintln("current weapon: " + weap);
			//iprintlnbold(weap);
		
			//Excludes all Perk based 'weapons' so that you don't get low ammo spam.
			if( !isDefined(weap) ||
					weap == "none" ||
					isSubStr( weap, "zombie_perk_bottle" ) ||
					is_placeable_mine( weap ) ||
					is_equipment( weap ) ||
					weap == "syrette_sp" ||
					weap == "zombie_knuckle_crack" ||
					weap == "zombie_bowie_flourish" ||
					weap == "zombie_sickle_flourish" ||
					issubstr( weap, "knife_ballistic_" ) ||
					( GetSubStr( weap, 0, 3) == "gl_" ) ||
					weap == "humangun_zm" ||
					weap == "humangun_upgraded_zm" ||
					weap == "equip_gasmask_zm" ||
					weap == "lower_equip_gasmask_zm" ||
					weap == "combat_knife_zm" ||
					weap == "rebirth_hands_sp" ||
					weap == "combat_bowie_knife_zm" ||
					weap == "combat_sickle_knife_zm" ||
					weap == "meat_zm" ||
					weap == "falling_hands_zm" )
			{
				continue;
			}
			//iprintln("checking ammo for " + weap);
			if ( players[i] GetAmmoCount( weap ) > 5)
			{
				continue;
			}
			if ( players[i] maps\_laststand::player_is_in_laststand() )
			{
				continue;
			}
			else if (players[i] GetAmmoCount( weap ) < 5 && players[i] GetAmmoCount( weap ) > 0)
			{
				if (players[i].player_ammo_low != 1 )
				{
					players[i].player_ammo_low = 1;
					players[i] maps\_zombiemode_audio::create_and_play_dialog( "general", "ammo_low" );
					players[i] thread ammo_dialog_timer();
				}

			}
			else if (players[i] GetAmmoCount( weap ) == 0)
			{
				if(!isDefined(weap) || weap == "none")
				{
					continue;
				}
				wait(2);

				if( !isdefined( players[i] ) )
				{
					return;
				}

				if( players[i] GetAmmoCount( weap ) != 0 )
				{
					continue;
				}

				if( players[i].player_ammo_out != 1 )
				{
				    players[i].player_ammo_out = 1;
				    players[i] maps\_zombiemode_audio::create_and_play_dialog( "general", "ammo_out" );
				    players[i] thread ammoout_dialog_timer();
				}
			}
			else
			{
				continue;
			}
		}
		wait(.5);
	}
}
ammo_dialog_timer()
{
	self endon("disconnect");
	self endon("death");

	wait(20);
	self.player_ammo_low = 0;
}
ammoout_dialog_timer()
{
	self endon("disconnect");
	self endon("death");

    wait(20);
	self.player_ammo_out = 0;
}

/*------------------------------------
audio plays when more than 1 player connects
------------------------------------*/
spawn_vo()
{
	//not sure if we need this
	wait(1);

	players = getplayers();

	//just pick a random player for now and play some vo
	if(players.size > 1)
	{
		player = random(players);
		index = maps\_zombiemode_weapons::get_player_index(player);
		player thread spawn_vo_player(index,players.size);
	}

}

spawn_vo_player(index,num)
{
	sound = "plr_" + index + "_vox_" + num +"play";
	self playsound(sound, "sound_done");
	self waittill("sound_done");
}

testing_spawner_bug()
{
	wait( 0.1 );
	level.round_number = 7;

	spawners = [];
	spawners[0] = GetEnt( "testy", "targetname" );
	while( 1 )
	{
		wait( 1 );
		level.enemy_spawns = spawners;
	}
}

precache_shaders()
{
 	PrecacheShader( "hud_chalk_1" );
 	PrecacheShader( "hud_chalk_2" );
 	PrecacheShader( "hud_chalk_3" );
 	PrecacheShader( "hud_chalk_4" );
 	PrecacheShader( "hud_chalk_5" );

	PrecacheShader( "zom_icon_community_pot" );
	PrecacheShader( "zom_icon_community_pot_strip" );

	precacheshader("zom_icon_player_life");

	PrecacheShader("waypoint_second_chance");

	precacheShader( "specialty_bo4hitmarker_white" );
	precacheShader( "specialty_bo4hitmarker_red__" );

}

precache_models()
{
	precachemodel( "char_ger_zombieeye" );
	precachemodel( "p_zom_win_bars_01_vert04_bend_180" );
	precachemodel( "p_zom_win_bars_01_vert01_bend_180" );
	precachemodel( "p_zom_win_bars_01_vert04_bend" );
	precachemodel( "p_zom_win_bars_01_vert01_bend" );
	PreCacheModel( "p_zom_win_cell_bars_01_vert04_bent" );
	precachemodel( "p_zom_win_cell_bars_01_vert01_bent" );
	PrecacheModel( "tag_origin" );

	// Counter models
	PrecacheModel( "p_zom_counter_0" );
	PrecacheModel( "p_zom_counter_1" );
	PrecacheModel( "p_zom_counter_2" );
	PrecacheModel( "p_zom_counter_3" );
	PrecacheModel( "p_zom_counter_4" );
	PrecacheModel( "p_zom_counter_5" );
	PrecacheModel( "p_zom_counter_6" );
	PrecacheModel( "p_zom_counter_7" );
	PrecacheModel( "p_zom_counter_8" );
	PrecacheModel( "p_zom_counter_9" );

	precachemodel( "char_ger_zombeng_body1_1" );

	// Player Tombstone
	precachemodel("zombie_revive");

	PrecacheModel( "zombie_z_money_icon" );
}

init_shellshocks()
{
	level.player_killed_shellshock = "zombie_death";
	PrecacheShellshock( "explosion" );
	PrecacheShellshock( level.player_killed_shellshock );
}

init_strings()
{
	PrecacheString( &"ZOMBIE_WEAPONCOSTAMMO" );
	PrecacheString( &"ZOMBIE_ROUND" );
	PrecacheString( &"SCRIPT_PLUS" );
	PrecacheString( &"ZOMBIE_GAME_OVER" );
	PrecacheString( &"ZOMBIE_SURVIVED_ROUND" );
	PrecacheString( &"ZOMBIE_SURVIVED_ROUNDS" );
	PrecacheString( &"ZOMBIE_SURVIVED_NOMANS" );
	PrecacheString( &"ZOMBIE_EXTRA_LIFE" );

	PrecacheString( &"REIMAGINED_WEAPONCOSTAMMO" );
	PrecacheString( &"REIMAGINED_WEAPONCOSTAMMO_UPGRADE" );
	PrecacheString( &"REIMAGINED_WEAPONCOSTAMMO_UPGRADE_HACKED" );
	PrecacheString( &"REIMAGINED_MYSTERY_BOX" );

	PrecacheString( &"REIMAGINED_PERK_BABYJUGG" );

	switch(ToLower(GetDvar(#"mapname")))
	{
		case "zombie_theater":
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_FOYER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_FOYER2_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_CREMATORIUM_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_ALLEYWAY_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_WEST_BALCONY_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_STAGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_THEATER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_DRESSING_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_DINING_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_THEATER_VIP_ZONE");
			break;
		case "zombie_pentagon":
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_CONFERENCE_LEVEL1");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_HALLWAY_LEVEL1");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_WAR_ROOM_ZONE_TOP");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_WAR_ROOM_ZONE_NORTH");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_WAR_ROOM_ZONE_SOUTH");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_CONFERENCE_LEVEL2");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_WAR_ROOM_ZONE_ELEVATOR");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_LABS_ELEVATOR");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_LABS_HALLWAY1");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_LABS_HALLWAY2");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_LABS_ZONE3");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_LABS_ZONE2");
			PrecacheString(&"REIMAGINED_ZOMBIE_PENTAGON_LABS_ZONE1");
			break;
		case "zombie_cosmodrome":
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_CENTRIFUGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_CENTRIFUGE_ZONE2");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_ACCESS_TUNNEL_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_STORAGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_STORAGE_ZONE2");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_STORAGE_LANDER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_BASE_ENTRY_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_CENTRIFUGE2POWER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_BASE_ENTRY_ZONE2");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_POWER_BUILDING");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_POWER_BUILDING_ROOF");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_ROOF_CONNECTOR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_NORTH_CATWALK_ZONE3");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_NORTH_PATH_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_UNDER_ROCKET_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COSMODROME_CONTROL_ROOM_ZONE");
			break;
		case "zombie_coast":
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_BEACH_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_START_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPBACK_FAR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_NEAR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPBACK_NEAR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPBACK_NEAR2_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPBACK_LEVEL3_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPFRONT_NEAR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPFRONT_BOTTOM_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPFRONT_FAR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPFRONT_STORAGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_SHIPFRONT_2_BEACH_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_BEACH_ZONE2");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_RESIDENCE_ROOF_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_RESIDENCE1_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_LIGHTHOUSE1_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_LIGHTHOUSE2_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_CATWALK_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_START_CAVE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_START_BEACH_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COAST_REAR_LAGOON_ZONE");
			break;
		case "zombie_temple":
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_TEMPLE_START_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_PRESSURE_PLATE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_CAVE_TUNNEL_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_CAVES1_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_CAVES2_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_CAVES3_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_POWER_ROOM_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_CAVES_WATER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_WATERFALL_LOWER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_WATERFALL_TUNNEL_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_WATERFALL_TUNNEL_A_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_WATERFALL_UPPER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_TEMPLE_WATERFALL_UPPER1_ZONE");
			break;
		case "zombie_moon":
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_NML_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_BRIDGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_WATER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_CATA_LEFT_START_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_CATA_LEFT_MIDDLE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_GENERATOR_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_CATA_RIGHT_START_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_CATA_RIGHT_MIDDLE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_CATA_RIGHT_END_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_GENERATOR_EXIT_EAST_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_ENTER_FOREST_EAST_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_TOWER_ZONE_EAST");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_TOWER_ZONE_EAST2");
			PrecacheString(&"REIMAGINED_ZOMBIE_MOON_FOREST_ZONE");
			break;
		case "zombie_cod5_prototype":
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_PROTOTYPE_START_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_PROTOTYPE_BOX_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_PROTOTYPE_UPSTAIRS_ZONE");
			break;
		case "zombie_cod5_asylum":
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_WEST_DOWNSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_WEST2_DOWNSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_NORTH_DOWNSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_SOUTH_UPSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_SOUTH2_UPSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_POWER_UPSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_KITCHEN_UPSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_NORTH_UPSTAIRS_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_ASYLUM_NORTH2_UPSTAIRS_ZONE");
			break;
		case "zombie_cod5_sumpf":
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_CENTER_BUILDING_UPSTAIRS");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_CENTER_BUILDING_UPSTAIRS_BUY");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_CENTER_BUILDING_COMBINED");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_NORTHWEST_OUTSIDE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_NORTHWEST_BUILDING");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_SOUTHWEST_OUTSIDE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_SOUTHWEST_BUILDING");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_NORTHEAST_OUTSIDE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_NORTHEAST_BUILDING");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_SOUTHEAST_OUTSIDE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_SUMPF_SOUTHEAST_BUILDING");
			break;
		case "zombie_cod5_factory":
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_RECEIVER_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_OUTSIDE_WEST_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_OUTSIDE_EAST_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_OUTSIDE_SOUTH_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_WNUEN_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_WNUEN_BRIDGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_BRIDGE_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_TP_EAST_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_TP_WEST_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_TP_SOUTH_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_WAREHOUSE_TOP_ZONE");
			PrecacheString(&"REIMAGINED_ZOMBIE_COD5_FACTORY_WAREHOUSE_BOTTOM_ZONE");
			break;

		default:
			// Precache custom map's zone names, if any
			if(isdefined(level._zombiemode_precache_zone_strings))
				level [[level._zombiemode_precache_zone_strings]]();
			break;
	}

	add_zombie_hint( "undefined", &"ZOMBIE_UNDEFINED" );

	// Random Treasure Chest
	//add_zombie_hint( "default_treasure_chest_950", &"ZOMBIE_RANDOM_WEAPON_950" );

	// Barrier Pieces
	add_zombie_hint( "default_buy_barrier_piece_10", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_10" );
	add_zombie_hint( "default_buy_barrier_piece_20", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_20" );
	add_zombie_hint( "default_buy_barrier_piece_50", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_50" );
	add_zombie_hint( "default_buy_barrier_piece_100", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_100" );

	// REWARD Barrier Pieces
	add_zombie_hint( "default_reward_barrier_piece", &"ZOMBIE_BUTTON_REWARD_BARRIER" );
	add_zombie_hint( "default_reward_barrier_piece_10", &"ZOMBIE_BUTTON_REWARD_BARRIER_10" );
	add_zombie_hint( "default_reward_barrier_piece_20", &"ZOMBIE_BUTTON_REWARD_BARRIER_20" );
	add_zombie_hint( "default_reward_barrier_piece_30", &"ZOMBIE_BUTTON_REWARD_BARRIER_30" );
	add_zombie_hint( "default_reward_barrier_piece_40", &"ZOMBIE_BUTTON_REWARD_BARRIER_40" );
	add_zombie_hint( "default_reward_barrier_piece_50", &"ZOMBIE_BUTTON_REWARD_BARRIER_50" );

	// Debris
	add_zombie_hint( "default_buy_debris_100", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_100" );
	add_zombie_hint( "default_buy_debris_200", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_200" );
	add_zombie_hint( "default_buy_debris_250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_250" );
	add_zombie_hint( "default_buy_debris_500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_500" );
	add_zombie_hint( "default_buy_debris_750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_750" );
	add_zombie_hint( "default_buy_debris_1000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1000" );
	add_zombie_hint( "default_buy_debris_1250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1250" );
	add_zombie_hint( "default_buy_debris_1500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500" );
	add_zombie_hint( "default_buy_debris_1750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1750" );
	add_zombie_hint( "default_buy_debris_2000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_2000" );

	// Doors
	add_zombie_hint( "default_buy_door_100", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_100" );
	add_zombie_hint( "default_buy_door_200", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_200" );
	add_zombie_hint( "default_buy_door_250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_250" );
	add_zombie_hint( "default_buy_door_500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_500" );
	add_zombie_hint( "default_buy_door_750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_750" );
	add_zombie_hint( "default_buy_door_1000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1000" );
	add_zombie_hint( "default_buy_door_1250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1250" );
	add_zombie_hint( "default_buy_door_1500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1500" );
	add_zombie_hint( "default_buy_door_1750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1750" );
	add_zombie_hint( "default_buy_door_2000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2000" );

	// Areas
	add_zombie_hint( "default_buy_area_100", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_100" );
	add_zombie_hint( "default_buy_area_200", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_200" );
	add_zombie_hint( "default_buy_area_250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_250" );
	add_zombie_hint( "default_buy_area_500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_500" );
	add_zombie_hint( "default_buy_area_750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_750" );
	add_zombie_hint( "default_buy_area_1000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1000" );
	add_zombie_hint( "default_buy_area_1250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1250" );
	add_zombie_hint( "default_buy_area_1500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1500" );
	add_zombie_hint( "default_buy_area_1750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1750" );
	add_zombie_hint( "default_buy_area_2000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_2000" );

	// POWER UPS
	//add_zombie_hint( "powerup_fire_sale_cost", &"ZOMBIE_FIRE_SALE_COST" );
}

init_sounds()
{
	add_sound( "end_of_round", "mus_zmb_round_over" );
	add_sound( "end_of_game", "mus_zmb_game_over" ); //Had to remove this and add a music state switch so that we can add other musical elements.
	add_sound( "chalk_one_up", "mus_zmb_chalk" );
	add_sound( "purchase", "zmb_cha_ching" );
	add_sound( "no_purchase", "zmb_no_cha_ching" );

	// Zombification
	// TODO need to vary these up
	add_sound( "playerzombie_usebutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "playerzombie_attackbutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "playerzombie_adsbutton_sound", "zmb_zombie_vocals_attack" );

	// Head gib
	add_sound( "zombie_head_gib", "zmb_zombie_head_gib" );

	// Blockers
	add_sound( "rebuild_barrier_piece", "zmb_repair_boards" );
	add_sound( "rebuild_barrier_metal_piece", "zmb_metal_repair" );
	add_sound( "rebuild_barrier_hover", "zmb_boards_float" );
	add_sound( "debris_hover_loop", "zmb_couch_loop" );
	add_sound( "break_barrier_piece", "zmb_break_boards" );
	add_sound( "grab_metal_bar", "zmb_bar_pull" );
	add_sound( "break_metal_bar", "zmb_bar_break" );
	add_sound( "drop_metal_bar", "zmb_bar_drop" );
	add_sound("blocker_end_move", "zmb_board_slam");
	add_sound( "barrier_rebuild_slam", "zmb_board_slam" );
	add_sound( "bar_rebuild_slam", "zmb_bar_repair" );
	add_sound( "zmb_rock_fix", "zmb_break_rock_barrier_fix" );
	add_sound( "zmb_vent_fix", "evt_vent_slat_repair" );

	// Doors
	add_sound( "door_slide_open", "zmb_door_slide_open" );
	add_sound( "door_rotate_open", "zmb_door_slide_open" );

	// Debris
	add_sound( "debris_move", "zmb_weap_wall" );

	// Random Weapon Chest
	add_sound( "open_chest", "zmb_lid_open" );
	add_sound( "music_chest", "zmb_music_box" );
	add_sound( "close_chest", "zmb_lid_close" );

	// Weapons on walls
	add_sound( "weapon_show", "zmb_weap_wall" );

}

init_levelvars()
{
	// Variables
	// used to a check in last stand for players to become zombies
	level.is_zombie_level			= true;
	level.laststandpistol			= "m1911_zm";		// so we dont get the uber colt when we're knocked out
	level.first_round				= true;
	level.round_number				= 1;
	level.round_start_time			= 0;
	level.pro_tips_start_time		= 0;
	level.intermission				= false;
	level.dog_intermission			= false;
	level.monkey_intermission	= false;
	level.zombie_total				= 0;
	level.total_zombies_killed		= 0;
	level.no_laststandmissionfail	= true;
	level.hudelem_count				= 0;
	level.zombie_move_speed			= 1;
	level.enemy_spawns				= [];				// List of normal zombie spawners
	level.zombie_rise_spawners		= [];				// List of zombie riser locations
//	level.crawlers_enabled			= 1;

	// Used for kill counters
	level.counter_model[0] = "p_zom_counter_0";
	level.counter_model[1] = "p_zom_counter_1";
	level.counter_model[2] = "p_zom_counter_2";
	level.counter_model[3] = "p_zom_counter_3";
	level.counter_model[4] = "p_zom_counter_4";
	level.counter_model[5] = "p_zom_counter_5";
	level.counter_model[6] = "p_zom_counter_6";
	level.counter_model[7] = "p_zom_counter_7";
	level.counter_model[8] = "p_zom_counter_8";
	level.counter_model[9] = "p_zom_counter_9";

	level.zombie_vars = [];

	level.JUG_PRK = "specialty_armorvest";
	level.QRV_PRK = "specialty_quickrevive";
	level.SPD_PRK = "specialty_fastreload";
	level.DBT_PRK = "specialty_rof";
	level.STM_PRK = "specialty_endurance";
	level.PHD_PRK = "specialty_flakjacket";
	level.DST_PRK = "specialty_deadshot";
	level.MUL_PRK = "specialty_additionalprimaryweapon";
	level.ECH_PRK = "specialty_bulletdamage";
	level.VLT_PRK = "specialty_altmelee";
	level.WWN_PRK = "specialty_bulletaccuracy";

	//Reimagined-Expanded -- Pro Perk Vars
	level.JUG_PRO = "specialty_armorvest_upgrade";
	level.QRV_PRO = "specialty_quickrevive_upgrade";
	level.SPD_PRO = "specialty_fastreload_upgrade";
	level.DBT_PRO = "specialty_rof_upgrade";
	level.STM_PRO = "specialty_endurance_upgrade";
	level.PHD_PRO = "specialty_flakjacket_upgrade";
	level.DST_PRO = "specialty_deadshot_upgrade";
	level.MUL_PRO = "specialty_additionalprimaryweapon_upgrade";
	level.ECH_PRO = "specialty_bulletdamage_upgrade";
	level.VLT_PRO = "specialty_altmelee_upgrade";
	level.WWN_PRO = "specialty_bulletaccuracy_upgrade";

	difficulty = 1;
	column = int(difficulty) + 1;

	//#######################################################################
	// NOTE:  These values are in mp/zombiemode.csv and will override
	//	whatever you put in as a value below.  However, if they don't exist
	//	in the file, then the values below will be used.
	//#######################################################################
	//	set_zombie_var( identifier, 					value,	float,	column );

	// AI
	// Reimagined-Expanded
	//set_zombie_var( "zombie_health_increase", 			100,	false,	column );	//	cumulatively add this to the zombies' starting health each round (up to round 10)
	//set_zombie_var( "zombie_health_increase_multiplier",0.1, 	true,	column );	//	after round 10 multiply the zombies' starting health by this amount
	set_zombie_var( "zombie_health_start", 				150,	false,	column );	//	starting health of a zombie at round 1
	set_zombie_var( "zombie_spawn_delay", 				2.0,	true,	column );	// Base time to wait between spawning zombies.  This is modified based on the round number.
	set_zombie_var( "zombie_new_runner_interval", 		 10,	false,	column );	//	Interval between changing walkers who are too far away into runners
	set_zombie_var( "zombie_move_speed_multiplier", 	  8,	false,	column );	//	Multiply by the round number to give the base speed value.  0-40 = walk, 41-70 = run, 71+ = sprint

	set_zombie_var( "zombie_max_ai", 					40,		false,	column );	//	Base number of zombies per player (modified by round #)
	set_zombie_var( "zombie_ai_per_player", 			12,		false,	column );	//	additional zombie modifier for each player in the game
	set_zombie_var( "below_world_check", 				-1000 );					//	Check height to see if a zombie has fallen through the world.

	// Round
	set_zombie_var( "spectators_respawn", 				true );		// Respawn in the spectators in between rounds
	set_zombie_var( "zombie_use_failsafe", 				true );		// Will slowly kill zombies who are stuck
	set_zombie_var( "zombie_between_round_time", 		10 );		// How long to pause after the round ends
	set_zombie_var( "zombie_intermission_time", 		15 );		// Length of time to show the end of game stats
	set_zombie_var( "game_start_delay", 				0,		false,	column );	// How much time to give people a break before starting spawning

	// Life and death
	set_zombie_var( "penalty_no_revive", 				0.10, 	true,	column );	// Percentage of money you lose if you let a teammate die
	set_zombie_var( "penalty_died",						0.0, 	true,	column );	// Percentage of money lost if you die
	set_zombie_var( "penalty_downed", 					0.05, 	true,	column );	// Percentage of money lost if you go down // ww: told to remove downed point loss
	set_zombie_var( "starting_lives", 					1, 		false,	column );	// How many lives a solo player starts out with

	players = get_players();
	points = set_zombie_var( ("zombie_score_start_"+players.size+"p"), 3000, false, column );
	points = set_zombie_var( ("zombie_score_start_"+players.size+"p"), 3000, false, column );


	set_zombie_var( "zombie_score_kill_4player", 		50 );		// Individual Points for a zombie kill in a 4 player game
	set_zombie_var( "zombie_score_kill_3player",		50 );		// Individual Points for a zombie kill in a 3 player game
	set_zombie_var( "zombie_score_kill_2player",		50 );		// Individual Points for a zombie kill in a 2 player game
	set_zombie_var( "zombie_score_kill_1player",		50 );		// Individual Points for a zombie kill in a 1 player game

	set_zombie_var( "zombie_score_kill_4p_team", 		30 );		// Team Points for a zombie kill in a 4 player game
	set_zombie_var( "zombie_score_kill_3p_team",		35 );		// Team Points for a zombie kill in a 3 player game
	set_zombie_var( "zombie_score_kill_2p_team",		45 );		// Team Points for a zombie kill in a 2 player game
	set_zombie_var( "zombie_score_kill_1p_team",		 0 );		// Team Points for a zombie kill in a 1 player game

	set_zombie_var( "zombie_score_damage_normal",		10 );		// points gained for a hit with a non-automatic weapon
	set_zombie_var( "zombie_score_damage_light",		10 );		// points gained for a hit with an automatic weapon

	set_zombie_var( "zombie_score_bonus_melee", 		80 );		// Bonus points for a melee kill
		
	set_zombie_var( "zombie_score_bonus_head", 			50 );		// Bonus points for a head shot kill
	set_zombie_var( "zombie_score_bonus_neck", 			20 );		// Bonus points for a neck shot kill
	set_zombie_var( "zombie_score_bonus_torso", 		10 );		// Bonus points for a torso shot kill
	set_zombie_var( "zombie_score_bonus_burn", 			10 );		// Bonus points for a burn kill

	set_zombie_var( "zombie_flame_dmg_point_delay",		500 );

	set_zombie_var( "zombify_player", 					false );	// Default to not zombify the player till further support

	if ( IsSplitScreen() )
	{
		set_zombie_var( "zombie_timer_offset", 			280 );	// hud offsets
	}

	//Reimagined Apocalypse
	if(level.apocalypse) {
		level.zombie_vars["zombie_score_bonus_melee"] = 25;
		//level.zombie_vars["zombie_score_bonus_head"] = 50;
	}
	

}

init_dvars()
{
	setSavedDvar( "fire_world_damage", "0" );
	setSavedDvar( "fire_world_damage_rate", "0" );
	setSavedDvar( "fire_world_damage_duration", "0" );

	if( GetDvar( #"zombie_debug" ) == "" )
	{
		SetDvar( "zombie_debug", "0" );
	}

	if( GetDvar( #"zombie_cheat" ) == "" )
	{
		SetDvar( "zombie_cheat", "0" );
	}

	if ( level.script != "zombie_cod5_prototype" )
	{
		SetDvar( "magic_chest_movable", "1" );
	}

	if(GetDvar( #"magic_box_explore_only") == "")
	{
		SetDvar( "magic_box_explore_only", "1" );
	}

	SetDvar( "revive_trigger_radius", "75" );
	SetDvar( "player_lastStandBleedoutTime", "45" );

	SetDvar( "scr_deleteexplosivesonspawn", "0" );
	if( !isDefined(level.dev_only) ) {
		//SetDvar( "scr_suppressErrors", 1 );
	}
		

	level.zm_mod_version = "2.2.0";
	SetDvar( "zm_mod_version", level.zm_mod_version );


	// HACK: To avoid IK crash in zombiemode: MikeA 9/18/2009
	//setDvar( "ik_enable", "0" );
}


init_mutators()
{
	level.mutators = [];

	init_mutator( "mutator_noPerks" );
	init_mutator( "mutator_noTraps" );
	init_mutator( "mutator_noMagicBox" );
	init_mutator( "mutator_noRevive" );
	init_mutator( "mutator_noPowerups" );
	init_mutator( "mutator_noReloads" );
	init_mutator( "mutator_noBoards" );
	init_mutator( "mutator_fogMatch" );
	init_mutator( "mutator_quickStart" );
	init_mutator( "mutator_headshotsOnly" );
	init_mutator( "mutator_friendlyFire" );
	init_mutator( "mutator_doubleMoney" );
	init_mutator( "mutator_susceptible" );
	init_mutator( "mutator_powerShot" );
}

init_mutator( mutator_s )
{
	level.mutators[ mutator_s ] = ( "1" == GetDvar( mutator_s ) );
}


init_function_overrides()
{
	// Function pointers
	level.custom_introscreen		= ::zombie_intro_screen;
	level.custom_intermission		= ::player_intermission;
	level.reset_clientdvars			= ::onPlayerConnect_clientDvars;
	// Sets up function pointers for animscripts to refer to
	level.playerlaststand_func		= ::player_laststand;
	//	level.global_kill_func		= maps\_zombiemode_spawner::zombie_death;
	level.global_damage_func		= maps\_zombiemode_spawner::zombie_damage;
	level.global_damage_func_ads	= maps\_zombiemode_spawner::zombie_damage_ads;
	level.overridePlayerKilled		= ::player_killed_override;
	level.overridePlayerDamage		= ::player_damage_override; //_cheat;
	level.overrideActorKilled		= ::actor_killed_override;
	level.overrideActorDamage		= ::actor_damage_override;
	level.melee_miss_func			= ::zombiemode_melee_miss;
	level.player_becomes_zombie		= ::zombify_player;
	level.is_friendly_fire_on		= ::is_friendly_fire_on;
	level.can_revive				= ::can_revive;
	level.zombie_last_stand 		= ::last_stand_pistol_swap;
	level.zombie_last_stand_pistol_memory = ::last_stand_save_pistol_ammo;
	level.zombie_last_stand_ammo_return		= ::last_stand_restore_pistol_ammo;
	level.prevent_player_damage		= ::player_prevent_damage;

	if( !IsDefined( level.Player_Spawn_func ) )
	{
		level.Player_Spawn_func = ::coop_player_spawn_placement;
	}
	
}


// for zombietron, see maps\_zombietron_main::initZombieLeaderboardData()
//
initZombieLeaderboardData()
{
	// Initializing Leaderboard Stat Variables -- string values match stats.ddl
	level.zombieLeaderboardStatVariable["zombie_theater"]["highestwave"] = "zombie_theater_highestwave";
	level.zombieLeaderboardStatVariable["zombie_theater"]["timeinwave"]  = "zombie_theater_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_theater"]["totalpoints"] = "zombie_theater_totalpoints";

	level.zombieLeaderboardStatVariable["zombie_pentagon"]["highestwave"] = "zombie_pentagon_highestwave";
	level.zombieLeaderboardStatVariable["zombie_pentagon"]["timeinwave"]  = "zombie_pentagon_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_pentagon"]["totalpoints"] = "zombie_pentagon_totalpoints";

	// DLC 1 Cod 5 Zombies Leaderboard Stats

	level.zombieLeaderboardStatVariable["zombie_cod5_asylum"]["highestwave"] = "zombie_asylum_highestwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_asylum"]["timeinwave"]  = "zombie_asylum_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_asylum"]["totalpoints"] = "zombie_asylum_totalpoints";

	level.zombieLeaderboardStatVariable["zombie_cod5_factory"]["highestwave"] = "zombie_factory_highestwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_factory"]["timeinwave"]  = "zombie_factory_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_factory"]["totalpoints"] = "zombie_factory_totalpoints";

	level.zombieLeaderboardStatVariable["zombie_cod5_prototype"]["highestwave"] = "zombie_prototype_highestwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_prototype"]["timeinwave"]  = "zombie_prototype_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_prototype"]["totalpoints"] = "zombie_prototype_totalpoints";

	level.zombieLeaderboardStatVariable["zombie_cod5_sumpf"]["highestwave"] = "zombie_sumpf_highestwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_sumpf"]["timeinwave"]  = "zombie_sumpf_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_cod5_sumpf"]["totalpoints"] = "zombie_sumpf_totalpoints";

	// DLC 2 Zombies Leaderboard Stats

	level.zombieLeaderboardStatVariable["zombie_cosmodrome"]["highestwave"] = "zombie_cosmodrome_highestwave";
	level.zombieLeaderboardStatVariable["zombie_cosmodrome"]["timeinwave"]  = "zombie_cosmodrome_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_cosmodrome"]["totalpoints"] = "zombie_cosmodrome_totalpoints";

	// DLC 3 Zombies Leaderboard Stats

	level.zombieLeaderboardStatVariable["zombie_coast"]["highestwave"] = "zombie_coast_highestwave";
	level.zombieLeaderboardStatVariable["zombie_coast"]["timeinwave"]  = "zombie_coast_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_coast"]["totalpoints"] = "zombie_coast_totalpoints";

	// DLC 4 Zombies Leaderboard Stats

	level.zombieLeaderboardStatVariable["zombie_temple"]["highestwave"] = "zombie_temple_highestwave";
	level.zombieLeaderboardStatVariable["zombie_temple"]["timeinwave"]  = "zombie_temple_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_temple"]["totalpoints"] = "zombie_temple_totalpoints";

	// DLC 5 Zombies Leaderboard Stats

	level.zombieLeaderboardStatVariable["zombie_moon"]["highestwave"] = "zombie_moon_highestwave";
	level.zombieLeaderboardStatVariable["zombie_moon"]["timeinwave"]  = "zombie_moon_timeinwave";
	level.zombieLeaderboardStatVariable["zombie_moon"]["totalpoints"] = "zombie_moon_totalpoints";
	level.zombieLeaderboardStatVariable["zombie_moon"]["nomanslandtime"] = "zombie_moon_nomansland";


	// Initializing Leaderboard Number.  Matches values in live_leaderboard.h.
	level.zombieLeaderboardNumber["zombie_theater"]["waves"] = 0;
	level.zombieLeaderboardNumber["zombie_theater"]["points"] = 1;

	// level.zombieLeaderboardNumber["zombietron"]["waves"] = 3;  // defined in _zombietron_main.gsc
	// level.zombieLeaderboardNumber["zombietron"]["points"] = 4; // defined in _zombietron_main.gsc

	level.zombieLeaderboardNumber["zombie_pentagon"]["waves"] = 6;
	level.zombieLeaderboardNumber["zombie_pentagon"]["points"] = 7;

	// DLC 1 Cod 5 Zombie leaderboards

	// Asylum
	level.zombieLeaderboardNumber["zombie_cod5_asylum"]["waves"] = 9;
	level.zombieLeaderboardNumber["zombie_cod5_asylum"]["points"] = 10;

	// Factory
	level.zombieLeaderboardNumber["zombie_cod5_factory"]["waves"] = 12;
	level.zombieLeaderboardNumber["zombie_cod5_factory"]["points"] = 13;

	// Prototype
	level.zombieLeaderboardNumber["zombie_cod5_prototype"]["waves"] = 15;
	level.zombieLeaderboardNumber["zombie_cod5_prototype"]["points"] = 16;

	// Sumpf
	level.zombieLeaderboardNumber["zombie_cod5_sumpf"]["waves"] = 18;
	level.zombieLeaderboardNumber["zombie_cod5_sumpf"]["points"] = 19;

	// DLC 2 Zombie leaderboards

	// Cosmodrome
	level.zombieLeaderboardNumber["zombie_cosmodrome"]["waves"] = 21;
	level.zombieLeaderboardNumber["zombie_cosmodrome"]["points"] = 22;

	// DLC 3 Zombie leaderboards

	// Coast
	level.zombieLeaderboardNumber["zombie_coast"]["waves"] = 24;
	level.zombieLeaderboardNumber["zombie_coast"]["points"] = 25;

	// DLC 4 Zombie leaderboards

	// Temple
	level.zombieLeaderboardNumber["zombie_temple"]["waves"] = 27;
	level.zombieLeaderboardNumber["zombie_temple"]["points"] = 28;

	// DLC 5 Zombie leaderboards

	// Moon
	level.zombieLeaderboardNumber["zombie_moon"]["waves"] = 30;
	level.zombieLeaderboardNumber["zombie_moon"]["points"] = 31;
	level.zombieLeaderboardNumber["zombie_moon"]["kills"] = 32;
}


init_flags()
{
	flag_init( "spawn_point_override" );
	flag_init( "power_on" );
	flag_init( "crawler_round" );
	flag_init( "spawn_zombies", true );
	flag_init( "dog_round" );
	flag_init( "begin_spawning" );
	flag_init( "end_round_wait" );
	flag_init( "wait_and_revive" );
	flag_init("instant_revive");

	flag_init("insta_kill_round");
	flag_init("round_restarting");
	flag_init("enter_nml");
}

// Client flags registered here should be for global zombie systems, and should
// prefer to use high flag numbers and work downwards.

// Level specific flags should be registered in the level, and should prefer
// low numbers, and work upwards.

// Ensure that this function and the function in _zombiemode.csc match.

init_client_flags()
{
	// Client flags for script movers

	level._ZOMBIE_SCRIPTMOVER_FLAG_BOX_RANDOM	= 15;


	if(is_true(level.use_clientside_board_fx))
	{
		//for tearing down and repairing the boards and rock chunks
		level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX	= 14;
		level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX	= 13;
	}

	// Client flags for the player
	level._ZOMBIE_PLAYER_FLAG_CLOAK_WEAPON = 14;
	level._ZOMBIE_PLAYER_FLAG_DIVE2NUKE_VISION = 13;
	level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK = 12;

	if(is_true(level.riser_fx_on_client))
	{
		level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX = 8;
		if(!isDefined(level._no_water_risers))
		{
			level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX_WATER = 9;
		}
		if(is_true(level.risers_use_low_gravity_fx))
		{
			level._ZOMBIE_ACTOR_ZOMBIE_RISER_LOWG_FX = 7;
		}
	}

	//Reimagined-Expanded - we finally get into client flags
	level._ZOMBIE_ACTOR_ZOMBIE_HAS_DROP = 12;

}

init_fx()
{
	level._effect["eye_glow"]			 		= LoadFX( "misc/fx_zombie_eye_single" );
	//level._effect["eye_glow_red"] = 			LoadFX( "eyes/fx_zombie_eye_single_red" );
	//level._effect["eye_glow_purple"] = 			LoadFX( "eyes/fx_zombie_eye_single_purple" );

	//Gives CSC error if not included
	level._effect["headshot"] 					= LoadFX( "impacts/fx_flesh_hit" );
	level._effect["headshot_nochunks"] 			= LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["chest_light"]		 		= LoadFX( "env/light/fx_ray_sun_sm_short" );

	level._effect["bloodspurt"] 				= LoadFX( "misc/fx_zombie_bloodspurt" );

	//*
	
	level._effect["fx_zombie_bar_break"]		= LoadFX( "maps/zombie/fx_zombie_bar_break" );
	level._effect["fx_zombie_bar_break_lite"]	= LoadFX( "maps/zombie/fx_zombie_bar_break_lite" );

	level._effect["edge_fog"]			 		= LoadFX( "maps/zombie/fx_fog_zombie_amb" );


	//Reimagined-Expanded - removed to avoid fx overload
	
	//level._effect["tesla_head_light"]			= LoadFX( "maps/zombie/fx_zombie_tesla_neck_spurt");

	level._effect["rise_burst_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_burst");
	level._effect["rise_billow_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_billowing");
	level._effect["rise_dust_water"]			= LoadFX("maps/zombie/fx_zombie_body_wtr_falling");

	level._effect["rise_burst"]					= LoadFX("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["rise_billow"]				= LoadFX("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["rise_dust"]					= LoadFX("maps/zombie/fx_mp_zombie_body_dust_falling");

	level._effect["fall_burst"]					= LoadFX("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["fall_billow"]				= LoadFX("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["fall_dust"]					= LoadFX("maps/zombie/fx_mp_zombie_body_dust_falling");
	//*/

	// Flamethrower
	//level._effect["character_fire_pain_sm"]     = LoadFX( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"]    = LoadFX( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFX( "env/fire/fx_fire_player_torso" );

	//level._effect["def_explosion"]				= LoadFX("explosions/fx_default_explosion");
	//level._effect["betty_explode"]				= LoadFX("weapon/bouncing_betty/fx_explosion_betty_generic");

	level._effect["ent_stolen"] 				= LoadFX( "maps/zombie/fx_zmb_ent_stolen" );
}


// zombie specific anims
init_standard_zombie_anims()
{
	// deaths
	level.scr_anim["zombie"]["death1"] 	= %ai_zombie_death_v1;
	level.scr_anim["zombie"]["death2"] 	= %ai_zombie_death_v2;
	level.scr_anim["zombie"]["death3"] 	= %ai_zombie_crawl_death_v1;
	level.scr_anim["zombie"]["death4"] 	= %ai_zombie_crawl_death_v2;

	// run cycles

	level.scr_anim["zombie"]["walk1"] 	= %ai_zombie_walk_v1;
	level.scr_anim["zombie"]["walk2"] 	= %ai_zombie_walk_v2;
	level.scr_anim["zombie"]["walk3"] 	= %ai_zombie_walk_v3;
	level.scr_anim["zombie"]["walk4"] 	= %ai_zombie_walk_v4;
	level.scr_anim["zombie"]["walk5"] 	= %ai_zombie_walk_v6;
	level.scr_anim["zombie"]["walk6"] 	= %ai_zombie_walk_v7;
	level.scr_anim["zombie"]["walk7"] 	= %ai_zombie_walk_v9;	//was goose step walk - overridden in theatre only (v8)
	level.scr_anim["zombie"]["walk8"] 	= %ai_zombie_walk_v9;

	level.scr_anim["zombie"]["run1"] 	= %ai_zombie_walk_fast_v1;
	level.scr_anim["zombie"]["run2"] 	= %ai_zombie_walk_fast_v2;
	level.scr_anim["zombie"]["run3"] 	= %ai_zombie_walk_fast_v3;
	level.scr_anim["zombie"]["run4"] 	= %ai_zombie_run_v2;
	level.scr_anim["zombie"]["run5"] 	= %ai_zombie_run_v4;
	level.scr_anim["zombie"]["run6"] 	= %ai_zombie_run_v3;
	level.scr_anim["zombie"]["run7"] 	= %ai_zombie_run_v1;

	level.scr_anim["zombie"]["sprint1"] = %ai_zombie_sprint_v1;
	level.scr_anim["zombie"]["sprint2"] = %ai_zombie_sprint_v2;
	level.scr_anim["zombie"]["sprint3"] = %ai_zombie_sprint_v1;
	level.scr_anim["zombie"]["sprint4"] = %ai_zombie_sprint_v2;

	level.scr_anim["zombie"]["sprint5"] = %ai_zombie_fast_sprint_01;
	level.scr_anim["zombie"]["sprint6"] = %ai_zombie_fast_sprint_02;
	level.scr_anim["zombie"]["sprint7"] = %ai_zombie_fast_sprint_03;

	// run cycles in prone
	level.scr_anim["zombie"]["crawl1"] 	= %ai_zombie_crawl;
	level.scr_anim["zombie"]["crawl2"] 	= %ai_zombie_crawl_v1;
	level.scr_anim["zombie"]["crawl3"] 	= %ai_zombie_crawl_v2;
	level.scr_anim["zombie"]["crawl4"] 	= %ai_zombie_crawl_v3;
	level.scr_anim["zombie"]["crawl5"] 	= %ai_zombie_crawl_v4;
	level.scr_anim["zombie"]["crawl6"] 	= %ai_zombie_crawl_v5;
	level.scr_anim["zombie"]["crawl_hand_1"] = %ai_zombie_walk_on_hands_a;
	level.scr_anim["zombie"]["crawl_hand_2"] = %ai_zombie_walk_on_hands_b;

	level.scr_anim["zombie"]["crawl_sprint1"] 	= %ai_zombie_crawl_sprint;
	level.scr_anim["zombie"]["crawl_sprint2"] 	= %ai_zombie_crawl_sprint_1;
	level.scr_anim["zombie"]["crawl_sprint3"] 	= %ai_zombie_crawl_sprint_2;

	if( !isDefined( level._zombie_melee ) )
	{
		level._zombie_melee = [];
	}
	if( !isDefined( level._zombie_walk_melee ) )
	{
		level._zombie_walk_melee = [];
	}
	if( !isDefined( level._zombie_run_melee ) )
	{
		level._zombie_run_melee = [];
	}

	level._zombie_melee["zombie"] = [];
	level._zombie_walk_melee["zombie"] = [];
	level._zombie_run_melee["zombie"] = [];


	level._zombie_melee["zombie"][0] 				= %ai_zombie_attack_v2;				// slow swipes
	level._zombie_melee["zombie"][1]				= %ai_zombie_attack_v4;				// single left swipe
	level._zombie_melee["zombie"][2]				= %ai_zombie_attack_v6;				// wierd double swipe
	level._zombie_melee["zombie"][3] 				= %ai_zombie_attack_v1;				// DOUBLE SWIPE
	level._zombie_melee["zombie"][4] 				= %ai_zombie_attack_forward_v1;		// DOUBLE SWIPE
	level._zombie_melee["zombie"][5] 				= %ai_zombie_attack_forward_v2;		// slow DOUBLE SWIPE

	level._zombie_run_melee["zombie"][0]				=	%ai_zombie_run_attack_v1;	// fast single right
	level._zombie_run_melee["zombie"][1]				=	%ai_zombie_run_attack_v2;	// fast double swipe
	level._zombie_run_melee["zombie"][2]				=	%ai_zombie_run_attack_v3;	// fast swipe

	if( isDefined( level.zombie_anim_override ) )
	{
		[[ level.zombie_anim_override ]]();
	}

	// melee in walk
	level._zombie_walk_melee["zombie"][0]			= %ai_zombie_walk_attack_v1;	// fast single right swipe
	level._zombie_walk_melee["zombie"][1]			= %ai_zombie_walk_attack_v2;	// slow right/left single hit
	level._zombie_walk_melee["zombie"][2]			= %ai_zombie_walk_attack_v3;	// fast single left swipe
	level._zombie_walk_melee["zombie"][3]			= %ai_zombie_walk_attack_v4;	// slow single right swipe

	// melee in crawl
	if( !isDefined( level._zombie_melee_crawl ) )
	{
		level._zombie_melee_crawl = [];
	}
	level._zombie_melee_crawl["zombie"] = [];
	level._zombie_melee_crawl["zombie"][0] 		= %ai_zombie_attack_crawl;
	level._zombie_melee_crawl["zombie"][1] 		= %ai_zombie_attack_crawl_lunge;

	if( !isDefined( level._zombie_stumpy_melee ) )
	{
		level._zombie_stumpy_melee = [];
	}
	level._zombie_stumpy_melee["zombie"] = [];
	level._zombie_stumpy_melee["zombie"][0] = %ai_zombie_walk_on_hands_shot_a;
	level._zombie_stumpy_melee["zombie"][1] = %ai_zombie_walk_on_hands_shot_b;
	//level._zombie_melee_crawl["zombie"][2]		= %ai_zombie_crawl_attack_A;

	// tesla deaths
	if( !isDefined( level._zombie_tesla_death ) )
	{
		level._zombie_tesla_death = [];
	}
	level._zombie_tesla_death["zombie"] = [];
	level._zombie_tesla_death["zombie"][0] = %ai_zombie_tesla_death_a;
	level._zombie_tesla_death["zombie"][1] = %ai_zombie_tesla_death_b;
	level._zombie_tesla_death["zombie"][2] = %ai_zombie_tesla_death_c;
	level._zombie_tesla_death["zombie"][3] = %ai_zombie_tesla_death_d;
	level._zombie_tesla_death["zombie"][4] = %ai_zombie_tesla_death_e;

	if( !isDefined( level._zombie_tesla_crawl_death ) )
	{
		level._zombie_tesla_crawl_death = [];
	}
	level._zombie_tesla_crawl_death["zombie"] = [];
	level._zombie_tesla_crawl_death["zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_tesla_crawl_death["zombie"][1] = %ai_zombie_tesla_crawl_death_b;

	// thundergun knockdowns and getups
	if( !isDefined( level._zombie_knockdowns ) )
	{
		level._zombie_knockdowns = [];
	}
	level._zombie_knockdowns["zombie"] = [];
	level._zombie_knockdowns["zombie"]["front"] = [];

	level._zombie_knockdowns["zombie"]["front"]["no_legs"] = [];
	level._zombie_knockdowns["zombie"]["front"]["no_legs"][0] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["no_legs"][1] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["no_legs"][2] = %ai_zombie_thundergun_hit_forwardtoface;

	level._zombie_knockdowns["zombie"]["front"]["has_legs"] = [];

	level._zombie_knockdowns["zombie"]["front"]["has_legs"][0] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][1] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][2] = %ai_zombie_thundergun_hit_upontoback;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][3] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][4] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][5] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][6] = %ai_zombie_thundergun_hit_stumblefall;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][7] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][8] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][9] = %ai_zombie_thundergun_hit_upontoback;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][10] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][11] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][12] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][13] = %ai_zombie_thundergun_hit_deadfallknee;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][14] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][15] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][16] = %ai_zombie_thundergun_hit_upontoback;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][17] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][18] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][19] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][20] = %ai_zombie_thundergun_hit_flatonback;

	level._zombie_knockdowns["zombie"]["left"] = [];
	level._zombie_knockdowns["zombie"]["left"][0] = %ai_zombie_thundergun_hit_legsout_right;

	level._zombie_knockdowns["zombie"]["right"] = [];
	level._zombie_knockdowns["zombie"]["right"][0] = %ai_zombie_thundergun_hit_legsout_left;

	level._zombie_knockdowns["zombie"]["back"] = [];
	level._zombie_knockdowns["zombie"]["back"][0] = %ai_zombie_thundergun_hit_faceplant;

	if( !isDefined( level._zombie_getups ) )
	{
		level._zombie_getups = [];
	}
	level._zombie_getups["zombie"] = [];
	level._zombie_getups["zombie"]["back"] = [];

	level._zombie_getups["zombie"]["back"]["early"] = [];
	level._zombie_getups["zombie"]["back"]["early"][0] = %ai_zombie_thundergun_getup_b;
	level._zombie_getups["zombie"]["back"]["early"][1] = %ai_zombie_thundergun_getup_c;

	level._zombie_getups["zombie"]["back"]["late"] = [];
	level._zombie_getups["zombie"]["back"]["late"][0] = %ai_zombie_thundergun_getup_b;
	level._zombie_getups["zombie"]["back"]["late"][1] = %ai_zombie_thundergun_getup_c;
	level._zombie_getups["zombie"]["back"]["late"][2] = %ai_zombie_thundergun_getup_quick_b;
	level._zombie_getups["zombie"]["back"]["late"][3] = %ai_zombie_thundergun_getup_quick_c;

	level._zombie_getups["zombie"]["belly"] = [];

	level._zombie_getups["zombie"]["belly"]["early"] = [];
	level._zombie_getups["zombie"]["belly"]["early"][0] = %ai_zombie_thundergun_getup_a;

	level._zombie_getups["zombie"]["belly"]["late"] = [];
	level._zombie_getups["zombie"]["belly"]["late"][0] = %ai_zombie_thundergun_getup_a;
	level._zombie_getups["zombie"]["belly"]["late"][1] = %ai_zombie_thundergun_getup_quick_a;

	// freezegun deaths
	if( !isDefined( level._zombie_freezegun_death ) )
	{
		level._zombie_freezegun_death = [];
	}
	level._zombie_freezegun_death["zombie"] = [];
	level._zombie_freezegun_death["zombie"][0] = %ai_zombie_freeze_death_a;
	level._zombie_freezegun_death["zombie"][1] = %ai_zombie_freeze_death_b;
	level._zombie_freezegun_death["zombie"][2] = %ai_zombie_freeze_death_c;
	level._zombie_freezegun_death["zombie"][3] = %ai_zombie_freeze_death_d;
	level._zombie_freezegun_death["zombie"][4] = %ai_zombie_freeze_death_e;

	if( !isDefined( level._zombie_freezegun_death_missing_legs ) )
	{
		level._zombie_freezegun_death_missing_legs = [];
	}
	level._zombie_freezegun_death_missing_legs["zombie"] = [];
	level._zombie_freezegun_death_missing_legs["zombie"][0] = %ai_zombie_crawl_freeze_death_01;
	level._zombie_freezegun_death_missing_legs["zombie"][1] = %ai_zombie_crawl_freeze_death_02;

	// deaths
	if( !isDefined( level._zombie_deaths ) )
	{
		level._zombie_deaths = [];
	}
	level._zombie_deaths["zombie"] = [];
	level._zombie_deaths["zombie"][0] = %ch_dazed_a_death;
	level._zombie_deaths["zombie"][1] = %ch_dazed_b_death;
	level._zombie_deaths["zombie"][2] = %ch_dazed_c_death;
	level._zombie_deaths["zombie"][3] = %ch_dazed_d_death;

	/*
	ground crawl
	*/

	if( !isDefined( level._zombie_rise_anims ) )
	{
		level._zombie_rise_anims = [];
	}

	// set up the arrays
	level._zombie_rise_anims["zombie"] = [];

	//level._zombie_rise_anims["zombie"][1]["walk"][0]		= %ai_zombie_traverse_ground_v1_crawl;
	level._zombie_rise_anims["zombie"][1]["walk"][0]		= %ai_zombie_traverse_ground_v1_walk;

	//level._zombie_rise_anims["zombie"][1]["run"][0]		= %ai_zombie_traverse_ground_v1_crawlfast;
	level._zombie_rise_anims["zombie"][1]["run"][0]		= %ai_zombie_traverse_ground_v1_run;

	level._zombie_rise_anims["zombie"][1]["sprint"][0]	= %ai_zombie_traverse_ground_climbout_fast;

	//level._zombie_rise_anims["zombie"][2]["walk"][0]		= %ai_zombie_traverse_ground_v2_walk;	//!broken
	level._zombie_rise_anims["zombie"][2]["walk"][0]		= %ai_zombie_traverse_ground_v2_walk_altA;
	//level._zombie_rise_anims["zombie"][2]["walk"][2]		= %ai_zombie_traverse_ground_v2_walk_altB;//!broken

	// ground crawl death
	if( !isDefined( level._zombie_rise_death_anims ) )
	{
		level._zombie_rise_death_anims = [];
	}

	level._zombie_rise_death_anims["zombie"] = [];

	level._zombie_rise_death_anims["zombie"][1]["in"][0]		= %ai_zombie_traverse_ground_v1_deathinside;
	level._zombie_rise_death_anims["zombie"][1]["in"][1]		= %ai_zombie_traverse_ground_v1_deathinside_alt;

	level._zombie_rise_death_anims["zombie"][1]["out"][0]		= %ai_zombie_traverse_ground_v1_deathoutside;
	level._zombie_rise_death_anims["zombie"][1]["out"][1]		= %ai_zombie_traverse_ground_v1_deathoutside_alt;

	level._zombie_rise_death_anims["zombie"][2]["in"][0]		= %ai_zombie_traverse_ground_v2_death_low;
	level._zombie_rise_death_anims["zombie"][2]["in"][1]		= %ai_zombie_traverse_ground_v2_death_low_alt;

	level._zombie_rise_death_anims["zombie"][2]["out"][0]		= %ai_zombie_traverse_ground_v2_death_high;
	level._zombie_rise_death_anims["zombie"][2]["out"][1]		= %ai_zombie_traverse_ground_v2_death_high_alt;

	//taunts
	if( !isDefined( level._zombie_run_taunt ) )
	{
		level._zombie_run_taunt = [];
	}
	if( !isDefined( level._zombie_board_taunt ) )
	{
		level._zombie_board_taunt = [];
	}
	level._zombie_run_taunt["zombie"] = [];
	level._zombie_board_taunt["zombie"] = [];

	//level._zombie_taunt["zombie"][0] = %ai_zombie_taunts_1;
	//level._zombie_taunt["zombie"][1] = %ai_zombie_taunts_4;
	//level._zombie_taunt["zombie"][2] = %ai_zombie_taunts_5b;
	//level._zombie_taunt["zombie"][3] = %ai_zombie_taunts_5c;
	//level._zombie_taunt["zombie"][4] = %ai_zombie_taunts_5d;
	//level._zombie_taunt["zombie"][5] = %ai_zombie_taunts_5e;
	//level._zombie_taunt["zombie"][6] = %ai_zombie_taunts_5f;
	//level._zombie_taunt["zombie"][7] = %ai_zombie_taunts_7;
	//level._zombie_taunt["zombie"][8] = %ai_zombie_taunts_9;
	//level._zombie_taunt["zombie"][8] = %ai_zombie_taunts_11;
	//level._zombie_taunt["zombie"][8] = %ai_zombie_taunts_12;

	level._zombie_board_taunt["zombie"][0] = %ai_zombie_taunts_4;
	level._zombie_board_taunt["zombie"][1] = %ai_zombie_taunts_7;
	level._zombie_board_taunt["zombie"][2] = %ai_zombie_taunts_9;
	level._zombie_board_taunt["zombie"][3] = %ai_zombie_taunts_5b;
	level._zombie_board_taunt["zombie"][4] = %ai_zombie_taunts_5c;
	level._zombie_board_taunt["zombie"][5] = %ai_zombie_taunts_5d;
	level._zombie_board_taunt["zombie"][6] = %ai_zombie_taunts_5e;
	level._zombie_board_taunt["zombie"][7] = %ai_zombie_taunts_5f;


	level._zombie_run_melee["zombie"][0]				=	%ai_zombie_boss_attack_sprinting;
	level._zombie_sprint_melee["zombie"][0]				=	%ai_zombie_boss_attack_sprinting;
	//level._zombie_run_melee["zombie"][2]				=	%ai_zombie_boss_attack_running;
	//level._zombie_run_melee["zombie"][0]				=	%ai_zombie_boss_attack_running;
	
}

init_anims()
{
	init_standard_zombie_anims();
}

// Initialize any animscript related variables
init_animscripts()
{
	// Setup the animscripts, then override them (we call this just incase an AI has not yet spawned)
	animscripts\zombie_init::firstInit();

	anim.idleAnimArray		["stand"] = [];
	anim.idleAnimWeights	["stand"] = [];
	anim.idleAnimArray		["stand"][0][0] 	= %ai_zombie_idle_v1_delta;
	anim.idleAnimWeights	["stand"][0][0] 	= 10;

	anim.idleAnimArray		["crouch"] = [];
	anim.idleAnimWeights	["crouch"] = [];
	anim.idleAnimArray		["crouch"][0][0] 	= %ai_zombie_idle_crawl_delta;
	anim.idleAnimWeights	["crouch"][0][0] 	= 10;
	 
}

// Handles the intro screen
zombie_intro_screen( string1, string2, string3, string4, string5 )
{
	flag_wait( "all_players_connected" );
}

players_playing()
{
	// initialize level.players_size
	players = get_players();
	level.players_size = players.size;

	wait( 20 );

	players = get_players();
	level.players_size = players.size;
}


//	Init some additional settings based on difficulty and number of players
//
difficulty_init()
{
	flag_wait( "all_players_connected" );

	difficulty =1;
	table	= "mp/zombiemode.csv";
	column	= int(difficulty)+1;
	players = get_players();
	points	= 500;


	// Get individual starting points
	points = set_zombie_var( ("zombie_score_start_"+players.size+"p"), 3000, false, column );
/#
	if( GetDvarInt( #"zombie_cheat" ) >= 1 )
	{
		points = 100000;
	}
#/
	for ( p=0; p<players.size; p++ )
	{
		if(level.gamemode == "snr")
		{
			players[p].score = 10000;
		}
		else
		{
			players[p].score = 500;
			//players[p].score = 10000000;
		}
		players[p].score_total = players[p].score;
		players[p].old_score = players[p].score;
	}

	// Get team starting points
	points = set_zombie_var( ("zombie_team_score_start_"+players.size+"p"), 2000, false, column );
/#
	if( GetDvarInt( #"zombie_cheat" ) >= 1 )
	{
		points = 100000;
	}
#/
	for ( tp = 0; tp<level.team_pool.size; tp++ )
	{
		pool = level.team_pool[ tp ];
		pool.score			= points;
		pool.old_score		= pool.score;
		pool.score_total	= pool.score;
	}

	// Other difficulty-specific changes
	switch ( difficulty )
	{
	case "0":
	case "1":
		break;
	case "2":
		level.first_round	= false;
		level.round_number	= 8;
		break;
	case "3":
		level.first_round	= false;
		level.round_number	= 18;
		break;
	default:
		break;
	}

	if( level.mutators["mutator_quickStart"] )
	{
		level.first_round	= false;
		level.round_number	= 5;
	}
}


//
// NETWORK SECTION ====================================================================== //
//

watchTakenDamage()
{
	self endon( "disconnect" );
	self endon( "death" );

	self.has_taken_damage = false;
	while(1)
	{
		self waittill("damage", damage_amount );

		if ( 0 < damage_amount )
		{
			self.has_taken_damage = true;
			return;
		}
	}
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player );

		if(!IsDefined(level.char_nums))
		{
			level.char_nums = array(0, 1, 2, 3);
		}
		//player.zm_random_char = level.char_nums[RandomInt(level.char_nums.size)];
		//player.entity_num = player.zm_random_char;
		//level.char_nums = array_remove_nokeys(level.char_nums, player.entity_num);

		//player.entity_num = player GetEntityNumber();
		player thread onPlayerSpawned();
		player thread onPlayerDisconnect();
		player thread player_revive_monitor();

		player thread onPlayerDowned();
		player thread onPlayerDeath();

		player freezecontrols( true );

		player thread watchTakenDamage();

		player.score = 0;
		player.score_total = player.score;
		player.old_score = player.score;

		player.is_zombie = false;
		player.initialized = false;
		player.zombification_time = 0;
		player.enableText = true;

		player.team_num = 0;

		player setTeamForEntity( "allies" );

		//player maps\_zombiemode_protips::player_init();

		// DCS 090910: now that player can destroy some barricades before set.
		player thread maps\_zombiemode_blockers::rebuild_barrier_reward_reset();

		player thread melee_notify();
		player thread sprint_notify();
		player thread switch_weapons_notify();
		player thread is_reloading_check();
		player thread store_last_held_primary_weapon();
	}
}

onPlayerConnect_clientDvars()
{
	self SetClientDvars( "cg_deadChatWithDead", "1",
		"cg_deadChatWithTeam", "1",
		"cg_deadHearTeamLiving", "1",
		"cg_deadHearAllLiving", "1",
		"cg_everyoneHearsEveryone", "1",
		"compass", "0",
		"hud_showStance", "0",
		"cg_thirdPerson", "0",
		//"cg_fov", "90",
		"cg_thirdPersonAngle", "0",
		"ammoCounterHide", "1",
		"miniscoreboardhide", "1",
		"cg_drawSpectatorMessages", "0",
		"ui_hud_hardcore", "0",
		"playerPushAmount", "1",
		"g_deadchat", "1",
		"cg_friendlyNameFadeOut", "1",
		"player_backSpeedScale", "1",
		"player_strafeSpeedScale", "1",
		"player_sprintStrafeSpeedScale", "1",
		"cg_hudDamageIconTime", "2500",
		"ui_playerWeaponName", ""
		 );

	self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );

	// Enabling the FPS counter in ship for now
	//self setclientdvar( "cg_drawfps", "1" );

	self setClientDvar( "aim_lockon_pitch_strength", 0.0 );

	if(!level.wii)
	{
		//self SetClientDvar("r_enablePlayerShadow", 1);
	}

	self setClientDvar("cg_mature", "1");

	self setClientDvar("cg_drawFriendlyFireCrosshair", "1");

	// reset dvar that changes when double tap is bought
	self SetClientDvar("player_burstFireCooldown", .2);

	self SetClientDvar("player_enduranceSpeedScale", 1.1);

	// look up and down 90 degrees
	// can't set to exactly 90 or else looking completely up or down will cause the player to move in the opposite direction
	self setClientDvar( "player_view_pitch_up", 89.9999 );
	self setClientDvar( "player_view_pitch_down", 89.9999 );

	// disable melee lunge
	self setClientDvar( "aim_automelee_enabled", 0 );

	// disable deadshot aim assist on controllers
	self setClientDvar( "aim_autoAimRangeScale", 0 );

	// disable names on cosmonaut
	self SetClientDvar("r_zombieNameAllowDevList", 0);
	self SetClientDvar("r_zombieNameAllowFriendsList", 0);

	// makes FPS area in corner smaller
	self SetClientDvar("cg_drawFPSLabels", 0);

	// Reimagined-Expanded, toggle cheats
	if(level.server_cheats)
	{
		self SetClientDvar("sv_cheats", 1,
							"zombie_cheat", 1);
	} else 
	{
		self SetClientDvar("sv_cheats", 0,
							"zombie_cheat", 0);
	}
	
	

	// allows shooting while looking at players
	self SetClientDvar("g_friendlyFireDist", 0);

	// dtp buffs
	self SetClientDvars("dtp_post_move_pause", 0,
		"dtp_exhaustion_window", 100,
		"dtp_startup_delay", 100);

	// set minimum fov (so sniper scopes dont go below this)
	self SetClientDvar("cg_fovMin", 30);

	// remove hold breath and variable zoom hintstrings when scoped in
	self SetClientDvar("cg_drawBreathHint", 0);

	self SetClientDvar("hud_enemy_counter_value", "");
	self SetClientDvar("hud_total_time", "");
	self SetClientDvar("hud_round_time", "");
	self SetClientDvar("hud_round_total_time", "");
	self SetClientDvar("hud_zone_name", "");
	self SetClientDvar("hitmarker_x", "");

	// reset versus HUD dvars
	self SetClientDvar("vs_logo_on", 0);
	self SetClientDvar("vs_top_logos_on", 0);
	self SetClientDvar("vs_top_playernames_on", 0);
	self SetClientDvar("vs_counter_friendly_on", 0);
	self SetClientDvar("vs_counter_enemy_on", 0);
	self SetClientDvar("vs_counter_friendly_num_on", 0);
	self SetClientDvar("vs_counter_enemy_num_on", 0);
	self SetClientDvar("vs_friendly_playername", "");
	self SetClientDvar("vs_enemy_playername", "");

	// ammo on HUD never fades away
	self SetClientDvar("hud_fade_ammodisplay", 0);

	//Fog Off
	self SetClientDvar("r_fog_settings", 1);

	//Reimagined-Expanded, baby perks go over health bar
	self SetClientDvar("perk_bar_00", "");
	self SetClientDvar("perk_bar_01", "");
	self SetClientDvar("perk_bar_02", "");
	self SetClientDvar("perk_bar_03", "");

	//Reimagined-Expanded, player perks
	self SetClientDvar("perk_slot_00", "");
	self SetClientDvar("perk_slot_01", "");
	self SetClientDvar("perk_slot_02", "");
	self SetClientDvar("perk_slot_03", "");
	self SetClientDvar("perk_slot_04", "");
	self SetClientDvar("perk_slot_05", "");
	self SetClientDvar("perk_slot_06", "");
	self SetClientDvar("perk_slot_07", "");
	self SetClientDvar("perk_slot_08", "");
	self SetClientDvar("perk_slot_09", "");
	self SetClientDvar("perk_slot_10", "");
	self SetClientDvar("perk_slot_11", "");
	self SetClientDvar("perk_slot_12", "");
	self SetClientDvar("perk_slot_13", "");
	self SetClientDvar("perk_slot_14", "");

	self SetClientDvar( "ui_hud_perk_hints", 1 );
}



checkForAllDead()
{
	players = get_players();

	//in grief, if all players left are on the same team then end the game
	if(level.gamemode != "survival")
	{
		team = players[0].vsteam;
		all_same_team = true;

		for( i = 1; i < players.size; i++ )
		{
			if( players[i].vsteam != team )
			{
				all_same_team = false;
				break;
			}
		}

		if(all_same_team)
		{
			level.vs_winning_team = team;
			level notify( "end_game" );
			return;
		}
	}

	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( !(players[i] maps\_laststand::player_is_in_laststand()) && !(players[i].sessionstate == "spectator") )
		{
			count++;
		}
	}

	if( count==0 )
	{
		if(level.gamemode == "survival")
		{
			level notify( "end_game" );
		}
		else
		{
			if(level.gamemode != "race" && level.gamemode != "gg")
			{
				level.last_player_alive = self;
				level thread maps\_zombiemode_grief::round_restart();
			}
		}
	}
}


onPlayerDisconnect()
{
	self waittill( "disconnect" );
	self remove_from_spectate_list();
	self checkForAllDead();

	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread character_names_hud();
	}
}

onPlayerDowned()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill("player_downed");

		//Reimagined-Expanded Down penalty
		if(level.apocalypse && !flag( "solo_game" ) )
			self thread laststand_points_penalty();

		if(level.gamemode != "survival" && get_number_of_valid_players() > 0)
		{
			if(level.gamemode != "race" && level.gamemode != "gg" && level.gamemode != "snr")
			{
				players = get_players();
				for(i = 0; i < players.size; i++)
				{
					// only show grief message from a down if there are no other enemies still alive
					if(players[i].vsteam != self.vsteam && players[i] maps\_zombiemode_grief::get_number_of_valid_enemy_players() == 0)
					{
						players[i] thread maps\_zombiemode_grief::grief_msg();
					}
				}
			}

			if(level.gamemode == "snr")
			{
				if((level.vsteams == "ffa" && self maps\_zombiemode_grief::get_number_of_valid_enemy_players() <= 1) || (level.vsteams != "ffa" && self maps\_zombiemode_grief::get_number_of_valid_friendly_players() == 0))
				{
					level thread maps\_zombiemode_grief::snr_round_win();
				}
			}
		}

		if((level.gamemode == "grief" || level.gamemode == "snr") && level.vsteams == "ffa" && get_players().size > 1)
		{
			self thread maps\_zombiemode_grief::instant_bleedout();
		}

		if(level.gamemode == "race" || level.gamemode == "gg")
		{
			self thread maps\_zombiemode_grief::auto_revive_after_time();
		}

		if(level.gamemode == "gg")
		{
			if(self.gg_wep_num > 0)
			{
				self.gg_wep_num--;
				self maps\_zombiemode_grief::update_gungame_hud();
			}
			else
			{
				self.gg_kill_count = 0;
			}

			self.player_bought_pack = undefined;

			pap_trigger = GetEntArray("zombie_vending_upgrade", "targetname");
			for(i=0;i<pap_trigger.size;i++)
			{
				if(IsDefined(pap_trigger[i].user) && pap_trigger[i].user == self)
				{
					pap_trigger[i] notify("pap_force_timeout");
				}
			}
		}
	}
}

Laststand_points_penalty()
{
	self endon ("player_revived");
	self endon ("death");
	self endon ("disconnect");

	//While player not revived, all players lose points
	if( !isdefined( self.bleedout_time ) ) {
		//iprintln("Player not bleeding out");
		return;
	}

	count = 0;
	players = get_players();
	while( self.bleedout_time > 0 )
	{
		
		wait ( level.VALUE_PLAYER_DOWNED_PENALTY_INTERVAL );

		//Skip points penalty if someone has QRV_PRO and can reive player
		skipPointsPenalty = false;
		for ( i = 0; i < players.size; i++ ) {
			if ( players[i] hasProPerk( level.QRV_PRO ) && players[i] maps\_laststand::can_revive( self ) ) {
				skipPointsPenalty = true;
				break;
			}
		}

		if ( skipPointsPenalty )
			continue;
		

		for ( i = 0; i < players.size; i++ ) {
			penalty = level.VALUE_PLAYER_DOWNED_PENALTY * ( level.players_size - 1 );
			if( players[i].score > penalty )
				players[i] maps\_zombiemode_score::minus_to_player_score( penalty );
		}	
		
	}

}

onPlayerDeath()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill("bled_out");

		if(level.gamemode != "survival" && get_number_of_valid_players() > 0)
		{
			players = get_players();
			for(i = 0; i < players.size; i++)
			{
				// only show grief message from a bleed out if there are other enemies still alive
				if(players[i].vsteam != self.vsteam && players[i] maps\_zombiemode_grief::get_number_of_valid_enemy_players() > 0)
				{
					players[i] thread maps\_zombiemode_grief::grief_msg();
				}

				if(players[i].vsteam == self.vsteam && players[i] maps\_zombiemode_grief::get_number_of_valid_friendly_players() == 0)
				{
					//players[i] playlocalsound( "vs_solo" );
				}
			}
		}

		self.knife_index = 0;
	}
}

//
//	Runs when the player spawns into the map
//	self is the player.surprise!
//
onPlayerSpawned()
{
	self endon( "disconnect" );

	for( ;; )
	{
		self waittill( "spawned_player" );

		self freezecontrols( true );

		self init_player_offhand_weapons();

		if(!flag("round_restarting"))
		{
			self thread give_starting_weapon("m1911_zm");
			self thread set_melee_weapons();
		}

		self enablehealthshield( false );
/#
		if ( GetDvarInt( #"zombie_cheat" ) >= 1 && GetDvarInt( #"zombie_cheat" ) <= 3 )
		{
			self EnableInvulnerability();
		}
#/

		self PlayerKnockback( false );

		self SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "90",
			"cg_thirdPersonAngle", "0",
			"ui_show_mule_wep_indicator", "0",
			"ui_show_stamina_ghost_indicator", "0" );
		
		if(level.gamemode == "snr" || level.gamemode == "race" || level.gamemode == "gg")
		{
			self SetClientDvar("hud_enemy_counter_on_game", 0);
		}
		else
		{
			self SetClientDvar("hud_enemy_counter_on_game", 1);
		}

		if( level.mapname == "zombie_cod5_factory")
			self thread delay_hud_setup(12);
		else
			self thread delay_hud_setup(0.1);
		

		self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );

		self cameraactivate(false);

		self add_to_spectate_list();

		self.num_perks = 0;
		self.on_lander_last_stand = undefined;

		if ( is_true( level.player_out_of_playable_area_monitor ) )
		{
			self thread player_out_of_playable_area_monitor();
		}

		if ( is_true( level.player_too_many_weapons_monitor ) )
		{
			self thread [[level.player_too_many_weapons_monitor_func]]();
		}

		self thread remove_idle_sway();

		self send_message_to_csc("hud_anim_handler", "hud_mule_wep_out");

		//self thread revive_grace_period();

		self.move_speed = 1;

		//self SetPerk("specialty_unlimitedsprint");

		if( isdefined( self.initialized ) )
		{
			if( self.initialized == false )
			{
				self.initialized = true;

				self freezecontrols( true ); // first spawn only, intro_black_screen will pull them out of it

				// ww: set the is_drinking variable
				self.is_drinking = 0;

				// set the initial score on the hud
				self maps\_zombiemode_score::set_player_score_hud( true );
				self thread player_zombie_breadcrumb();

				// This will keep checking to see if you're trying to use an ability.
				//self thread maps\_zombiemode_ability::hardpointItemWaiter();

				//self thread maps\_zombiemode_ability::hardPointItemSelector();

				//Init stat tracking variables
				self.stats["kills"] = 0;
				self.stats["score"] = 0;
				self.stats["downs"] = 0;
				self.stats["revives"] = 0;
				self.stats["perks"] = 0;
				self.stats["headshots"] = 0;
				self.stats["zombie_gibs"] = 0;

				//track damage taken by this player
				self.stats["damage_taken"] = 0;

				//track player distance traveled
				self.stats["distance_traveled"] = 0;
				self thread player_monitor_travel_dist();

				self thread player_grenade_watcher();

				self thread fall_velocity_check();

				self thread player_gravity_fix();

				self thread health_bar_hud();

				self thread character_names_hud();

				self thread zone_hud();

				self thread grenade_hud();
			}
			else
			{
				self thread unfreeze_controls_after_frame();
			}
		}
	}
}

delay_hud_setup( delay )
{
	wait( delay );
	self setClientDvar("hud_health_bar_on_game", 1);
	self setClientDvar("hud_timer_on_game", 1);
	self setClientDvar("hud_zone_name_on_game", 1);
	self setClientDvar("hud_character_names_on_game", 1);
}

// unfreeze after a frame so players cant become "frozen" when spawning in if they are holding attack button
unfreeze_controls_after_frame()
{
	wait_network_frame();
	self FreezeControls( false );
}

give_starting_weapon(wep)
{
	self GiveWeapon( wep );
	self GiveStartAmmo( wep );
	wait_network_frame();
	self SwitchToWeapon( wep );
}

set_melee_weapons()
{

	if( !flag("round_restarting") )
	{
		wait_network_frame();
	}

	self.current_melee_weapon = "rebirth_hands_sp";
	self.offhand_melee_weapon = "knife_zm";
	offhand_equipment = "combat_" + self.offhand_melee_weapon;	//offhand knife

	self GiveWeapon( "vorkuta_knife_sp" );						//offhand punch
	self SetActionSlot(2, "weapon",  offhand_equipment );

	if( !self HasWeapon( offhand_equipment ) )
		self GiveWeapon( offhand_equipment );

	if( !self HasWeapon( self.current_melee_weapon ) )
		self GiveWeapon( self.current_melee_weapon );
	
	self set_player_melee_weapon( self.current_melee_weapon );

}

spawn_life_brush( origin, radius, height )
{
	life_brush = spawn( "trigger_radius", origin, 0, radius, height );
	life_brush.script_noteworthy = "life_brush";

	return life_brush;
}


in_life_brush()
{
	life_brushes = getentarray( "life_brush", "script_noteworthy" );

	if ( !IsDefined( life_brushes ) )
	{
		return false;
	}

	for ( i = 0; i < life_brushes.size; i++ )
	{

		if ( self IsTouching( life_brushes[i] ) )
		{
			return true;
		}
	}

	return false;
}


spawn_kill_brush( origin, radius, height )
{
	kill_brush = spawn( "trigger_radius", origin, 0, radius, height );
	kill_brush.script_noteworthy = "kill_brush";

	return kill_brush;
}


in_kill_brush()
{
	kill_brushes = getentarray( "kill_brush", "script_noteworthy" );

	if ( !IsDefined( kill_brushes ) )
	{
		return false;
	}

	for ( i = 0; i < kill_brushes.size; i++ )
	{

		if ( self IsTouching( kill_brushes[i] ) )
		{
			return true;
		}
	}

	return false;
}


in_enabled_playable_area()
{
	playable_area = getentarray( "player_volume", "script_noteworthy" );

	if( !IsDefined( playable_area ) )
	{
		return false;
	}

	for ( i = 0; i < playable_area.size; i++ )
	{
		if ( maps\_zombiemode_zone_manager::zone_is_enabled( playable_area[i].targetname ) && self IsTouching( playable_area[i] ) )
		{
			return true;
		}
	}

	return false;
}


get_player_out_of_playable_area_monitor_wait_time()
{
/#
	if ( is_true( level.check_kill_thread_every_frame ) )
	{
		return 0.05;
	}
#/

	return 3;
}


player_out_of_playable_area_monitor()
{
	self notify( "stop_player_out_of_playable_area_monitor" );
	self endon( "stop_player_out_of_playable_area_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );

	// load balancing
	wait( (0.15 * self GetEntityNumber()) );

	while ( true )
	{
		// skip over players in spectate, otherwise Sam keeps laughing every 3 seconds since their corpse is still invisibly in a kill area
		if ( self.sessionstate == "spectator" )
		{
			wait( get_player_out_of_playable_area_monitor_wait_time() );
			continue;
		}

		if(is_true(self.inteleportation) || is_true(self.in_elevator))
		{
			wait( get_player_out_of_playable_area_monitor_wait_time() );
			continue;
		}

		if ( !self in_life_brush() && (self in_kill_brush() || !self in_enabled_playable_area()) )
		{
			if ( !isdefined( level.player_out_of_playable_area_monitor_callback ) || self [[level.player_out_of_playable_area_monitor_callback]]() )
			{
/#
				//iprintlnbold( "out of playable" );
				if ( isdefined( self isinmovemode( "ufo", "noclip" ) ) || is_true( level.disable_kill_thread ) || GetDvarInt( "zombie_cheat" ) > 0 )
				{
					wait( get_player_out_of_playable_area_monitor_wait_time() );
					continue;
				}
#/
 				if( is_true( level.player_4_vox_override ) )
				{
					self playlocalsound( "zmb_laugh_rich" );
				}
				else
				{
					self playlocalsound( "zmb_laugh_child" );
				}

				wait( 0.5 );

				if ( getplayers().size == 1 && flag( "solo_game" ) && is_true( self.waiting_to_revive ) )
				{
					level notify( "end_game" );
				}
				else
				{
					self.lives = 0;
					self dodamage( self.health + 1000, self.origin );
					self.bleedout_time = 0;
				}
			}
		}

		wait( get_player_out_of_playable_area_monitor_wait_time() );
	}
}


get_player_too_many_weapons_monitor_wait_time()
{
	return 3;
}


player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take )
{
	self endon( "player_too_many_weapons_monitor_takeaway_sequence_done" );

	self waittill_any( "player_downed", "replace_weapon_powerup" );

	for ( i = 0; i < primary_weapons_to_take.size; i++ )
	{
		self TakeWeapon( primary_weapons_to_take[i] );
	}

	self maps\_zombiemode_score::minus_to_player_score( self.score );
	self GiveWeapon( "m1911_zm" );
	if ( !self maps\_laststand::player_is_in_laststand() )
	{
		self decrement_is_drinking();
	}
	else if ( flag( "solo_game" ) )
	{
		self.score_lost_when_downed = 0;
	}

	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
}


player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take )
{
	self thread player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take );

	self endon( "player_downed" );
	self endon( "replace_weapon_powerup" );

	self increment_is_drinking();
	score_decrement = round_up_to_ten( int( self.score / (primary_weapons_to_take.size + 1) ) );

	for ( i = 0; i < primary_weapons_to_take.size; i++ )
	{
		if( is_true( level.player_4_vox_override ) )
		{
			self playlocalsound( "zmb_laugh_rich" );
		}
		else
		{
			self playlocalsound( "zmb_laugh_child" );
		}
		self SwitchToWeapon( primary_weapons_to_take[i] );
		self maps\_zombiemode_score::minus_to_player_score( score_decrement );
		wait( 3 );

		self TakeWeapon( primary_weapons_to_take[i] );
	}

	if( is_true( level.player_4_vox_override ) )
	{
		self playlocalsound( "zmb_laugh_rich" );
	}
	else
	{
		self playlocalsound( "zmb_laugh_child" );
	}
	self maps\_zombiemode_score::minus_to_player_score( self.score );
	wait( 1 );
	self GiveWeapon( "m1911_zm" );
	self SwitchToWeapon( "m1911_zm" );
	self decrement_is_drinking();

	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
}


player_too_many_weapons_monitor()
{
	self notify( "stop_player_too_many_weapons_monitor" );
	self endon( "stop_player_too_many_weapons_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );

	// load balancing
	wait( (0.15 * self GetEntityNumber()) );

	while ( true )
	{
		if ( self has_powerup_weapon() || self maps\_laststand::player_is_in_laststand() || self.sessionstate == "spectator" )
		{
			wait( get_player_too_many_weapons_monitor_wait_time() );
			continue;
		}

/#
		if ( GetDvarInt( "zombie_cheat" ) > 0 )
		{
			wait( get_player_too_many_weapons_monitor_wait_time() );
			continue;
		}
#/

		primary_weapons_to_take = [];
		weapon_limit = 2;
		if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
		{
			weapon_limit = 3;
		}

		primaryWeapons = self GetWeaponsListPrimaries();
		for ( i = 0; i < primaryWeapons.size; i++ )
		{
			if ( maps\_zombiemode_weapons::is_weapon_included( primaryWeapons[i] ) || maps\_zombiemode_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
			{
				primary_weapons_to_take[primary_weapons_to_take.size] = primaryWeapons[i];
			}
		}

		if ( primary_weapons_to_take.size > weapon_limit )
		{
			if(self GetCurrentWeapon() == primary_weapons_to_take[primary_weapons_to_take.size - 1])
			{
				self SwitchToWeapon(primary_weapons_to_take[0]);
			}
			self TakeWeapon(primary_weapons_to_take[primary_weapons_to_take.size - 1]);
			/*if ( !isdefined( level.player_too_many_weapons_monitor_callback ) || self [[level.player_too_many_weapons_monitor_callback]]( primary_weapons_to_take ) )
			{
				self thread player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take );
				self waittill( "player_too_many_weapons_monitor_takeaway_sequence_done" );
			}*/
		}

		wait( get_player_too_many_weapons_monitor_wait_time() );
	}
}


player_monitor_travel_dist()
{
	self endon("disconnect");

	prevpos = self.origin;
	while(1)
	{
		wait .1;

		self.stats["distance_traveled"] += distance( self.origin, prevpos );
		prevpos = self.origin;
	}
}

player_grenade_watcher()
{
	self endon( "disconnect" );

	while ( 1 )
	{
		self waittill( "grenade_fire", grenade, weapName );

		if( isdefined( grenade ) && isalive( grenade ) )
		{
			grenade.team = self.team;
		}

		// disable grenades for a short period after just throwing a grenade
		// to fix a bug that caused players to be able to throw a second grenade faster than intended
		if(is_lethal_grenade(weapName) || is_tactical_grenade(weapName))
		{
			self thread temp_disable_offhand_weapons();
		}
	}
}

temp_disable_offhand_weapons()
{
	self endon( "disconnect" );

	self DisableOffhandWeapons();
	while(self IsThrowingGrenade())
		wait_network_frame();
	self EnableOffhandWeapons();
}

player_prevent_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if ( eInflictor == self || eAttacker == self )
	{
		return false;
	}

	if ( isdefined( eInflictor ) && isdefined( eInflictor.team ) )
	{
		if ( eInflictor.team == self.team )
		{
			return true;
		}
	}

	return false;
}

//
//	Keep track of players going down and getting revived
player_revive_monitor()
{
	self endon( "disconnect" );

	while (1)
	{
		self waittill( "player_revived", reviver );

        //AYERS: Working on Laststand Audio
        //self clientnotify( "revived" );

		bbPrint( "zombie_playerdeaths: round %d playername %s deathtype revived x %f y %f z %f", level.round_number, self.playername, self.origin );

		//self laststand_giveback_player_perks();

		if ( IsDefined(reviver) )
		{
			self maps\_zombiemode_audio::create_and_play_dialog( "general", "revive_up" );

			//reviver maps\_zombiemode_rank::giveRankXp( "revive" );
			//maps\_zombiemode_challenges::doMissionCallback( "zm_revive", reviver );

			// Check to see how much money you lost from being down.
			points = self.score_lost_when_downed;
			reviver maps\_zombiemode_score::player_add_points( "reviver", points );
			self.score_lost_when_downed = 0;

			//Reimagined-Expanded - Quickrevive Pro bonus
			if( reviver hasProPerk(level.QRV_PRO))
			{
				self thread maps\sb_bo2_zombie_blood_powerup::zombie_blood_powerup( self, 10 );
			}
		}

		wait_network_frame();

		if(level.gamemode == "gg")
		{
			self maps\_zombiemode_grief::update_gungame_weapon(true);
		}
		else if(!maps\_zombiemode_weapons::is_weapon_included( self GetCurrentWeapon() ) && !maps\_zombiemode_weapons::is_weapon_upgraded( self GetCurrentWeapon() ))
		{
			primaryWeapons = self GetWeaponsListPrimaries();
			for ( i = 0; i < primaryWeapons.size; i++ )
			{
				if ( maps\_zombiemode_weapons::is_weapon_included( primaryWeapons[i] ) || maps\_zombiemode_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
				{
					self SwitchToWeapon(primaryWeapons[i]);
					break;
				}
			}
		}
	}
}


// self = a player
// If the player has just 1 perk, they wil always get it back
// If the player has more than 1 perk, they will lose a single perk
laststand_giveback_player_perks()
{
	if ( IsDefined( self.laststand_perks ) )
	{
		// Calculate a lost perk index
		lost_perk_index = int( -1 );
		if( self.laststand_perks.size > 1 )
		{
			lost_perk_index = RandomInt( self.laststand_perks.size-1 );
		}

		// Give the player back their perks
		for ( i=0; i<self.laststand_perks.size; i++ )
		{
			if ( self HasPerk( self.laststand_perks[i] ) )
			{
				continue;
			}
			if( i == lost_perk_index )
			{
				continue;
			}

			maps\_zombiemode_perks::give_perk( self.laststand_perks[i] );
		}
	}
}

remote_revive_watch()
{
	self endon( "death" );
	self endon( "player_revived" );

	self waittill( "remote_revive", reviver );

	self maps\_laststand::remote_revive( reviver );
}

remove_deadshot_bottle()
{
	wait( 0.05 );

	if ( isdefined( self.lastActiveWeapon ) && self.lastActiveWeapon == "zombie_perk_bottle_deadshot" )
	{
		self.lastActiveWeapon = "none";
	}
}

take_additionalprimaryweapon()
{
	weapon_to_take = [];

	if ( is_true( self._retain_perks ) )
	{
		return weapon_to_take;
	}

	//check to see if any weapon slots are empty
	count = 0;
	for(i=0;i<self.weapon_slots.size;i++)
	{
		if(self.weapon_slots[i] != "none")
		{
			count++;
		}
	}
	if( count < 3 )
	{
		return weapon_to_take;
	}

	weapon_to_take[0] = self.weapon_slots[self.weapon_slots.size - 1];
	weapon_to_take[1] = self GetWeaponAmmoClip(weapon_to_take[0]);
	weapon_to_take[2] = self GetWeaponAmmoStock(weapon_to_take[0]);

	self TakeWeapon( weapon_to_take[0] );

	return weapon_to_take;

	/*primary_weapons_that_can_be_taken = [];

	primaryWeapons = self GetWeaponsListPrimaries();
	for ( i = 0; i < primaryWeapons.size; i++ )
	{
		if((primaryWeapons[i] == "tesla_gun_zm" || primaryWeapons[i] == "tesla_gun_upgraded_zm") && IsDefined(self.has_tesla) && self.has_tesla)
		{
			continue;
		}

		if ( maps\_zombiemode_weapons::is_weapon_included( primaryWeapons[i] ) || maps\_zombiemode_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
		{
			primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryWeapons[i];
		}
	}

	if ( primary_weapons_that_can_be_taken.size >= 3 )
	{
		weapon_to_take[0] = primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size - 1];
		if ( weapon_to_take[0] == self GetCurrentWeapon() )
		{
			self SwitchToWeapon( primary_weapons_that_can_be_taken[0] );
		}
		weapon_to_take[1] = self GetWeaponAmmoClip(weapon_to_take[0]);
		weapon_to_take[2] = self GetWeaponAmmoStock(weapon_to_take[0]);
		dual_wield_name = WeaponDualWieldWeaponName( weapon_to_take[0] );
		if ( "none" != dual_wield_name )
		{
			weapon_to_take[3] = self GetWeaponAmmoClip(dual_wield_name);
		}
		//self.weapon_taken_by_losing_specialty_additionalprimaryweapon_clip_ammo = self GetWeaponAmmoClip(weapon_to_take);
		//self.weapon_taken_by_losing_specialty_additionalprimaryweapon_stock_ammo = self GetWeaponAmmoStock(weapon_to_take);
		self TakeWeapon( weapon_to_take[0] );
	}

	return weapon_to_take;*/
}

store_additionalprimaryweapon(weapon)
{
	self endon("bled_out");
	self endon("perk_boughtspecialty_additionalprimaryweapon" );

	if(!IsDefined(weapon[0]))
		return;

	while(1)
	{
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon = weapon[0];
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon_clip_ammo = weapon[1];
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon_stock_ammo = weapon[2];
		wait .05;
	}
}

player_laststand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	// Grab the perks, we'll give them back to the player if he's revived
	//self.laststand_perks = maps\_zombiekmode_deathcard::deathcard_save_perks( self );

	self thread revive_waypoint();

 	if ( self HasPerk( "specialty_additionalprimaryweapon" ) && !(self hasProPerk(level.MUL_PRO)) )
 	{
 		//must take weapon from here if downed, does not take weapon correctly if called in _zombiemode_perks::perk_think()
 		self.weapon_taken_by_losing_additionalprimaryweapon = self maps\_zombiemode::take_additionalprimaryweapon();
 	}

	//AYERS: Working on Laststand Audio
	/*
	players = get_players();
	if( players.size >= 2 )
	{
	    self clientnotify( "lststnd" );
	}
	*/

		//if ( IsDefined( level.deathcard_laststand_func ) )
	//{
	//	self [[ level.deathcard_laststand_func ]]();
	//}
	self clear_is_drinking();

	self thread remove_deadshot_bottle();

	self thread remote_revive_watch();

	self maps\_zombiemode_score::player_downed_penalty();

	// Turns out we need to do this after all, but we don't want to change _laststand.gsc postship, so I'm doing it here manually instead
	self DisableOffhandWeapons();

	self thread last_stand_grenade_save_and_return();

	if( sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_FALLING" )
	{
	    self maps\_zombiemode_audio::create_and_play_dialog( "general", "revive_down" );
	}

	bbPrint( "zombie_playerdeaths: round %d playername %s deathtype downed x %f y %f z %f", level.round_number, self.playername, self.origin );

	if( IsDefined( level._zombie_minigun_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_minigun_powerup_last_stand_func]]();
	}

	if( IsDefined( level._zombie_tesla_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_tesla_powerup_last_stand_func]]();
	}

	if( IsDefined( level._zombie_meat_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_meat_powerup_last_stand_func]]();
	}

	if( IsDefined( self.intermission ) && self.intermission )
	{
		//maps\_zombiemode_challenges::doMissionCallback( "playerDied", self );

		bbPrint( "zombie_playerdeaths: round %d playername %s deathtype died x %f y %f z %f", level.round_number, self.playername, self.origin );

		level waittill( "forever" );
	}
}


failsafe_revive_give_back_weapons()
{
	for ( i = 0; i < 10; i++ )
	{
		wait( 0.05 );

		if ( !isdefined( self.reviveProgressBar ) )
		{
			continue;
		}

		players = get_players();
		for ( playerIndex = 0; playerIndex < players.size; playerIndex++ )
		{
			revivee = players[playerIndex];

			if ( self maps\_laststand::is_reviving( revivee ) )
			{
				// don't clean up revive stuff if he is reviving someone else
				continue;
			}
		}

		// he's not reviving anyone but he still has revive stuff up, clean it all up
/#
//iprintlnbold( "FAILSAFE CLEANING UP REVIVE HUD AND GUN" );
#/
		// pass in "none" since we have no idea what the weapon they should be showing is
		self maps\_laststand::revive_give_back_weapons( "none" );

		if ( isdefined( self.reviveProgressBar ) )
		{
			self.reviveProgressBar maps\_hud_util::destroyElem();
		}

		if ( isdefined( self.reviveTextHud ) )
		{
			self.reviveTextHud destroy();
		}

		return;
	}
}


spawnSpectator()
{
	self endon( "disconnect" );
	self endon( "spawned_spectator" );
	self notify( "spawned" );
	self notify( "end_respawn" );


	if( level.intermission )
	{
		return;
	}

	if( IsDefined( level.no_spectator ) && level.no_spectator )
	{
		wait( 3 );
		ExitLevel();
	}

	// The check_for_level_end looks for this
	self.is_zombie = true;

	//failsafe against losing viewarms due to the thread returning them getting an endon from "zombified"
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		if ( self != players[i] )
		{
			players[i] thread failsafe_revive_give_back_weapons();
		}
	}

	// Remove all reviving abilities
	self notify ( "zombified" );

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}

	self.zombification_time = GetTime(); //set time when player died

	resetTimeout();

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );

	self.sessionstate = "spectator";
	self.spectatorclient = -1;

	self remove_from_spectate_list();

	self.maxhealth = self.health;
	self.shellshocked = false;
	self.inWater = false;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = GetTime();
	self.afk = false;

	self SetElectrified(0);
	self SetBurn(0);
	self SetBlur(0);

	self setClientDvar("hud_health_bar_on_game", 0);
	self setClientDvar("hud_zone_name_on_game", 0);

	println( "*************************Zombie Spectator***" );
	self detachAll();

	self setSpectatePermissions( true );
	self thread spectator_thread();

	self Spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
}

setSpectatePermissions( isOn )
{
	self AllowSpectateTeam( "allies", isOn );
	self AllowSpectateTeam( "axis", false );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", false );
}

spectator_thread()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );

/*	we are not currently supporting the shared screen tech
	if( IsSplitScreen() )
	{
		last_alive = undefined;
		players = get_players();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, true );

		return;
	}
*/

//	self thread spectator_toggle_3rd_person();
}

spectator_toggle_3rd_person()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );

	third_person = true;
	self set_third_person( true );
	//	self NotifyOnCommand( "toggle_3rd_person", "weapnext" );

	//	while( 1 )
	//	{
	//		self waittill( "toggle_3rd_person" );
	//
	//		if( third_person )
	//		{
	//			third_person = false;
	//			self set_third_person( false );
	//			wait( 0.5 );
	//		}
	//		else
	//		{
	//			third_person = true;
	//			self set_third_person( true );
	//			wait( 0.5 );
	//		}
	//	}
}


set_third_person( value )
{
	if( value )
	{
		self SetClientDvars( "cg_thirdPerson", "1",
			"cg_fov", "40",
			"cg_thirdPersonAngle", "354" );

		self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
	}
	else
	{
		self SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "90",
			"cg_thirdPersonAngle", "0" );

		self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
	}
}

last_stand_revive()
{
	level endon( "between_round_over" );

	players = getplayers();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] maps\_laststand::player_is_in_laststand() && players[i].revivetrigger.beingRevived == 0 )
		{
			players[i] maps\_laststand::auto_revive();
		}
	}
}

// ww: arrange the last stand pistols so when it come time to choose which one they are inited
last_stand_pistol_rank_init()
{
	level.pistol_values = [];

	flag_wait( "_start_zm_pistol_rank" );

	if( flag( "solo_game" ) )
	{
		// ww: in a solo game the ranking of the pistols is a bit different based on the upgraded 1911 swap
		// any pistol ranked 4 or lower will be ignored and the player will be given the upgraded 1911
		level.pistol_values[ level.pistol_values.size ] = "m1911_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm"; // ww: this is spot 4, anything scoring lower than this should be replaced
		level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "m1911_upgraded_zm";
		//Reimagined-Expanded - new pistols
		level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm_x2";
		level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm_x2";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm_x2";
		
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_zm";
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_upgraded_zm";
	}
	else
	{
		level.pistol_values[ level.pistol_values.size ] = "m1911_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_zm";
		level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "m1911_upgraded_zm";
		//Reimagined-Expanded - new pistols
		level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm_x2";
		level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm_x2";
		level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm_x2";
		
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_zm";
		level.pistol_values[ level.pistol_values.size ] = "ray_gun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "freezegun_upgraded_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_zm";
		level.pistol_values[ level.pistol_values.size ] = "microwavegundw_upgraded_zm";
	}

}

// ww: changing the _laststand scripts to this one so we interfere with SP less
last_stand_pistol_swap()
{
	if ( self has_powerup_weapon() )
	{
		// this will force the laststand module to switch us to any primary weapon, since we will no longer have this after revive
		self.lastActiveWeapon = "none";
	}

	if ( !self HasWeapon( self.laststandpistol ) )
	{
		self GiveWeapon( self.laststandpistol, 0, self maps\_zombiemode_weapons::get_pack_a_punch_weapon_options( self.laststandpistol ) );
	}
	ammoclip = WeaponClipSize( self.laststandpistol );
	doubleclip = ammoclip * 2;

	if( is_true( self._special_solo_pistol_swap ) || (self.laststandpistol == "m1911_upgraded_zm" && !self.hadpistol) )
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = false;
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if( flag("solo_game") && self.laststandpistol == "m1911_upgraded_zm")
	{
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol == "m1911_zm" )
	{
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol == "ray_gun_zm" || self.laststandpistol == "ray_gun_upgraded_zm" )
	{
		if ( self.stored_weapon_info[ self.laststandpistol ].total_amt >= ammoclip )
		{
			self SetWeaponAmmoClip( self.laststandpistol, ammoclip );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = ammoclip;
		}
		else
		{
			self SetWeaponAmmoClip( self.laststandpistol, self.stored_weapon_info[ self.laststandpistol ].total_amt );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = self.stored_weapon_info[ self.laststandpistol ].total_amt;
		}
		self SetWeaponAmmoStock( self.laststandpistol, 0 );
	}
	else
	{
		if ( self.stored_weapon_info[ self.laststandpistol ].stock_amt >= doubleclip )
		{
			self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = doubleclip + self.stored_weapon_info[ self.laststandpistol ].clip_amt + self.stored_weapon_info[ self.laststandpistol ].left_clip_amt;
		}
		else
		{
			self SetWeaponAmmoStock( self.laststandpistol, self.stored_weapon_info[ self.laststandpistol ].stock_amt );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = self.stored_weapon_info[ self.laststandpistol ].total_amt;
		}
	}

	self SwitchToWeapon( self.laststandpistol );
}

// ww: make sure the player has the best pistol when they go in to last stand
last_stand_best_pistol()
{
	pistol_array = [];

	current_weapons = self GetWeaponsListPrimaries();

	for( i = 0; i < current_weapons.size; i++ )
	{
		// make sure the weapon is a pistol
		if( WeaponClass( current_weapons[i] ) == "pistol" )
		{
			if (  (current_weapons[i] != "m1911_zm" && !flag("solo_game") )  || (!flag("solo_game") && current_weapons[i] != "m1911_upgraded_zm" ))
			{

				if ( self GetAmmoCount( current_weapons[i] ) <= 0 )
				{
					continue;
				}
			}

			pistol_array_index = pistol_array.size; // set up the spot in the array
			pistol_array[ pistol_array_index ] = SpawnStruct(); // struct to store info on

			pistol_array[ pistol_array_index ].gun = current_weapons[i];
			pistol_array[ pistol_array_index ].value = 0; // add a value in case a new weapon is introduced that hasn't been set up in level.pistol_values

			// compare the current weapon to the level.pistol_values to see what the value is
			for( j = 0; j < level.pistol_values.size; j++ )
			{
				if( level.pistol_values[j] == current_weapons[i] )
				{
					pistol_array[ pistol_array_index ].value = j;
					break;
				}
			}
		}
	}

	self.laststandpistol = last_stand_compare_pistols( pistol_array );
}

// ww: compares the array passed in for the highest valued pistol
last_stand_compare_pistols( struct_array )
{
	if( !IsArray( struct_array ) || struct_array.size <= 0 )
	{
		self.hadpistol = false;

		//array will be empty if the pistol had no ammo...so lets see if the player had the pistol
		if(isDefined(self.stored_weapon_info))
		{
			stored_weapon_info = GetArrayKeys( self.stored_weapon_info );
			for( j = 0; j < stored_weapon_info.size; j++ )
			{
				if( stored_weapon_info[ j ] == level.laststandpistol)
				{
					self.hadpistol = true;
				}
			}
		}

		return level.laststandpistol; // nothing in the array then give the level last stand pistol
	}

	highest_score_pistol = struct_array[0]; // first time through give the first one to the highest score

	for( i = 1; i < struct_array.size; i++ )
	{
		if( struct_array[i].value > highest_score_pistol.value )
		{
			highest_score_pistol = struct_array[i];
		}
	}

	if( flag( "solo_game" ) )
	{
		self._special_solo_pistol_swap = 0; // ww: this way the weapon knows to pack texture when given
		if( highest_score_pistol.value <= 3 )
		{
			self.hadpistol = false;
			self._special_solo_pistol_swap = 1;
			return level.laststandpistol; // ww: if it scores too low the player gets the 1911 upgraded
		}
		else
		{
			return highest_score_pistol.gun; // ww: gun is high in ranking and won't be replaced
		}
	}
	else // ww: happens when not in solo
	{
		return highest_score_pistol.gun;
	}

}

// ww: override function for saving player pistol ammo count
last_stand_save_pistol_ammo()
{
	weapon_inventory = self GetWeaponsList();
	self.stored_weapon_info = [];

	for( i = 0; i < weapon_inventory.size; i++ )
	{
		weapon = weapon_inventory[i];

		if ( WeaponClass( weapon ) == "pistol" )
		{
			self.stored_weapon_info[ weapon ] = SpawnStruct();
			self.stored_weapon_info[ weapon ].clip_amt = self GetWeaponAmmoClip( weapon );
			self.stored_weapon_info[ weapon ].left_clip_amt = 0;
			dual_wield_name = WeaponDualWieldWeaponName( weapon );
			if ( "none" != dual_wield_name )
			{
				self.stored_weapon_info[ weapon ].left_clip_amt = self GetWeaponAmmoClip( dual_wield_name );
			}
			self.stored_weapon_info[ weapon ].stock_amt = self GetWeaponAmmoStock( weapon );
			self.stored_weapon_info[ weapon ].total_amt = self.stored_weapon_info[ weapon ].clip_amt + self.stored_weapon_info[ weapon ].left_clip_amt + self.stored_weapon_info[ weapon ].stock_amt;
			self.stored_weapon_info[ weapon ].given_amt = 0;
		}
	}

	self last_stand_best_pistol();
}

// ww: override to restore the player's pistol ammo after being picked up
last_stand_restore_pistol_ammo()
{
	//self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;

	if( !IsDefined( self.stored_weapon_info ) )
	{
		return;
	}

	weapon_inventory = self GetWeaponsList();
	weapon_to_restore = GetArrayKeys( self.stored_weapon_info );

	for( i = 0; i < weapon_inventory.size; i++ )
	{
		weapon = weapon_inventory[i];

		if ( weapon != self.laststandpistol )
		{
			continue;
		}

		for( j = 0; j < weapon_to_restore.size; j++ )
		{
			check_weapon = weapon_to_restore[j];

			if( weapon == check_weapon )
			{
				dual_wield_name = WeaponDualWieldWeaponName( weapon_to_restore[j] );
				if ( weapon != "m1911_zm" )
				{
					last_clip = self GetWeaponAmmoClip( weapon );
					last_left_clip = 0;
					if ( "none" != dual_wield_name )
					{
						last_left_clip = self GetWeaponAmmoClip( dual_wield_name );
					}
					last_stock = self GetWeaponAmmoStock( weapon );
					last_total = last_clip + last_left_clip + last_stock;

					used_amt = self.stored_weapon_info[ weapon ].given_amt - last_total;

					if ( used_amt >= self.stored_weapon_info[ weapon ].stock_amt )
					{
						used_amt -= self.stored_weapon_info[ weapon ].stock_amt;
						self.stored_weapon_info[ weapon ].stock_amt = 0;

						self.stored_weapon_info[ weapon ].clip_amt -= used_amt;
						if ( self.stored_weapon_info[ weapon ].clip_amt < 0 )
						{
							self.stored_weapon_info[ weapon ].clip_amt = 0;
						}
					}
					else
					{
						new_stock_amt = self.stored_weapon_info[ weapon ].stock_amt - used_amt;
						if ( new_stock_amt < self.stored_weapon_info[ weapon ].stock_amt )
						{
							self.stored_weapon_info[ weapon ].stock_amt = new_stock_amt;
						}
					}
				}

				self SetWeaponAmmoClip( weapon_to_restore[j], self.stored_weapon_info[ weapon_to_restore[j] ].clip_amt );
				if ( "none" != dual_wield_name )
				{
					self SetWeaponAmmoClip( dual_wield_name , self.stored_weapon_info[ weapon_to_restore[j] ].left_clip_amt );
				}
				self SetWeaponAmmoStock( weapon_to_restore[j], self.stored_weapon_info[ weapon_to_restore[j] ].stock_amt );
				break;
			}
		}
	}
}

// ww: changes the last stand pistol to the upgraded 1911s if it is solo
zombiemode_solo_last_stand_pistol()
{
	level.laststandpistol = "m1911_upgraded_zm";
}

// ww: zeros out the player's grenades until they revive
last_stand_grenade_save_and_return()
{
	self endon( "death" );

	lethal_nade_amt = 0;
	has_lethal_nade = false;
	tactical_nade_amt = 0;
	has_tactical_nade = false;

	// figure out which nades this player has
	weapons_on_player = self GetWeaponsList();
	for ( i = 0; i < weapons_on_player.size; i++ )
	{
		if ( self is_player_lethal_grenade( weapons_on_player[i] ) )
		{
			has_lethal_nade = true;
			lethal_nade_amt = self GetWeaponAmmoClip( self get_player_lethal_grenade() );
			self SetWeaponAmmoClip( self get_player_lethal_grenade(), 0 );
			self TakeWeapon( self get_player_lethal_grenade() );
		}
		else if ( self is_player_tactical_grenade( weapons_on_player[i] ) )
		{
			has_tactical_nade = true;
			tactical_nade_amt = self GetWeaponAmmoClip( self get_player_tactical_grenade() );
			self SetWeaponAmmoClip( self get_player_tactical_grenade(), 0 );
			self TakeWeapon( self get_player_tactical_grenade() );
		}
	}

	self waittill( "player_revived" );

	if ( has_lethal_nade )
	{
		self GiveWeapon( self get_player_lethal_grenade() );
		self SetWeaponAmmoClip( self get_player_lethal_grenade(), lethal_nade_amt );
	}

	if ( has_tactical_nade )
	{
		self GiveWeapon( self get_player_tactical_grenade() );
		self SetWeaponAmmoClip( self get_player_tactical_grenade(), tactical_nade_amt );
	}
}

spectators_respawn()
{
	level endon( "between_round_over" );

	if( !IsDefined( level.zombie_vars["spectators_respawn"] ) || !level.zombie_vars["spectators_respawn"] )
	{
		return;
	}

	if( !IsDefined( level.custom_spawnPlayer ) )
	{
		// Custom spawn call for when they respawn from spectator
		level.custom_spawnPlayer = ::spectator_respawn;
	}

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "spectator" )
			{
				players[i] [[level.spawnPlayer]]();
				if (isDefined(level.script) && level.round_number > 6 && players[i].score < 1500)
				{
					players[i].old_score = players[i].score;
					players[i].score = 1500;
					players[i] maps\_zombiemode_score::set_player_score_hud();
				}

				//Reimagined_Expanded, give players pro perks back
				players[i] give_pro_perks();

				//Start watch threads again
				players[i] thread watch_player_button_press();
				players[i] thread watch_player_current_weapon();
			}
		}

		wait( 1 );
	}
}

give_pro_perks( overrideToGiveAll )
{
	if( is_true( overrideToGiveAll ) ) {
		//level.max_perks = 20;
	}
	else
		overrideToGiveAll = false;

	//Create array of all pro perks player has
	pro_perks = [];
	for(i = 0; i < level.ARRAY_VALID_PRO_PERKS.size; i++)
	{
		if(self hasProPerk( level.ARRAY_VALID_PRO_PERKS[i]) || overrideToGiveAll)
			pro_perks[pro_perks.size] = level.ARRAY_VALID_PRO_PERKS[i];

	}

	//Remove all perks from player now
	for(i = 0; i < level.ARRAY_VALID_PRO_PERKS.size; i++) {
		self maps\_zombiemode_perks::removePerk(level.ARRAY_VALID_PRO_PERKS[i]);
	}
	
	for(i = 0; i < pro_perks.size; i++) {
		self maps\_zombiemode_perks::returnPerk( pro_perks[i] );
		wait(0.5);
	}

}

spectator_respawn()
{
	println( "*************************Respawn Spectator***" );
	assert( IsDefined( self.spectator_respawn ) );

	origin = self.spectator_respawn.origin;
	angles = self.spectator_respawn.angles;

	self setSpectatePermissions( false );

	new_origin = undefined;

	if ( isdefined( level.check_valid_spawn_override ) )
	{
		new_origin = [[ level.check_valid_spawn_override ]]( self );
	}

	if ( !isdefined( new_origin ) )
	{
		new_origin = check_for_valid_spawn_near_team( self );
	}

	if( IsDefined( new_origin ) )
	{
		self Spawn( new_origin, angles );
	}
	else
	{
		self Spawn( origin, angles );
	}


/*	we are not currently supporting the shared screen tech
	if( IsSplitScreen() )
	{
		last_alive = undefined;
		players = get_players();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, false );
	}
*/

	if ( IsDefined( self get_player_placeable_mine() ) )
	{
		self TakeWeapon( self get_player_placeable_mine() );
		self set_player_placeable_mine( undefined );
	}

	self maps\_zombiemode_equipment::equipment_take();

	self.is_burning = undefined;
	self.abilities = [];

	// The check_for_level_end looks for this
	self.is_zombie = false;
	self.ignoreme = false;

	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self RevivePlayer();

	self notify( "spawned_player" );

	if(IsDefined(level._zombiemode_post_respawn_callback))
	{
		self thread [[level._zombiemode_post_respawn_callback]]();
	}

	// Penalize the player when we respawn, since he 'died'
	//self maps\_zombiemode_score::player_reduce_points( "died" );

	//DCS: make bowie & claymore trigger available again.
	bowie_triggers = GetEntArray( "bowie_upgrade", "targetname" );
	// ww: player needs to reset trigger knowledge without claiming full ownership
	self._bowie_zm_equipped = undefined;
	players = get_players();
	for( i = 0; i < bowie_triggers.size; i++ )
	{
		bowie_triggers[i] SetVisibleToAll();
		// check the player to see if he has the bowie, if they do trigger goes invisible
		for( j = 0; j < players.size; j++ )
		{
			if( IsDefined( players[j]._bowie_zm_equipped ) && players[j]._bowie_zm_equipped == 1 )
			{
				bowie_triggers[i] SetInvisibleToPlayer( players[j] );
			}
		}
	}

	sickle_triggers = GetEntArray( "sickle_upgrade", "targetname" );
	// ww: player needs to reset trigger knowledge without claiming full ownership
	self._sickle_zm_equipped = undefined;
	players = get_players();
	for( i = 0; i < sickle_triggers.size; i++ )
	{
		sickle_triggers[i] SetVisibleToAll();
		// check the player to see if he has the sickle, if they do trigger goes invisible
		for( j = 0; j < players.size; j++ )
		{
			if( IsDefined( players[j]._sickle_zm_equipped ) && players[j]._sickle_zm_equipped == 1 )
			{
				sickle_triggers[i] SetInvisibleToPlayer( players[j] );
			}
		}
	}

	// ww: inside _zombiemode_claymore the claymore triggers are fixed for players who haven't bought them
	// to see them after someone respawns from bleedout
	// it isn't the best way to do it but it is late in the project and probably better if i don't modify it
	// unless a bug comes through on it
	claymore_triggers = getentarray("claymore_purchase","targetname");
	for(i = 0; i < claymore_triggers.size; i++)
	{
		claymore_triggers[i] SetVisibleToPlayer(self);
		claymore_triggers[i].claymores_triggered = false;
	}

	self thread player_zombie_breadcrumb();

	return true;
}

check_for_valid_spawn_near_team( revivee )
{
	players = get_players();
	spawn_points = getstructarray("player_respawn_point", "targetname");

	// Moon was adding NML spawn points
	if(level.script != "zombie_moon")
	{
		initial_spawn_points = getstructarray( "initial_spawn_points", "targetname" );
		spawn_points = array_combine(spawn_points, initial_spawn_points);
	}

	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;

	if( spawn_points.size == 0 )
		return undefined;

	if(IsDefined(level.last_player_alive))
	{
		for( j = 0 ; j < spawn_points.size; j++ )
		{
			if( isdefined(spawn_points[level.last_player_alive GetEntityNumber()].script_int) )
				ideal_distance = spawn_points[level.last_player_alive GetEntityNumber()].script_int;
			else
				ideal_distance = 1000;

			if ( spawn_points[j].locked == false )
			{
				// On Five, only spawn players on the floor they died
				if(level.script == "zombie_pentagon" && abs(level.last_player_alive.origin[2] - spawn_points[j].origin[2]) > 250)
				{
					continue;
				}

				distance = DistanceSquared( level.last_player_alive.origin, spawn_points[j].origin );
				if( distance < ( ideal_distance * ideal_distance ) )
				{
					if ( distance < closest_distance )
					{
						closest_distance = distance;
						closest_group = j;
					}
				}
				else
				{
					if ( distance < backup_distance )
					{
						backup_group = j;
						backup_distance = distance;
					}
				}
			}
		}

		level.last_player_alive = undefined;

		//	If we don't have a closest_group, let's use the backup
		if ( !IsDefined( closest_group ) )
		{
			closest_group = backup_group;
		}

		if ( IsDefined( closest_group ) )
		{
			spawn_array = getstructarray( spawn_points[closest_group].target, "targetname" );

			for( k = 0; k < spawn_array.size; k++ )
			{
				if( spawn_array[k].script_int == (revivee.entity_num + 1) )
				{
					return spawn_array[k].origin;
				}
			}

			return spawn_array[0].origin;
		}
	}

	for( i = 0; i < players.size; i++ )
	{
		if( is_player_valid( players[i] ) )
		{
			for( j = 0 ; j < spawn_points.size; j++ )
			{
				if( isdefined(spawn_points[i].script_int) )
					ideal_distance = spawn_points[i].script_int;
				else
					ideal_distance = 1000;

				if ( spawn_points[j].locked == false )
				{
					// On Five, only spawn players on the floor they died
					if(level.script == "zombie_pentagon" && abs(players[i].origin[2] - spawn_points[j].origin[2]) > 250)
					{
						continue;
					}

					distance = DistanceSquared( players[i].origin, spawn_points[j].origin );
					if( distance < ( ideal_distance * ideal_distance ) )
					{
						if ( distance < closest_distance )
						{
							closest_distance = distance;
							closest_group = j;
						}
					}
					else
					{
						if ( distance < backup_distance )
						{
							backup_group = j;
							backup_distance = distance;
						}
					}
				}
			}
		}

		//	If we don't have a closest_group, let's use the backup
		if ( !IsDefined( closest_group ) )
		{
			closest_group = backup_group;
		}

		if ( IsDefined( closest_group ) )
		{
			spawn_array = getstructarray( spawn_points[closest_group].target, "targetname" );

			for( k = 0; k < spawn_array.size; k++ )
			{
				if( spawn_array[k].script_int == (revivee.entity_num + 1) )
				{
					return spawn_array[k].origin;
				}
			}

			return spawn_array[0].origin;
		}
	}

	return undefined;
}


get_players_on_team(exclude)
{

	teammates = [];

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		//check to see if other players on your team are alive and not waiting to be revived
		if(players[i].spawn_side == self.spawn_side && !isDefined(players[i].revivetrigger) && players[i] != exclude )
		{
			teammates[teammates.size] = players[i];
		}
	}

	return teammates;
}



get_safe_breadcrumb_pos( player )
{
	players = get_players();
	valid_players = [];

	min_dist = 150 * 150;
	for( i = 0; i < players.size; i++ )
	{
		if( !is_player_valid( players[i] ) )
		{
			continue;
		}

		valid_players[valid_players.size] = players[i];
	}

	for( i = 0; i < valid_players.size; i++ )
	{
		count = 0;
		for( q = 1; q < player.zombie_breadcrumbs.size; q++ )
		{
			if( DistanceSquared( player.zombie_breadcrumbs[q], valid_players[i].origin ) < min_dist )
			{
				continue;
			}

			count++;
			if( count == valid_players.size )
			{
				return player.zombie_breadcrumbs[q];
			}
		}
	}

	return undefined;
}

default_max_zombie_func( max_num )
{
	max = max_num;

	if ( level.round_number == 1 ) // fix for moon, level.first_round is being set to false too quick on moon
	{
		max = int( max_num * 0.25 );
	}
	else if (level.round_number < 3)
	{
		max = int( max_num * 0.3 );
	}
	else if (level.round_number < 4)
	{
		max = int( max_num * 0.5 );
	}
	else if (level.round_number < 5)
	{
		max = int( max_num * 0.7 );
	}
	else if (level.round_number < 6)
	{
		max = int( max_num * 0.9 );
	}

	return max;
}

round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/

	
	if( level.enemy_spawns.size < 1 )
	{
		ASSERTMSG( "No active spawners in the map.  Check to see if the zone is active and if it's pointing to spawners." );
		return;
	}

/#
	if ( GetDvarInt( #"zombie_cheat" ) == 2 || GetDvarInt( #"zombie_cheat" ) >= 4 )
	{
		return;
	}
#/

	ai_calculate_health( level.round_number );

	//CODER MOD: TOMMY K
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i].zombification_time = 0;
	}

	ai_calculate_amount();

	if ( level.round_number < 10 ) {
		level thread [[ level.zombie_speed_up_func ]]();
	}

	mixed_spawns = 0;	// Number of mixed spawns this round.  Currently means number of dogs in a mixed round

	// DEBUG HACK:
	//max = 1;
	old_spawn = undefined;
//	while( level.zombie_total > 0 )
	count = 0;
	while( 1 )
	{

		while( level.zombie_total <= 0 )
		{
			wait( 0.05 );
		}

		if(get_enemy_count() >= level.zombie_ai_limit)
		{
			while(get_enemy_count() >= level.zombie_ai_limit)
			{
				wait .05;
			}
			wait 1;
		}

		// Reimagined-Expanded added ability to pause zombie spawning
		if ( !flag("spawn_zombies" ) )
		{
			flag_wait( "spawn_zombies" );
		}

		spawn_point = level.enemy_spawns[RandomInt( level.enemy_spawns.size )];

		if( !IsDefined( old_spawn ) )
		{
				old_spawn = spawn_point;
		}
		else if( Spawn_point == old_spawn )
		{
				spawn_point = level.enemy_spawns[RandomInt( level.enemy_spawns.size )];
		}
		old_spawn = spawn_point;

	//iPrintLn(spawn_point.targetname + " " + level.VALUE_ZOMBIE_SPAWN_DELAY);

		// MM Mix in dog spawns...
		spawn_dog = false;
		if ( IsDefined( level.mixed_rounds_enabled ) && level.mixed_rounds_enabled == 1 )
		{
			if ( level.round_number >= 30 || level.gamemode == "snr" || level.gamemode == "gg" )
			{
				if ( RandomInt(100) < 3 )
				{
					spawn_dog = true;
				}
			}
			else if ( level.round_number >= 25 && mixed_spawns < 3 )
			{
				if ( RandomInt(100) < 2 )
				{
					spawn_dog = true;
				}
			}
			else if ( level.round_number >= 20 && mixed_spawns < 2 )
			{
				if ( RandomInt(100) < 2 )
				{
					spawn_dog = true;
				}
			}
			else if ( level.round_number >= 15 && mixed_spawns < 1 )
			{
				if ( RandomInt(100) < 1 )
				{
					spawn_dog = true;
				}
			}
		}

		if ( spawn_dog )
		{
			keys = GetArrayKeys( level.zones );
			for ( i=0; i<keys.size; i++ )
			{
				if ( level.zones[ keys[i] ].is_occupied )
				{
					akeys = GetArrayKeys( level.zones[ keys[i] ].adjacent_zones );
					for ( k=0; k<akeys.size; k++ )
					{
						if ( level.zones[ akeys[k] ].is_active &&
							 !level.zones[ akeys[k] ].is_occupied &&
							 level.zones[ akeys[k] ].dog_locations.size > 0 )
						{
							level thread maps\_zombiemode_ai_dogs::special_dog_spawn( undefined, 1 );
							level.zombie_total--;
							wait_network_frame();
							break;
						}
					}

					if ( level.zones[ keys[i] ].is_active && level.zones[ keys[i] ].dog_locations.size > 0 )
					{
						level thread maps\_zombiemode_ai_dogs::special_dog_spawn( undefined, 1 );
						level.zombie_total--;
						wait_network_frame();
						break;
					}
				}
			}
		}
		else
		{
			//Spawn zombie
			cluster_size = determine_horde_cluster_size();
			MAX_TRIES = 10;

			//iprintln( "spawning cluster of size: " + cluster_size );
			while( cluster_size > 0 )
			{
				tries = 0;
				while( tries < MAX_TRIES )
				{
					ai = spawn_zombie( spawn_point );
					tries++;
					if( IsDefined( ai ) && IsDefined( ai.animname) )
					{
						//wait(0.1);
						level.zombie_total--;
						count++;
						ai thread round_spawn_failsafe();

						cluster_size--;
						//iprintln( "SPAWNED ZOMBIE: " + ai.zombie_hash + " | " + cluster_size + " | " + get_enemy_count() );
						//iprintln( spawn_point );
						//iprintln( "SPAWNED ZOMBIE, id | CLUSTER SIZE: " + ai.zombie_hash + " | " + cluster_size );
						//iprintln( "ZOMBIE TOTAL: " + get_enemy_count() );
						//iprintln( "Spawned zombies with tries: " + tries );
						if( cluster_size < 1 )
							break;
					}
					else
					{
						if( tries >= MAX_TRIES-1 )
						{
							//iprintln( "Failed to spawn zombie num " get_enemy_count() + " | " + tries );
						}
							
						

						if( !IsDefined( ai ) )
							continue;

						if( !IsDefined(ai.health) ) {
							ai Delete();
							continue;
						}

						ai DoDamage( ai.health + 100, (0,0,0) );
						continue;
					}
				}
				//END CLUSTER
				
				if( tries >= MAX_TRIES )
					break;
				
			}
			//END ZOMBIE SPAWN ATTEMPTS

		}
		
		//Reimagined-Expanded: Mix up zombie spawning times into hordes
		self determine_horde_wait( count );
		
		
		wait(0.1);
	}
}

determine_horde_wait( count )
{
	horde_threshold = level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[ level.round_number ];
	if( !IsDefined( horde_threshold ) ) {
		horde_threshold = level.round_number;
	}

		
	if(      count > 0 
		&& ( count % level.VALUE_HORDE_SIZE ) == 0  	//Reached a horde size
		&& level.zombie_total >= horde_threshold		//No horde wait if less zombies than a horde remain
		)
		{
			wait( level.VALUE_HORDE_DELAY );
		}

		//If less than 3/4 of horde, small delay
		delay = level.VALUE_ZOMBIE_SPAWN_DELAY;
	
		//if( level.classic )
		{
			delay += 1;
		}
			
		
		//Adjust delay based on round number
		if( level.round_number < 5 )
			delay -= 4;
		else if( level.round_number < 10 )
			delay -= 3;
		else if( level.round_number < 20 )
			delay -= 3;
		else if( level.round_number < 30 )
			delay -= 3;
		else 
			delay -= 4;
		


		//Adjust delay based on zombie count
		zombs_count = get_enemy_count();
		if( zombs_count < 12 )
			delay = 0.8;
		else if( zombs_count < 16 )
			delay -= 3.8;
		else if( zombs_count < 20 )
			delay -= 3.2;
		else if( zombs_count < 32 )
			delay -= 2;

	// -0.5s for each player in the game:
		delay -= get_players().size * 0.25;

		//iprintln( "Delay: " + delay );

		if( isDefined( level.spawn_delay_override ) )
			delay = level.spawn_delay_override;

		if( delay > 0 ) {
			randDelay = RandomFloatRange( 0, delay );
			wait( randDelay );
			//iprintln( "Waited: " + randDelay );
		}
			
	//iprintln( "count: " + zombs_count );
}

/*
	Reimagined-Expanded: Determine the size of the horde cluster

	Method: determine_horde_cluster_size

	Descr: Handle logic for determining size of spawning a small cluster of zombies from same spawnpoint

*/

determine_horde_cluster_size()
{
	if( level.classic )
		return 1;

	//Reimagined-Expanded
	//Spawn zombies in clusters occaissionally
	cluster_size = 1;
	zombs_count = get_enemy_count();
	zombs_remaining = level.zombie_total - zombs_count;
	if( zombs_count > level.THRESHOLD_ZOMBIE_SPAWN_CLUSTER_TOTAL_ENEMIES_MAX
		|| zombs_count < level.THRESHOLD_ZOMBIE_SPAWN_CLUSTER_TOTAL_ENEMIES_MIN )
	{
		//Check if there's room to spawn a cluster
		//nothing
		//iprintln( "Not enough room for clusters" );
	}
	else if(  zombs_remaining + 2 < level.zombie_round_cluster_size )
	{
		//If only a few zombies remain in the round, skip clusters
		//nothing		
	}
	else if( (RandomInt(100) < level.VALUE_ZOMBIE_SPAWN_CLUSTER_CHANCE) )
	{
		cluster_size = RandomIntRange( 2,  level.zombie_round_cluster_size + 2 );
		small_cluster = RandomIntRange( 2, 4 );
		enemies_til_max = level.THRESHOLD_ZOMBIE_SPAWN_CLUSTER_ASSUME_MAX_ENEMIES - get_enemy_count();

		//Weight towards spawning more samll clusters
		if( (enemies_til_max < level.VALUE_ZOMBIE_SPAWN_CLUSTER_SIZE_MAX) || (RandomInt(2) < 1) )
			cluster_size = small_cluster;

		//iprintln( "Calculated cluster size: " + cluster_size );
	}

	
	return cluster_size;
}

ai_calculate_amount()
{
	max = level.zombie_vars["zombie_max_ai"];

	if(level.round_number == 1)
	{
		max = int( max * 0.25 );
	}
	else if(level.round_number == 2)
	{
		max = int( max * 0.35 );
	}
	else if (level.round_number == 3)
	{
		max = int( max * 0.5 );
	}
	else if (level.round_number == 4)
	{
		max = int( max * 0.75 );
	}

	if(level.round_number > 5)
	{
		// Starts at 1.5, increases .25 each round until 3
		amount = level.round_number / 4;
		if(amount > 3)
		{
			amount = 3;
		}

		amount_multiplier = level.round_number / 5;
		if( amount_multiplier < 1 )
		{
			amount_multiplier = 1;
		}

		// After round 10, exponentially have more AI attack the player
		if( level.round_number >= 10 )
		{
			amount_multiplier *= level.round_number * 0.15;
		}

		max += int(amount * amount_multiplier);
	}

	// coop multiplier
	player_multiplier = 1;
	player_num = get_players().size;
	if(player_num > 1)
	{
		min_multiplier = 1;
		max_multiplier = 1;
		if(player_num == 2)
		{
			min_multiplier = 1.34;
			max_multiplier = 2;
		}
		else if(player_num == 3)
		{
			min_multiplier = 1.67;
			max_multiplier = 3;
		}
		else if(player_num >= 4)
		{
			min_multiplier = 2;
			max_multiplier = 4;
		}

		// from rounds 5-20, increase multiplier from min to max
		min_round = 5;
		max_round = 20;
		if(level.round_number >= max_round)
		{
			player_multiplier = max_multiplier;
		}
		else if(level.round_number > min_round)
		{
			multipler_diff = max_multiplier - min_multiplier;
			round_diff = max_round - min_round;
			multiplier_round_add = multipler_diff / round_diff;
			player_multiplier = min_multiplier + (multiplier_round_add * (level.round_number - min_round));
		}
		else
		{
			player_multiplier = min_multiplier;
		}
	}

	max = int(max * player_multiplier);
	level.zombie_round_total = max;

	//Reimagined-Expanded: More zombies in Apocalypse mode!
	if(level.tough_zombies && level.round_number > 5) {
		level.zombie_round_total = int( level.zombie_round_total  * 1.2);
	} 

	if( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = ::default_max_zombie_func;
	}

	if( IsDefined(level.calculate_amount_override) ) 
	{
		if( level.calculate_amount_override < level.zombie_round_total)
			level.zombie_round_total = level.calculate_amount_override;
	}

	level.zombie_total += level.zombie_round_total; //Reimagined-Expanded: Add zombies to the total in apocalypse mode

	if ( IsDefined( level.zombie_total_set_func ) )
	{
		level thread [[ level.zombie_total_set_func ]]();
	}

	iprintln( "Round " + level.round_number + " - " + level.zombie_round_total + " zombies" );
	iprintln( "Total zombies: " + level.zombie_total );
	
}

//
//	Make the last few zombies run
//
zombie_speed_up()
{
	if( level.round_number <= 3 )
	{
		return;
	}

	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/

	// Wait until we've finished spawning
	while ( level.zombie_total > 4 )
	{
		wait( 2.0 );
	}

	// Now wait for these guys to get whittled down
	num_zombies = get_enemy_count();
	while( num_zombies > 3 )
	{
		wait( 2.0 );

		num_zombies = get_enemy_count();
	}

	zombies = GetAiSpeciesArray( "axis", "all" );
	while( zombies.size > 0 )
	{
		if( zombies.size == 1 && zombies[0].has_legs == true && zombies[0].animname == "zombie" )
		{
			if ( isdefined( level.zombie_speed_up ) )
			{
				zombies[0] thread [[ level.zombie_speed_up ]]();
				break;
			}
			else
			{
				var = randomintrange(1, 4);
				zombies[0] set_run_anim( "sprint" + var );
				zombies[0].run_combatanim = level.scr_anim[zombies[0].animname]["sprint" + var];
			}
		}
		wait(0.5);
		zombies = GetAiSpeciesArray( "axis", "all" );
	}
}

// TESTING: spawn one zombie at a time
round_spawning_test()
{
	while (true)
	{
		spawn_point = level.enemy_spawns[RandomInt( level.enemy_spawns.size )];	// grab a random spawner

		ai = spawn_zombie( spawn_point );
		ai waittill("death");

		wait 5;
	}
}


/////////////////////////////////////////////////////////

// round_text( text )
// {
// 	if( level.first_round )
// 	{
// 		intro = true;
// 	}
// 	else
// 	{
// 		intro = false;
// 	}
//
// 	hud = create_simple_hud();
// 	hud.horzAlign = "center";
// 	hud.vertAlign = "middle";
// 	hud.alignX = "center";
// 	hud.alignY = "middle";
// 	hud.y = -100;
// 	hud.foreground = 1;
// 	hud.fontscale = 16.0;
// 	hud.alpha = 0;
// 	hud.color = ( 1, 1, 1 );
//
// 	hud SetText( text );
// 	hud FadeOverTime( 1.5 );
// 	hud.alpha = 1;
// 	wait( 1.5 );
//
// 	if( intro )
// 	{
// 		wait( 1 );
// 		level notify( "intro_change_color" );
// 	}
//
// 	hud FadeOverTime( 3 );
// 	//hud.color = ( 0.8, 0, 0 );
// 	hud.color = ( 0.21, 0, 0 );
// 	wait( 3 );
//
// 	if( intro )
// 	{
// 		level waittill( "intro_hud_done" );
// 	}
//
// 	hud FadeOverTime( 1.5 );
// 	hud.alpha = 0;
// 	wait( 1.5 );
// 	hud destroy();
// }


//	Allows zombie spawning to be paused.  Displays a countdown timer.
//

check_zombie_pause() {
	
	//Reimagined-Expanded added ability to pause zombie spawning, apocalypse
	if ( GetDvarInt("zombie_pause") > 0 && !level.apocalypse)
	{
		level.countdown_hud = create_counter_hud();
		level.countdown_hud settext( "Paused" );
		level.countdown_hud.color = ( 1, 1, 1 );
		level.countdown_hud.alpha = 1;
		level.countdown_hud FadeOverTime( 2.0 );

		level.countdown_hud.horzAlign = "center";
		level.countdown_hud.vertAlign = "middle";
		level.countdown_hud.alignX = "center";
		level.countdown_hud.alignY = "middle";
		level.countdown_hud.y = -100;
		level.countdown_hud.foreground = 1;
		level.countdown_hud.fontscale = 16.0;
		
		players = get_players();
	for(i=0;i<players.size;i++) {
		players[i].ignoreme = true;
	}
			
	while(GetDvarInt("zombie_pause") > 0) 
	{
		round_pause( 5 );
	}
	
	players = get_players();
	for(i=0;i<players.size;i++) {
		players[i].ignoreme = false;
	}	

	level.countdown_hud settext("");
	level.countdown_hud destroy_hud();

	}
}

round_pause( delay )
{
	if ( !IsDefined( delay ) )
	{
		delay = 5;
	}			
		
	while (delay >= 1) {
			wait(1);
			delay--;
	}	
	
}

//Reimagied-pre-round
reimagined_expanded_round_start()
{

	//Reimagined-Expanded: Set per round variables
	level.total_drops_round = 0;
	level.count_vulture_fx_drops_round = 0;
	level.special_dog_spawn_attempted = 0;	//Factory only

	level.THRESHOLD_EXECUTE_ZOMBIE_HEALTH = 0.34 * level.zombie_health;

	if( level.tough_zombies )
	{
		if( level.round_number < 4 )
		{
			level.zombie_move_speed = 25;	//down from 35
			level.zombie_vars["zombie_spawn_delay"] = 4 - level.players_size * 0.75;

			//MAX ZOMBIES
			level.zombie_ai_limit = 6 + 6*level.players_size; // Soft limit at 32, hard limit at 100, network issues?
			level.zombie_round_cluster_size = 1;

		} else if(  level.round_number < 11 ) {
			level.zombie_move_speed = 40;	//runners, sparse sprinters
			level.zombie_ai_limit = 8 + 12*level.players_size; // Soft limit at 32, hard limit at 100, network issues?

			level.VALUE_HORDE_SIZE = int( 10 + level.players_size * 2 );
			level.VALUE_HORDE_DELAY = int( 10 - level.players_size * 2 ); 

			level.zombie_vars["zombie_spawn_delay"] = 6.5 - (level.players_size * 0.5);
			level.zombie_round_cluster_size = 1;
		}
		else if(  level.round_number < 16 )		/* 11 - 16 */
		{
			level.zombie_move_speed = 50;	//runners, moderate sprinters, down from 90

			if( level.players_size == 1) {
				level.zombie_vars["zombie_spawn_delay"] = 6.5;
				level.zombie_ai_limit = 24; // Soft limit at 45, hard limit at 100, network issues?
			} else {
				level.zombie_vars["zombie_spawn_delay"] = 5.5;
				level.zombie_ai_limit = level.THRESHOLD_ZOMBIE_AI_LIMIT; // Soft limit at 45, hard limit at 100, network issues?
			}

			level.VALUE_HORDE_SIZE = 16 + 4*level.players_size;
			level.VALUE_HORDE_DELAY = 20 - 4*level.players_size;; 
			level.zombie_round_cluster_size = 3;

		} 
		else if(  level.round_number < 24 )		/* 16 - 24 */
		{
			level.zombie_move_speed = 60; //runners, many sprinters, down from 100
			level.zombie_vars["zombie_spawn_delay"] = 3.5;

			if( level.players_size == 1) {
				level.zombie_ai_limit = 32; 
				level.zombie_vars["zombie_spawn_delay"] = 4;
			}
			
			level.VALUE_HORDE_SIZE = 24 + 6*level.players_size;
			level.VALUE_HORDE_DELAY = 32 - 6*level.players_size;
			level.zombie_round_cluster_size = 4;

		} else if( level.round_number < 28 )	/* 24 - 28 */
		{
			if( level.players_size == 1) {
				level.zombie_ai_limit = level.THRESHOLD_ZOMBIE_AI_LIMIT; 
			}

			level.zombie_move_speed = 88;
			level.VALUE_HORDE_SIZE = 36 + 8*level.players_size;
			level.VALUE_HORDE_DELAY = 16 - 2*level.players_size;

			level.zombie_round_cluster_size = 5;

		} else {							/* 28+ */
			level.zombie_move_speed = 115;
			level.zombie_round_cluster_size = level.VALUE_ZOMBIE_SPAWN_CLUSTER_SIZE_MAX;
		}

	} else	//(More) Regular zombies!
	{	
		if( level.round_number < 8 )
		{
			level.zombie_move_speed = 25;	//down from 35
		}
		else if( level.round_number < 14 )
		{
			level.zombie_move_speed = 50;	//runners, sparse sprinters
		}
		else if( level.round_number < 24 )
		{
			level.zombie_move_speed = 70;
		}
		else 
		{
			level.zombie_move_speed = level.SUPER_SPRINTER_SPEED;
		}

		//print spawn delay
		iprintln( "Zombie move speed: " + level.zombie_move_speed );
		//iprintln( "Zombie spawn delay: " + level.zombie_vars["zombie_spawn_delay"] );

		//Cap zombie move speed by super sprinter speed
		if ( level.zombie_move_speed > level.SUPER_SPRINTER_SPEED )
			level.zombie_move_speed = level.SUPER_SPRINTER_SPEED;

		//MAX ZOMBIES
		level.zombie_ai_limit = 24;
		if( level.round_number > 24 ) {
			level.zombie_ai_limit = 32; 
			//level.ARRAY_VALUES["zombie_spawn_delay"] = 2.5;
		}

			
		
	}

	//Speed up remaining zombies
	level thread last_zombies_speed_up();

	//Increase max perks every 5 rounds after 15
	/*
	if( level.round_number > 14 && level.round_number % 5 == 0 ) 
	{
		//Switch case for the maps:
		switch( level.mapname ) 
		{
			case "zombie_cod5_prototype":
			//case "zombie_cod5_asylum":
			//case "zombie_cod5_sumpf":
			case "zombie_cod5_factory":
			case "zombie_theater":
			case "zombie_pentagon":
				level.max_perks++;
				break;	
		}
		
	}
	*/

	//Drop Increment for later rounds
	//if( level.extra_drops )
	{
		if( level.round_number >= level.THRESHOLD_ZOMBIE_DROP_INCREMENT_START_ROUND )
		{
			level.drop_rate_adjustment = level.VALUE_ZOMBIE_DROP_INCREMENT * (level.round_number - level.THRESHOLD_ZOMBIE_DROP_INCREMENT_START_ROUND);	
			//iprintln( "Drop rate adjustment: " + level.drop_rate_adjustment );
			//iprintln( "Drop rate BLUE: " + (level.VALUE_ZOMBIE_DROP_RATE_BLUE + level.drop_rate_adjustment) );
			//iprintln( "Drop rate GREEN: " + (level.VALUE_ZOMBIE_DROP_RATE_GREEN + level.drop_rate_adjustment) );
		}

		extra_restock = is_true( level.extra_restock_added );
		if( level.round_number > 15 && !extra_restock )
		{
			level.zombie_powerup_array[level.zombie_powerup_array.size] = "restock";
			level.extra_restock_added = true;
		}
			
		extra_ammo = is_true( level.extra_ammo_added );
		if( level.round_number > 20 && !extra_ammo )
		{
			level.zombie_powerup_array[level.zombie_powerup_array.size] = "full_ammo";
			level.extra_ammo_added = true;
		}
			
	}
	


	if(level.spawn_delay_override)
		level.zombie_vars["zombie_spawn_delay"] = level.spawn_delay_override;
		

	if( IsDefined(level.zombie_ai_limit_override) )
		level.zombie_ai_limit = level.zombie_ai_limit_override;
	
	SetAILimit( level.zombie_ai_limit );//allows zombies to spawn in as some were just killed
	
	//Tracking
	print_entities = IsDefined( level.dev_only) || true;
	if( print_entities	)
	{
		//Spawning entities, spawn entities
		entity = Spawn( "script_model", (0, 0, 0) );
		number = entity GetEntityNumber();
		if( number > 980 )
		{
			iprintln( "***Reimagined Expanded: Total entities exceeded 1000, Game may crash soon***" );
			iprintln( "Total: " + number );
		}
		
		entity delete();
	}
	
}

	/*
	   Descr:
	   Method threaded on level.
	   Wait for event level.STRING_MIN_ZOMBS_REMAINING_NOTIFY or "round_end"
	   If its "round_end" then exit
	   Otherwise, if its the specified event, get all zombies on the map and set run cycle to sprint

	*/
	last_zombies_speed_up()
	{
		level endon( "end_of_round" );
		level endon( "intermission" );

		level waittill( level.STRING_MIN_ZOMBS_REMAINING_NOTIFY );

		zombies = GetAiSpeciesArray( "axis", "all" );

		//check if zombies defined and has size
		if( !isDefined( zombies ) || zombies.size < 1 )
			return;

		for( i = 0; i < zombies.size; i++ )
		{
			if( !isDefined( zombies[i].animname ) )
				continue;
			
			if( is_true( zombies[i].has_legs ) && zombies[i].animname == "zombie" )
			{
				if( zombies[i].zombie_move_speed != "sprint" ) 
				{
					zombies[i].zombie_move_speed_original = "sprint";
					zombies[i] maps\_zombiemode_spawner::set_zombie_run_cycle("sprint");
				}
			}

			//wait for small amount
			wait( randomfloatrange( 0.2, 0.8 ) );
		}

	}


//	Zombie spawning
//
round_start()
{
	if ( IsDefined(level.round_prestart_func) )
	{
		[[ level.round_prestart_func ]]();
	}
	else
	{
		wait( 2 );
	}

	if(level.gamemode != "snr" && level.gamemode != "gg")
	{
		level.zombie_health = level.zombie_vars["zombie_health_start"];
	}

	// so players get init'ed with grenades
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] giveweapon( players[i] get_player_lethal_grenade() );
		players[i] setweaponammoclip( players[i] get_player_lethal_grenade(), 0);
		players[i] SetClientDvars( "ammoCounterHide", "0",
				"miniscoreboardhide", "0" );
		//players[i] thread maps\_zombiemode_ability::give_round1_abilities();
	}

	if( getDvarInt( #"scr_writeconfigstrings" ) == 1 )
	{
		wait(5);
		ExitLevel();
		return;
	}
//	if( isDefined(level.chests) && isDefined(level.chest_index) )
//	{
//		Objective_Add( 0, "active", "Mystery Box", level.chests[level.chest_index].chest_lid.origin, "minimap_icon_mystery_box" );
//	}


	flag_set( "begin_spawning" );

	//maps\_zombiemode_solo::init();

	if(level.gamemode != "snr" && level.gamemode != "gg")
	{
		level.chalk_hud1 = create_chalk_hud(4);
		level.chalk_hud2 = create_chalk_hud(68);
	}

// 	if( level.round_number >= 1 && level.round_number <= 5 )
// 	{
// 		level.chalk_hud1 SetShader( "hud_chalk_" + level.round_number, 64, 64 );
// 	}
// 	else if ( level.round_number >= 5 && level.round_number <= 10 )
// 	{
// 		level.chalk_hud1 SetShader( "hud_chalk_5", 64, 64 );
// 	}

	//	level waittill( "introscreen_done" );

	if( !isDefined(level.round_spawn_func) )
	{
		level.round_spawn_func = ::round_spawning;
	}
	level.round_spawn_wrapper_func = ::round_spawn_wrapper_func;
	level.zombie_spawn_func = level.round_spawn_func;
	level.base_zombie_spawn_func = ::round_spawning;


	if( !isDefined(level.zombie_speed_up_func) ) {
		level.zombie_speed_up_func = ::zombie_speed_up;
	}

/#
	if (GetDvarInt( #"zombie_rise_test") )
	{
		level.round_spawn_func = ::round_spawning_test;		// FOR TESTING, one zombie at a time, no round advancement
	}
#/

	if ( !isDefined(level.round_wait_func) )
	{
		level.round_wait_func = ::round_wait;
	}

	if ( !IsDefined(level.round_think_func) )
	{
		level.round_think_func = ::round_think;
	}

	if( level.mutators["mutator_fogMatch"] )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			players[i] thread set_fog( 729.34, 971.99, 338.336, 398.623, 0.58, 0.60, 0.56, 3 );
		}
	}

	level thread [[ level.round_think_func ]]();
}


//
//
create_chalk_hud( x )
{
	if( !IsDefined( x ) )
	{
		x = 0;
	}

	if(level.gamemode != "survival")
	{
		x += 64;
	}

	hud = create_simple_hud();
	hud.alignX = "left";
	hud.alignY = "bottom";
	hud.horzAlign = "user_left";
	hud.vertAlign = "user_bottom";
	hud.color = ( 0.21, 0, 0 );
	hud.x = x;
	hud.y = -4;
	hud.alpha = 0;
	hud.fontscale = 32.0;

	hud SetShader( "hud_chalk_1", 64, 64 );

	return hud;
}


//
//
destroy_chalk_hud()
{
	if( isDefined( level.chalk_hud1 ) )
	{
		level.chalk_hud1 Destroy();
		level.chalk_hud1 = undefined;
	}

	if( isDefined( level.chalk_hud2 ) )
	{
		level.chalk_hud2 Destroy();
		level.chalk_hud2 = undefined;
	}
}


//
// Let's the players know that you need power to open these
play_door_dialog()
{
	level endon( "power_on" );
	self endon ("warning_dialog");
	timer = 0;

	while(1)
	{
		wait(0.05);
		players = get_players();
		for(i = 0; i < players.size; i++)
		{
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer =0;
				continue;
			}
			while(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer++;
			}
			if(dist > 70*70 && timer >= 3)
			{
				self playsound("door_deny");

				players[i] maps\_zombiemode_audio::create_and_play_dialog( "general", "door_deny" );
				wait(3);
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}

wait_until_first_player()
{
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
}

//
//	Set the current round number hud display
chalk_one_up(override_round_number)
{
	if(level.gamemode == "snr" || level.gamemode == "gg" )
	{
		wait 10.25; //added up all the time of the wait statements in this function
		return;
	}

	huds = [];
	huds[0] = level.chalk_hud1;
	huds[1] = level.chalk_hud2;

	round_number = level.round_number;
	if(IsDefined(override_round_number))
	{
		round_number = override_round_number;
	}

	if(!IsDefined(override_round_number) || round_number == 1)
	{
		// Hud1 shader
		if( round_number >= 1 && round_number <= 5 )
		{
			huds[0] SetShader( "hud_chalk_" + round_number, 64, 64 );
		}
		else if ( round_number >= 5 && round_number <= 10 )
		{
			huds[0] SetShader( "hud_chalk_5", 64, 64 );
		}

		// Hud2 shader
		if( round_number > 5 && round_number <= 10 )
		{
			huds[1] SetShader( "hud_chalk_" + ( round_number - 5 ), 64, 64 );
		}

		// Display value
		if ( IsDefined( level.chalk_override ) )
		{
			huds[0] SetText( level.chalk_override );
			huds[1] SetText( " " );
		}
		else if( round_number <= 5 )
		{
			huds[1] SetText( " " );
		}
		else if( round_number > 10 )
		{
			huds[0].fontscale = 32;
			huds[0] SetValue( round_number );
			huds[1] SetText( " " );
		}
	}

	if(!IsDefined(level.doground_nomusic))
	{
		level.doground_nomusic = 0;
	}
	if( level.first_round && !IsDefined(override_round_number) )
	{
		intro = true;
		if( isdefined( level._custom_intro_vox ) )
		{
			level thread [[level._custom_intro_vox]]();
		}
		else
		{
			level thread play_level_start_vox_delayed();
		}
	}
	else
	{
		intro = false;
	}

	//Round Number Specific Lines
	if( !IsDefined(override_round_number) && level.round_number == 5 || level.round_number == 10 || level.round_number == 20 || level.round_number == 35 || level.round_number == 50 )
	{
	    players = getplayers();
	    rand = RandomIntRange(0,players.size);
	    players[rand] thread maps\_zombiemode_audio::create_and_play_dialog( "general", "round_" + level.round_number );
	}

	round = undefined;
	if( intro )
	{
		wait( 8 );
		// Hud1 shader
		if( round_number >= 1 && round_number <= 5 )
		{
			huds[0] SetShader( "hud_chalk_" + round_number, 64, 64 );
		}
		else if ( round_number >= 5 && round_number <= 10 )
		{
			huds[0] SetShader( "hud_chalk_5", 64, 64 );
		}

		// Hud2 shader
		if( round_number > 5 && round_number <= 10 )
		{
			huds[1] SetShader( "hud_chalk_" + ( round_number - 5 ), 64, 64 );
		}

		// Display value
		if ( IsDefined( level.chalk_override ) )
		{
			huds[0] SetText( level.chalk_override );
			huds[1] SetText( " " );
		}
		else if( round_number <= 5 )
		{
			huds[1] SetText( " " );
		}
		else if( round_number > 10 )
		{
			huds[0].fontscale = 32;
			huds[0] SetValue( round_number );
			huds[1] SetText( " " );
		}

		// Create "ROUND" hud text
		round = create_simple_hud();
		round.alignX = "center";
		round.alignY = "bottom";
		round.horzAlign = "user_center";
		round.vertAlign = "user_bottom";
		round.fontscale = 16;
		round.color = ( 1, 1, 1 );
		round.x = 0;
		round.y = -265;
		round.alpha = 0;
		round SetText( &"ZOMBIE_ROUND" );

//		huds[0] FadeOverTime( 0.05 );
		huds[0].color = ( 1, 1, 1 );
		huds[0].alpha = 0;
		huds[0].horzAlign = "user_center";
		huds[0].x = -5;
		huds[0].y = -200;

		huds[1] SetText( " " );

		// Fade in white
		round FadeOverTime( 1 );
		round.alpha = 1;

		huds[0] FadeOverTime( 1 );
		huds[0].alpha = 1;

		wait( 1 );

		// Fade to red
		round FadeOverTime( 2 );
		round.color = ( 0.21, 0, 0 );

		huds[0] FadeOverTime( 2 );
		huds[0].color = ( 0.21, 0, 0 );
		wait(2);
	}
	else if(!IsDefined(override_round_number))
	{
		for ( i=0; i<huds.size; i++ )
		{
			huds[i] FadeOverTime( 0.5 );
			huds[i].alpha = 0;
		}
		wait( 0.5 );
	}

// 	if( (level.round_number <= 5 || level.round_number >= 11) && IsDefined( level.chalk_hud2 ) )
// 	{
// 		huds[1] = undefined;
// 	}
//
	for ( i=0; i<huds.size; i++ )
	{
		if(IsDefined(override_round_number))
		{
			huds[i] FadeOverTime( .5 );
		}
		else
		{
			huds[i] FadeOverTime( 2 );
		}
		huds[i].alpha = 1;
	}

	if( intro )
	{
		wait( 3 );

		if( IsDefined( round ) )
		{
			round FadeOverTime( 1 );
			round.alpha = 0;
		}

		wait( 0.25 );

		level notify( "intro_hud_done" );
		huds[0] MoveOverTime( 1.75 );
		huds[0].horzAlign = "user_left";
		//		huds[0].x = 0;
		huds[0].y = -4;
		x = 4;
		if(level.gamemode != "survival")
		{
			x += 64;
		}
		huds[0].x = x;
		wait( 2 );

		round destroy_hud();
	}
	else
	{
		for ( i=0; i<huds.size; i++ )
		{
			huds[i].color = ( 1, 1, 1 );
		}
	}

	// Okay now wait just a bit to let the number set in
	if ( !intro )
	{
		if(IsDefined(override_round_number))
		{
			wait( .5 );
		}
		else
		{
			wait( 2 );
		}

		for ( i=0; i<huds.size; i++ )
		{
			huds[i] FadeOverTime( 1 );
			if(IsDefined(override_round_number))
			{
				huds[i].color = ( 0, 0, 0 );
			}
			else
			{
				huds[i].color = ( 0.21, 0, 0 );
			}
		}

		// set yellow insta kill on HUD
		if(round_number >= 163 && round_number % 2 == 1 && 
			!is_true(flag("dog_round")) && !is_true(flag("thief_round")) && !is_true(flag("monkey_round")) && !is_true(flag("enter_nml")))
		{
			flag_set("insta_kill_round");
		}
	}

	if(IsDefined(override_round_number))
	{
		// Hud1 shader
		if( round_number >= 1 && round_number <= 5 )
		{
			huds[0] SetShader( "hud_chalk_" + round_number, 64, 64 );
		}
		else if ( round_number >= 5 && round_number <= 10 )
		{
			huds[0] SetShader( "hud_chalk_5", 64, 64 );
		}

		// Hud2 shader
		if( round_number > 5 && round_number <= 10 )
		{
			huds[1] SetShader( "hud_chalk_" + ( round_number - 5 ), 64, 64 );
		}

		// Display value
		if ( IsDefined( level.chalk_override ) )
		{
			huds[0] SetText( level.chalk_override );
			huds[1] SetText( " " );
		}
		else if( round_number <= 5 )
		{
			huds[1] SetText( " " );
		}
		else if( round_number > 10 )
		{
			huds[0].fontscale = 32;
			huds[0] SetValue( round_number );
			huds[1] SetText( " " );
		}
	}

	ReportMTU(level.round_number);	// In network debug instrumented builds, causes network spike report to generate.

	// Remove any override set since we're done with it
	if ( IsDefined( level.chalk_override ) )
	{
		level.chalk_override = undefined;
	}
}


//	Flash the round display at the end of the round
//
chalk_round_over()
{
	huds = [];
	huds[huds.size] = level.chalk_hud1;
	huds[huds.size] = level.chalk_hud2;

	if( level.round_number <= 5 || level.round_number > 10 )
	{
		level.chalk_hud2 SetText( " " );
	}

	time = level.zombie_vars["zombie_between_round_time"];
	if ( time > 3 )
	{
		time = time - 2;	// add this deduction back in at the bottom
	}

	for( i = 0; i < huds.size; i++ )
	{
		if( IsDefined( huds[i] ) )
		{
			huds[i] FadeOverTime( time * 0.25 );
			huds[i].color = ( 1, 1, 1 );
		}
	}

	// Pulse
	fade_time = 0.5;
	steps =  ( time * 0.5 ) / fade_time;
	for( q = 0; q < steps; q++ )
	{
		for( i = 0; i < huds.size; i++ )
		{
			if( !IsDefined( huds[i] ) )
			{
				continue;
			}

			huds[i] FadeOverTime( fade_time );
			huds[i].alpha = 0;
		}

		wait( fade_time );

		for( i = 0; i < huds.size; i++ )
		{
			if( !IsDefined( huds[i] ) )
			{
				continue;
			}

			huds[i] FadeOverTime( fade_time );
			huds[i].alpha = 1;
		}

		wait( fade_time );
	}

	for( i = 0; i < huds.size; i++ )
	{
		if( !IsDefined( huds[i] ) )
		{
			continue;
		}

		huds[i] FadeOverTime( time * 0.25 );
		//		huds[i].color = ( 0.8, 0, 0 );
		huds[i].color = ( 0.21, 0, 0 );
		huds[i].alpha = 0;
	}

	wait ( 2.0 );
}

//Reimagined-Expanded
setApocalypseOptions()
{

	//User did not choose options, default game
	if( level.user_options == 0 )
	{
		if( GetDvar("zombie_apocalypse_default") == "")
			level.apocalypse = 0;
		else
			level.apocalypse = GetDvarInt("zombie_apocalypse_default");

		level.alt_bosses = 1;
		level.no_bosses = false;
		level.expensive_perks = false;
		level.tough_zombies = false;
		level.zombie_types = false;
		level.total_perks = 5;
		level.bo2_perks = true;
		level.extra_drops = true;
		level.server_cheats = true;
		level.starting_round = 1;
		SetDvar( "zombie_rt1", "1" );
	}
	else
	{
		/* Set the following dvars for the game */

		level.apocalypse = GetDvarInt("zombie_apocalypse");
		level.alt_bosses=GetDvarInt("zombie_alt_bosses");
		level.expensive_perks=GetDvarInt("zombie_exp_perks");
		level.tough_zombies=GetDvarInt("zombie_tough_zombies");
		level.zombie_types=GetDvarInt("zombie_types");
		level.total_perks=GetDvarInt("zombie_perk_limit");
		level.bo2_perks=GetDvarInt("zombie_bo2_perks");
		level.extra_drops=GetDvarInt("zombie_extra_drops");
		level.weapon_fx=GetDvarInt("zombie_weapon_effects");

		level.starting_round=GetDvarInt("zombie_round_start");
		level.server_cheats=GetDvarInt("reimagined_cheat");
	}
	
	
	//Set the gamemode from player chose apocalypse or not
	if( level.apocalypse == 0 ) {	//Classic mode
		level.classic = true;
		level.apocalypse = false;
	}
	else if( level.apocalypse == 1 ) {	//Reimagined mode
		level.classic = false;
		level.apocalypse = false;
	}
	else if( level.apocalypse == 2 ) {	//Apocalypse mode
		level.classic = false;
		level.apocalypse = true;
	}


	SetDvar( "zombie_classic", ""+level.classic );
	
	
	
	//level thread wait_print("User Ops: " , level.user_options);
	//level thread wait_print("Server cheats: ", level.server_cheats);


	//Apocalypse variables defaults
	if( IsDefined( level.apocalypse_override ) && !level.apocalypse_override ) {
		level.apocalypse = 0;
	}
		
	
	if(level.apocalypse > 0 || is_true(level.apocalypse_override) ) 
	{
		level.apocalypse = true;
		level.classic = false;
	}
	if(level.expensive_perks > 0 || level.apocalypse)
		level.expensive_perks = true;
	if(level.tough_zombies > 0 || level.apocalypse)
		level.tough_zombies = true;
	if(level.zombie_types > 0 || level.apocalypse)
		level.zombie_types = true;
	if(level.bo2_perks > 0 || level.apocalypse)
		level.bo2_perks = true;
	if(level.extra_drops > 0 || level.apocalypse)
		level.extra_drops = true;
	if(level.alt_bosses == 2 || level.apocalypse)
		level.alt_bosses = true;

	if(level.alt_bosses == 0 ) //Should force off if apocalypse
		level.no_bosses = true;
	else
		level.no_bosses = false;

	if( IsDefined(level.classic_override) )
		level.classic = level.classic_override;
	

	if(level.apocalypse) 
	{		
		level.starting_round = 1;
		level.server_cheats=false;
		level.total_perks = 5;

	} 
	else if( level.server_cheats > 0) 
	{
		//Cheats and apocalypse are mutually exclusive
		level.server_cheats=true;
		level.total_perks = 100;
	}

	if(IsDefined(level.server_cheats_override)) {
		level.server_cheats = true;
		level.total_perks = 100;
	}

	if( IsDefined( level.override_bo2_perks ) ) {
		level.bo2_perks = level.override_bo2_perks;
	}

	level.max_perks = level.total_perks;

	level thread print_apocalypse_options();
	//fade_introblack

}


print_apocalypse_options()
{
	level waittill("hold_introblack");
	//wait(10);

	players = GetPlayers();
	offsets = array( 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300 );

	OPTIONS_TIME = 6;
	for(i=0; i<players.size; i++)
	{
	
		if( level.apocalypse )
			players[i] thread generate_hint_title(undefined, "Apocalypse Zombies", OPTIONS_TIME);
		else if( level.classic )
			players[i] thread generate_hint_title(undefined, "Classic Zombies", OPTIONS_TIME);
		else
			players[i] thread generate_hint_title(undefined, "Reimagined Zombies", OPTIONS_TIME);

		wait (0.5);

		j = 0;
		{ players[i] thread generate_hint(undefined, "v" + level.zm_mod_version, 6, OPTIONS_TIME ); j++; }

		//BO2 Perks on and off
		if( level.bo2_perks )
			{ players[i] thread generate_hint(undefined, "BO2 Perks: On", offsets[j], OPTIONS_TIME ); j++; }
		else
			{ players[i] thread generate_hint(undefined, "BO2 Perks: Off", offsets[j], OPTIONS_TIME ); j++; }

		//If classic zombies, "Upgraded Perks" is off
		if( level.classic )
			{ players[i] thread generate_hint(undefined, "Upgraded Perks: Off", offsets[j], OPTIONS_TIME ); j++; }
		else
			{ players[i] thread generate_hint(undefined, "Upgraded Perks: On", offsets[j], OPTIONS_TIME ); j++; }

		//Other settings
		if( level.expensive_perks )
			{ players[i] thread generate_hint(undefined, "Expensive Perks: On", offsets[j], OPTIONS_TIME ); j++; }
		if( level.tough_zombies )
			{ players[i] thread generate_hint(undefined, "Tough Zombies: On", offsets[j], OPTIONS_TIME ); j++; }
		if( level.zombie_types )
			{ players[i] thread generate_hint(undefined, "Zombie Types: On", offsets[j], OPTIONS_TIME ); j++; }
		if( level.extra_drops )
			{ players[i] thread generate_hint(undefined, "Extra Drops: On", offsets[j], OPTIONS_TIME ); j++; }
	
		if( level.alt_bosses == 2 )
		{
			players[i] thread generate_hint(undefined, "Zombie Bosses: Tough", offsets[j], OPTIONS_TIME );
			j++;
		}
		else if( level.no_bosses )
		{
			players[i] thread generate_hint(undefined, "Zombie Bosses: None", offsets[j], OPTIONS_TIME );
			j++;
		}
		else
		{
			players[i] thread generate_hint(undefined, "Zombie Bosses: Normal", offsets[j], OPTIONS_TIME );
			j++;
		}
		
		//wait(0.5);
		j++;	//buffer
		if( level.apocalypse )
			players[i] thread generate_hint(undefined, "Difficulty: Apocalypse (Hard)", offsets[j], OPTIONS_TIME );
		else if( level.classic )
			players[i] thread generate_hint(undefined, "Difficulty: Classic (Normal)", offsets[j], OPTIONS_TIME );
		else 
			players[i] thread generate_hint(undefined, "Difficulty: Reimagined (Normal)", offsets[j], OPTIONS_TIME );
		j++;

		//Count max j++ statements up to here: 7

		wait( OPTIONS_TIME + 1 );

		if( level.apocalypse ) 
		{
			//apocalypse_hints = "- Zombies are stronger and faster \n- Zombies will respawn at full health if not killed quickly \n- Rounds will automatically start if you wait too long; with a break every 5 rounds \n- Damaging zombies gives less points; kills and headshots give more points \n- Points are rewarded for finishing a round quickly \n- Doors and upgrades are more expensive";
			//apocalypse_hints = "- Zombies are stronger and faster \n";
			//apocalypse_hints += "- Zombies will respawn at full health if not killed quickly \n";
			//apocalypse_hints += "- Rounds will automatically start if you wait too long; with a break every 5 rounds \n";
			//apocalypse_hints += "- Damaging zombies gives less points; kills and headshots give more points \n";
			//apocalypse_hints += "- Points are rewarded for finishing a round quickly \n";
			//apocalypse_hints += "- Doors and upgrades are more expensive";

			players[i] generate_perk_hint("Apocalypse", true);

		}
		else if( level.classic )
		{
			players[i] thread generate_hint(undefined, "In-Game Hints can be toggled from the in-Game the Settings", offsets[ offsets.size-5 ], 5);
			players[i] thread generate_hint(undefined, "Difficulty can be adjusted from the Main Menu 'Game' Settings ", offsets[ offsets.size-3 ], 5);
		}
		else
		{
			players[i] thread generate_hint(undefined, "For a more Vanilla experience, try 'Classic' difficulty from the Main Menu", offsets[ offsets.size-3 ], 5);
			players[i] thread generate_hint(undefined, "For a challenge, try 'Apocalypse' difficulty", offsets[ offsets.size-2 ], 5);
			players[i] thread generate_hint(undefined, "In-Game Hints can be toggled from the in-Game the Settings", offsets[ offsets.size-1 ], 5);
		}

		


		wait(6);
		if( IsDefined( level.ARRAY_FREE_PERK_HINTS[level.mapname] ))
			players[i] generate_hint(undefined, "Free Perk Hint: " + level.ARRAY_FREE_PERK_HINTS[level.mapname],
				 offsets[ offsets.size-1 ], 4);
	}
	
}


//Reimagined-Expanded
pre_round_think()
{	
	if( IsDefined(level.starting_round_override) )
		level.starting_round = level.starting_round_override;

	if(level.starting_round > 1) 
	{
		level.round_number = level.starting_round;

		//Give all players 1000 points per round
		players = GetPlayers();
		for(i=0;i<players.size;i++) {
			//iprintln("Giving points: " + i);
			players[i] maps\_zombiemode_score::add_to_player_score( level.starting_round * 1000, true);
		}
	}

	if( IsDefined(level.starting_points_override) )
		GetPlayers()[0] maps\_zombiemode_score::add_to_player_score( level.starting_points_override );

	/*	MAP SPECFIC				*/

	level.asylum_array_powerup_hackables = [];

	//iprintln("Apocalypse is: "+ level.apocalypse);
	//iprintln("Alt Bosses is: "+ level.alt_bosses);
	//iprintln("Expensive Perks is: "+ level.expensive_perks);
	//iprintln("Tough Zombies is: "+ level.tough_zombies);
	//iprintln("Zombie Types is: "+ level.zombie_types);
	//iprintln("No Perks is: "+ level.total_perks);
	//iprintln("BO2 Perks is: "+ level.bo2_perks);
	//iprintln("Extra Drops is: "+ level.extra_drops);
	//iprintln("No Bosses is: "+ level.no_bosses);
	// */
}


round_think()
{
	level pre_round_think();

	for( ;; )
	{
		//Reimagined-Expanded
		level reimagined_expanded_round_start();

		//////////////////////////////////////////
		//designed by prod DT#36173
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
			maxreward = 500;
		level.zombie_vars["rebuild_barrier_cap_per_round"] = 1000;
		//////////////////////////////////////////

		level.pro_tips_start_time = GetTime();
		level.zombie_last_run_time = GetTime();	// Resets the last time a zombie ran

        level thread maps\_zombiemode_audio::change_zombie_music( "round_start" );
		chalk_one_up();
		//		round_text( &"ZOMBIE_ROUND_BEGIN" );

		maps\_zombiemode_powerups::powerup_round_start();

		players = get_players();
		array_thread( players, maps\_zombiemode_blockers::rebuild_barrier_reward_reset );

		//array_thread( players, maps\_zombiemode_ability::giveHardpointItems );

		level thread award_grenades_for_survivors();
		
		
		//Reimagined-Expanded
		//continually delays round start until turned off
		//iprintln("DVAR zomb_puase is: "+ GetDvar("zombie_pause"));
		//also in moon think function
		check_zombie_pause();
		

		bbPrint( "zombie_rounds: round %d player_count %d", level.round_number, players.size );

		level.round_start_time = GetTime();
		level thread [[level.round_spawn_wrapper_func]]();

		level notify( "start_of_round" );

		[[level.round_wait_func]]();

		level.first_round = false;
		level notify( "end_of_round" );

		if(flag("insta_kill_round"))
		{
			flag_clear("insta_kill_round");
		}

		level thread maps\_zombiemode_audio::change_zombie_music( "round_end" );

		UploadStats();

		if ( 1 != players.size )
		{
			level thread spectators_respawn();
			//level thread last_stand_revive();
		}

		//		round_text( &"ZOMBIE_ROUND_END" );
		level chalk_round_over();

		level.round_number++;

		level notify( "between_round_over" );
	}
}

round_spawn_wrapper_func()
{
	//If its a special round, call zombie spawning function too in apocalypse mode
	specialRound = is_true( level.dog_intermission )
				|| is_true( level.monkey_intermission )
				|| is_true( level.thief_intermission )
				|| flag("thief_round") 
				|| flag("monkey_round") 
				|| flag("dog_round") 
				|| flag( "crawler_round" )
				|| flag( "dog_round_spawning" );
				
				 // || flag("enter_nml");

	level thread [[level.round_spawn_func]]();

	if( level.apocalypse && specialRound )
	{
		level thread [[level.zombie_spawn_func]]();
	}
		
}


award_grenades_for_survivors()
{
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (!players[i].is_zombie)
		{
			lethal_grenade = players[i] get_player_lethal_grenade();
			if( !players[i] HasWeapon( lethal_grenade ) )
			{
				players[i] GiveWeapon( lethal_grenade );
				players[i] SetWeaponAmmoClip( lethal_grenade, 0 );
				ammo_clip = 0;
			}
			else
			{
				ammo_clip = players[i] GetWeaponAmmoClip(lethal_grenade);
			}
			ammo_clip += 2;

			max_clip = 4;
			/*if(players[i] HasPerk("specialty_stockpile"))
			{
				max_clip = 5;
			}*/

			if(ammo_clip > max_clip)
			{
				ammo_clip = max_clip;
			}
			else if( players[i] hasProPerk( level.MUL_PRO ) )
			{
				ammo_clip = max_clip;
			}

			players[i] SetWeaponAmmoClip( lethal_grenade, ammo_clip );

			/* 
				#########################
			*/

			/* 
				tactical Grenades
			*/

			tactical = players[i] get_player_tactical_grenade(); 

			if( !IsDefined(tactical )  )
				continue;

			//If player has Widows Wine Pro and Widows grenade, give them +1 grenade
			wine_grenade = "bo3_zm_widows_grenade";
			if( players[i] hasProPerk( level.WWN_PRK ) && tactical == wine_grenade )
			{
				ammo = players[i] GetWeaponAmmoClip( tactical );

				if( players[i] hasProPerk( level.MUL_PRO ) )
					players[i] SetWeaponAmmoClip( tactical, 4 );
				else if( ammo < 4 )
					players[i] SetWeaponAmmoClip( tactical, ammo + 2 );

				continue;
			}

			//If Player has mule pro, give them a tactical grenade
			if( players[i] hasProPerk( level.MUL_PRO ) )
			{
				ammo = players[i] GetWeaponAmmoClip( tactical );
				if( ammo < 2 )
					players[i] SetWeaponAmmoClip( tactical, ammo + 1 );
			}

		}
	}
}

ai_calculate_health( round_number )
{
	
	//iprintln("Zombie Health calculate: ");

	//Reimagined-Expanded - exponential health scaling
	//calculate health calculate_health
	base = 1200;
	if( level.tough_zombies )
		base = 1500;
	
	roundHealthAdjust = [];
	roundHealthLogFactor = [];

	MAX_ROUND_ADJUST = 50;
	for(i=0; i<MAX_ROUND_ADJUST; i++)
	{
		roundHealthLogFactor[i] = 3.5;

		if( i < 10 )
			roundHealthAdjust[i] = 0.2;
		else if( i < 15 )
			roundHealthAdjust[i] = 0.6;
		else if( i < 20 )
		{
			roundHealthAdjust[i] = 0.8;
		}
		else if( i < 25 )
		{
			roundHealthAdjust[i] = 1;
		}
		else
		{	roundHealthAdjust[i] = 1;
			roundHealthLogFactor[i] = 2;
		}
			
	}

	startHealth = 150;
	logFactor = 3.5;	
	health = startHealth;
	//iprintln(health);
	for ( i=2; i<=round_number; i++ )
	{	
		lowRoundZombHealthAdjust = 1;
		roundAdjustedLogFactor = 2;
		if( i < MAX_ROUND_ADJUST )
		{
			roundAdjustedLogFactor = roundHealthLogFactor[i];
			lowRoundZombHealthAdjust = roundHealthAdjust[i];
		}
			
		
		health += ( base * lowRoundZombHealthAdjust * ( i/logFactor ) );
		//iprintln(health);	
	}

	//cap zombies health, first round of capped 
	if(health > level.THRESHOLD_MAX_ZOMBIE_HEALTH) {
		health = level.THRESHOLD_MAX_ZOMBIE_HEALTH;
	}

	//Player zombie health multiplier
	if(level.tough_zombies && level.round_number >= level.THRESHOLD_ZOMBIE_PLAYER_BONUS_HEALTH_ROUND ) {
		health *= level.VALUE_ZOMBIE_PLAYER_HEALTH_MULTIPLIER[ level.players_size ];
	}	
	
	zombie_totals_defined = isdefined(level.zombie_total) && isdefined(level.zombie_round_total);
	apocalypse_health = ( round_number > level.THRESHOLD_MAX_APOCALYSE_ROUND ) && level.zombie_total > level.zombie_round_total;
	if( level.apocalypse && apocalypse_health  && zombie_totals_defined ) {
		health *= ( level.zombie_total / level.zombie_round_total); //factor always >= 1
	}
	
	//PRINT
	//iprintln("Current health print:  ");
	iprintln("Current health:  " + health);
	level.zombie_health = Int( health );
}

/#
round_spawn_failsafe_debug()
{
	level notify( "failsafe_debug_stop" );
	level endon( "failsafe_debug_stop" );

	start = GetTime();
	level.chunk_time = 0;

	while ( 1 )
	{
		level.failsafe_time = GetTime() - start;

		if ( isdefined( self.lastchunk_destroy_time ) )
		{
			level.chunk_time = GetTime() - self.lastchunk_destroy_time;
		}
		wait_network_frame();
	}
}
#/


//put the conditions in here which should
//cause the failsafe to reset
round_spawn_failsafe()
{
	self endon("death");//guy just died

	//////////////////////////////////////////////////////////////
	//FAILSAFE "hack shit"  DT#33203
	//////////////////////////////////////////////////////////////
	wait 5;

	if( !level.zombie_vars["zombie_use_failsafe"] )
	{
		return;
	}

	if ( is_true( self.ignore_round_spawn_failsafe ) )
	{
		return;
	}

	prevorigin = self.origin;
	time = GetTime();

	while(1)
	{
		wait( .05 );

		//if i've torn a board down in the last 30 seconds, just wait again.
		if ( isDefined(self.lastchunk_destroy_time) )
		{
			if ( (GetTime() - self.lastchunk_destroy_time) < 30000 )
			{
				time = GetTime();
				continue;
			}
		}

		//if players are teleporting, wait also
		teleporting = false;
		players = get_players();
		for(i=0; i < players.size; i++)
		{
			if (IsDefined(players[i].inteleportation) && players[i].inteleportation)
			{
				teleporting = true;
				break;
			}
		}
		if(teleporting)
		{
			time = GetTime();
			continue;
		}

		//fell out of world
		if ( self.origin[2] < level.zombie_vars["below_world_check"] )
		{
			if(is_true(level.put_timed_out_zombies_back_in_queue ) && !flag("dog_round") )
			{
				level.zombie_total++;
			}
			self dodamage( self.health + 100, (0,0,0) );
			break;
		}

		if ( DistanceSquared( self.origin, prevorigin ) > 48*48)
		{
			prevorigin = self.origin;
			time = GetTime();
			continue;
		}

		if((GetTime() - time) < 30000)
		{
			continue;
		}

		//add this zombie back into the spawner queue to be re-spawned
		if(is_true(level.put_timed_out_zombies_back_in_queue ) && !flag("dog_round"))
		{
			if(!is_true(self.nuked) && !is_true(self.marked_for_death))
			{
				level.zombie_total++;
			}
		}

		//add this to the stats even tho he really didn't 'die'
		level.zombies_timeout_playspace++;

		// DEBUG HACK
		self dodamage( self.health + 100, (0,0,0) );
	}
	//////////////////////////////////////////////////////////////
	//END OF FAILSAFE "hack shit"
	//////////////////////////////////////////////////////////////
}

// Waits for the time and the ai to die
round_wait()
{
/#
    if (GetDvarInt( #"zombie_rise_test") )
	{
		level waittill("forever"); // TESTING: don't advance rounds
	}
#/

/#
	if ( GetDvarInt( #"zombie_cheat" ) == 2 || GetDvarInt( #"zombie_cheat" ) >= 4 )
	{
		level waittill("forever");
	}
#/

	wait( 1 );

	//Reimagined-Expanded, apocalypse mode keeps rounds moving
	if( level.apocalypse ) {
	
		//Moon Ramping Up zombies sound to play on next round start
		//For all players, play sound at position: playsoundatposition(sound, self.origin);
		players = get_players();
		for(i=0;i<players.size;i++) {
			playsoundatposition("amb_alarm_radar_station", players[i].origin);
		}
		
		if( !IsDefined( level.sound_num ) )
			level.sound_num = 0;

		//iprintln("Siren sound" + level.sound_num);
	   	thread play_sound_2d( "amb_alarm_radar_station" );
		//thread play_sound_2d( "zmb_defcon_alarm" );
		//thread play_sound_2d( "nomans_warning" );

		level thread reimagined_expanded_apocalypse_rounds();
	}

	//Reimagined-Epanded
	//We don't care about dog rounds, dogs and zombies/mokeys etc come at once
	while( level.zombie_total > 0 || get_enemy_count() > 0 )
	{
		if( flag( "end_round_wait" ) )
		{
			level thread reimagined_expanded_apocalypse_bonus( false );
			return;
		}

		while(flag("round_restarting"))
		{
			wait .05;
		}

		wait( .05 );
	}

	//Reimagined-Expanded, apocalypse mode bonus
	if( level.apocalypse && level.round_number <= level.THRESHOLD_MAX_APOCALYSE_ROUND ) 
	{
		if( level.round_number % level.VALUE_APOCALYPSE_WAIT_ROUNDS == 0 )
			return;	//Intermission round, no bonus every 5 rounds
		level thread reimagined_expanded_apocalypse_bonus();
	}

}

reimagined_expanded_apocalypse_bonus( giveBonus )
{
	wait( 5 );
		players = get_players();
		for(i=0;i<players.size;i++) {
			bonus = level.ARRAY_APOCALYPSE_ROUND_BONUS_POINTS[ level.round_number ];
			if( giveBonus )
				players[i] maps\_zombiemode_score::add_to_player_score( bonus, true );
			else
				players[i].gross_possible_points += bonus;
		}
}

get_total_remaining_enemies()
{
	return level.zombie_total + get_enemy_count() + level.zombie_dog_total;
}

/*
	Reimagined-Expanded apocalypse round formula, this code is called form a thread in round_wait function
	- Before round 10, players have minimum alloted time to complete round, or it advances anyways
	- After round 10, the round advances 30, 60, 150 (etc) seconds after nth zombie spawns (10th, 15th, 20th, etc)
	- every 5 rounds, there is a true typical wait where the last zombie must die
*/
reimagined_expanded_apocalypse_rounds()
{
	self endon("end_of_round");

	round = level.round_number;
	wait_time = round; 			//Round 45 means you have 45 seconds to kill 45 zombies	
	zombs_threshold = round;

	if( round <= level.THRESHOLD_MAX_APOCALYSE_ROUND ) 
	{	
		wait_time = level.ARRAY_APOCALYPSE_ROUND_TIME_LIMITS[ round ];

		if( round % level.VALUE_APOCALYPSE_WAIT_ROUNDS == 0 )
			zombs_threshold = 0;	//intermission
		else 
			zombs_threshold = level.ARRAY_APOCALYPSE_ROUND_ZOMBIE_THRESHOLDS[ round ];
	}

	wait(5);	//Give zombs some time to start spawning

	remaining_zombies = get_total_remaining_enemies();
	while( remaining_zombies > zombs_threshold )
	{
		remaining_zombies = get_total_remaining_enemies();
		wait( 0.5 );
	}
	
	wait( wait_time );

	//On special rounds, wait for all zombies to die, players get bonus
	specialround = level.dog_intermission || level.monkey_intermission || level.thief_intermission || flag("thief_round") || flag("monkey_round") || flag("dog_round"); // || flag("enter_nml");
	if( !specialround ) {
		self thread clear_flag("end_round_wait", 5);
		flag_set("end_round_wait");
	}
}
// */

//Reimagined-Expanded flag clearing utility
clear_flag(flag, wait_time) 
{
	if( IsDefined(wait_time) )
		wait(wait_time);
	flag_clear(flag);
}

is_friendly_fire_on()
{
	return level.mutators[ "mutator_friendlyFire" ];
}


can_revive( reviver )
{
	if( self has_powerup_weapon() )
	{
		return false;
	}

	return true;
}


zombify_player()
{
	self maps\_zombiemode_score::player_died_penalty();

	bbPrint( "zombie_playerdeaths: round %d playername %s deathtype died x %f y %f z %f", level.round_number, self.playername, self.origin );

	if ( IsDefined( level.deathcard_spawn_func ) )
	{
		self [[level.deathcard_spawn_func]]();
	}

	if( !IsDefined( level.zombie_vars["zombify_player"] ) || !level.zombie_vars["zombify_player"] )
	{
		if (!is_true(self.solo_respawn ))
		{
			self thread spawnSpectator();
		}

		return;
	}

	self.ignoreme = true;
	self.is_zombie = true;
	self.zombification_time = GetTime();

	self.team = "axis";
	self notify( "zombified" );

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger Delete();
	}
	self.revivetrigger = undefined;

	self setMoveSpeedScale( 0.3 );
	self reviveplayer();

	self TakeAllWeapons();
	//self starttanning();
	self GiveWeapon( "zombie_melee", 0 );
	self SwitchToWeapon( "zombie_melee" );
	self DisableWeaponCycling();
	self DisableOffhandWeapons();
	self VisionSetNaked( "zombie_turned", 1 );

	maps\_utility::setClientSysState( "zombify", 1, self ); 	// Zombie grain goooo

	self thread maps\_zombiemode_spawner::zombie_eye_glow();

	// set up the ground ref ent
	self thread injured_walk();
	// allow for zombie attacks, but they lose points?

	self thread playerzombie_player_damage();
	self thread playerzombie_soundboard();
}

playerzombie_player_damage()
{
	self endon( "death" );
	self endon( "disconnect" );

	self thread playerzombie_infinite_health();  // manually keep regular health up
	self.zombiehealth = level.zombie_health;

	// enable PVP damage on this guy
	// self EnablePvPDamage();

	while( 1 )
	{
		self waittill( "damage", amount, attacker, directionVec, point, type );

		if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
		{
			wait( 0.05 );
			continue;
		}

		self.zombiehealth -= amount;

		if( self.zombiehealth <= 0 )
		{
			// "down" the zombie
			self thread playerzombie_downed_state();
			self waittill( "playerzombie_downed_state_done" );
			self.zombiehealth = level.zombie_health;
		}
	}
}

playerzombie_downed_state()
{
	self endon( "death" );
	self endon( "disconnect" );

	downTime = 15;

	startTime = GetTime();
	endTime = startTime +( downTime * 1000 );

	self thread playerzombie_downed_hud();

	self.playerzombie_soundboard_disable = true;
	self thread maps\_zombiemode_spawner::zombie_eye_glow_stop();
	self DisableWeapons();
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowProne( true );

	while( GetTime() < endTime )
	{
		wait( 0.05 );
	}

	self.playerzombie_soundboard_disable = false;
	self thread maps\_zombiemode_spawner::zombie_eye_glow();
	self EnableWeapons();
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );

	self notify( "playerzombie_downed_state_done" );
}

playerzombie_downed_hud()
{
	self endon( "death" );
	self endon( "disconnect" );

	text = NewClientHudElem( self );
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "user_center";
	text.vertAlign = "user_bottom";
	text.foreground = true;
	text.font = "default";
	text.fontScale = 1.8;
	text.alpha = 0;
	text.color = ( 1.0, 1.0, 1.0 );
	text SetText( &"ZOMBIE_PLAYERZOMBIE_DOWNED" );

	text.y = -113;
	if( IsSplitScreen() )
	{
		text.y = -137;
	}

	text FadeOverTime( 0.1 );
	text.alpha = 1;

	self waittill( "playerzombie_downed_state_done" );

	text FadeOverTime( 0.1 );
	text.alpha = 0;
}

playerzombie_infinite_health()
{
	self endon( "death" );
	self endon( "disconnect" );

	bighealth = 100000;

	while( 1 )
	{
		if( self.health < bighealth )
		{
			self.health = bighealth;
		}

		wait( 0.1 );
	}
}

playerzombie_soundboard()
{
	self endon( "death" );
	self endon( "disconnect" );

	self.playerzombie_soundboard_disable = false;

	self.buttonpressed_use = false;
	self.buttonpressed_attack = false;
	self.buttonpressed_ads = false;

	self.useSound_waitTime = 3 * 1000;  // milliseconds
	self.useSound_nextTime = GetTime();
	useSound = "playerzombie_usebutton_sound";

	self.attackSound_waitTime = 3 * 1000;
	self.attackSound_nextTime = GetTime();
	attackSound = "playerzombie_attackbutton_sound";

	self.adsSound_waitTime = 3 * 1000;
	self.adsSound_nextTime = GetTime();
	adsSound = "playerzombie_adsbutton_sound";

	self.inputSound_nextTime = GetTime();  // don't want to be able to do all sounds at once

	while( 1 )
	{
		if( self.playerzombie_soundboard_disable )
		{
			wait( 0.05 );
			continue;
		}

		if( self UseButtonPressed() )
		{
			if( self can_do_input( "use" ) )
			{
				self thread playerzombie_play_sound( useSound );
				self thread playerzombie_waitfor_buttonrelease( "use" );
				self.useSound_nextTime = GetTime() + self.useSound_waitTime;
			}
		}
		else if( self AttackButtonPressed() )
		{
			if( self can_do_input( "attack" ) )
			{
				self thread playerzombie_play_sound( attackSound );
				self thread playerzombie_waitfor_buttonrelease( "attack" );
				self.attackSound_nextTime = GetTime() + self.attackSound_waitTime;
			}
		}
		else if( self AdsButtonPressed() )
		{
			if( self can_do_input( "ads" ) )
			{
				self thread playerzombie_play_sound( adsSound );
				self thread playerzombie_waitfor_buttonrelease( "ads" );
				self.adsSound_nextTime = GetTime() + self.adsSound_waitTime;
			}
		}

		wait( 0.05 );
	}
}

can_do_input( inputType )
{
	if( GetTime() < self.inputSound_nextTime )
	{
		return false;
	}

	canDo = false;

	switch( inputType )
	{
	case "use":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_use )
		{
			canDo = true;
		}
		break;

	case "attack":
		if( GetTime() >= self.attackSound_nextTime && !self.buttonpressed_attack )
		{
			canDo = true;
		}
		break;

	case "ads":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_ads )
		{
			canDo = true;
		}
		break;

	default:
		ASSERTMSG( "can_do_input(): didn't recognize inputType of " + inputType );
		break;
	}

	return canDo;
}

playerzombie_play_sound( alias )
{
	self play_sound_on_ent( alias );
}

playerzombie_waitfor_buttonrelease( inputType )
{
	if( inputType != "use" && inputType != "attack" && inputType != "ads" )
	{
		ASSERTMSG( "playerzombie_waitfor_buttonrelease(): inputType of " + inputType + " is not recognized." );
		return;
	}

	notifyString = "waitfor_buttonrelease_" + inputType;
	self notify( notifyString );
	self endon( notifyString );

	if( inputType == "use" )
	{
		self.buttonpressed_use = true;
		while( self UseButtonPressed() )
		{
			wait( 0.05 );
		}
		self.buttonpressed_use = false;
	}

	else if( inputType == "attack" )
	{
		self.buttonpressed_attack = true;
		while( self AttackButtonPressed() )
		{
			wait( 0.05 );
		}
		self.buttonpressed_attack = false;
	}

	else if( inputType == "ads" )
	{
		self.buttonpressed_ads = true;
		while( self AdsButtonPressed() )
		{
			wait( 0.05 );
		}
		self.buttonpressed_ads = false;
	}
}

remove_ignore_attacker()
{
	self notify( "new_ignore_attacker" );
	self endon( "new_ignore_attacker" );
	self endon( "disconnect" );

	if( !isDefined( level.ignore_enemy_timer ) )
	{
		level.ignore_enemy_timer = 0.4;
	}

	wait( level.ignore_enemy_timer );

	self.ignoreAttacker = undefined;
}

player_damage_override_cheat( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
	return 0;
}


//
//	player_damage_override
//		MUST return the value of the damage override
//
// MM (08/10/09) - Removed calls to PlayerDamageWrapper because it's always called in
//		Callback_PlayerDamage now.  We just need to return the damage.
//
player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	iDamage = self check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
	if ( !iDamage )
	{
		return 0;
	}

	// WW (8/14/10) - If a player is hit by the crossbow bolt then set them as the holder of the monkey shot
	if( sWeapon == "crossbow_explosive_upgraded_zm" && sMeansOfDeath == "MOD_IMPACT" )
	{
		level.monkey_bolt_holder = self;
	}

	// Raven - snigl - Notify of blow gun hit
	if( GetSubStr(sWeapon, 0, 8 ) == "blow_gun" && sMeansOfDeath == "MOD_IMPACT" )
	{
		eAttacker notify( "blow_gun_hit", self, eInflictor );
	}

	// WW (8/20/10) - Sledgehammer fix for Issue 43492. This should stop the player from taking any damage while in laststand
	if( self maps\_laststand::player_is_in_laststand() )
	{
		return 0;
	}

	if ( isDefined( eInflictor ) )
	{
		if ( is_true( eInflictor.water_damage ) )
		{
			return 0;
		}

		// Turrets - don't damage players
		if(sMeansOfDeath == "MOD_RIFLE_BULLET" && sWeapon == "zombie_bullet_crouch")
		{
			if(level.gamemode != "survival" && eInflictor.owner.vsteam != self.vsteam)
			{
				self notify("grief_damage", sWeapon, sMeansOfDeath, eInflictor.owner);
			}
			return 0;
		}
	}

	// QED explosive weapon damage fix to not damage players
	if(sWeapon == "starburst_ray_gun_zm" || sWeapon == "starburst_m72_law_zm" || sWeapon == "starburst_china_lake_zm")
	{
		return 0;
	}

	if( isDefined( eAttacker ) )
	{
		if(IsPlayer(eAttacker) && eAttacker == self)
		{
			// fix for being able to damage yourself if you meleed while leaning
			if(sMeansofdeath == "MOD_MELEE")
			{
				return 0;
			}

			// dont do damage to self from tesla if bolt was more than 64 units away (didnt change in weapon file because that also changed the radius zombies could take damage from tesla which was not wanted)
			if((IsDefined(sWeapon) && (sWeapon == "tesla_gun_zm" || sWeapon == "tesla_gun_upgraded_zm" || sWeapon == "tesla_gun_powerup_zm" || sWeapon == "tesla_gun_powerup_upgraded_zm")) && (sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH"))
			{
				if(IsDefined(eInflictor) && DistanceSquared(eInflictor.origin, self.origin) > 64*64)
				{
					return 0;
				}
			}
		}

		if(IsPlayer(eAttacker) && eAttacker != self)
		{
			if(level.gamemode != "survival" && eAttacker.vsteam != self.vsteam)
			{
				self notify("grief_damage", sWeapon, sMeansOfDeath, eAttacker);
			}
			return 0;
		}

		if( isDefined( self.ignoreAttacker ) && self.ignoreAttacker == eAttacker )
		{
			return 0;
		}

		if( (isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie) || level.mutators["mutator_friendlyFire"] )
		{
			self.ignoreAttacker = eAttacker;
			self thread remove_ignore_attacker();

			if ( isdefined( eAttacker.custom_damage_func ) )
			{
				iDamage = eAttacker [[ eAttacker.custom_damage_func ]]( self );
			}
			else if ( isdefined( eAttacker.meleeDamage ) )
			{
				iDamage = eAttacker.meleeDamage;
			}
			else
			{
				iDamage = 50;		// 45
			}
		}


		// tracking damage against players
		valid_zomb = false;
		if( isDefined( eAttacker.animname ) )
		{
			valid_zomb = is_in_array( level.ARRAY_VALID_STANDARD_ZOMBIES, eAttacker.animname ) 
						|| eAttacker.animname == "monkey_zombie";
			
			valid_zomb = valid_zomb && !is_boss_zombie( eAttacker.animname );
		}
			

		if( valid_zomb )
		{
			if( self hasProPerk( level.ECH_PRO ) && self.cherry_defense ) {
				self thread maps\_zombiemode_perks::player_electric_cherry_defense( eAttacker );
				return 0;
			}
			else if( self HasPerk( level.WWN_PRK ) && !self.widows_heavy_warning_cooldown )
			{
				eAttacker thread maps\_zombiemode_perks::zombie_watch_widows_web( self );

				if( level.classic )
				{
					nade = "bo3_zm_widows_grenade";
					hasWeapon = self HasWeapon( nade );
					ammo = self GetWeaponAmmoClip( nade );
					hasWineNade = hasWeapon && (ammo > 0);
					if( hasWineNade ) {
						self SetWeaponAmmoClip( nade, ammo - 1 );
						return 0;
					}
				}
				
					
			}
				

			if( is_true(eAttacker.is_zombie) || is_true( eAttacker.isDog )  )
			{
				if( isDefined(eAttacker.zombie_hash) )
				{
					hash = eAttacker.zombie_hash;
					if( hash == self.previous_zomb_attacked_by )
					{
						if( is_true( eAttacker.isDog ) )
						{
							iDamage = int(iDamage * 2);
						}
						else
						{
							iDamage = int(iDamage * 0.5);
						}

					}
						
					self.previous_zomb_attacked_by = hash;

					//Reimagined-Expaded, maybe we'll use later, not necessary right now
					//Slow consequtive zombie attack by slowing animation
					
					if( level.round_number < level.THREHOLD_SLOW_ZOMBIE_ATTACK_ANIM_ROUND_MAX ) {
						eAttacker thread slow_zombie_attack_anim();
					}
					
				}
				else {
					eAttacker.zombie_hash = randomint(level.VALUE_ZOMBIE_HASH_MAX);
				}

				self.stats["damage_taken"] += iDamage;
			}

		}
		
		eAttacker notify( "hit_player" );

		if( is_true(eattacker.is_zombie) && eattacker.animname == "director_zombie" )
		{
			 self PlaySound( "zmb_director_light_hit" );
			 if(RandomIntRange(0,1) == 0 )
		    {
		        self thread maps\_zombiemode_audio::create_and_play_dialog( "general", "hitmed" );
		    }
		    else
		    {
		        self thread maps\_zombiemode_audio::create_and_play_dialog( "general", "hitlrg" );
		    }
		}
		else if( sMeansOfDeath != "MOD_FALLING")
		{
			if(!(( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" ) && self HasPerk("specialty_flakjacket")))
			{
				self PlaySound( "evt_player_swiped" );
			    if(RandomIntRange(0,1) == 0 )
			    {
			        self thread maps\_zombiemode_audio::create_and_play_dialog( "general", "hitmed" );
			    }
			    else
			    {
			        self thread maps\_zombiemode_audio::create_and_play_dialog( "general", "hitlrg" );
			    }
			}
		}
	}
	finalDamage = iDamage;
	

	// claymores and freezegun shatters, like bouncing betties, harm no players
	if ( is_placeable_mine( sWeapon ) || sWeapon == "freezegun_zm" || sWeapon == "freezegun_upgraded_zm" )
	{
		return 0;
	}

	if ( isDefined( self.player_damage_override ) )
	{
		self thread [[ self.player_damage_override ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
	}

	if( sMeansOfDeath == "MOD_FALLING" )
	{
		if ( self HasPerk( "specialty_flakjacket" ) )
		{
			if ( isdefined( self.divetoprone ) && self.divetoprone == 1 )
			{
				if ( IsDefined( level.zombiemode_divetonuke_perk_func ) )
				{
					[[ level.zombiemode_divetonuke_perk_func ]]( self, self.origin, true );
				}
			}

			return 0;
		}

		// increase fall damage beyond 110
		if(iDamage >= 110)
		{
			min_velocity = 420;
			max_velocity = 740;
			if (self.divetoprone)
			{
				min_velocity = 300;
				max_velocity = 560;
			}
			diff_velocity = max_velocity - min_velocity;
			velocity = abs(self.fall_velocity);
			if (velocity < min_velocity)
			{
				velocity = min_velocity;
			}

			fall_damage = int(((velocity - min_velocity) / diff_velocity) * 110);

			if(fall_damage > iDamage)
			{
				iDamage = fall_damage;
				finalDamage = fall_damage;
			}
		}
	}

	players = get_players();

	//iprintln("health: " + self.health);

	//Reimagined-Expanded
	//Raygun doesnt damage players anymore
	if ( sWeapon == "ray_gun_zm" || sWeapon == "ray_gun_upgraded_zm" )
	{
		return 0;
	}


	if( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		// check for reduced damage from flak jacket perk
		if ( self HasPerk( "specialty_flakjacket" ) )
		{
			return 0;
		}

		if(self.health > 75)
		{
			return 75;
		}

		iDamage = 75;
		finalDamage = 75;
	}

	//iprintln("i: " + iDamage);
	//iprintln("final: " + finalDamage);

	//iprintln(sMeansOfDeath);
	//iprintln(finalDamage);

	if( iDamage < self.health )
	{
		if ( IsDefined( eAttacker ) )
		{
			eAttacker.sound_damage_player = self;

			if( IsDefined( eAttacker.has_legs ) && !eAttacker.has_legs )
			{
			    self maps\_zombiemode_audio::create_and_play_dialog( "general", "crawl_hit" );
			}
			else if( IsDefined( eAttacker.animname ) && ( eAttacker.animname == "monkey_zombie" ) )
			{
			    self maps\_zombiemode_audio::create_and_play_dialog( "general", "monkey_hit" );
			}
		}

		// MM (08/10/09)
		return finalDamage;
	}
	if( level.intermission )
	{
		level waittill( "forever" );
	}

	if(level.gamemode != "survival")
	{
		self maps\_zombiemode_grief::store_player_weapons();
	}

	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self || players[i].is_zombie || players[i] maps\_laststand::player_is_in_laststand() || players[i].sessionstate == "spectator" )
		{
			count++;
		}
	}
	if( count < players.size )
	{
		// MM (08/10/09)
		return finalDamage;
	}

	//if ( maps\_zombiemode_solo::solo_has_lives() )
	//{
	//	SetDvar( "player_lastStandBleedoutTime", "3" );
	//}
	//else
	//{
	if ( players.size == 1 && flag( "solo_game" ) && level.gamemode == "survival" )
	{
		if ( self.lives == 0 )
		{
			self.intermission = true;
		}
	}
	//}

	// WW (01/05/11): When a two players enter a system link game and the client drops the host will be treated as if it was a solo game
	// when it wasn't. This led to SREs about undefined and int being compared on death (self.lives was never defined on the host). While
	// adding the check for the solo game flag we found that we would have to create a complex OR inside of the if check below. By breaking
	// the conditions out in to their own variables we keep the complexity without making it look like a mess.
	solo_death = ( players.size == 1 && flag( "solo_game" ) && ( self.lives == 0 ) ); // there is only one player AND the flag is set AND self.lives equals 0
	non_solo_death = ( players.size > 1 || ( players.size == 1 && !flag( "solo_game" ) ) ); // the player size is greater than one OR ( players.size equals 1 AND solo flag isn't set )

	if ( (solo_death || non_solo_death) ) // if only one player on their last life or any game that started with more than one player
	{
		if(level.gamemode == "survival")
		{
			self thread maps\_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
			self player_fake_death();
		}
	}

	if( count == players.size )
	{
		if ( players.size == 1 && flag( "solo_game" ) && self.lives > 0 )
		{
			self thread wait_and_revive();
			return finalDamage;
		}
		else if(level.gamemode == "survival")
		{
			level notify("pre_end_game");
			wait_network_frame();
			level notify( "end_game" );
		}
		else
		{
			if(level.gamemode != "race" && level.gamemode != "gg")
			{
				level.last_player_alive = self;
				level thread maps\_zombiemode_grief::round_restart();
			}
			return finalDamage;
		}

		return 0;	// MM (09/16/09) Need to return something
	}
	else
	{
		// MM (08/10/09)
		return finalDamage;
	}
}

	slow_zombie_attack_anim()
	{
		self endon("death");

		self maps\_zombiemode_spawner::set_zombie_run_cycle("walk");

		wait( level.VALUE_SLOW_ZOMBIE_ATTACK_ANIM_TIME );

		self maps\_zombiemode_spawner::set_zombie_run_cycle(self.zombie_move_speed_original);
	}


check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if ( !isdefined( level.player_damage_callbacks ) )
	{
		return iDamage;
	}

	for ( i = 0; i < level.player_damage_callbacks.size; i++ )
	{
		newDamage = self [[ level.player_damage_callbacks[i] ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
		if ( -1 != newDamage )
		{
			return newDamage;
		}
	}

	return iDamage;
}


register_player_damage_callback( func )
{
	if ( !isdefined( level.player_damage_callbacks ) )
	{
		level.player_damage_callbacks = [];
	}

	level.player_damage_callbacks[level.player_damage_callbacks.size] = func;
}


wait_and_revive()
{
	flag_set( "wait_and_revive" );

	if ( isdefined( self.waiting_to_revive ) && self.waiting_to_revive == true )
	{
		return;
	}

	self.waiting_to_revive = true;
	if ( isdefined( level.exit_level_func ) )
	{
		self thread [[ level.exit_level_func ]]();
	}
	else
	{
		self thread default_exit_level();
	}

	// wait to actually go into last stand before reviving
	while ( 1 )
	{
		if ( self maps\_laststand::player_is_in_laststand() )
		{
			break;
		}

		wait_network_frame();
	}

	solo_revive_time = 10.0;

	self.revive_hud SetText( &"GAME_REVIVING" );
	self maps\_laststand::revive_hud_show_n_fade( solo_revive_time );

	flag_wait_or_timeout("instant_revive", solo_revive_time);

	flag_clear( "wait_and_revive" );

	self maps\_laststand::auto_revive( self );
	self.lives--;
	self.waiting_to_revive = false;
}

//Reimagined-Expanded Self is zombie
//HERE
zombie_knockdown( wait_anim, upgraded )
{
	if( is_true(self.knockdown) )
		return;

	//If zombie is not in the map
	if( !checkObjectInPlayableArea( self ) )
	{
		//return; turning off for now
	}
		

	if( !IsDefined(self) || !IsAlive(self) || is_boss_zombie(self.animname) || is_special_zombie(self.animname) )
		return;

	if( self.animname != "zombie" )
		return;

	if( !IsDefined(wait_anim) )
		wait_anim = level.VALUE_ZOMBIE_KNOCKDOWN_TIME;

	if( !IsDefined(upgraded) )
		upgraded = false;

	self.knockdown = true;
	fall_anim = %ai_zombie_thundergun_hit_upontoback;
	if( !is_true( self.has_legs ) )
	{
		//From BO1 origin staffs anim
		fall_anim = %ai_zombie_thundergun_hit_doublebounce;
	}
		
	
	self SetPlayerCollision( 0 );
	//endon_str = "zombie_knockdown_" + attacker.entity_num;
	//self thread setZombiePlayerCollisionOff(attacker, wait_anim, 200, endon_str);
	//self StartRagdoll();
	mag = 20;
	randX = RandomFloatRange(0, 1);
	randY = RandomFloatRange(0, 1);
	//self launchragdoll((randX,randY,1) * mag);

	self animscripted( "fall_anim", self.origin, self.angles, fall_anim );
	animscripts\traverse\zombie_shared::wait_anim_length( fall_anim, wait_anim );
	
	wait( wait_anim );

	if( !IsDefined(self) || !IsAlive(self) )
		return;
	//self.doingRagdollDeath = false;
	//self.nodeathragdoll = true;
	getup_anim = %ai_zombie_thundergun_getup_b;
	if( is_true( self.has_legs ) )
	{
		self animscripted( "getup_anim", self.origin, self.angles, getup_anim );
		animscripts\traverse\zombie_shared::wait_anim_length( getup_anim, wait_anim );
	}
	
	self SetPlayerCollision( 1 );

	wait(0.25);
	self.knockdown = false;

}

//Reimagined-Expanded - kill zombie while he is down, Self is zombie
zombie_ragdoll_kill( player, power, kill_zomb )
{
	self endon( "death" );
	player endon( "disconnect" );

	if( !IsDefined(self) || !IsAlive(self) )
		return;

	if( !isDefined(player) )
		return;

	if( !isDefined( kill_zomb ) )
	{
		kill_zomb = false;	
	}

	//default set power to 75
	if( !isDefined( power ) )
	{
		power = 75;
	}

	self.a.nodeath = true;

	direction_vec = VectorNormalize( self.origin - player.origin );
	direction_vec = vector_scale( direction_vec, power );
	self StartRagdoll();
	self launchragdoll(direction_vec);
	wait_network_frame();

	//self playweapondeatheffects( weap, player getEntityNumber() );
	if( kill_zomb )
		self DoDamage( self.health + 666, player.origin, player, undefined, "MOD_UNKNOWN" );
}



//
//		MUST return the value of the damage override
//

//damage function
actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime )
{
	//iprintln("Weapon: " + weapon);
	//iprintln("Weapon Class: " + WeaponClass(weapon));
	//iprintln("Means of Death: " + meansofdeath);
	//iprintln("Inflictor: " + inflictor);
	//iprintln("Flags: " + flags);
	//iprintln("Has Drop: " + self.hasDrop);
	//iprintln("Final Damage 0: ");
	//iprintln("Zombie hash: " + self.zombie_hash);
	//iprintln("Zomb health: " + self.health);
	//iprintln("Zomb max health: " + self.maxhealth);

	
	//Reimagined-Expanded, different implementation for double PaP
	//DOUBLE_upgraded , _is_double_upgraded , upgraded_double_string
	dwWeap = WeaponDualWieldWeaponName( weapon );
	baseWeapon = weapon;
	weapon = attacker get_upgraded_weapon_string( weapon );

	//Reimagined-Expanded, special weapon category implementations
	//if the weapon is sabertooth and the means of death is MOD_RIFLE_BULLET, set meansOfDeath to "MOD_MELEE"
	if( isSubStr( weapon, "sabertooth" ) && meansofdeath == "MOD_RIFLE_BULLET" )
	{
		meansofdeath = "MOD_MELEE";
	}

	//iprintln("Weapon damaging: " + weapon);
	//iprintln("Health: " + self.maxhealth);
	//iprintln( "dw weap: " + WeaponDualWieldWeaponName( weapon ) );
	
	// WW (8/14/10) - define the owner of the monkey shot
	if( weapon == "crossbow_explosive_upgraded_zm" && meansofdeath == "MOD_IMPACT" )
	{
		level.monkey_bolt_holder = self;
	}
	
	//Reimagined-Expanded-print
	//iprintln( "***HIT :  Zombie health: "+self.health+",  dam:"+damage+", weapon:"+ weapon );
	//iprintln("Mode type is: " + meansofdeath);

	// Raven - snigl - Record what the blow gun hit
	if( GetSubStr(weapon, 0, 8 ) == "blow_gun" && meansofdeath == "MOD_IMPACT" )
	{
		attacker notify( "blow_gun_hit", self, inflictor );
	}

	if ( isdefined( attacker.animname ) && attacker.animname == "quad_zombie" )
	{
		if ( isdefined( self.animname ) && self.animname == "quad_zombie" )
		{
			return 0;
		}
	}

	if( isdefined( self.animname ) && is_in_array(level.ARRAY_VALID_DESPAWN_ZOMBIES, self.animname) )
	{
		self notify("zombie_damaged");
	}

	// Turrets - kill in 4 shots
	if(meansofdeath == "MOD_RIFLE_BULLET" && weapon == "zombie_bullet_crouch")
	{
		damage = int(self.maxhealth/4) + 1;

		if(damage < 500)
		{
			damage = 500;
		}
	}

	// Gersch - skip damage if they are dead do full damage
	if( IsDefined( self._black_hole_bomb_collapse_death ) && self._black_hole_bomb_collapse_death == 1 )
	{
		return self.maxhealth + 1000;
	}

	// skip conditions
	if( !isdefined( self) || !isdefined( attacker ) )
		return damage;
	if ( !isplayer( attacker ) && isdefined( self.non_attacker_func ) )
	{
		override_damage = self [[ self.non_attacker_func ]]( damage, weapon );
		if ( override_damage )
			return override_damage;
	}
	if ( !isplayer( attacker ) && !isplayer( self ) )
		return damage;
	if( !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;

	//iprintln( meansofdeath );
	//iprintln( "Anim name: " + self.animname );
	old_damage = damage;
	final_damage = damage;
	//iprintln("Final Damage 1: " + final_damage);

	if ( IsDefined( self.actor_damage_func ) )
	{
		final_damage = [[ self.actor_damage_func ]]( weapon, old_damage, attacker );
		//iprintln( "Custom damage function: " + final_damage );
	}

	if ( IsDefined( self.actor_full_damage_func ) )
	{
		final_damage = [[ self.actor_full_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime );
		//iprintln( " Full Custom damage function: " + final_damage );
	}

	//iprintln("Final Damage 2: " + final_damage);

	// debug
	/#
		if ( GetDvarInt( #"scr_perkdebug") )
			println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	#/

	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;

	if( !isDefined( self.damage_assists ) )
	{
		self.damage_assists = [];
	}

	if ( !isdefined( self.damage_assists[attacker.entity_num] ) )
	{
		self.damage_assists[attacker.entity_num] = attacker;
	}

	if( level.mutators[ "mutator_headshotsOnly" ] && !is_headshot( weapon, sHitLoc, meansofdeath ) )
	{
		return 0;
	}

	if( level.mutators[ "mutator_powerShot" ] )
	{
		final_damage = int( final_damage * 1.5 );
	}

	//iprintln("Final Damage 3: " + final_damage);

	/***
		DEADSHOT usePlayerHitmarkers
	***/
	validHitmarkerDeathTypes = array("MOD_RIFLE_BULLET", "MOD_PISTOL_BULLET");
	usePlayerHitmarkers = is_in_array(validHitmarkerDeathTypes, meansofdeath);


	if( level.classic )
		usePlayerHitmarkers = usePlayerHitmarkers && attacker HasPerk(level.DST_PRK);
	else
		usePlayerHitmarkers = usePlayerHitmarkers && attacker hasProPerk(level.DST_PRO);

	if( usePlayerHitmarkers )
	{
		weakpoints = array_add(level.CONDITION_DEADSHOT_PRO_WEAKPOINTS, self.weakpoint);
		
		if( is_in_array(weakpoints, sHitLoc) ) 
		{
			attacker thread maps\_zombiemode_perks::trigger_deadshot_pro_hitmarker( true );
		} else {
			attacker thread maps\_zombiemode_perks::trigger_deadshot_pro_hitmarker( false );
		}	
	}

	/***
		END DEADSHOT usePlayerHitmarkers
	***/

	if((is_true(level.zombie_vars["zombie_insta_kill"]) || is_true(attacker.powerup_instakill) || is_true(attacker.personal_instakill)) && !is_true(self.magic_bullet_shield) && self.animname != "thief_zombie" && self.animname != "director_zombie" && self.animname != "sonic_zombie" && self.animname != "napalm_zombie" && self.animname != "astro_zombie" && !is_true(self.upgraded_dog))
	{
		// insta kill should not effect these weapons as they already are insta kill, causes special anims and scripted things to not work
		no_insta_kill_on_weps = array("tesla_gun_zm", "tesla_gun_upgraded_zm", "tesla_gun_powerup_zm", "tesla_gun_powerup_upgraded_zm", "humangun_zm", "humangun_upgraded_zm", "microwavegundw_zm", "microwavegundw_upgraded_zm");
		//iprintln("Final Damage 3.5: " + final_damage);
		if(!is_in_array(no_insta_kill_on_weps, weapon))
		{
			if ( !is_true( self.no_gib ) )
			{
				self maps\_zombiemode_spawner::zombie_head_gib();
			}

			if( is_true( self.in_water ) )
			{
				self.water_damage = true;
			}

				//Shino Special Behavior
			if( level.mapname == "zombie_cod5_sumpf" && IsDefined( level.current_swamplight_struct ))
			{
				isNearSwamplight = checkDist( self.origin, level.current_swamplight_struct.origin, level.THRESHOLD_SHINO_SWAMPLIGHT_KILL_RADIUS );
				if( isNearSwamplight)
				{
					level notify( "swamplight_zomb_sacraficed", self );
					return 0;
				}
			}

			return self.maxhealth + 1000;
		}
	}
	//If its install and a boss zombie, double damage
	if( is_true(level.zombie_vars["zombie_insta_kill"]) && is_boss_zombie(self.animname) )
	{
		damage *= 2;
	}

	if(meansofdeath == "MOD_MELEE" )
	{

		final_damage = 200;	//base damage
		
		undefined_weapon = !IsDefined(weapon);
		boss_zombie = is_boss_zombie(self.animname);

		if(  undefined_weapon )  
			return final_damage;
		
		hasUgradedKnife = ( attacker HasWeapon("bowie_knife_zm") ||
							attacker HasWeapon("combat_bowie_knife_zm") ||
							attacker HasWeapon("sickle_knife_zm") ||
							attacker HasWeapon("combat_sickle_knife_zm") );

		hasUgradedKnife = hasUgradedKnife || ( attacker.knife_index > 0 );

		usingUpgradedKnife = ( weapon == "bowie_knife_zm" || 
							weapon == "combat_bowie_knife_zm" ||
							weapon == "sickle_knife_zm" || 
							weapon == "combat_sickle_knife_zm" );

		usingUpgradedKnife = IsSubStr(weapon, "knife_") && hasUgradedKnife;

		usingBallisticKnife = ( weapon == "knife_ballistic_zm" || baseWeapon == "knife_ballistic_upgraded_zm" );		

		if( boss_zombie ) {
			//skip pre processing for punch
		}
		else if( is_in_array(level.ARRAY_VALID_ZOMBIE_KNOCKDOWN_WEAPONS, weapon ) && is_true( self.is_zombie ) ) 		//knife punch!
		{
			//iprintln("Punching Zombie " + weapon);
			wait_anim = level.VALUE_ZOMBIE_KNOCKDOWN_TIME;
			if( weapon == "vorkuta_knife_zm" )
				wait_anim *= 1.5;

			if( final_damage < self.health ) {
				self thread zombie_knockdown( wait_anim, false );
			} 
			

		}
		else if ( weapon == "upgraded_knife_zm" ) //upgraded knife/punch
		{
			self [[ self.thundergun_fling_func ]]( attacker );
		}
		else if( (usingUpgradedKnife || (usingBallisticKnife && hasUgradedKnife) )   && !is_boss_zombie(self.animname)) 
		{
			final_damage = int(self.maxhealth / 3) + 10;
			if( level.round_number < 12)
				final_damage = int( self.maxhealth ) + 100;
			else if( level.round_number < 18 || is_true( self.isDog ) )
				final_damage *= 2;

		}
		else if( weapon == "combat_knife_zm" || weapon == "knife_zm" ) //Reimagined, knife held as independent weapo
		{
			//iprintln("Knifing Zombie " + weapon);
			damage = int(self.maxhealth / level.round_number) + 100;
			factor = 4;
			if( level.round_number < 6 )
				factor = 2;
			
			final_damage = int(self.maxhealth / factor ) + 10;
			if(damage > final_damage)
				final_damage = damage;

		}

		base_knife_damage = final_damage;

		//Bonus for ballistic knife
		if( isSubStr(weapon, "ballistic") )
		{
			
			if( weapon == "knife_ballistic_zm" )
			{
				if( is_boss_zombie(self.animname) )
					final_damage = 1000;
				else
					final_damage = int(level.THRESHOLD_MAX_ZOMBIE_HEALTH * 0.1);
			} 
			else if( weapon == "knife_ballistic_upgraded_zm" )
			{
				if( is_boss_zombie(self.animname) )
					final_damage = 2000;
				else
					final_damage = int(level.THRESHOLD_MAX_ZOMBIE_HEALTH * 0.3);
				
			} 
			else if( weapon == "knife_ballistic_upgraded_zm_x2" )
			{
				if( is_boss_zombie(self.animname) )
					final_damage = 4000;
				//else if meansofdeath is melee
				else //if( meansOfDeath == "MOD_MELEE" )
				{
					//\give knife_ballistic_upgraded_zm_x2
					final_damage = int( level.THRESHOLD_MAX_ZOMBIE_HEALTH * 0.6 );

					if( final_damage > self.health )
					{
						//just shock zombie, no shocked anim
						self thread maps\_zombiemode_weapon_effects::tesla_play_death_fx();
					}
					else
					{
						//Zomb is not killed, stun him
						self thread maps\_zombiemode_weapon_effects::tesla_arc_damage( self, attacker, 128, 0);
						wait(0.01);
					}					
									
				}
					
			}

			final_damage += base_knife_damage;
		}
		
		if( attacker hasProPerk( level.STM_PRO ) ) {
			final_damage *= 2;
		}

		//return final_damage;
	}

	if( meansofdeath == "MOD_IMPACT" )
	{
		//else if statement for all ballistic knife levels
		if( weapon == "knife_ballistic_zm" )
		{

		}
		else if( weapon == "knife_ballistic_upgraded_zm" )
		{
			//\give knife_ballistic_upgraded_zm_x2
			self thread maps\_zombiemode_weapon_effects::tesla_arc_damage( self, attacker, 128, 1);
			if( self.marked_for_tesla )
				final_damage = int( level.THRESHOLD_MAX_ZOMBIE_HEALTH * 0.6 );
							
			wait(0.01);
		}
		else if( weapon == "knife_ballistic_upgraded_zm_x2" )
		{
			//\give knife_ballistic_upgraded_zm_x2
			self thread maps\_zombiemode_weapon_effects::tesla_arc_damage( self, attacker, 128, 2);
			if( self.marked_for_tesla )
				final_damage = int( self.max_health + 1000 );
							
			wait(0.01);
		}
	}

	//iprintln("Final Damage 5: " + final_damage);

	//ORIGIN_
	//iprintln("Origin: " + attacker.origin );
	//iprintln("class: " + attacker.classname );
	//iprintln("class: " + attacker.class );
	/*
	//iprintln("Testing has Upp Jugg: " + attacker hasProPerk(level.JUG_PRO));
	//iprintln("Testing has Upp QRV: " + attacker hasProPerk(level.QRV_PRO));
	//iprintln("Testing has Upp SPD: " + attacker hasProPerk(level.SPD_PRO));
	//iprintln("Testing has Upp DTP: " + attacker hasProPerk(level.DBT_PRO));
	//iprintln("Testing has Upp STM: " + attacker hasProPerk(level.STM_PRO));
	//iprintln("Testing has Upp PHD: " + attacker hasProPerk(level.PHD_PRO));
	//iprintln("Testing has Upp DST: " + attacker hasProPerk(level.DST_PRO));
	//iprintln("Testing has Upp MUL: " + attacker hasProPerk(level.MUL_PRO));
	//iprintln("Testing has Upp ECH: " + attacker hasProPerk(level.ECH_PRO));
	//iprintln("Testing has Upp VLT: " + attacker hasProPerk(level.VLT_PRO));
	//iprintln("Testing has Upp WWN: " + attacker hasProPerk(level.WWN_PRO)); 

	//iprintln("BA: " + attacker HasPerk("specialty_bulletaccuracy"));
	//iprintln("SA: " + attacker HasPerk("specialty_bulletaccuracy"));
	//iprintln("SS: " + attacker HasPerk("specialty_stockpile"));

	*/
	
	if(weapon == "ray_gun_zm" )
	{
		min_factor = 8;
		baseDmg = 20000;
		rayDmg = 20000;

		if( rayDmg < self.health / min_factor )
			rayDmg = self.health / min_factor;
		
		if(attacker hasProPerk(level.PHD_PRO))
			rayDmg *= 2;
	
		if( is_boss_zombie(self.animname) )
			rayDmg = baseDmg / 10;


		final_damage = rayDmg;

	}

	if( weapon == "ray_gun_upgraded_zm" || weapon == "m1911_upgraded_zm" )
	{
		min_factor = 4;
		basedDmg = int( level.THRESHOLD_MAX_ZOMBIE_HEALTH / min_factor );
		rayDmg = basedDmg;

		if(attacker hasProPerk(level.PHD_PRO))
			rayDmg *= 2;

		if( is_boss_zombie(self.animname) )
			rayDmg = basedDmg / 10;

		final_damage = rayDmg;
	}

	//if(weapon == "sniper_explosive_zm" || weapon == "sniper_explosive_upgraded_zm")
	//The weapon is actually the bolt, not the gun
	
	if(weapon == "sniper_explosive_bolt_zm" || weapon == "sniper_explosive_bolt_upgraded_zm")
	{
		factor = level.VALUE_COAST_SCAVENGER_ROUND_SCALING_FACTOR * level.round_number;
		final_damage = int( damage * factor);

		if( IsSubStr( weapon, "upgraded" ) )
			final_damage *= 2;

	}


	// no damage scaling for these wonder weps
	//iprintln("meansOfDeath: " + meansofdeath);
	inRange = checkDist( attacker.origin, self.origin, level.WEAPON_SABERTOOTH_RANGE );
	if( IsSubStr( weapon, "sabertooth" ) && meansofdeath == "MOD_MELEE" && inRange )
	{
		//baseDmg = level.THRESHOLD_MAX_ZOMBIE_HEALTH * 0.02;
		baseDmg = 6000;
		//10% of zombie's max health
	
		/*
			For each of following criteria, increase damage by 50%
		*/

		//Is weapon upgraded
		if( IsSubStr( weapon, "upgraded" ) ) 
			baseDmg *= 2;
		
		//Is weapon double upgraded
		if( IsSubStr( weapon, "_x2" ) )
			baseDmg *= 2;

		//Player has stamina upgraded
		if( attacker hasProPerk(level.STM_PRO) )
			baseDmg *= 2;

		//Zombie is afflicted by shock or fire or poison
		zombie_aflicted = is_true( self.marked_for_tesla ) 
			|| is_true( self.marked_for_freeze ) 
			|| is_true( self.marked_for_poison ) 
			|| is_true( self.burned )
			|| is_true( self.knockdown );
		if( zombie_aflicted )
			baseDmg *= 2;

		/* 
			Special Effects for upgraded and x2
			Not applicable to boss zombies
		*/

		if( !is_boss_zombie(self.animname) )
		{
			//If animname is not zombie, set damage equal to max health
			if( self.animname == "zombie" )
			{
					//If upgraded, apply hellfire to all zombies
				if( IsSubStr( weapon, "_x2" ) && !is_true( self.burned ) )
				{
					//25% chance to apply hellfire to zombie
					//if( randomint(8) == 0 )
					if( attacker.bullet_hellfire )
						self thread maps\_zombiemode_weapon_effects::bonus_fire_damage( self, attacker, 20, level.VALUE_HELLFIRE_TIME);
				}
				//If double upgraded, shock nearby zombies too
				doKnockDownChance = IsSubStr( weapon, "upgraded" ) 
					&& !is_true( self.knockdown )
					&& !is_true( self.marked_for_tesla )
					&& checkDist( attacker.origin, self.origin, 35 );

				if( doKnockDownChance )
				{
					//25% chance to knock zombie down
					if( randomint(1) == 0 )
						self thread zombie_knockdown( level.VALUE_ZOMBIE_KNOCKDOWN_TIME );
					
				}
			}
			else
			{
				//Kills dogs, nova crawlers, and monkeys in one hit
				baseDmg = self.maxhealth;
			}

		}
		
		if(is_boss_zombie(self.animname) )
			baseDmg = baseDmg / 100;
			
		final_damage = baseDmg;
		//iprintln("Final Damage 4: " + final_damage);
		//return final_damage;
	}

	//iprintln("Final Damage 5: " + final_damage);

	// damage scaling for explosive weapons
	// consistent damage and scales for zombies farther away from explosion better
	if(meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" || meansofdeath == "MOD_PROJECTILE" || meansofdeath == "MOD_PROJECTILE_SPLASH")
	{
		// no damage scaling for these wonder weps
		if(weapon != "tesla_gun_zm" && weapon != "tesla_gun_upgraded_zm" && weapon != "tesla_gun_powerup_zm" && weapon != "tesla_gun_powerup_upgraded_zm" && weapon != "freezegun_zm" && weapon != "freezegun_upgraded_zm")
		{
			// boss zombie types do not get damage scaling
			if( !is_boss_zombie(self.animname) )
			{
				if( is_true( attacker.divetonuke_damage ) ) {
					return damage;
				}

				if( level.round_number < 15 )
				{
					final_damage = self.maxhealth;
				}
				else if( level.round_number < 25 )
				{
					final_damage = int(self.maxhealth / 2) + 10;
				}
				else
				{
					final_damage = int(self.maxhealth / 4) + 10;
				}
				
				min_damage = 20000;
				if(attacker HasPerk(level.PHD_PRK))
				{
					min_damage *= 2;
					final_damage *= 2;
				}

				if(attacker hasProPerk(level.PHD_PRO))
				{
					min_damage *= 2;
					final_damage *= 1.5;	//Total 75% Max_heath_damage
				}

				if( final_damage < min_damage )
					final_damage = min_damage;
					
			} 
			else if( is_true( attacker.divetonuke_damage ) )
			{
				return damage / 10; //boss zombie balancing
			}

		}

		//if thief zombie, trigger explosive damage
		if( self.animname == "thief_zombie" )
		{
			self notify("explosive_damage");
		}

	}

	// damage for non-shotgun bullet weapons - deals the same amount of damage through walls and multiple zombies
	// all body shots deal the same damage
	// neck, head, and healmet shots all deal the same damage

	//print the weapon
	//iprintln("Weapon: " + weapon);
	
	if(meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_RIFLE_BULLET")
	{
		
		//Reimagined-Expanded dont want to do a whole extra switch case for double pap damage, so we take subtring
		
		weaponName=weapon;
		if( IsSubStr( weapon, "_x2" ) ) {
				weaponName = GetSubStr(weapon, 0, weapon.size-3);
		}
		
		
		switch(weaponName)
		{
		//REGULAR WEAPONS
		case "m1911_zm":
			final_damage = 25;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.8;
			break;
		case "cz75_zm":
		case "cz75dw_zm":
			final_damage = 400;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "python_zm":
			final_damage = 2200;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 1.5;
			break;
		case "m14_zm":
		case "zombie_m1garand":
			final_damage = 390;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "ak74u_zm":
		case "zombie_thompson":
		case "mp40_zm":
		case "makarov_zm":
			final_damage = 360;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "mpl_zm":
		case "mp5k_zm":
		case "pm63_zm":
		case "asp_zm":
			final_damage = 320;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "ppsh_zm":
		case "spectre_zm":
			final_damage = 360;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.25;
			break;
		case "uzi_zm":
		case "mac11_zm":
		case "skorpion_zm":
		final_damage = 420;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 1.50;
			break;		
		case "m16_zm":
		case "g11_lps_zm":
		case "famas_zm":
		case "zombie_stg44":
		case "zombie_type100_smg":
			final_damage = 400;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "aug_acog_zm":
			final_damage = 460;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.25;
			break;
		case "commando_zm":
		case "galil_zm":
		case "ak47_zm":
			final_damage = 470;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "enfield_zm":
			final_damage = 520;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "fnfal_zm":
			final_damage = 520;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
			break;
		case "rpk_zm":
			final_damage = 1625;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.75;
			break;
		case "hk21_zm":
			final_damage = 1700;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.75;
			break;
		case "stoner63_zm":
			final_damage = 1800;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "m60_zm":
			final_damage = 2240;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "dragunov_zm":
			final_damage = 26000;
			if( (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") && !is_boss_zombie(self.animname) )
				final_damage *= 3;
			break;
		case "psg1_zm":
			final_damage = 44000;
			if( (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") && !is_boss_zombie(self.animname) )
				final_damage *= 3;
			break;
		case "l96a1_zm":
			final_damage = 36000;
			if( (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") && !is_boss_zombie(self.animname) )
				final_damage *= 3.5;
			break;
		//CLASSIC WEAPONS
		case "zombie_kar98k":
		case "zombie_type99_rifle":
		case "zombie_springfield":
			final_damage = 700;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "zombie_m1carbine":
			final_damage = 900;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "zombie_gewehr43":
			final_damage = 600;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "zombie_bar":
			final_damage = 900;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2;
			break;
		case "kar98k_scoped_zombie":
			final_damage = 1000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
			break;
		case "zombie_fg42":
			final_damage = 400;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 1.5;
			break;
		//UPGRADED WEAPONS
		case "cz75_upgraded_zm":
		case "cz75dw_upgraded_zm":
			final_damage = 1000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3.5;
			break;
		case "python_upgraded_zm":
			final_damage = 5000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "makarov_upgraded_zm":
			final_damage = 2100;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
			break;
		case "m14_upgraded_zm":
		case "m1garand_upgraded_zm":
		case "zombie_m1garand_upgraded":
			final_damage = 1400;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "mp40_upgraded_zm":
			final_damage = 1100;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "mp5k_upgraded_zm":
		case "mpl_upgraded_zm":
		case "pm63_upgraded_zm":
			final_damage = 1060;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "ppsh_upgraded_zm":
			final_damage = 1100;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "m16_gl_upgraded_zm":
			final_damage = 1350;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "famas_upgraded_zm":
			final_damage = 1450;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "ak74u_upgraded_zm":
			final_damage = 1100;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "aug_acog_mk_upgraded_zm":
			final_damage = 1500;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "commando_upgraded_zm":
		case "ak47_ft_upgraded_zm":
			final_damage = 1600;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "galil_upgraded_zm":
		case "g11_lps_upgraded_zm":
			final_damage = 1550;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "spectre_upgraded_zm":
		case "kiparis_upgraded_zm":
			final_damage = 1200;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "uzi_upgraded_zm":
		case "mac11_upgraded_zm":
		case "skorpion_upgraded_zm":
		final_damage = 1450;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 1.50;
			break;
		case "rpk_upgraded_zm":
			final_damage = 1980;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "hk21_upgraded_zm":
			final_damage = 1800;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "m60_upgraded_zm":
			final_damage = 4000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 2.5;
			break;
		case "stoner63_upgraded_zm":
		case "bar_upgraded_zm":
		case "zombie_bar_upgraded":
			final_damage = 2100;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;
		case "dragunov_upgraded_zm":
			final_damage = 58000;
			if( (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")  )
				final_damage *= 3;
			break;
		case "psg1_upgraded_zm":
			final_damage = 90000;
			if( (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")  )
				final_damage *= 3;
			break;
		case "l96a1_upgraded_zm":
			final_damage = 74000;
			if( (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") )
				final_damage *= 4;
			break;
		case "fnfal_upgraded_zm":
			final_damage = 800;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 8;
			break;
		case "enfield_upgraded_zm":
			final_damage = 2240;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
			break;
		//UPGRADED WAW WEAPONS
		case "zombie_kar98k_upgraded":
		case "springfield_upgraded_zm":
			final_damage = 4200;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
			break;
		case "zombie_gewehr43_upgraded":
			final_damage = 2240;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
		break;
		case "zombie_m1carbine_upgraded":
			final_damage = 1680;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;

		case "zombie_type100_smg_upgraded":
			final_damage = 1120;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;

		case "zombie_fg42_upgraded":
			final_damage = 1000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;

		case "zombie_stg44_upgraded":
			final_damage = 1200;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;

		case "zombie_thompson_upgraded":
			final_damage = 960;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 3;
			break;

		//Reiminaged-Expanded - Shotgun Damange increase
		case "rottweil72_zm":
			final_damage = 2000 * ( damage / 180);
			break;
		case "rottweil72_upgraded_zm":
			final_damage = 12500 * ( damage / 300);
			break;
		case "ithaca_zm":
		case "zombie_doublebarrel":
		case "zombie_doublebarrel_sawed":
			final_damage = 3000 * ( damage / 160);
			break;
		case "ks23_zm":
		case "mk_aug_upgraded_zm":
			final_damage = 5000 * ( damage / 160);
			break;
		case "ithaca_upgraded_zm":
		case "zombie_doublebarrel_upgraded":
		case "ks23_upgraded_zm":
			final_damage = 10000 * ( damage / 300);
			break;
		case "spas_zm":
		case "zombie_shotgun":
			final_damage = 2600 * ( damage / 160);
			break;
		case "spas_upgraded_zm":
		case "zombie_shotgun_upgraded":
			final_damage = 18000 * ( damage / 300);
			break;
		case "hs10_zm":
			final_damage = 4200 * ( damage / 160);
			break;
		case "hs10_upgraded_zm":
			final_damage = 17500 * ( damage / 300);
			break;
		case "hs10lh_upgraded_zm":
			final_damage = 17500 * ( damage / 300);
			break;
		default:
			//iprintln("default case for damage weapons");
			break;
			
		}

		//Reimagined-Expanded - Buff for early game weapons, they need it
		//Disabling after nerf to health

		
		if( !isSubStr(weapon, "_upgraded") ) {
			final_damage *= level.VALUE_PAP_WEAPON_BONUS_DAMAGE;
		}

		//iprintln("Final Damage 6: " + final_damage);
		
		if( IsSubStr( weapon, "x2" ) ) 
		{
			//flat 4x damage increase for double pap'ed weapon


			//if its a valid shotgun, increase damage by 2x
			if( is_in_array( level.ARRAY_SHOTGUN_WEAPONS, weaponname ) )
			{
				final_damage *= 2;
			} 
			else if( IsSubStr( weapon, "zombie" ) || is_in_array( level.ARRAY_WALL_WEAPONS, weaponname ) )
			{
				final_damage *= 3;
			} 
			else 
			{
				final_damage *= 4;
			}
			
		}
		
		
		// Death Machine - kills in 4 body shots or 2 headshots
		if(weapon == "minigun_zm")
		{
			final_damage = 500;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
			{
				final_damage *= 2;
			}

			if(self.animname != "thief_zombie" && self.animname != "director_zombie" && self.animname != "astro_zombie")
			{
				min_damage = final_damage;
				final_damage = int(self.maxhealth / 4) + 1;
				if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				{
					final_damage *= 2;
				}

				if(final_damage < min_damage)
				{
					final_damage = min_damage;
				}
			}
		}

		if(weapon == "ks23_upgraded_zm_x2")
		{
			if( is_boss_zombie(self.animname) ) {
				//nothing
			}
			else if ( self.animname == "zombie" ) {
				//nothing
			}
			else {	//All special zombie types - dog, monkey, crawer are exectuted and electrecuted
				self thread maps\_zombiemode_weapon_effects::tesla_arc_damage( self, attacker, 128, 2);
			}
				
		}

		if( IsSubStr( weapon, "g11" ) && is_boss_zombie(self.animname) )
		{
			//If upgrad multiply damage by 10, else by 5
			if( IsSubStr( weapon, "upgraded" ) )
				final_damage = int( final_damage * 5 );
			else
				final_damage = int( final_damage * 2 );
		}


		/************************************************

					DOUBLE PAP SPECIAL EFFECTS

		*************************************************/

		// Isolate Bonus damage Weapons
		//  case "spectre_upgraded_zm_x2":
		if( attacker.bullet_isolate ) {
			//iprintln("Isolate Damage");
			final_damage *= 2;
		}

		// Hellfire Weapons
		//  case "ppsh_upgraded_zm_x2":
		//  case "rpk_upgraded_zm_x2":
		//  case "ak47_ft_upgraded_zm_x2":
		//  case "rottweil72_upgraded_zm":
		// case "cz75dw_upgraded_zm_x2":
		// case "sabertooth_upgraded_zm_x2":

		if( (attacker.bullet_hellfire || weapon == "rottweil72_upgraded_zm") && !is_true( self.in_water ) ) 
		{
			//iprintln("Hellfire Damage");
			if(is_boss_zombie(self.animname))
			{	//just double damage
			} else
			{
				radius=level.VALUE_HELLFIRE_RANGE;
				time=level.VALUE_HELLFIRE_TIME;
				if(attacker hasProPerk(level.PHD_PRO)) {
					radius*=level.VALUE_PHD_PRO_HELLFIRE_BONUS_RANGE_SCALE;
					time*=level.VALUE_PHD_PRO_HELLFIRE_BONUS_TIME_SCALE;
				}
				self thread maps\_zombiemode_weapon_effects::bonus_fire_damage( self, attacker, 20, level.VALUE_HELLFIRE_TIME);
														//zomb, player, radius, time
			}
			final_damage = int(final_damage * level.VALUE_AMMOTYPE_BONUS_DAMAGE);
		}
		
		// Sheercold Weapons
		//	case "spectre_upgraded_zm_x2":
		//	case "hk21_upgraded_zm_x2":
		//	case "galil_upgraded_zm_x2":
		if( attacker.bullet_sheercold )
			//&& is_in_array(level.ARRAY_SHEERCOLD_WEAPONS, weapon) ) 
		{	
			//iprintln("SheerCold Damage");
			if(is_boss_zombie(self.animname))
			{	//just double damage
			} else if( !IsDefined(self.marked_for_freeze) || !self.marked_for_freeze ) 
			{
				self thread maps\_zombiemode_weapon_effects::bonus_freeze_damage( self, attacker, 20, 1.5);
				wait(0.05);
			}

			final_damage = int(final_damage * level.VALUE_AMMOTYPE_BONUS_DAMAGE);
		}

		//Shock Weapons
		//	case "ak74u_upgraded_zm_x2":
		//	case "aug_acog_mk_upgraded_zm_x2":
		//	case "famas_upgraded_zm_x2":
		//	case "cz75_upgraded_zm_x2":
		//	case "cz75lh_upgraded_zm_x2":
		//  "Balistic"

		//Randomly give this weapon bullet electric if ads button is pressed
		if( weapon == "cz75dw_upgraded_zm_x2" )
		{

			if( attacker AdsButtonPressed() )
			{
				threshold = 7 +  8 * int(attacker hasProPerk(level.DBT_PRO));
				//iprintln("Threshold: " + threshold);
				if( RandomInt(100) < threshold ) 
					attacker.bullet_electric = true;
				else
					attacker.bullet_electric = false;
			}
			
		}
		 
		if(attacker.bullet_electric && ! is_true( self.marked_for_tesla ) ) 
		{
			//iprintln("Electric Damage");
			if(is_boss_zombie(self.animname)) { 
			//nothing
			} else 
			{
				if( weaponClass(baseWeapon) != "spread" )
					attacker.bullet_electric=false;
				
				self thread maps\_zombiemode_weapon_effects::tesla_arc_damage( self, attacker, 256, 2);
																		//zomb, player, arc range, num arcs
			}

			final_damage = int(final_damage * level.VALUE_AMMOTYPE_BONUS_DAMAGE);
		}

		if( is_in_array(level.ARRAY_EXECUTE_WEAPONS, weapon) && !is_boss_zombie(self.animname) )
		{
			execute_health = 0.34 * self.maxhealth;
			if( self.health < execute_health + final_damage )
			{
				final_damage = self.health;
				return final_damage;
			}
			
		}

		switch(weapon)
		{
			//Electric Effect
			case "ak74u_upgraded_zm_x2":	//currently not in game
			case "aug_acog_mk_upgraded_zm_x2":
			case "famas_upgraded_zm_x2":
			case "cz75_upgraded_zm_x2":
			case "cz75lh_upgraded_zm_x2":
			//Handled Above
			break;
			
			//Fire
			case "ppsh_upgraded_zm_x2":
			case "rpk_upgraded_zm_x2":
			case "ak47_ft_upgraded_zm_x2":
			case "cz75dw_upgraded_zm_x2":
			//Handled Above
			break;
			
			//Freeze
			case "spectre_upgraded_zm_x2":
			case "hk21_upgraded_zm_x2":
			case "galil_upgraded_zm_x2":
			//Handled Above
			break;	
			
			case "commando_upgraded_zm_x2":
			case "stoner63_upgraded_zm_x2":
			case "m60_upgraded_zm_x2":
					final_damage = int(final_damage * 1.5); //big damage
			break;
			case "fnfal_upgraded_zm_x2":
			case "makarov_upgraded_zm_x2":
			case "m14_upgraded_zm":
				if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") {
					final_damage = int(final_damage * 2); //big headshot damage
				}
			break;
			
			//Snipers
			case "psg1_upgraded_zm_x2":
			case "l96a1_upgraded_zm_x2":
			case "dragunov_upgraded_zm_x2":
				final_damage = int(final_damage * 2); //big damage
				if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck") {
					final_damage = int(final_damage * 5); //big damage
				}
			break;
		}
		//End Switch


		if( attacker HasPerk( level.DBT_PRK ) )
		{
			if( attacker hasProPerk(level.DBT_PRO) )
			{
				final_damage = int(final_damage * level.VALUE_DBT_PRO_DAMAGE_BONUS);
			}
			else
			{
				final_damage = int(final_damage * level.VALUE_DBT_DAMAGE_BONUS);
			}
			
		}

		if(attacker HasPerk( level.DST_PRK ) && WeaponClass(baseWeapon) != "spread" && (sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck"))
		{
			final_damage = int(final_damage * 2);
		}

		//iprintln( "Final dmg after main perks: " + final_damage );

		//Reimagined-Expanded -- Deadshot Hitmarkers
		if( attacker hasProPerk(level.DST_PRO) ) //&& WeaponClass(baseWeapon) != "spread" ) 
		{
			//Flat damage increase for ADS
			if( attacker AdsButtonPressed() )
				final_damage = int(final_damage * 1.5);

			if(!isDefined(self.weakpoint))
				self.weakpoint = "";

			weakpoints = array_add(level.CONDITION_DEADSHOT_PRO_WEAKPOINTS, self.weakpoint);
			
			if( is_in_array(weakpoints, sHitLoc) ) 
			{
				attacker.weakpoint_streak++;	//add HUD for this
				headshot_streak_bonus = (1 + (attacker.weakpoint_streak * level.VALUE_DEADSHOT_PRO_WEAKPOINT_STACK) );
				final_damage = int(final_damage * headshot_streak_bonus);
				//attacker thread maps\_zombiemode_perks::trigger_deadshot_pro_hitmarker( true );
			} else {
				attacker.weakpoint_streak = 0;
				//attacker thread maps\_zombiemode_perks::trigger_deadshot_pro_hitmarker( false );
			}
			
		}
		
		//Reimagined-Expanded -- Doubletap Pro Bullet Penetration
		isUpgradedSniper =  is_in_array(level.ARRAY_VALID_SNIPERS, weapon)  && isSubStr(weapon, "upgraded");
		dbt_marked = ( IsDefined(self.dbtap_marked) && self.dbtap_marked == attacker.entity_num );
		boss_zomb = is_boss_zombie(self.animname);
		if( (attacker hasProPerk(level.DBT_PRO) || isUpgradedSniper )
		&&  !dbt_marked 
		&& (attacker.dbtp_penetrated_zombs < level.THRESHOLD_DBT_TOTAL_PENN_ZOMBS) 
		&& !boss_zomb
		)

		{
			self.dbtap_marked = attacker.entity_num;

			args = SpawnStruct();
			args.inflictor = inflictor;
			args.attacker = attacker;
			args.damage = damage;
			args.flags = flags;
			args.meansofdeath = meansofdeath;
			args.weapon = weapon;
			args.vpoint = vpoint;
			args.vdir = vdir;
			args.sHitLoc = sHitLoc;	//maybe chest? Can't give people free headshots
			args.modelIndex = modelIndex;
			args.psOffsetTime = psOffsetTime;
			
			if( attacker hasProPerk(level.DBT_PRO) && isUpgradedSniper )
				attacker thread maps\_zombiemode_weapon_effects::zombie_bullet_penetration( self, args, level.VALUE_SNIPER_PENN_BONUS );
			else 
				attacker thread maps\_zombiemode_weapon_effects::zombie_bullet_penetration( self, args );

		} else {
			//iprintln("Marked: " + dbt_marked);
			self.dbtap_marked = -1;
		}

		//Shotgun Bonus Damage
		if( WeaponClass(baseWeapon) == "spread" ) 
		{
			final_damage *= attacker.shotgun_attrition;
			if( is_boss_zombie(self.animname) ) {
				return int(final_damage / 5);
			}

			//Zombie knockdown
			if( isSubStr(weapon, "upgraded")  )
			{
				if( final_damage >= self.health ) {
				return int( final_damage );
			}

				if( final_damage > int(self.maxhealth / 4) && (self.health > self.max_health / 2) ) {
					self thread zombie_knockdown( level.VALUE_ZOMBIE_KNOCKDOWN_TIME, false );
				}
			}
			
		}

		/* \give statements for snipers:
			\give l96a1_zm
			\give l96a1_upgraded_zm
		*/
		//Handle snipers
		if( is_in_array(level.ARRAY_VALID_SNIPERS, weapon) ) 
		{
			if( is_boss_zombie(self.animname) ) {
				final_damage =  int(final_damage / 5);
			}
			//Zombie knockdown
			else if( final_damage >= self.health ) {
				//no knockdown
			}
			else if( IsSubStr(weapon, "dragunov") ) {
				//no knockdown
			}
			else if( final_damage > int(self.maxhealth / 4) && (self.health > self.max_health / 2) ) {
				self thread zombie_knockdown( level.VALUE_ZOMBIE_KNOCKDOWN_TIME, false );
			}			
		}

		//Widows Wine posion damage
		valid_poison = !is_in_array(level.ARRAY_VALID_SNIPERS, weapon)
			&& ( attacker HasPerk( level.WWN_PRK ) || is_in_array(level.ARRAY_POISON_WEAPONS , weapon) );

		if( valid_poison )
		{
			valid_zomb = is_in_array(level.ARRAY_WIDOWS_VALID_POISON_ZOMBIES, self.animname) && !is_true(self.marked_for_poison);

			if( valid_zomb ) 
			{
				if( !isDefined(self.widows_posion_bullet_count) )
					self.widows_posion_bullet_count = 0;
				
				chances = level.ARRAY_WIDOWS_POISON_CHANCES_BY_BULLET[ self.widows_posion_bullet_count ];
				if( attacker hasProPerk(level.DBT_PRO) )
					chances *= 2;
				rand = randomint(100);
			
				if( rand <= chances*100 ) 
				{
					attacker thread maps\_zombiemode_perks::player_zombie_handle_widows_poison( self );
				}
				else
				{
					self.widows_posion_bullet_count++;
				}
			}
		}

	
		
	}
	//END BULLET DAMAGE

	//projectile impact damage - all body shots deal the same damage
	//neck, head, and healmet shots all deal the same damage
	if(meansofdeath == "MOD_IMPACT")
	{
		if(weapon == "crossbow_explosive_zm")
		{
			final_damage = 750;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
		}
		else if(weapon == "crossbow_explosive_upgraded_zm")
		{
			final_damage = 2250;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
		}
		else if(weapon == "knife_ballistic_zm" || weapon == "knife_ballistic_bowie_zm" || weapon == "knife_ballistic_sickle_zm")
		{
			final_damage = 5000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
		}
		else if(weapon == "knife_ballistic_upgraded_zm" || weapon == "knife_ballistic_bowie_upgraded_zm" || weapon == "knife_ballistic_sickle_upgraded_zm" ||
				weapon == "knife_ballistic_upgraded_zm_x2")
		{
			final_damage = 10000;
			if(sHitLoc == "head" || sHitLoc == "helmet" || sHitLoc == "neck")
				final_damage *= 4;
		}
		else if(is_lethal_grenade(weapon) || is_tactical_grenade(weapon))
		{
			final_damage = 30;
		}
		
		//Reimagined-Expanded - x2 Special Weapons
		if(weapon == "knife_ballistic_upgraded_zm_x2") 
		{
			if(is_boss_zombie(self.animname)) { 
			//nothing
			} else 
			{
				attacker.bullet_electric=false;
				self thread maps\_zombiemode_weapon_effects::tesla_arc_damage( self, attacker, 256, 3);
																		//zomb, player, arc range, num arcs
				wait(0.1);
				if( self.marked_for_tesla )
					final_damage = (self.health + 666);
			}
		}
	}

	//Reimagined-Expanded - x2 Weapons
	if(weapon == "crossbow_explosive_upgraded_zm_x2" && meansofdeath == "MOD_GRENADE_SPLASH" && !is_boss_zombie(self.animname))
	{	

		radius=level.VALUE_EXPLOSIVE_BASE_RANGE / 2;
		dmg=level.VALUE_EXPLOSIVE_BASE_DMG*2;
		hellfire_time=0; //Handled in weapon fx

		if(attacker hasProPerk(level.PHD_PRO)) {
			radius*=level.VALUE_PHD_PRO_EXPLOSION_BONUS_RANGE_SCALE;
			dmg*=level.VALUE_PHD_PRO_EXPLOSION_BONUS_DMG_SCALE;
		}

		attacker thread maps\_zombiemode_weapon_effects::explosive_arc_damage( self, dmg, radius, hellfire_time);
		return self.maxhealth + 1000; // should always kill
			
	}
	
	///*
	
	//Reimagined-Expanded Hellfire spreads more hellfire
	if(meansOfDeath=="hellfire" || weapon == "ft_ak47_upgraded_zm" ) 
	{
		self.in_water = false;
		if( is_true( self.burned ) || is_true( self.in_water ) )
			return 10;

		if( is_boss_zombie(self.animname) ) {
			return 1000;
		}

		radius=level.VALUE_HELLFIRE_RANGE;
		time=level.VALUE_HELLFIRE_TIME;
		if(attacker hasProPerk(level.PHD_PRO)) {
			radius*=level.VALUE_PHD_PRO_HELLFIRE_BONUS_RANGE_SCALE;
			time*=level.VALUE_PHD_PRO_HELLFIRE_BONUS_TIME_SCALE;
		}

		self thread maps\_zombiemode_weapon_effects::bonus_fire_damage( self, attacker, radius, time);
		final_damage = 10;
	}
	
	//Reimagined-Expanded, can china-lake be upgraded??
	if(weapon == "m72_law_zm" || weapon == "china_lake_zm" || weapon == "asp_upgraded_zm" ) 
	{
		radius=level.VALUE_EXPLOSIVE_BASE_RANGE;
		dmg=level.VALUE_EXPLOSIVE_BASE_DMG;
		hellfire_time=level.VALUE_HELLFIRE_TIME;

		if(attacker hasProPerk(level.PHD_PRO)) {
			radius*=level.VALUE_PHD_PRO_EXPLOSION_BONUS_RANGE_SCALE;
			dmg*=level.VALUE_PHD_PRO_EXPLOSION_BONUS_DMG_SCALE;
			hellfire_time*=level.VALUE_PHD_PRO_HELLFIRE_BONUS_TIME_SCALE;
		}

		if(!IsDefined(self.explosive_marked))
			self.explosive_marked = false;

		//Hellfire
		if(weapon == "m72_law_upgraded_zm" || weapon == "china_lake_upgraded_zm") 
		{
			if( !is_boss_zombie(self.animname) && !self.explosive_marked) {
				attacker thread maps\_zombiemode_weapon_effects::explosive_arc_damage( self, dmg, radius, hellfire_time);
				level thread maps\_zombiemode_weapon_effects::napalm_fire_effects( self, 160, hellfire_time, attacker );
				return self.maxhealth + 1000; // should always kill
			} 
		}

		if ( is_boss_zombie(self.animname) )
		{
			final_damage = dmg/10; //against boss zombies
		}
	}


	


	//iprintln( "Final dmg for bullet guns: " + final_damage );
	
	
	//iprintln( "Get weaon ammo: " + (attacker GetWeaponAmmoClip(weapon)) );
	//iprintln( "Mod 10: " + ((attacker GetWeaponAmmoStock(weapon)) % 10) );

	//Classic Special Damage Multipliers (perks and conditions)
	if(weapon == "molotov_zm")
	{
		return self.maxhealth + 1000;
	}

	if((weapon == "sniper_explosive_bolt_zm" || weapon == "sniper_explosive_bolt_upgraded_zm") && self.animname != "director_zombie")
	{
		return self.maxhealth + 1000;
	}


	//iprintln("Final Damage 7: " + final_damage);


	

	if(!is_true(self.nuked) && !is_true(self.marked_for_death))
	{
		final_damage = int(final_damage * attacker.zombie_vars["zombie_damage_scalar"]);
	}

	if ( is_true( self.in_water ) )
	{
		if ( int( final_damage ) >= self.health )
		{
			self.water_damage = true;
		}
	}

	if(self.animname == "director_zombie")
	{

		self.dmg_taken += int(final_damage);
		iprintln("Director Damage: " + self.dmg_taken);
	}

	//Shino Special Behavior
	if( level.mapname == "zombie_cod5_sumpf" && IsDefined( level.current_swamplight_struct ))
	{
		isLethalDamage = int(final_damage) >= self.health;
		isNearSwamplight = checkDist( self.origin, level.current_swamplight_struct.origin, level.THRESHOLD_SHINO_SWAMPLIGHT_KILL_RADIUS );
		if( isLethalDamage && isNearSwamplight)
		{
			level notify( "swamplight_zomb_sacraficed", self );
			return 0;
		}
	}

	//If damage is greater zombie health, do zombie ragdoll
	if( !is_boss_zombie(self.animname) )
	{
		if( int(final_damage) >= self.health )
		{
			/*
				1. If zombie is knocked down, do small ragdoll death
				2. If zombie is killed by sniper or sabertooth, do larger ragdoll death
				3. If player is using a shotgun, and zombie is within 96 units, do ragdoll death
			*/
			isSmallKnockDownWep = is_in_array( level.ARRAY_VALID_SHOTGUNS, weapon ) || is_in_array( level.ARRAY_VALID_ZOMBIE_KNOCKDOWN_WEAPONS , weapon );
			zombieIsCloseToPlayer = checkDist( self.origin, attacker.origin, 96 );
			zombieIsKnockedDown = is_true( self.knocked_down );

			doSmallRagdoll = zombieIsKnockedDown || (isSmallKnockDownWep && zombieIsCloseToPlayer);

			if( doSmallRagdoll )
			{
				self thread zombie_ragdoll_kill( attacker, 50 );
			}
			else if( is_in_array(level.ARRAY_VALID_SNIPERS, weapon) 
			||	   ( IsSubStr( weapon, "sabertooth" ) && meansofdeath == "MOD_MELEE" ) )
			{
				self thread zombie_ragdoll_kill( attacker, 100 );
			}
			
			wait( 0.05 );
		}
	}
	
		
	// return unchanged damage
	//iPrintln( final_damage );
	return int( final_damage );
}


hasProPerk( perk )
{
	return self.PRO_PERKS[ perk ];
}

is_boss_zombie( animname )
{
	if(!isDefined(animname))
		return false;

	return (
	   animname == "thief_zombie"
	|| animname == "director_zombie" 
	|| animname == "astro_zombie" 
	|| animname == "bo2_zm_mech" 
	|| animname == "kf2_scrake" 
	|| animname == "bo1_simianaut"
	|| animname == "boss_zombie"
	);
}

is_special_zombie( animname )
{
	
	if(!isDefined(animname))
		return false;

	return 
	(  
	   animname == "monkey"
	|| animname == "monkey_zombie" 
	|| animname == "napalm_zombie"
	|| animname == "sonic_zombie" 
	//|| animname == "kf2_scrake" 
	//|| animname == "bo1_simianaut" 
	);
}

is_headshot( sWeapon, sHitLoc, sMeansOfDeath )
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_BAYONET" && sMeansOfDeath != "MOD_IMPACT"; //CoD5: MGs need to cause headshots as well. && !isMG( sWeapon );
}

actor_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime)
{
	if ( game["state"] == "postgame" )
		return;

	self SetPlayerCollision(0);
	self StopSounds();

	if( isai(attacker) && isDefined( attacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( attacker.script_owner.team != self.aiteam )
			attacker = attacker.script_owner;
	}

	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;

	if( IsPlayer( level.monkey_bolt_holder ) && sMeansOfDeath == "MOD_GRENADE_SPLASH"
			&& ( sWeapon == "crossbow_explosive_upgraded_zm" || sWeapon == "explosive_bolt_upgraded_zm" ) ) //
	{
		level._bolt_on_back = level._bolt_on_back + 1;
	}


	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		multiplier = 1;
		if( is_headshot( sWeapon, sHitLoc, sMeansOfDeath ) )
		{
			multiplier = 1.5;
		}

		type = undefined;

		//MM (3/18/10) no animname check
		if ( IsDefined(self.animname) )
		{
			switch( self.animname )
			{
			case "quad_zombie":
				type = "quadkill";
				break;
			case "ape_zombie":
				type = "apekill";
				break;
			case "zombie":
				type = "zombiekill";
				break;
			case "zombie_dog":
				type = "dogkill";
				break;
			}
		}
		//if( isDefined( type ) )
		//{
		//	value = maps\_zombiemode_rank::getScoreInfoValue( type );
		//	self process_assist( type, attacker );

		//	value = int( value * multiplier );
		//	attacker thread maps\_zombiemode_rank::giveRankXP( type, value, false, false );
		//}
	}

	if(sMeansofdeath == "MOD_RIFLE_BULLET" && sWeapon == "zombie_bullet_crouch")
	{
		eInflictor.owner.kills++;
	}

	if(sMeansOfDeath == "MOD_UNKNOWN" && (sWeapon == "thundergun_zm" || sWeapon == "thundergun_upgraded_zm"))
	{
		self.no_powerups = true;
	}

	if((sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH") && (sWeapon == "freezegun_zm" || sWeapon == "freezegun_upgraded_zm"))
	{
		self.no_powerups = true;
	}

	if(sMeansOfDeath == "MOD_IMPACT" && (sWeapon == "sniper_explosive_zm" || sWeapon == "sniper_explosive_upgraded_zm"))
	{
		//self.no_powerups = true;
	}

	if(sMeansOfDeath == "MOD_PROJECTILE_SPLASH" && sWeapon == "humangun_upgraded_zm")
	{
		self.no_powerups = true;
		self thread hide_and_delete();
	}

	if(is_true(self.is_ziplining))
	{
		self.deathanim = undefined;
	}

	if ( IsDefined( self.actor_killed_override ) )
	{
		self [[ self.actor_killed_override ]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
	}

	//iprintln(sWeapon);

}


process_assist( type, attacker )
{
	if ( isDefined( self.damage_assists ) )
	{
		for ( j = 0; j < self.damage_assists.size; j++ )
		{
			player = self.damage_assists[j];

			if ( !isDefined( player ) )
				continue;

			if ( player == attacker )
				continue;

			//assist_xp = maps\_zombiemode_rank::getScoreInfoValue( type + "_assist" );
			//player thread maps\_zombiemode_rank::giveRankXP( type + "_assist", assist_xp );
		}
		self.damage_assists = undefined;
	}
}


end_game()
{
	level waittill ( "end_game" );

	flag_set("round_restarting");

	clientnotify( "zesn" );
	level thread maps\_zombiemode_audio::change_zombie_music( "game_over" );

	//AYERS: Turn off ANY last stand audio at the end of the game
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		setClientSysState( "lsm", "0", players[i] );

		players[i].zombie_vars["zombie_powerup_minigun_time"] = 0;
		players[i].zombie_vars["zombie_powerup_tesla_time"] = 0;
		players[i].zombie_vars["zombie_powerup_insta_kill_time"] = 0;
		players[i].zombie_vars["zombie_powerup_fire_sale_time"] = 0;
		players[i].zombie_vars["zombie_powerup_point_doubler_time"] = 0;
		players[i].zombie_vars["zombie_powerup_bonfire_sale_time"] = 0;

		players[i].zombie_vars["zombie_powerup_half_damage_time"] = 0;
		players[i].zombie_vars["zombie_powerup_slow_down_time"] = 0;
		players[i].zombie_vars["zombie_powerup_half_points_time"] = 0;

		if(IsDefined(players[i].perk_hud))
		{
			perks = GetArrayKeys(players[i].perk_hud);
			for(j=0;j<perks.size;j++)
			{
				players[i] maps\_zombiemode_perks::perk_hud_destroy(perks[j]);
			}
		}

		if(level.gamemode != "survival")
		{
			players[i].grief_hud1.alpha = 0;
			players[i].grief_hud2.alpha = 0;
		}

		players[i] EnableInvulnerability();

		players[i] thread freeze_controls_on_ground();
	}

	StopAllRumbles();

	level.intermission = true;
	wait 0.1;

	update_leaderboards();

	game_over = [];
	survived = [];

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		game_over[i] = NewClientHudElem( players[i] );
		game_over[i].alignX = "center";
		game_over[i].alignY = "middle";
		game_over[i].horzAlign = "center";
		game_over[i].vertAlign = "middle";
		game_over[i].y -= 130;
		game_over[i].foreground = true;
		game_over[i].fontScale = 3;
		game_over[i].alpha = 0;
		game_over[i].color = ( 1.0, 1.0, 1.0 );
		game_over[i] SetText( &"ZOMBIE_GAME_OVER" );

		game_over[i] FadeOverTime( 1 );
		game_over[i].alpha = 1;
		if ( players[i] isSplitScreen() )
		{
			game_over[i].y += 40;
		}

		survived[i] = NewClientHudElem( players[i] );
		survived[i].alignX = "center";
		survived[i].alignY = "middle";
		survived[i].horzAlign = "center";
		survived[i].vertAlign = "middle";
		survived[i].y -= 100;
		survived[i].foreground = true;
		survived[i].fontScale = 2;
		survived[i].alpha = 0;
		survived[i].color = ( 1.0, 1.0, 1.0 );
		if ( players[i] isSplitScreen() )
		{
			survived[i].y += 40;
		}

		if(level.gamemode != "survival")
		{
			if(!IsDefined(level.vs_winning_team))
			{
				survived[i] SetText( &"REIMAGINED_YOU_TIED" );
				//players[i] playlocalsound( "vs_lose" );
			}
			else if(players[i].vsteam == level.vs_winning_team)
			{
				survived[i] SetText( &"REIMAGINED_YOU_WIN" );
				//players[i] playlocalsound( "vs_win" );
			}
			else
			{
				survived[i] SetText( &"REIMAGINED_YOU_LOSE" );
				//players[i] playlocalsound( "vs_lose" );
			}
		}
		else if( level.round_number < 2 )
		{
			if( level.script == "zombie_moon" )
			{
				if( !isdefined(level.left_nomans_land) )
				{
					//nomanslandtime = level.nml_best_time;
					//player_survival_time = int( nomanslandtime/1000 );
					player_survival_time = level.total_time;
					player_survival_time_in_mins = maps\_zombiemode::to_mins( player_survival_time );
					survived[i] SetText( &"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins );
				}
				else if( level.left_nomans_land==2 )
				{
					survived[i] SetText( &"ZOMBIE_SURVIVED_ROUND" );
				}
			}
			else
			{
				survived[i] SetText( &"ZOMBIE_SURVIVED_ROUND" );
			}
		}
		else
		{
			survived[i] SetText( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number );
		}

		survived[i] FadeOverTime( 1 );
		survived[i].alpha = 1;
	}

	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] SetClientDvars( "ammoCounterHide", "1",
				"miniscoreboardhide", "1" );
		//players[i] maps\_zombiemode_solo::solo_destroy_lives_hud();
		//players[i] maps\_zombiemode_ability::clear_hud();
	}
	destroy_chalk_hud();

	UploadStats();

	wait( 1 );

	//play_sound_at_pos( "end_of_game", ( 0, 0, 0 ) );
	wait( 2 );

	intermission();
	//wait( level.zombie_vars["zombie_intermission_time"] );
	wait 10;

	level notify( "stop_intermission" );
	array_thread( get_players(), ::player_exit_level );

	bbPrint( "zombie_epilogs: rounds %d", level.round_number );

	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		survived[i] FadeOverTime( 1 );
		survived[i].alpha = 0;
		game_over[i] FadeOverTime( 1 );
		game_over[i].alpha = 0;
	}

	wait( 1.5 );


/*	we are not currently supporting the shared screen tech
	if( IsSplitScreen() )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			share_screen( players[i], false );
		}
	}
*/

	for ( j = 0; j < get_players().size; j++ )
	{
		player = get_players()[j];
		player CameraActivate( false );

		survived[j] Destroy();
		game_over[j] Destroy();
	}

	/*if ( level.onlineGame || level.systemLink )
	{
		ExitLevel( false );
	}
	else
	{
		MissionFailed();
	}*/

	if(GetDvar("zm_gamemode") != "survival" && GetDvar("map_rotation") == "random")
	{
		map_names = array("zombie_cod5_prototype", "zombie_cod5_asylum", "zombie_cod5_sumpf", "zombie_cod5_factory", "zombie_theater", "zombie_pentagon", "zombie_cosmodrome", "zombie_coast", "zombie_temple", "zombie_moon");
		map_name = random(map_names);
		if(map_name == level.script)
		{
			Map_Restart();
		}
		else
		{
			ChangeLevel(map_name);
		}
	}
	else
	{
		//MissionFailed();
		Map_Restart();
	}

	// Let's not exit the function
	wait( 666 );
}

update_leaderboards()
{
	uploadGlobalStatCounters();

	if ( GetPlayers().size <= 1 )
	{
		//Solo leaderboard!
		cheater_found = maps\_zombiemode_ffotd::nazizombies_checking_for_cheats();
		if( cheater_found == false )
		{
			//no cheater found - upload score and stats
			nazizombies_upload_solo_highscore();
		}
		return;
	}

	if( level.systemLink )
	{
		return;
	}

	if ( GetDvarInt( #"splitscreen_playerCount" ) == GetPlayers().size )
	{
		return;
	}

	cheater_found = maps\_zombiemode_ffotd::nazizombies_checking_for_cheats();
	if( cheater_found == false )
	{
		//no cheater found - upload score and stats
		nazizombies_upload_highscore();
		nazizombies_set_new_zombie_stats();
	}
}

initializeStatTracking()
{
	level.global_zombies_killed = 0;
}

uploadGlobalStatCounters()
{
	incrementCounter( "global_zombies_killed", level.global_zombies_killed );
	incrementCounter( "global_zombies_killed_by_players", level.zombie_player_killed_count );
	incrementCounter( "global_zombies_killed_by_traps", level.zombie_trap_killed_count );
}

player_fake_death()
{
	level notify ("fake_death");
	self notify ("fake_death");

	self TakeAllWeapons();
	self GiveWeapon("falling_hands_zm");

	self AllowProne( true );
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowSprint( false );
	self SetStance("prone");

	self.ignoreme = true;
	self EnableInvulnerability();
}

freeze_controls_on_ground()
{
	level endon( "intermission" );

	while(!self IsOnGround())
	{
		wait_network_frame();
	}

	self FreezeControls( true );
}

player_exit_level()
{
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );

	if( IsDefined( self.game_over_bg ) )
	{
		self.game_over_bg.foreground = true;
		self.game_over_bg.sort = 100;
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 1;
	}
}

player_killed_override()
{
	// BLANK
	level waittill( "forever" );
}


injured_walk()
{
	self.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );

	self.player_speed = 50;

	// TODO do death countdown
	self AllowSprint( false );
	self AllowProne( false );
	self AllowCrouch( false );
	self AllowAds( false );
	self AllowJump( false );

	self PlayerSetGroundReferenceEnt( self.ground_ref_ent );
	self thread limp();
}

limp()
{
	level endon( "disconnect" );
	level endon( "death" );
	// TODO uncomment when/if SetBlur works again
	//self thread player_random_blur();

	stumble = 0;
	alt = 0;

	while( 1 )
	{
		velocity = self GetVelocity();
		player_speed = abs( velocity[0] ) + abs( velocity[1] );

		if( player_speed < 10 )
		{
			wait( 0.05 );
			continue;
		}

		speed_multiplier = player_speed / self.player_speed;

		p = RandomFloatRange( 3, 5 );
		if( RandomInt( 100 ) < 20 )
		{
			p *= 3;
		}
		r = RandomFloatRange( 3, 7 );
		y = RandomFloatRange( -8, -2 );

		stumble_angles = ( p, y, r );
		stumble_angles = vector_scale( stumble_angles, speed_multiplier );

		stumble_time = RandomFloatRange( .35, .45 );
		recover_time = RandomFloatRange( .65, .8 );

		stumble++;
		if( speed_multiplier > 1.3 )
		{
			stumble++;
		}

		self thread stumble( stumble_angles, stumble_time, recover_time );

		level waittill( "recovered" );
	}
}

stumble( stumble_angles, stumble_time, recover_time, no_notify )
{
	stumble_angles = self adjust_angles_to_player( stumble_angles );

	self.ground_ref_ent RotateTo( stumble_angles, stumble_time, ( stumble_time/4*3 ), ( stumble_time/4 ) );
	self.ground_ref_ent waittill( "rotatedone" );

	base_angles = ( RandomFloat( 4 ) - 4, RandomFloat( 5 ), 0 );
	base_angles = self adjust_angles_to_player( base_angles );

	self.ground_ref_ent RotateTo( base_angles, recover_time, 0, ( recover_time / 2 ) );
	self.ground_ref_ent waittill( "rotatedone" );

	if( !IsDefined( no_notify ) )
	{
		level notify( "recovered" );
	}
}

adjust_angles_to_player( stumble_angles )
{
	pa = stumble_angles[0];
	ra = stumble_angles[2];

	rv = AnglesToRight( self.angles );
	fv = AnglesToForward( self.angles );

	rva = ( rv[0], 0, rv[1]*-1 );
	fva = ( fv[0], 0, fv[1]*-1 );
	angles = vector_scale( rva, pa );
	angles = angles + vector_scale( fva, ra );
	return angles +( 0, stumble_angles[1], 0 );
}

coop_player_spawn_placement()
{
	structs = getstructarray( "initial_spawn_points", "targetname" );

	temp_ent = Spawn( "script_model", (0,0,0) );
	for( i = 0; i < structs.size; i++ )
	{
		temp_ent.origin = structs[i].origin;
		temp_ent placeSpawnpoint();
		structs[i].origin = temp_ent.origin;
	}
	temp_ent Delete();

	flag_wait( "all_players_connected" );

	//chrisp - adding support for overriding the default spawning method

	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		players[i] setorigin( structs[i].origin );
		players[i] setplayerangles( structs[i].angles );
		players[i].spectator_respawn = structs[i];
	}
}


player_zombie_breadcrumb()
{
	self endon( "disconnect" );
	self endon( "spawned_spectator" );
	level endon( "intermission" );

	self.zombie_breadcrumbs = [];
	self.zombie_breadcrumb_distance = 24 * 24; // min dist (squared) the player must move to drop a crumb
	self.zombie_breadcrumb_area_num = 3;	   // the number of "rings" the area breadcrumbs use
	self.zombie_breadcrumb_area_distance = 16; // the distance between each "ring" of the area breadcrumbs

	self store_crumb( self.origin );
	last_crumb = self.origin;

	self thread debug_breadcrumbs();

	while( 1 )
	{
		wait_time = 0.1;

	/#
		if( self isnotarget() )
		{
			wait( wait_time );
			continue;
		}
	#/

		//For cloaking ability
		//if( self.ignoreme )
		//{
		//	wait( wait_time );
		//	continue;
		//}


		store_crumb = true;
		airborne = false;
		crumb = self.origin;

//TODO TEMP SCRIPT for vehicle testing Delete/comment when done
		if ( !self IsOnGround() && self isinvehicle() )
		{
			trace = bullettrace( self.origin + (0,0,10), self.origin, false, undefined );
			crumb = trace["position"];
		}

//TODO TEMP DISABLE for vehicle testing.  Uncomment when reverting
// 		if ( !self IsOnGround() )
// 		{
// 			airborne = true;
// 			store_crumb = false;
// 			wait_time = 0.05;
// 		}
//
		if( !airborne && DistanceSquared( crumb, last_crumb ) < self.zombie_breadcrumb_distance )
		{
			store_crumb = false;
		}

		if ( airborne && self IsOnGround() )
		{
			// player was airborne, store crumb now that he's on the ground
			store_crumb = true;
			airborne = false;
		}

		if( isDefined( level.custom_breadcrumb_store_func ) )
		{
			store_crumb = self [[ level.custom_breadcrumb_store_func ]]( store_crumb );
		}

		if( isDefined( level.custom_airborne_func ) )
		{
			airborne = self [[ level.custom_airborne_func ]]( airborne );
		}

		if( store_crumb )
		{
			debug_print( "Player is storing breadcrumb " + crumb );

			if( IsDefined(self.node) )
			{
				debug_print( "has closest node " );
			}

			last_crumb = crumb;
			self store_crumb( crumb );
		}

		wait( wait_time );
	}
}


store_crumb( origin )
{
	offsets = [];
	height_offset = 32;

	index = 0;
	for( j = 1; j <= self.zombie_breadcrumb_area_num; j++ )
	{
		offset = ( j * self.zombie_breadcrumb_area_distance );

		offsets[0] = ( origin[0] - offset, origin[1], origin[2] );
		offsets[1] = ( origin[0] + offset, origin[1], origin[2] );
		offsets[2] = ( origin[0], origin[1] - offset, origin[2] );
		offsets[3] = ( origin[0], origin[1] + offset, origin[2] );

		offsets[4] = ( origin[0] - offset, origin[1], origin[2] + height_offset );
		offsets[5] = ( origin[0] + offset, origin[1], origin[2] + height_offset );
		offsets[6] = ( origin[0], origin[1] - offset, origin[2] + height_offset );
		offsets[7] = ( origin[0], origin[1] + offset, origin[2] + height_offset );

		for ( i = 0; i < offsets.size; i++ )
		{
			self.zombie_breadcrumbs[index] = offsets[i];
			index++;
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LEADERBOARD CODE///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
to_mins( seconds )
{
	/*hours = 0;
	minutes = 0;

	if( seconds > 59 )
	{
		minutes = int( seconds / 60 );

		seconds = int( seconds ) % 60;
		seconds = seconds * 0.001;

		if( minutes > 59 )
		{
			hours = int( minutes / 60 );
			minutes = int( minutes ) % 60;
			minutes = minutes * 0.001;
		}
	}

	if( hours < 10 )
	{
		hours = "0" + hours;
	}

	if( minutes < 10 )
	{
		minutes = "0" + minutes;
	}

	seconds = int( seconds );
	if( seconds < 10 )
	{
		seconds = "0" + seconds;
	}

	combined = "" + hours  + ":" + minutes  + ":" + seconds;

	return combined;*/

	hours = int(seconds / 3600);
	minutes = int((seconds - (hours * 3600)) / 60);
	seconds = int(seconds - (hours * 3600) - (minutes * 60));

	if( hours < 10 )
	{
		hours = "0" + hours;
	}
	if( minutes < 10 )
	{
		minutes = "0" + minutes;
	}
	if( seconds < 10 )
	{
		seconds = "0" + seconds;
	}

	combined = "" + hours + ":" + minutes + ":" + seconds;

	return combined;
}

to_mins_short(seconds)
{
	hours = int(seconds / 3600);
	minutes = int((seconds - (hours * 3600)) / 60);
	seconds = int(seconds - (hours * 3600) - (minutes * 60));

	if( minutes < 10 && hours >= 1 )
	{
		minutes = "0" + minutes;
	}
	if( seconds < 10 )
	{
		seconds = "0" + seconds;
	}

	combined = "";
	if(hours >= 1)
	{
		combined = "" + hours + ":" + minutes + ":" + seconds;
	}
	else
	{
		combined = "" + minutes + ":" + seconds;
	}

	return combined;
}

//This is used to upload the score to the solo leaderboard for the moon map(No Man's Land)
nazizombies_upload_solo_highscore()
{
	map_name = GetDvar( #"mapname" );

	if ( !isZombieLeaderboardAvailable( map_name, "kills" ) )
		return;

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( map_name == "zombie_moon" )
		{
			nomanslandtime = level.nml_best_time;
			nomansland_kills = level.nml_kills;
			nomansland_score = level.nml_score;
			player_survival_time = int( nomanslandtime/1000 );
			total_score = nomansland_score;	//players[i].score_total;
			total_kills = nomansland_kills;	//players[i].kills;

			leaderboard_number = getZombieLeaderboardNumber( map_name, "kills" );

			rounds_survived = level.round_number;

			if( isdefined(level.nml_didteleport) && (level.nml_didteleport==false) )
			{
				rounds_survived = 0;
			}

/#
			if( GetDvarInt( #"zombie_cheat" ) >= 1 )
			{
				level.devcheater = 1;
			}

			if( isdefined(level.devcheater) && level.devcheater )
			{
				rounds_survived = -1;
			}
#/

			rankNumber = makeNMLRankNumberSolo( total_kills, total_score );
			if( !isdefined(level.round_number) )
			{
				level.round_number = 0;
			}

			if( !isdefined(level.nml_pap) )
			{
				level.nml_pap = 0;
			}
			if( !isdefined(level.nml_speed) )
			{
				level.nml_speed = 0;
			}
			if( !isdefined(level.nml_jugg) )
			{
				level.nml_jugg = 0;
			}


			if( !isdefined(level.sololb_build_number) )
			{
				level.sololb_build_number = 48;
			}

			players[i] UploadScore( leaderboard_number, int(rankNumber), total_kills, total_score, player_survival_time, rounds_survived, level.sololb_build_number, level.nml_pap, level.nml_speed, level.nml_jugg );
		}
	}
}

makeNMLRankNumberSolo( total_kills, total_score )
{
	maximum_survival_time = 108000;

	// Upper cap on total_kills is 2000
	if( total_kills > 2000 )
		total_kills = 2000;

	// Upper cap on player total score
	if( total_score > 99999 )
		total_score = 99999;


	//pad out ranking time.
	score_padding = "";
	if ( total_score < 10 )
		score_padding += "0000";
	else if( total_score < 100 )
		score_padding += "000";
	else if( total_score < 1000 )
		score_padding += "00";
	else if( total_score < 10000 )
		score_padding += "0";

	// Trying to make the rankNumber by combining kills with 5 digit padded points earned.
	rankNumber = total_kills + score_padding + total_score;

	return rankNumber;
}

//CODER MOD: TOMMY K
nazizombies_upload_highscore()
{
	// Nazi Zombie Leaderboards
	// nazi_zombie_prototype_waves = 13
	// nazi_zombie_prototype_points = 14

	// this has gotta be the dumbest way of doing this, but at 1:33am in the morning my brain is fried!
	playersRank = 1;
	if( level.players_size == 1 )
		playersRank = 4;
	else if( level.players_size == 2 )
		playersRank = 3;
	else if( level.players_size == 3 )
		playersRank = 2;

	map_name = GetDvar( #"mapname" );

	if ( !isZombieLeaderboardAvailable( map_name, "waves" ) || !isZombieLeaderboardAvailable( map_name, "points" ) )
		return;

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		pre_highest_wave = players[i] playerZombieStatGet( map_name, "highestwave" );
		pre_time_in_wave = players[i] playerZombieStatGet( map_name, "timeinwave" );

		new_highest_wave = level.round_number + "" + playersRank;
		new_highest_wave = int( new_highest_wave );

		if( new_highest_wave >= pre_highest_wave )
		{
			if( players[i].zombification_time == 0 )
			{
				players[i].zombification_time = GetTime();
			}

			player_survival_time = players[i].zombification_time - level.round_start_time;
			player_survival_time = int( player_survival_time/1000 );

			/*
			if( map_name == "zombie_moon" )
			{
				nomanslandtime = level.nml_best_time ;
				player_survival_time = int( nomanslandtime/1000 );
				//player_survival_time_in_mins = maps\_zombiemode::to_mins( player_survival_time );
				//IPrintLnBold( "NO MANS LAND = " + player_survival_time_in_mins );
			}
			*/

			if( new_highest_wave > pre_highest_wave || player_survival_time > pre_time_in_wave )
			{
				rankNumber = makeRankNumber( level.round_number, playersRank, player_survival_time );

				leaderboard_number = getZombieLeaderboardNumber( map_name, "waves" );

				players[i] UploadScore( leaderboard_number, int(rankNumber), level.round_number, player_survival_time, level.players_size );
				//players[i] UploadScore( leaderboard_number, int(rankNumber), level.round_number );

				players[i] playerZombieStatSet( map_name, "highestwave", new_highest_wave );
				players[i] playerZombieStatSet( map_name, "timeinwave", player_survival_time );
			}
		}

		pre_total_points = players[i] playerZombieStatGet( map_name, "totalpoints" );
		if( players[i].score_total > pre_total_points )
		{
			leaderboard_number = getZombieLeaderboardNumber( map_name, "points" );

			players[i] UploadScore( leaderboard_number, players[i].score_total, players[i].kills, level.players_size );

			players[i] playerZombieStatSet( map_name, "totalpoints", players[i].score_total );
		}
	}
}

isZombieLeaderboardAvailable( map, type )
{
	if ( !isDefined( level.zombieLeaderboardNumber[map] ) )
		return 0;

	if ( !isDefined( level.zombieLeaderboardNumber[map][type] ) )
		return 0;

	return 1;
}

getZombieLeaderboardNumber( map, type )
{
	if ( !isDefined( level.zombieLeaderboardNumber[map][type] ) )
		assertMsg( "Unknown leaderboard number for map " + map + "and type " + type );

	return level.zombieLeaderboardNumber[map][type];
}

getZombieStatVariable( map, variable )
{
	if ( !isDefined( level.zombieLeaderboardStatVariable[map][variable] ) )
		assertMsg( "Unknown stat variable " + variable + " for map " + map );

	return level.zombieLeaderboardStatVariable[map][variable];
}

playerZombieStatGet( map, variable )
{
	stat_variable = getZombieStatVariable( map, variable );
	result = self zombieStatGet( stat_variable );

	return result;
}

playerZombieStatSet( map, variable, value )
{
	stat_variable = getZombieStatVariable( map, variable );
	self zombieStatSet( stat_variable, value );
}

nazizombies_set_new_zombie_stats()
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		//grab stat and add final totals
		total_kills = players[i] zombieStatGet( "zombie_kills" ) + players[i].stats["kills"];
		total_points = players[i] zombieStatGet( "zombie_points" ) + players[i].stats["score"];
		total_rounds = players[i] zombieStatGet( "zombie_rounds" ) + (level.round_number - 1); // rounds survived
		total_downs = players[i] zombieStatGet( "zombie_downs" ) + players[i].stats["downs"];
		total_revives = players[i] zombieStatGet( "zombie_revives" ) + players[i].stats["revives"];
		total_perks = players[i] zombieStatGet( "zombie_perks_consumed" ) + players[i].stats["perks"];
		total_headshots = players[i] zombieStatGet( "zombie_heashots" ) + players[i].stats["headshots"];
		total_zombie_gibs = players[i] zombieStatGet( "zombie_gibs" ) + players[i].stats["zombie_gibs"];

		//set zombie stats
		players[i] zombieStatSet( "zombie_kills", total_kills );
		players[i] zombieStatSet( "zombie_points", total_points );
		players[i] zombieStatSet( "zombie_rounds", total_rounds );
		players[i] zombieStatSet( "zombie_downs", total_downs );
		players[i] zombieStatSet( "zombie_revives", total_revives );
		players[i] zombieStatSet( "zombie_perks_consumed", total_perks );
		players[i] zombieStatSet( "zombie_heashots", total_headshots );
		players[i] zombieStatSet( "zombie_gibs", total_zombie_gibs );
	}
}

makeRankNumber( wave, players, time )
{
	if( time > 86400 )
		time = 86400; // cap it at like 1 day, need to cap cause you know some muppet is gonna end up trying it

	//pad out time
	padding = "";
	if ( 10 > time )
		padding += "0000";
	else if( 100 > time )
		padding += "000";
	else if( 1000 > time )
		padding += "00";
	else if( 10000 > time )
		padding += "0";

	rank = wave + "" + players + padding + time;

	return rank;
}


//CODER MOD: TOMMY K
/*
=============
zombieStatGet

Returns the value of the named stat
=============
*/
zombieStatGet( dataName )
{
	if( level.systemLink )
	{
		return;
	}
	if ( GetDvarInt( #"splitscreen_playerCount" ) == GetPlayers().size )
	{
		return;
	}

	return ( self getdstat( "PlayerStatsList", dataName ) );
}

//CODER MOD: TOMMY K
/*
=============
zombieStatSet

Sets the value of the named stat
=============
*/
zombieStatSet( dataName, value )
{
	if( level.systemLink )
	{
		return;
	}
	if ( GetDvarInt( #"splitscreen_playerCount" ) == GetPlayers().size )
	{
		return;
	}

	self setdstat( "PlayerStatsList", dataName, value );
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// INTERMISSION =========================================================== //
//

intermission()
{
	level.intermission = true;
	level notify( "intermission" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		setclientsysstate( "levelNotify", "zi", players[i] ); // Tell clientscripts we're in zombie intermission

		players[i] SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "90" );

		players[i].health = 100; // This is needed so the player view doesn't get stuck
		players[i] thread [[level.custom_intermission]]();
	}

	
	

	wait( 0.25 );

	// Delay the last stand monitor so we are 100% sure the zombie intermission ("zi") is set on the cients
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		setClientSysState( "lsm", "0", players[i] );
	}

	visionset = "zombie";
	if( IsDefined( level.zombie_vars["intermission_visionset"] ) )
	{
		visionset = level.zombie_vars["intermission_visionset"];
	}

	level thread maps\_utility::set_all_players_visionset( visionset, 2 );
	level thread zombie_game_over_death();
}

zombie_game_over_death()
{
	// Kill remaining zombies, in style!
	zombies = GetAiArray( "axis" );
	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		zombies[i] SetGoalPos( zombies[i].origin );
	}

	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		wait( 0.5 + RandomFloat( 2 ) );

		if ( isdefined( zombies[i] ) )
		{
			zombies[i] maps\_zombiemode_spawner::zombie_head_gib();
			zombies[i] DoDamage( zombies[i].health + 666, zombies[i].origin );
		}
	}
}

player_intermission()
{
	//self closeMenu();
	//self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	self SetClientDvar("hud_enemy_counter_on_game", 0);
	self setClientDvar("hud_timer_on_game", 0);
	self setClientDvar("hud_health_bar_on_game", 0);
	self setClientDvar("hud_zone_name_on_game", 0);
	self setClientDvar("hud_character_names_on_game", 0);	

	points = getstructarray( "intermission", "targetname" );

	if( !IsDefined( points ) || points.size == 0 )
	{
		points = getentarray( "info_intermission", "classname" );
		if( points.size < 1 )
		{
			println( "NO info_intermission POINTS IN MAP" );
			return;
		}
	}

	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	if( level.apocalypse )
	{
		//self thread player_apocalypse_stats(undefined, 12);	
	}

	org = undefined;
	while( 1 )
	{
		points = array_randomize( points );
		for( i = 0; i < points.size; i++ )
		{
			point = points[i];
			// Only spawn once if we are using 'moving' org
			// If only using info_intermissions, this will respawn after 5 seconds.
			if( !IsDefined( org ) )
			{
				self Spawn( point.origin, point.angles );
			}

			// Only used with STRUCTS
			if( IsDefined( points[i].target ) )
			{
				if( !IsDefined( org ) )
				{
					org = Spawn( "script_model", self.origin + ( 0, 0, -60 ) );
					org SetModel("tag_origin");
				}

//				self LinkTo( org, "", ( 0, 0, -60 ), ( 0, 0, 0 ) );
//				self SetPlayerAngles( points[i].angles );
				org.origin = points[i].origin;
				org.angles = points[i].angles;


				for ( j = 0; j < get_players().size; j++ )
				{
					player = get_players()[j];
					player CameraSetPosition( org );
					player CameraSetLookAt();
					player CameraActivate( true );
				}

				speed = 20;
				if( IsDefined( points[i].speed ) )
				{
					speed = points[i].speed;
				}

				target_point = getstruct( points[i].target, "targetname" );
				dist = Distance( points[i].origin, target_point.origin );
				time = dist / speed;

				q_time = time * 0.25;
				if( q_time > 1 )
				{
					q_time = 1;
				}

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 0;

				org MoveTo( target_point.origin, time, q_time, q_time );
				org RotateTo( target_point.angles, time, q_time, q_time );
				wait( time - q_time );

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 1;

				wait( q_time );
			}
			else
			{
				self.game_over_bg FadeOverTime( 1 );
				self.game_over_bg.alpha = 0;

				wait( 5 );

				self.game_over_bg thread fade_up_over_time(1);

				//wait( 1 );
			}
		}
	}
}

//Show additional Stats for Apocalypse games

player_apocalypse_stats( message, timeout )
{
	if( !isdefined( message ) )
	{
		message = "apocalypse_stats_end";
	}

	if( !isdefined( timeout ) )
	{
		timeout = 10000;
	}


	headers = array( "Perk Slots", "Total Points", "Efficiency" );
	totals = [];
	efficiencies = [];

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		totals[i] = players[i].gross_points;
		base_points = self.kill_tracker * level.VALUE_APOCALYPSE_ZOMBIE_DEATH_POINTS;
		gross = players[i].gross_points - base_points;
		gross_possible = players[i].gross_possible_points - base_points;
		//efficiencies[i] = players[i].gross_points / players[i].gross_possible_points;
		efficiencies[i] = gross / gross_possible;
	}

	COL_OFFSET = 70;
	VERT_OFFSET = 64;
	HORZ_OFFSET = 120;

	if( players.size > 1 )
	{
		HORZ_OFFSET += 2*COL_OFFSET; //Move over one columns
		headers = array( "Perk Slots", "", "Total Points", "Efficiency" );
	}

	hudElems = [];
	for( i = 0; i < headers.size; i++ )
	{
		if( headers[i] == "" )
			continue;					//Adding column for spacing
		
		for( j = 0; j < players.size; j++ )
		{
			
			ent_num = players[j].entity_num;
			hudElems[i][j] = NewClienthudElem( self );
			hudElems[i][j].alignX = "center";
			hudElems[i][j].alignY = "middle";
			hudElems[i][j].horzAlign = "center";
			hudElems[i][j].vertAlign = "middle";
			hudElems[i][j].y -= VERT_OFFSET;
			hudElems[i][j].x -= (HORZ_OFFSET - (i * COL_OFFSET));
			hudElems[i][j].foreground = true;
			hudElems[i][j].fontScale = 1.2;
			hudElems[i][j].alpha = 1;
			//hudElems[i][j].color = level.ARRAY_ZOMBIEMODE_PLAYER_COLORS[ ent_num ];
			hudElems[i][j].color = ( 1.0, 1.0, 1.0 );
			hudElems[i][j].hidewheninmenu = true;
			hudElems[i][j] SetText( headers[i] );
		}
	}

	//SET VALUES
	ROW_OFSSET = 20;

	for( k = 0; k < headers.size; k++ )
	{
		if( headers[k] == "" )
			continue;					//Adding column for spacing
		
		for( j = 0; j < players.size; j++ )
		{
			i = k + headers.size;
			hudElems[i][j] = NewClienthudElem( self );
			hudElems[i][j].alignX = "center";
			hudElems[i][j].alignY = "middle";
			hudElems[i][j].horzAlign = "center";
			hudElems[i][j].vertAlign = "middle";
			hudElems[i][j].y -= VERT_OFFSET;
			hudElems[i][j].y += ROW_OFSSET*(j+1);
			hudElems[i][j].x -= (HORZ_OFFSET - (k * COL_OFFSET));
			hudElems[i][j].foreground = true;
			hudElems[i][j].fontScale = 1.2;
			hudElems[i][j].alpha = 1;
			hudElems[i][j].color = ( 1.0, 1.0, 1.0 );
			if( k == 0 )
			{
				hudElems[i][j] SetText( players[j].perk_slots );
				
			}
			else if( k == 1)
			{
				hudElems[i][j] SetText( totals[j] );
				
			}
			else if( k == 2)
			{
				hudElems[i][j] SetText( Int( efficiencies[j] * 1000 ) / 10 );
			}
		}
	}

	self waittill_notify_or_timeout( message, timeout );

	outer_size = headers.size * 2;

	for( i = 0; i < outer_size; i++ )
	{
		for( j = 0; j < players.size; j++ )
		{
			hudElems[i][j] Destroy();
		}
	}

	
}

fade_up_over_time(t)
{
		self FadeOverTime( t );
		self.alpha = 1;
}

prevent_near_origin()
{
	while (1)
	{
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			for (q = 0; q < players.size; q++)
			{
				if (players[i] != players[q])
				{
					if (check_to_kill_near_origin(players[i], players[q]))
					{
						p1_org = players[i].origin;
						p2_org = players[q].origin;

						wait 5;

						if (check_to_kill_near_origin(players[i], players[q]))
						{
							if ( (distance(players[i].origin, p1_org) < 30) && distance(players[q].origin, p2_org) < 30)
							{
								setsaveddvar("player_deathInvulnerableTime", 0);
								players[i] DoDamage( players[i].health + 1000, players[i].origin, undefined, undefined, "riflebullet" );
								setsaveddvar("player_deathInvulnerableTime", level.startInvulnerableTime);
							}
						}
					}
				}
			}
		}

		wait 0.2;
	}
}

check_to_kill_near_origin(player1, player2)
{
	if (!isdefined(player1) || !isdefined(player2))
	{
		return false;
	}

	if (distance(player1.origin, player2.origin) > 12)
	{
		return false;
	}

	if ( player1 maps\_laststand::player_is_in_laststand() || player2 maps\_laststand::player_is_in_laststand() )
	{
		return false;
	}

	if (!isalive(player1) || !isalive(player2))
	{
		return false;
	}

	return true;
}


//


default_exit_level()
{
	zombies = GetAiArray( "axis" );
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( is_true( zombies[i].ignore_solo_last_stand ) )
		{
			continue;
		}

		if ( isDefined( zombies[i].find_exit_point ) )
		{
			zombies[i] thread [[ zombies[i].find_exit_point ]]();
			continue;
		}

		if ( zombies[i].ignoreme )
		{
			zombies[i] thread default_delayed_exit();
		}
		else
		{
			zombies[i] thread default_find_exit_point();
		}
	}
}

default_delayed_exit()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( !flag( "wait_and_revive" ) )
		{
			return;
		}

		// broke through the barricade, find an exit point
		if ( !self.ignoreme )
		{
			break;
		}
		wait_network_frame();
	}

	self thread default_find_exit_point();
}

default_find_exit_point()
{
	self endon( "death" );

	player = getplayers()[0];

	dist_zombie = 0;
	dist_player = 0;
	dest = 0;

	away = VectorNormalize( self.origin - player.origin );
	endPos = self.origin + vector_scale( away, 600 );

	locs = array_randomize( level.enemy_dog_locations );

	for ( i = 0; i < locs.size; i++ )
	{
		dist_zombie = DistanceSquared( locs[i].origin, endPos );
		dist_player = DistanceSquared( locs[i].origin, player.origin );

		if ( dist_zombie < dist_player )
		{
			dest = i;
			break;
		}
	}

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	self setgoalpos( locs[dest].origin );

	while ( 1 )
	{
		if ( !flag( "wait_and_revive" ) )
		{
			break;
		}
		wait_network_frame();
	}

	self thread maps\_zombiemode_spawner::find_flesh();
}

play_level_start_vox_delayed()
{
    wait(5);
    players = getplayers();
	num = RandomIntRange( 0, players.size );
	players[num] maps\_zombiemode_audio::create_and_play_dialog( "general", "intro" );
}


//show some stats on the screen ( debug only )
init_screen_stats()
{

	level.zombies_timeout_spawn_info = NewHudElem();
	level.zombies_timeout_spawn_info.alignX = "right";
	level.zombies_timeout_spawn_info.x = 100;
	level.zombies_timeout_spawn_info.y = 80;
	level.zombies_timeout_spawn_info.label = "Timeout(Spawncloset): ";
	level.zombies_timeout_spawn_info.fontscale = 1.2;


	level.zombies_timeout_playspace_info = NewHudElem();
	level.zombies_timeout_playspace_info.alignX = "right";
	level.zombies_timeout_playspace_info.x = 100;
	level.zombies_timeout_playspace_info.y = 95;
	level.zombies_timeout_playspace_info.label ="Timeout(Playspace): ";
	level.zombies_timeout_playspace_info.fontscale = 1.2;

	level.zombie_player_killed_count_info = NewHudElem();
	level.zombie_player_killed_count_info.alignX = "right";
	level.zombie_player_killed_count_info.x = 100;
	level.zombie_player_killed_count_info.y = 110;
	level.zombie_player_killed_count_info.label = "Zombies killed by players: ";
	level.zombie_player_killed_count_info.fontscale = 1.2;

	level.zombie_trap_killed_count_info = NewHudElem();
	level.zombie_trap_killed_count_info.alignX = "right";
	level.zombie_trap_killed_count_info.x = 100;
	level.zombie_trap_killed_count_info.y = 125;
	level.zombie_trap_killed_count_info.label = "Zombies killed by traps: ";
	level.zombie_trap_killed_count_info.fontscale = 1.2;

	level.zombie_pathing_failed_info = NewHudElem();
	level.zombie_pathing_failed_info.alignX = "right";
	level.zombie_pathing_failed_info.x = 100;
	level.zombie_pathing_failed_info.y = 140;
	level.zombie_pathing_failed_info.label = "Pathing failed: ";
	level.zombie_pathing_failed_info.fontscale = 1.2;


	level.zombie_breadcrumb_failed_info = NewHudElem();
	level.zombie_breadcrumb_failed_info.alignX = "right";
	level.zombie_breadcrumb_failed_info.x = 100;
	level.zombie_breadcrumb_failed_info.y = 155;
	level.zombie_breadcrumb_failed_info.label = "Breadcrumbs failed: ";
	level.zombie_breadcrumb_failed_info.fontscale = 1.2;


	level.player_0_distance_traveled_info = NewHudElem();
	level.player_0_distance_traveled_info.alignX = "right";
	level.player_0_distance_traveled_info.x = 100;
	level.player_0_distance_traveled_info.y = 170;
	level.player_0_distance_traveled_info.label = "Player(0) Distance traveled: ";
	level.player_0_distance_traveled_info.fontscale = 1.2;

}

update_screen_stats()
{
	flag_wait("all_players_spawned");
	while(1)
	{
		wait(1);

		if(getdvarint("zombie_show_stats") == 0)
		{
			level.zombies_timeout_spawn_info.alpha = 0;
			level.zombies_timeout_playspace_info.alpha = 0;
			level.zombie_player_killed_count_info.alpha = 0;
			level.zombie_trap_killed_count_info.alpha = 0;
			level.zombie_pathing_failed_info.alpha = 0;
			level.zombie_breadcrumb_failed_info.alpha = 0;
			level.player_0_distance_traveled_info.alpha = 0;
			continue;
		}
		else
		{
			level.zombies_timeout_spawn_info.alpha = 1;
			level.zombies_timeout_playspace_info.alpha = 1;
			level.zombie_player_killed_count_info.alpha = 1;
			level.zombie_trap_killed_count_info.alpha = 1;
			level.zombie_pathing_failed_info.alpha = 1;
			level.zombie_breadcrumb_failed_info.alpha = 1;
			level.player_0_distance_traveled_info.alpha = 1;

			level.zombies_timeout_spawn_info setValue( level.zombies_timeout_spawn );
			level.zombies_timeout_playspace_info SetValue(level.zombies_timeout_playspace );
			level.zombie_player_killed_count_info SetValue( level.zombie_player_killed_count);
			level.zombie_trap_killed_count_info SetValue( level.zombie_trap_killed_count);
			level.zombie_pathing_failed_info SetValue( level.zombie_pathing_failed );
			level.zombie_breadcrumb_failed_info SetValue( level.zombie_breadcrumb_failed );
			level.player_0_distance_traveled_info SetValue( get_players()[0].stats["distance_traveled"] );
		}
	}
}


register_sidequest( id, solo_stat, solo_collectible, coop_stat, coop_collectible )
{
	if ( !IsDefined( level.zombie_sidequest_solo_stat ) )
	{
		level.zombie_sidequest_previously_completed = [];
		level.zombie_sidequest_solo_stat = [];
		level.zombie_sidequest_solo_collectible = [];
		level.zombie_sidequest_coop_stat = [];
		level.zombie_sidequest_coop_collectible = [];
	}

	level.zombie_sidequest_solo_stat[id] = solo_stat;
	level.zombie_sidequest_solo_collectible[id] = solo_collectible;
	level.zombie_sidequest_coop_stat[id] = coop_stat;
	level.zombie_sidequest_coop_collectible[id] = coop_collectible;

	flag_wait( "all_players_spawned" );

	level.zombie_sidequest_previously_completed[id] = false;
	if ( flag( "solo_game" ) )
	{
		if ( IsDefined( level.zombie_sidequest_solo_collectible[id] ) )
		{
			level.zombie_sidequest_previously_completed[id] = HasCollectible( level.zombie_sidequest_solo_collectible[id] );
		}
	}
	else
	{
		// don't do stats stuff if it's not an online game
		if ( level.systemLink || GetDvarInt( #"splitscreen_playerCount" ) == GetPlayers().size )
		{
			if ( IsDefined( level.zombie_sidequest_coop_collectible[id] ) )
			{
				level.zombie_sidequest_previously_completed[id] = HasCollectible( level.zombie_sidequest_coop_collectible[id] );
			}
			return;
		}

		if ( !isdefined( level.zombie_sidequest_coop_stat[id] ) )
		{
			return;
		}

		players = get_players();
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] zombieStatGet( level.zombie_sidequest_coop_stat[id] ) )
			{
				level.zombie_sidequest_previously_completed[id] = true;
				return;
			}
		}
	}
}


is_sidequest_previously_completed(id)
{
	return is_true( level.zombie_sidequest_previously_completed[id] );
}


set_sidequest_completed(id)
{
	if ( maps\_cheat::is_cheating() || flag( "has_cheated" ) )
	{
		return;
	}

	if ( flag( "solo_game" ) )
	{
		client_notify_str = "SQS";
	}
	else
	{
		client_notify_str = "SQC";
	}
	clientnotify( client_notify_str ); // updates the collectibles value

	level notify( "zombie_sidequest_completed", id );
	level.zombie_sidequest_previously_completed[id] = true;

	// don't do stats stuff if it's not an online game
	if ( level.systemLink )
	{
		return;
	}
	if ( GetDvarInt( #"splitscreen_playerCount" ) == GetPlayers().size )
	{
		return;
	}

	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( level.zombie_sidequest_solo_stat[id] ) )
		{
			players[i] zombieStatSet( level.zombie_sidequest_solo_stat[id], (players[i] zombieStatGet( level.zombie_sidequest_solo_stat[id] ) + 1) );
		}

		if ( !flag( "solo_game" ) && isdefined( level.zombie_sidequest_coop_stat[id] ) )
		{
			players[i] zombieStatSet( level.zombie_sidequest_coop_stat[id], (players[i] zombieStatGet( level.zombie_sidequest_coop_stat[id] ) + 1) );
		}
	}
}

timer_hud()
{
	level thread total_time();

	level thread round_time_loop();
}

total_time()
{
	level endon( "intermission" );

	level waittill("fade_introblack");

	level.total_time = 0;
	while(1)
	{
		update_time(level.total_time, "hud_total_time");

		//adjust the spacing of round_time and road_total_time whenever updating total_time to 10 mins, 1 hour, or 10 hours
		if(level.gamemode == "survival" || level.gamemode == "grief")
		{
			if(level.total_time == 600 || level.total_time == 3600 || level.total_time == 36000)
			{
				update_time(level.round_time, "hud_round_time");

				if(level.gamemode == "survival")
				{
					update_time(level.round_total_time, "hud_round_total_time");
				}
			}
		}

		wait 1;

		level.total_time++;
	}
}

round_time_loop()
{
	level endon( "intermission" );

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] send_message_to_csc("hud_anim_handler", "hud_round_time_out");
		players[i] send_message_to_csc("hud_anim_handler", "hud_round_total_time_out");
	}

	if(!(level.gamemode == "survival" || level.gamemode == "grief"))
	{
		return;
	}

	if(level.script == "zombie_moon" && level.gamemode == "survival")
	{
		level waittill( "end_of_round" );
	}

	level waittill( "start_of_round" );

	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			players[i] send_message_to_csc("hud_anim_handler", "hud_round_time_in");
		}

		level thread round_time();

		//end round timer when last enemy of round is killed
		if((level.script == "zombie_cod5_sumpf" || level.script == "zombie_cod5_factory" || level.script == "zombie_theater") && flag( "dog_round" ))
		{
			level waittill( "last_dog_down" );
		}
		else if(level.script == "zombie_pentagon" && flag( "thief_round" ))
		{
			flag_wait( "last_thief_down" );
		}
		else if(level.script == "zombie_cosmodrome" && flag( "monkey_round" ))
		{
			flag_wait( "last_monkey_down" );
		}
		else
		{
			level waittill( "end_of_round" );
		}

		while(is_true(flag("enter_nml")))
		{
			level waittill( "end_of_round" ); //end no man's land
			level waittill( "end_of_round" ); //end actual round
		}

		level notify("stop_round_time");

		if(level.gamemode == "survival")
		{
			level.round_total_time = level.total_time;

			update_time(level.round_total_time, "hud_round_total_time");

			players = get_players();
			for(i=0;i<players.size;i++)
			{
				players[i] send_message_to_csc("hud_anim_handler", "hud_round_total_time_in");
			}
		}

		level waittill("between_round_over");

		players = get_players();
		for(i=0;i<players.size;i++)
		{
			players[i] send_message_to_csc("hud_anim_handler", "hud_round_time_out");
			if(level.gamemode == "survival")
				players[i] send_message_to_csc("hud_anim_handler", "hud_round_total_time_out");
		}

		level waittill( "start_of_round" );

		if(is_true(flag("enter_nml")))
		{
			level waittill( "start_of_round" );
		}
	}
}

round_time()
{
	level endon( "intermission" );
	level endon("stop_round_time");
	level.round_time = 0;
	while(1)
	{
		update_time(level.round_time, "hud_round_time");

		wait 1;

		level.round_time++;
	}
}

update_time(level_var, client_var)
{
	time = to_mins_short(level_var);

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] SetClientDvar(client_var, time);
	}
}

watch_faulty_rounds()
{
	level endon( "end_game" );

	time_no_enemies = 0;
	while(1)
	{
		wait(1);
		enemy_count = get_enemy_count();
		if(enemy_count <= 0)
			time_no_enemies++;
		else
			time_no_enemies = 0;

		if(time_no_enemies > 30) 
		{
			level.zombie_total = 0;
			flag_set( "end_round_wait" );
			level notify( "last_dog_down" );
			wait( 1 );
			flag_clear( "end_round_wait" );
			time_no_enemies = 0;
		}
		
	}	
}


enemies_remaining_hud()
{
	if(level.gamemode != "survival" && level.gamemode != "grief")
	{
		return;
	}

	notifyDespawnOnce = false;
	while(1)
	{
		players = get_players();
		zombs = get_total_remaining_enemies();

		if( zombs <= level.THRESHOLD_MIN_ZOMBIES_DESPAWN_OFF_NUMBER && !notifyDespawnOnce ) 
		{
			notifyDespawnOnce = true;
			if( level.round_number < 6 ) 
			{
				if( zombs <= level.THRESHOLD_MIN_ZOMBIES_DESPAWN_OFF_NUMBER_EARLY ) 
					level notify( level.STRING_MIN_ZOMBS_REMAINING_NOTIFY );
				else
					notifyDespawnOnce = false;
				
			}
			else 
			{
				level notify( level.STRING_MIN_ZOMBS_REMAINING_NOTIFY );
			}
			
		}
		else if( zombs > level.THRESHOLD_MIN_ZOMBIES_DESPAWN_OFF_NUMBER ) 
		{
			notifyDespawnOnce = false;
		}
			

		if( zombs == 0 || is_true(flag("enter_nml")) || is_true(flag("round_restarting")) )
		{
			if(GetDvar("hud_enemy_counter_value") != "")
			{
				for(i=0;i<players.size;i++)
				{
					players[i] SetClientDvar("hud_enemy_counter_value", "");
				}
			}
		}
		else
		{
			if(GetDvarInt("hud_enemy_counter_value") != zombs)
			{
				for(i=0;i<players.size;i++)
				{
					players[i] SetClientDvar("hud_enemy_counter_value", zombs);
				}
			}
		}

		wait .5;
	}
}

sidequest_hud()
{
	if((level.script != "zombie_cod5_factory" && level.script != "zombie_cosmodrome" && level.script != "zombie_coast" && level.script != "zombie_temple" && level.script != "zombie_moon") || level.gamemode != "survival")
		return;

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] send_message_to_csc("hud_anim_handler", "hud_sidequest_time_out");
	}

	// Moon has 2 parts to the sidequest
	if(level.script == "zombie_moon")
	{
		flag_wait("sam_switch_thrown");

		time = to_mins_short(level.total_time);

		players = get_players();
		for(i=0;i<players.size;i++)
		{
			players[i] SetClientDvar("hud_sidequest_text", "REIMAGINED_SIDEQUEST_PART_ONE_COMPLETE");
			players[i] SetClientDvar("hud_sidequest_time", time);
			players[i] send_message_to_csc("hud_anim_handler", "hud_sidequest_time_in");
		}

		wait 5;

		players = get_players();
		for(i=0;i<players.size;i++)
		{
			players[i] send_message_to_csc("hud_anim_handler", "hud_sidequest_time_out");
		}
	}

	if(level.script == "zombie_cod5_factory")
	{
		flag_wait( "ee_exp_monkey" );
		flag_wait( "ee_bowie_bear" );
		flag_wait( "ee_perk_bear" );
	}
	else if(level.script == "zombie_cosmodrome")
	{
		level waittill( "help_found" );
	}
	else if(level.script == "zombie_coast")
	{
		level waittill( "stop_spark" );
	}
	else if(level.script == "zombie_temple")
	{
		level waittill("temple_sidequest_achieved");
	}
	else if(level.script == "zombie_moon")
	{
		level waittill("start_launch");
	}

	time = to_mins_short(level.total_time);

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] SetClientDvar("hud_sidequest_text", "REIMAGINED_SIDEQUEST_COMPLETE");
		players[i] SetClientDvar("hud_sidequest_time", time);
		players[i] send_message_to_csc("hud_anim_handler", "hud_sidequest_time_in");
	}

	wait 5;

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] send_message_to_csc("hud_anim_handler", "hud_sidequest_time_out");
	}
}

zone_hud()
{
	self endon("disconnect");

	current_name = " ";

	while(1)
	{
		wait_network_frame();

		name = choose_zone_name(self get_current_zone(), current_name);

		if(current_name == name)
		{
			continue;
		}

		current_name = name;

		self send_message_to_csc("hud_anim_handler", "hud_zone_name_out");
		wait .25;
		self SetClientDvar("hud_zone_name", name);
		self send_message_to_csc("hud_anim_handler", "hud_zone_name_in");
	}
}

choose_zone_name(zone, current_name)
{
	if(self.sessionstate == "spectator")
	{
		zone = undefined;
	}

	if(IsDefined(zone))
	{
		if(level.script == "zombie_pentagon")
		{
			if(zone == "labs_elevator")
			{
				zone = "war_room_zone_elevator";
			}
		}
		else if(level.script == "zombie_cosmodrome")
		{
			if(IsDefined(self.lander) && self.lander)
			{
				zone = undefined;
			}
		}
		else if(level.script == "zombie_coast")
		{
			if(IsDefined(self.is_ziplining) && self.is_ziplining)
			{
				zone = undefined;
			}
		}
		else if(level.script == "zombie_temple")
		{
			if(zone == "waterfall_tunnel_a_zone")
			{
				zone = "waterfall_tunnel_zone";
			}
		}
		else if(level.script == "zombie_moon")
		{
			if(IsSubStr(zone, "airlock"))
			{
				return current_name;
			}
		}
	}

	name = " ";

	if(IsDefined(zone))
	{
		name = "reimagined_" + level.script + "_" + zone;
	}

	return name;
}

grenade_hud()
{
	self endon("disconnect");

	while(1)
	{
		if(self is_drinking())
		{
			self SetClientDvar("lethal_grenade_amount", 0);
			self SetClientDvar("tactical_grenade_amount", 0);
			self SetClientDvar("disable_grenade_amount_update", true);
		}
		else
		{
			self SetClientDvar("disable_grenade_amount_update", false);
		}

		// Now done in csc, keeping code here in case I need to switch back

		/*lethal_nade = self get_player_lethal_grenade();
		tactical_nade = self get_player_tactical_grenade();

		lethal_nade_icon = "hud_grenadeicon";
		tactical_nade_icon = "hud_cymbal_monkey";

		if(lethal_nade == "frag_grenade_zm")
		{
			lethal_nade_icon = "hud_grenadeicon";
		}
		else if(lethal_nade == "sticky_grenade_zm")
		{
			lethal_nade_icon = "hud_icon_sticky_grenade";
		}
		else if(lethal_nade == "stielhandgranate")
		{
			lethal_nade_icon = "hud_grenadeicon";
		}

		if(tactical_nade == "zombie_cymbal_monkey")
		{
			tactical_nade_icon = "hud_cymbal_monkey";
		}
		else if(tactical_nade == "zombie_black_hole_bomb")
		{
			tactical_nade_icon = "hud_blackhole";
		}
		else if(tactical_nade == "zombie_nesting_dolls")
		{
			tactical_nade_icon = "hud_nestingbomb";
		}
		else if(tactical_nade == "zombie_quantum_bomb")
		{
			tactical_nade_icon = "hud_icon_quantum_bomb";
		}
		else if(tactical_nade == "molotov_zm")
		{
			tactical_nade_icon = "hud_icon_molotov";
		}

		lethal_nade_amt = self GetWeaponAmmoClip( lethal_nade );
		tactical_nade_amt = self GetWeaponAmmoClip( tactical_nade );

		self SetClientDvar("lethal_grenade_icon", lethal_nade_icon);
		self SetClientDvar("tactical_grenade_icon", tactical_nade_icon);
		self SetClientDvar("lethal_grenade_amount", lethal_nade_amt);
		self SetClientDvar("tactical_grenade_amount", tactical_nade_amt);*/

		wait_network_frame();
	}
}

box_weapon_changes()
{
	flag_wait("all_players_connected");

	/*if(IsSubStr(level.script, "zombie_cod5_"))
	{
		weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );
		for( i = 0; i < weapon_spawns.size; i++ )
		{
	        if(WeaponType(weapon_spawns[i].zombie_weapon_upgrade) != "grenade" && !level.zombie_weapons[weapon_spawns[i].zombie_weapon_upgrade].is_in_box)
	        {
	        	level.zombie_weapons[weapon_spawns[i].zombie_weapon_upgrade].is_in_box = true;
	        }
		}
	}*/

	if(level.script == "zombie_cod5_prototype" || level.script == "zombie_cod5_asylum" || level.script == "zombie_cod5_sumpf")
	{
		level.zombie_weapons["zombie_cymbal_monkey"].is_in_box = false;
	}
}

revive_grace_period()
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		self waittill("player_revived");
		self.ignoreme = true;
		wait 1;
		self.ignoreme = false;
	}
}

//removes idle sway on sniper scopes
remove_idle_sway()
{
	self endon("death");
	self endon("disconnect");

	// other weapons are done from weapon file
	//snipers = array("l96a1_zm", "l96a1_upgraded_zm", "psg1_zm", "psg1_upgraded_zm", "sniper_explosive_zm", "sniper_explosive_upgraded_zm", "kar98k_scoped_zombie");
	snipers = array("sniper_explosive_zm", "sniper_explosive_upgraded_zm");
	set = false;

	while(1)
	{
		wait_network_frame();

		if(self HasPerk("specialty_deadshot"))
		{
			if(set)
				set = false;
			continue;
		}

		wep = self GetCurrentWeapon();
		is_sniper = is_in_array(snipers, wep);
		is_ads = isADS(self);

		if(is_sniper && is_ads && !set)
		{
			self SetClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
			set = true;
		}
		else if(( !is_sniper || !is_ads ) && set)
		{
			self ClearClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
			set = false;
		}
	}
}

disable_character_dialog()
{
	flag_wait("all_players_connected");
	if(level.gamemode != "survival")
	{
		while(1)
		{
			level.player_is_speaking = 1;
			wait .1;
		}
	}
	else
	{
		while(1)
		{
			if(GetDvarInt("character_dialog") == 1)
			{
				level.player_is_speaking = 0;
				while(GetDvarInt("character_dialog") == 1)
				{
					wait .1;
				}
			}

			while(GetDvarInt("character_dialog") == 0)
			{
				level.player_is_speaking = 1;
				wait .1;
			}
		}
	}
}

health_bar_hud()
{
	health_bar_width_max = 110;

	while (1)
	{
		health_ratio = self.health / self.maxhealth;

		self SetClientDvar("hud_health_bar_value", self.health);
		self SetClientDvar("hud_health_bar_width", health_bar_width_max * health_ratio);

		wait 0.05;
	}
}

character_names_hud()
{
	//disable any hud names of players that have disconnected
	self SetClientDvar( "hud_character_name_on_white", false );
	self SetClientDvar( "hud_character_name_on_blue", false );
	self SetClientDvar( "hud_character_name_on_yellow", false );
	self SetClientDvar( "hud_character_name_on_green", false );

	if(level.gamemode != "survival")
		return;

	flag_wait("all_players_spawned");

	players = get_players();
	for ( j = 0; j < players.size; j++ )
	{
		//players[j].entity_num = players[j] GetEntityNumber();
		// Allow custom maps to override this logic
		if(isdefined(level._zombiemode_get_player_name_string))
		{
			name = players[j] [[level._zombiemode_get_player_name_string]](players[j].entity_num);
		}
		else if(level.script == "zombie_cod5_prototype" || level.script == "zombie_cod5_asylum")
		{
			name = "REIMAGINED_ZOMBIE_COD5_ASYLUM_PLAYER_NAME_" + players[j].entity_num;
		} 
		else if(level.script == "zombie_pentagon")
		{
			name = "REIMAGINED_ZOMBIE_PENTAGON_PLAYER_NAME_" + players[j].entity_num;
		}
		else if(level.script == "zombie_coast")
		{
			name = "REIMAGINED_ZOMBIE_COAST_PLAYER_NAME_" + players[j].entity_num;
		}
		else
		{
			name = "REIMAGINED_ZOMBIE_THEATER_PLAYER_NAME_" + players[j].entity_num;
		}

		if(IsDefined(name))
		{
			offset = players.size - j - 1;
			color = level.ARRAY_ZOMBIEMODE_PLAYER_COLORS[ players[j].entity_num ];
			color = "white";
			self SetClientDvar( "hud_character_name_" + color, name );
			self SetClientDvar( "hud_character_name_offset_" + color, offset * 20 );
			self SetClientDvar( "hud_character_name_on_" + color, true );
		}
	}
}


set_gamemode()
{
	level.gamemode = "survival";
	if(level.gamemode != "survival")
	{
		level.vsteams = GetDvar("vs_teams");
	}
	else
	{
		level.vsteams = "";
	}

	level thread set_gamemode_name();
}


set_gamemode_name()
{
	wait_network_frame();
	flag_wait("all_players_connected");

	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] SetClientDvar("zm_gamemode_name", "survival");
		players[i] SetClientDvar("zm_gamemode_name2", level.vsteams);
	}
}

melee_notify()
{
	self endon("disconnect");

	while(1)
	{
		if(self IsMeleeing())
		{
			self notify("melee");
			while(self IsMeleeing())
				wait_network_frame();
		}
		else
		{
			wait_network_frame();
		}
	}
}

sprint_notify()
{
	self endon("disconnect");

	while(1)
	{
		if(self IsSprinting())
		{
			self notify("sprint");
			while(self IsSprinting())
				wait_network_frame();
		}
		wait_network_frame();
	}
}

switch_weapons_notify()
{
	self endon("disconnect");

	while(1)
	{
		while(!self IsSwitchingWeapons())
			wait_network_frame();
		self notify("weapon_switch");
		while(self IsSwitchingWeapons())
			wait_network_frame();
		self notify("weapon_switch_complete");
	}
}

is_reloading_check()
{
	self endon("disconnect");

	self.is_reloading = false;
	self.still_reloading = false;

	while(1)
	{
		self waittill("reload_start");

		empty_clip = self GetCurrentWeaponClipAmmo() == 0;

		self.is_reloading = true;
		self.still_reloading = true;

		waittill_return = self waittill_any_return("reload", "melee", "sprint", "weapon_switch");

		self.is_reloading = false;

		if(waittill_return == "reload")
		{
			self reload_complete_check(empty_clip);
		}
		self.still_reloading = false;
	}
}

reload_complete_check(empty_clip)
{
	self endon("disconnect");
	self endon("melee");
	self endon("sprint");
	self endon("weapon_switch");
	self endon("weapon_fired");

	weapon = self GetCurrentWeapon();
	reload_time = WeaponReloadTime(weapon);
	if(self HasPerk("specialty_fastreload"))
		reload_time *= GetDvarFloat("perk_weapReloadMultipler");

	reload_time *= .2;
	if(empty_clip)
		reload_time *= 2;

	wait reload_time;
}

revive_waypoint()
{
	waypoint = "waypoint_second_chance";
	if(level.gamemode != "survival")
	{
		if(IsDefined(level.vsteam))
		{
			waypoint = "waypoint_" + level.vsteam;
		}
		else
		{
			waypoint = "waypoint_" + self.vsteam;
		}
	}

	self.reviveWaypoint = NewHudElem();
	self.reviveWaypoint SetTargetEnt(self);
	self.reviveWaypoint.sort = 20;
	self.reviveWaypoint.alpha = 1;
	self.reviveWaypoint SetWaypoint( true, waypoint );
	self.reviveWaypoint.color = ( 1, .7, .1 );

	time = int(GetDvar("player_lastStandBleedoutTime"));
	self thread revive_waypoint_color_think(time);

	self thread destroy_revive_waypoint();
}

revive_waypoint_color_think(time)
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );
	self endon( "player_revived" );
	self endon( "bled_out" );
	self endon( "round_restarted" );

	start_time = GetTime();
	time_ms = time * 1000;

	while(1)
	{
		current_time = GetTime();

		if( IsDefined( self.revivetrigger ) && IsDefined( self.revivetrigger.beingRevived ) && self.revivetrigger.beingRevived )
		{
			self.reviveWaypoint.color = (1,1,1);
		}
		else
		{
			g_diff = ((current_time - start_time) / time_ms) * .7;
			b_diff = ((current_time - start_time) / time_ms) * .1;

			g_color = .7 - g_diff;
			b_color = .1 - b_diff;
			self.reviveWaypoint.color = (1, g_color, b_color);
		}

		self waittill_notify_or_timeout("update_revive_waypoint", .05);
	}
}

destroy_revive_waypoint()
{
	self waittill_any("player_revived", "bled_out", "round_restarted", "disconnect", "death");

	if(IsDefined(self.reviveWaypoint))
		self.reviveWaypoint destroy_hud();
}

hide_and_delete()
{
	self endon("death");

	self.water_damage = false;
	self Hide();
	wait .4;
	self Delete();
}

store_last_held_primary_weapon()
{
	self endon("disconnect");

	while(1)
	{
		self waittill( "weapon_change" );

		current_wep = self GetCurrentWeapon();

		if( !IsDefined( current_wep ) || current_wep == "none" )
			continue;

		if(WeaponInventoryType(current_wep) == "altmode")
		{
			current_wep = WeaponAltWeaponName(current_wep);
		}

		if(is_in_array(self GetWeaponsListPrimaries(), current_wep))
		{
			self.last_held_primary_weapon = current_wep;
		}
	}
}

// fix for players getting stuck in the air with high fps
player_gravity_fix()
{
	self endon("disconnect");

	force = 1;

	while(1)
	{
		if(GetDvarInt("sv_cheats"))
		{
			wait_network_frame();
			continue;
		}

		vel = self GetVelocity();

		if(!self IsOnGround() && vel[2] == 0 && !is_true(self.inteleportation) && !is_true(self.riding_geyser) && !is_true(self.is_ziplining) && !is_true(self._being_flung))
		{
			self SetVelocity( vel + (0, 0, -1 * force) );

			force *= 2;
		}
		else if(force != 1)
		{
			force = 1;
		}

		wait_network_frame();
	}
}

fall_velocity_check()
{
	self endon("disconnect");

	while (1)
	{
		if(!self isOnGround())
		{
			vel = self getVelocity();
			self.fall_velocity = vel[2];
		}
		else
		{
			self.fall_velocity = 0;
		}

		wait_network_frame();
	}
}