#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\zombie_Utility;

/*
init()
{
	PrecacheRumble( "explosion_generic" );
	init_boss_zombie_anims();
	
	level._effect["boss_groundhit"] = loadfx("maps/zombie/fx_zombie_boss_grnd_hit");
	level._effect["boss_spawn"] = loadfx("maps/zombie/fx_zombie_boss_spawn");
	
	
	
	if( !isDefined( level.boss_zombie_spawn_heuristic ) )
	{
		level.boss_zombie_spawn_heuristic = maps\_zombiemode_ai_boss::boss_zombie_default_spawn_heuristic;
	}
	
	
	
	if( !isDefined( level.boss_zombie_pathfind_heuristic ) )
	{
		level.boss_zombie_pathfind_heuristic = maps\_zombiemode_ai_boss::boss_zombie_default_pathfind_heuristic;
	}
	if ( !isDefined( level.boss_zombie_enter_level ) )
	{
		level.boss_zombie_enter_level = maps\_zombiemode_ai_boss::boss_zombie_default_enter_level;
	}
	precacheshellshock( "electrocution" );
	
	
	level.boss_idle_nodes = GetNodeArray( "boss_idle", "script_noteworthy" );
	
	level.num_boss_zombies = 0;
	level.boss_zombie_spawners = GetEntArray( "boss_zombie_spawner", "targetname" );
	array_thread( level.boss_zombie_spawners, ::add_spawn_function, maps\_zombiemode_ai_boss::boss_prespawn );
	
	if( !isDefined( level.max_boss_zombies ) )
	{
		level.max_boss_zombies = 1;
	}
	if( !isDefined( level.boss_respawn_timer ) )
	{
		level.boss_respawn_timer = 30;
	}
	if( !isDefined( level.boss_zombie_health_mult ) )
	{
		level.boss_zombie_health_mult = 7;
	}
	if( !isDefined( level.boss_zombie_damage_mult ) )
	{
		level.boss_zombie_damage_mult = 2;
	}
	if( !isDefined( level.boss_zombie_min_health ) )
	{
		level.boss_zombie_min_health = 5000;
	}
	if( !isDefined( level.boss_zombie_scream_a_chance ) )
	{
		level.boss_zombie_scream_a_chance = 100;
	}
	if( !isDefined( level.boss_zombie_scream_a_radius ) )
	{
		level.boss_zombie_scream_a_radius_sq = 512*512;
	}
	if( !isDefined( level.boss_zombie_scream_b_chance ) )
	{
		level.boss_zombie_scream_b_chance = 0;
	}
	if( !isDefined( level.boss_zombie_scream_b_radius ) )
	{
		level.boss_zombie_scream_b_radius_sq = 512*512;
	}
	if( !isDefined( level.boss_zombie_groundhit_damage ) )
	{
		level.boss_zombie_groundhit_damage = 90;
	}
	if( !isDefined( level.boss_zombie_groundhit_radius ) )
	{
		level.boss_zombie_groundhit_radius = 256;
	}
	if( !isDefined( level.boss_zombie_proximity_wake ) )
	{
		level.boss_zombie_proximity_wake = 1296;
	}
	if( !isDefined( level.boss_thundergun_damage ) )
	{
		level.boss_thundergun_damage = 1000;
	}
	if( !isDefined( level.boss_fire_damage ) )
	{
		level.boss_fire_damage = 500;
	}
	if( !isDefined( level.boss_ground_attack_delay ) )
	{
		level.boss_ground_attack_delay = 5000;
	}
	
	
	
	firstSpawners = GetEntArray( "first_boss_spawner", "script_noteworthy" );
	
	if( isDefined( firstSpawners ) && firstSpawners.size > 0 )
	{
		if( firstSpawners.size > level.max_boss_zombies )
		{
			chosenSpawners = [];
			while( chosenSpawners.size < level.max_boss_zombies )
			{
				index = RandomInt( firstSpawners.size );
				if( firstSpawners[index].script_string == "boss" ) 
				{
					chosenSpawners = array_add( chosenSpawners, firstSpawners[index] );
				}
				firstSpawners = array_remove( firstSpawners, firstSpawners[index] );
			}
		}
		else
		{
			chosenSpawners = firstSpawners;
		}
		
		for( i = 0; i < chosenSpawners.size; i++ )
		{
			chosenSpawners[i] boss_zombie_spawn();
		}
	}
	
	level thread boss_zombie_manager();
	
	level.ammo_spawn = true;
	level.boss_death = 0;
	level.boss_death_ammo = 2;
	level.boss_health_reduce = 0.7;
	level thread boss_adjust_max_ammo();
}

#using_animtree( "generic_human" );
boss_prespawn()
{
	self.animname = "boss_zombie";
	
	self.custom_idle_setup = maps\_zombiemode_ai_boss::boss_zombie_idle_setup;
	
	self.damage_mult = level.boss_zombie_damage_mult;
	self.a.idleAnimOverrideArray = [];
	self.a.idleAnimOverrideArray["stand"] = [];
	self.a.idleAnimOverrideWeights["stand"] = [];
	self.a.idleAnimOverrideArray["stand"][0][0] 	= %ai_zombie_boss_idle_a;
	self.a.idleAnimOverrideWeights["stand"][0][0] 	= 10;
	self.a.idleAnimOverrideArray["stand"][0][1] 	= %ai_zombie_boss_idle_b;
	self.a.idleAnimOverrideWeights["stand"][0][1] 	= 10;
	self.ignoreall = true; 
	self.allowdeath = true; 			
	self.is_zombie = true; 			
	self.has_legs = true; 			
															
	self allowedStances( "stand" ); 
	self.gibbed = false; 
	self.head_gibbed = false;
	
	
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatInitialized = false; 
	self.a.disablePain = true;
	self disable_react(); 
	
	
	self.freezegun_damage = 0;
	
	self.dropweapon = false; 
	self thread maps\_zombiemode_spawner::zombie_damage_failsafe();
	self thread maps\_zombiemode_spawner::delayed_zombie_eye_glow();	
	self.flame_damage_time = 0;
	self.meleeDamage = 50;
	self.no_powerups = true;
	self thread maps\_zombiemode_ai_boss::boss_set_airstrike_damage();
	self.thundergun_disintegrate_func = ::boss_thundergun_disintegrate;
	self.thundergun_fling_func = ::boss_thundergun_disintegrate;
	self.fire_damage_func = ::boss_fire_damage;
	
	self.custom_damage_func = ::boss_custom_damage;
	self.actor_damage_func = ::boss_actor_damage;
	self.nuke_damage_func = ::boss_nuke_damage;
	self.noChangeDuringMelee = true;
	self setTeamForEntity( "axis" );
	self setPhysParams( 18, 0, 72 );
	self notify( "zombie_init_done" );
}
boss_health_watch()
{
	self endon( "death" );
	while ( 1 )
	{
		
		wait( 1 );
	}
}

boss_zombie_spawn()
{
	self.script_moveoverride = true; 
	
	if( !isDefined( level.num_boss_zombies ) )
	{
		level.num_boss_zombies = 0;
	}
	level.num_boss_zombies++;
	
	boss_zombie = self maps\_zombiemode_net::network_safe_stalingrad_spawn( "boss_zombie_spawn", 1 );
	
	
	
	self playsound( "zmb_engineer_spawn" );
	
	self.count = 666; 
	self.last_spawn_time = GetTime();
	if( !spawn_failed( boss_zombie ) ) 
	{ 
		boss_zombie.script_noteworthy = self.script_noteworthy;
		boss_zombie.targetname = self.targetname;
		boss_zombie.target = self.target;
		boss_zombie.deathFunction = maps\_zombiemode_ai_boss::boss_zombie_die;
		boss_zombie.animname = "boss_zombie";
	
		boss_zombie thread boss_zombie_think();
		
		if( isDefined( level.boss_zombie_death_pos ) && level.boss_zombie_death_pos.size > 0 )
		{
			level.boss_zombie_death_pos = array_remove( level.boss_zombie_death_pos, level.boss_zombie_death_pos[0] );
		}
	}
	else
	{
		level.num_boss_zombies--;
	}
}
boss_zombie_manager()
{
	
	start_boss = getent( "start_boss_spawner", "script_noteworthy" );
	if ( isDefined( start_boss ) )
	{
		while ( true )
		{
			if ( level.num_boss_zombies < level.max_boss_zombies )
			{
				start_boss boss_zombie_spawn();
				break;
			}
			wait( 0.5 );
		}
	}
	while( true ) 
	{
		AssertEx( isDefined( level.num_boss_zombies ) && isDefined( level.max_boss_zombies ), "Either max_boss_zombies or num_boss_zombies not defined, this should never be the case!" );
		while( level.num_boss_zombies < level.max_boss_zombies ) 
		{
			spawner = boss_zombie_pick_best_spawner();
			if( isDefined( spawner ) )
			{
				spawner boss_zombie_spawn();
			}
			wait( 10 );
		}
		wait( 10 );
	}
}
boss_zombie_pick_best_spawner()
{
	best_spawner = undefined;
	best_score = -1;
	for( i = 0; i < level.boss_zombie_spawners.size; i++ )
	{
		score = [[ level.boss_zombie_spawn_heuristic ]]( level.boss_zombie_spawners[i] );
		if( score > best_score )
		{
			best_spawner = level.boss_zombie_spawners[i];
			best_score = score;
		}
	}
	return best_spawner;
}
boss_zombie_think()
{
	self endon( "death" );
	
	self.is_activated = false;
	self.entered_level = false;
	
	self thread boss_zombie_check_for_activation();
	self thread boss_zombie_check_player_proximity();
	self thread boss_zombie_choose_run();
	
	
	
	self.ignoreall = false;
	self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;
	self.maxhealth = level.zombie_health * level.boss_zombie_health_mult;
	self.health = level.zombie_health * level.boss_zombie_health_mult;
	
	if( self.maxhealth < level.boss_zombie_min_health )
	{
		self.maxhealth = level.boss_zombie_min_health;
		self.health = level.boss_zombie_min_health;
	}
	if ( level.boss_health_reduce < 1.0 )
	{
		reduce = int( self.health * level.boss_health_reduce );
		level.boss_health_reduce += 0.1;
		self.health = reduce;
		self.maxhealth = reduce;
	}
	else
	{
		level.boss_health_reduce = 1.0;
	}
	players = GetPlayers();
	if ( players.size == 4 )
	{
		bonus = int( self.health * .5 );
		self.maxhealth += bonus;
		self.health += bonus;
	}
	
	
	self.maxsightdistsqrd = 96 * 96;
	
	self.zombie_move_speed = "walk";
	
	self thread [[ level.boss_zombie_enter_level ]]();
	if ( isDefined( level.boss_zombie_custom_think ) )
	{
		self thread [[ level.boss_zombie_custom_think ]]();
	}
	while( true )
	{
		if ( !self.entered_level )
		{
			wait_network_frame();
			continue;
		}
		else if ( isDefined( self.custom_think ) && self.custom_think )
		{
			wait_network_frame();
			continue;
		}
		else if( isDefined( self.performing_activation ) && self.performing_activation ) 
		{
			wait_network_frame();
			continue;
		}
		else if ( isDefined( self.ground_hit ) && self.ground_hit )
		{
			wait_network_frame();
			continue;
		}
		else if( !isDefined( self.following_player ) || !self.following_player ) 
		{
			self thread maps\_zombiemode_spawner::find_flesh();
			self.following_player = true;
		}
		wait( 1 );
	}
}
boss_zombie_pick_idle_point()
{
	best_score = -1;
	best_node = undefined;
	
	for( i = 0; i < level.boss_idle_nodes.size; i++ )
	{
		score = [[ level.boss_zombie_pathfind_heuristic ]]( level.boss_idle_nodes[i] );
		
		if( score > best_score )
		{
			best_score = score;
			best_node = level.boss_idle_nodes[i];
		}
	}
	
	return best_node;
}
boss_zombie_default_pathfind_heuristic( node ) 
{
	
	if( !isDefined( node.targetname ) || !isDefined( level.zones[node.targetname] ) )
	{
		return -1;
	}
	
	
	if( isDefined( node.is_claimed ) && node.is_claimed && ( !isDefined( self.curr_idle_node ) || self.curr_idle_node != node ) )
	{
		return -1;
	}
	
	players = get_players();
	score = 0;
	
	for( i = 0; i < players.size; i++ )
	{
		dist = distanceSquared( node.origin, players[i].origin );
		if( dist > 10000*10000 )
		{
			dist = 10000*10000;
		}
		if( dist <= 1 )
		{
			score += 10000*10000;
			continue;
		}
		score += int( 10000*10000/dist );
	}
	
	return score;
}
boss_zombie_default_spawn_heuristic( spawner )
{
	if( isDefined( spawner.last_spawn_time ) && (GetTime() - spawner.last_spawn_time < 30000) )
	{
		return -1;
	}
	
	if( !isDefined( spawner.script_noteworthy ) )
	{
		return -1;
	}
	if( spawner.script_noteworthy != "first_boss_spawner" && (!isDefined( level.zones ) || !isDefined( level.zones[ spawner.script_noteworthy ] ) || !level.zones[ spawner.script_noteworthy ].is_enabled ) )
	{
		return -1;
	}
	
	score = 0;
	
	
	if( !isDefined( level.boss_zombie_death_pos ) || level.boss_zombie_death_pos.size == 0 )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{
			score = int( distanceSquared( spawner.origin, players[i].origin ) );
		}
	}
	else
	{
		dist = int( distanceSquared( level.boss_zombie_death_pos[0], spawner.origin ) );
		if( dist > 10000*10000 )
		{
			dist = 10000*10000;
		}
		if( dist <= 1 )
		{
			dist = 1;
			
		}
		score = int( 10000*10000/dist );
	}
	
	return score;
}
boss_zombie_choose_run()
{
	self endon( "death" );
	
	while( true ) 
	{
		if( self.is_activated )
		{
			self.zombie_move_speed = "sprint";
			if ( level.round_number > 20 )
			{
				self.moveplaybackrate = 1.0;
			}
			else if ( level.round_number > 15 )
			{
				self.moveplaybackrate = 0.95;
			}
			else if ( level.round_number > 10 )
			{
				self.moveplaybackrate = 0.90;
			}
			else if ( level.round_number > 5 )
			{
				self.moveplaybackrate = 0.85;
			}
			else 
			{
				self.moveplaybackrate = 0.8;
			}
			rand = randomIntRange( 1, 4 );
			self set_run_anim( "sprint"+rand );
			self.run_combatanim = level.scr_anim["boss_zombie"]["sprint"+rand];
			self.crouchRunAnim = level.scr_anim["boss_zombie"]["sprint"+rand];
			self.crouchrun_combatanim = level.scr_anim["boss_zombie"]["sprint"+rand];
			self.needs_run_update = true;
			randf = randomFloatRange( 2, 3 );
			wait( randf );
		}
		else
		{
			self.zombie_move_speed = "walk";
			self set_run_anim( "walk1" );
			self.run_combatanim = level.scr_anim["boss_zombie"]["walk1"];
			self.crouchRunAnim = level.scr_anim["boss_zombie"]["walk1"];
			self.crouchrun_combatanim = level.scr_anim["boss_zombie"]["walk1"];
			self.needs_run_update = true;
		}
		wait( 0.05 );
	}
}
boss_zombie_health_manager()
{
	self endon( "death" );
	
	self thread wait_for_round_over();
	self thread wait_for_activation();
	
	while( true )
	{
		self waittill( "update_health" ); 
		self.maxhealth = level.zombie_health * level.boss_zombie_health_mult;
		self.health = level.zombie_health * level.boss_zombie_health_mult;
		if( self.maxhealth < level.boss_zombie_min_health )
		{
			self.maxhealth = level.boss_zombie_min_health;
			self.health = level.boss_zombie_min_health;
		}
		if( self.is_activated )
		{
			return;
		}
		wait( 0.05 );
	}
}
wait_for_round_over()
{
	self endon( "stop_managing_health" );
	
	while( true )
	{
		level waittill( "between_round_over" );
		self notify( "update_health" );
		wait( 0.05 );
	}
}
wait_for_activation()
{
	self waittill( "boss_activated" );
	self notify( "update_health" );
	self notify( "stop_managing_health" );
}
boss_zombie_check_player_proximity()
{
	self endon( "death" );
	while ( 1 )
	{
		if ( isdefined( self.performing_activation ) && self.performing_activation )
		{
			break;
		}
		players = getplayers();
		for ( i = 0; i < players.size; i++ )
		{
			dist = DistanceSquared( self.origin, players[i].origin );
			
			if ( dist < level.boss_zombie_proximity_wake )
			{
				self notify( "hit_player" );
				break;
			}
		}
		wait_network_frame();
	}
}
boss_zombie_update_proximity_wake()
{
	while ( !isdefined( level.round_number ) )
	{
		wait( 1 );
	}
	while ( 1 )
	{
		if ( level.round_number >= 20 )
		{
			level.boss_zombie_proximity_wake = 120;
			break;
		}
		else if ( level.round_number >= 15 )
		{
			level.boss_zombie_proximity_wake = 102;
		}
		else if ( level.round_number >= 10 )
		{
			level.boss_zombie_proximity_wake = 84;
		}
		wait( 1 );
	}
}
boss_zombie_check_for_activation()
{
	self endon( "death" );
	
	if( self.is_activated == true )
	{
		if( isDefined( self.curr_idle_node ) )
		{
			self.curr_idle_node.is_claimed = false;
		}
		return;
	}
	while( !self.entered_level )
	{
		wait_network_frame();
	}
		
	self waittill_either( "damage", "hit_player" );
	
	self notify( "stop_finding_flesh" );
	self.following_player = false;
	self.performing_activation = true;
	self.ground_hit = true;
	self thread scream_a_watcher( "groundhit_anim" );
	self thread groundhit_watcher( "groundhit_anim" );
	
	
	
	
	self playsound( "zmb_engineer_vocals_hit" );
	
	time = getAnimLength( %ai_zombie_boss_enrage_start );
	
	self animscripted( "groundhit_anim", self.origin, self.angles, %ai_zombie_boss_enrage_start, "normal", %body, 3 );
	
	time = time / 3.0;
	wait( time );
	
	self notify( "stop_activation_sequence" );
	self.performing_activation = false;
	self.ground_hit = false;
	
	self.is_activated = true;
	
	self notify( "boss_activated" );
	
	if( isDefined( self.curr_idle_node ) )
	{
		self.curr_idle_node.is_claimed = false;
	}
	
	self thread boss_zombie_ground_hit_think();
}
boss_zombie_shockwave_attack()
{
	self endon( "death" );
	if ( IsDefined( self.performing_activation ) && self.performing_activation )
	{
		return;
	}
	
	self notify( "stop_finding_flesh" );
	self.following_player = false;
	self.performing_activation = true;
	self thread groundhit_watcher( "groundhit_anim" );
	
	
	
	self playsound( "zmb_engineer_vocals_hit" );
	
	time = getAnimLength( %ai_zombie_boss_enrage_start );
	
	self animscripted( "groundhit_anim", self.origin, self.angles, %ai_zombie_boss_enrage_start );
	
	wait( time );
	
	self.performing_activation = false;
}
boss_zombie_ground_hit()
{
	self endon( "death" );
	if ( self.ground_hit )
	{
		return;
	}
	
	self notify( "stop_finding_flesh" );
	self.following_player = false;
	self.ground_hit = true;
	self thread groundhit_watcher( "groundhit_anim" );
	
	
	
	time = getAnimLength( %ai_zombie_boss_run_hitground );
	delta = getMoveDelta( %ai_zombie_boss_run_hitground, 0, 1 );
	d = length( delta );
	
	
	self SetFlaggedAnimKnobAllRestart( "groundhit_anim", %ai_zombie_boss_run_hitground, %body, 1, .1, 1 );
	
	animscripts\traverse\zombie_shared::wait_anim_length(%ai_zombie_boss_run_hitground, .02);
	
	self.ground_hit = false;
	self.nextGroundHit = GetTime() + level.boss_ground_attack_delay;
	self thread animscripts\zombie_combat::main();
}
boss_zombie_ground_hit_think()
{
	self endon( "death" );
	self.ground_hit = false;
	self.nextGroundHit = GetTime() + level.boss_ground_attack_delay;
	while( 1 )
	{
		if ( !self.ground_hit && GetTime() >= self.nextGroundHit )
		{
			players = GetPlayers();
			closeEnough = false;
			origin = self GetEye();
			for ( i = 0; i < players.size; i++ )
			{
				if ( players[i] maps\_laststand::player_is_in_laststand() )
				{
					continue;
				}
				test_origin = players[i] GetEye();
				d = DistanceSquared( origin, test_origin );
				if ( d > level.boss_zombie_groundhit_radius * level.boss_zombie_groundhit_radius )
				{
					continue;
				}
				if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
				{
					continue;
				}
				closeEnough = true;
				break;
			}
			if ( closeEnough )
			{
				self animcustom( ::boss_zombie_ground_hit );
			}
		}
		wait_network_frame();
	}
}
scream_a_watcher( animname )
{
	self endon( "death" );
	rand = RandomInt( 100 );
	if( rand > level.boss_zombie_scream_a_chance )
	{
		return; 
	}
	
	self waittillmatch( animname, "scream_a" );
	
	players = get_players();
	affected_players = [];
	for( i = 0; i < players.size; i++ )
	{
		if( distanceSquared( players[i].origin, self.origin ) < level.boss_zombie_scream_a_radius_sq )
		{
			affected_players = array_add( affected_players, players[i] );
		}
	}
	for( i = 0; i < affected_players.size; i++ )
	{
		affected_players[i] ShellShock( "electrocution", 1.5, true );
	}
}
groundhit_watcher( animname )
{
	self endon( "death" );
	self waittillmatch( animname, "wrench_hit" );
	
	playfxontag(level._effect["boss_groundhit"],self,"tag_origin");
	
	origin = self GetEye();
	zombies = get_array_of_closest( origin, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, level.boss_zombie_groundhit_radius );
	if ( IsDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( !IsDefined( zombies[i] ) )
			{
				continue;
			}
			if ( is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				continue;
			}
			test_origin = zombies[i] GetEye();
			if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
			{
				continue;
			}
			if ( zombies[i] == self )
			{
				continue;
			}
			if ( zombies[i].animname == "boss_zombie" )
			{
				continue;
			}
			refs = []; 
			refs[refs.size] = "guts"; 
			refs[refs.size] = "right_arm"; 
			refs[refs.size] = "left_arm"; 
			refs[refs.size] = "right_leg"; 
			refs[refs.size] = "left_leg"; 
			refs[refs.size] = "no_legs"; 
			refs[refs.size] = "head"; 
			if( refs.size )
			{
				zombies[i].a.gib_ref = random( refs ); 
			}
			zombies[i] DoDamage( zombies[i].health + 666, self.origin, self );
		}
	}
	players = get_players();
	affected_players = [];
	for( i = 0; i < players.size; i++ )
	{
		test_origin = players[i] GetEye();
		if( distanceSquared( origin, test_origin ) > level.boss_zombie_groundhit_radius * level.boss_zombie_groundhit_radius )
		{
			continue;
		}
		if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
		{
			continue;
		}
		affected_players = array_add( affected_players, players[i] );
	}
	for( i = 0; i < affected_players.size; i++ )
	{
		
		affected_players[i] ShellShock( "electrocution", 1.5, true );
	}
}
scream_b_watcher( animname )
{
	self endon( "death" );
	rand = RandomInt( 100 );
	if( rand > level.boss_zombie_scream_b_chance )
	{
		return; 
	}
	
	self waittillmatch( animname, "scream_b" );
	
	players = get_players();
	affected_players = [];
	for( i = 0; i < players.size; i++ )
	{
		if( distanceSquared( players[i].origin, self.origin ) < level.boss_zombie_scream_b_radius_sq )
		{
			affected_players = array_add( affected_players, players[i] );
		}
	}
	for( i = 0; i < affected_players.size; i++ )
	{
		affected_players[i] ShellShock( "electrocution", 1.5, true );
	}
}
boss_zombie_die()
{
	self maps\_zombiemode_spawner::reset_attack_spot();
	self.grenadeAmmo = 0;
	if( isDefined( self.curr_idle_node ) )
	{
		self.curr_idle_node.is_claimed = false;
	}
	
	
	
	self playsound( "zmb_engineer_death_bells" );
	
	
	
	level maps\_zombiemode_spawner::zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker,self );
	if( self.damagemod == "MOD_BURNED" )
	{
		self thread animscripts\zombie_death::flame_death_fx();
	}
	if( !isDefined( level.boss_zombie_death_pos ) )
	{
		level.boss_zombie_death_pos = [];
	}	
	
	level.boss_zombie_death_pos = array_add( level.boss_zombie_death_pos, self.origin );
	level notify( "boss_zombie_died" );
	self thread boss_zombie_wait_for_respawn();
	for ( i = 0; i < level.zombie_powerup_array.size; i++ )
	{
		if ( level.zombie_powerup_array[i] == "full_ammo" )
		{
			if ( level.ammo_spawn )
			{
				level.ammo_spawn = false;
				level.zombie_powerup_boss = i;
			}
			else
			{
				if ( i == level.zombie_powerup_array.size - 1 )
				{
					level.zombie_powerup_boss = 0;
				}
				else
				{
					level.zombie_powerup_boss = i+1;
				}
			}
			break;
		}
	}
	play_sound_2D( "mus_bright_sting" );
	level.zombie_vars["zombie_drop_item"] = 1;
	level.powerup_drop_count--;
	level thread maps\_zombiemode_powerups::powerup_drop( self.origin );
	level.boss_death++;
	if ( level.boss_death >= level.boss_death_ammo )
	{
		level.ammo_spawn = true;
		level.boss_death = 0;
	}
	return false;
}
boss_adjust_max_ammo()
{
	while ( 1 )
	{
		level waittill( "between_round_over" );
		
		
		
		
		
		
		
		wait_network_frame();
	}
}
boss_zombie_wait_for_respawn()
{
	
	level thread wait_for_round();
	level thread wait_for_immediate();
	level waittill( "respawn_now" );
	level.num_boss_zombies--;
}
wait_for_round()
{
	level endon( "respawn_now" );
	level waittill( "between_round_over" );	
	wait( 1 );
	level waittill( "between_round_over" );
	
	level notify( "respawn_now" );
}
wait_for_immediate()
{
	level endon( "respawn_now" );
	level waittill( "respawn_boss_immediate" );
	
	level notify( "respawn_now" );
}
boss_thundergun_disintegrate( player )
{
	self endon( "death" );
	self DoDamage( level.boss_thundergun_damage, player.origin, player );
	if ( self.health > 0 )
	{
		self boss_zombie_shockwave_attack();
	}
}
boss_fire_damage( trap )
{
	self endon( "death" );
	
	self DoDamage( level.boss_fire_damage, self.origin );			
	while ( 1 )
	{
		wait( 0.25 );
		if ( self IsTouching( trap ) )
		{
			self DoDamage( level.boss_fire_damage, self.origin, trap );			
		}
		else
		{
			if ( self.health > 0 )
			{
				self.marked_for_death = undefined;
			}
			break;
		}
	}
}
boss_trap_reaction( trap )
{
	self endon( "death" );
	trap notify( "trap_done" );
}
boss_custom_damage( player )
{
	self endon( "death" );
	if ( isDefined( self.ground_hit ) && self.ground_hit )
	{
		return level.boss_zombie_groundhit_damage;
	}
	return self.meleeDamage;
}
boss_actor_damage( weapon, damage, attacker )
{
	self endon( "death" );
	switch( weapon )
	{
	case "spas_zm":
	case "spas_upgraded_zm":
	case "ithaca_zm":
	case "ithaca_upgraded_zm":
		damage *= 0.5;
		break;
	}
	if ( level.zombie_vars["zombie_insta_kill"] )
	{
		damage *= 2;
	}
	return damage;
}
boss_nuke_damage()
{
	self endon( "death" );
	if ( self.is_activated )
	{
		damage = self.maxhealth * 0.5;
		self DoDamage( damage, self.origin );			
	}
	if ( self.health > 0 )
	{
		self boss_zombie_shockwave_attack();
	}
}
boss_zombie_default_enter_level()
{
	Playfx( level._effect["boss_spawn"], self.origin );
	playsoundatposition( "zmb_bolt", self.origin );
	PlayRumbleOnPosition("explosion_generic", self.origin);
	self.entered_level = true;
}
*/

//Renn Script
#using_animtree( "generic_human" );
zmb_engineer( target )
{

  if( !isDefined( target ) ) // then ill guess it just be a piece of shit normal zombie
  {
    return;
  }

  if( !is_true(self.zombie_init_done) ) {
	//self waittill( "zombie_init_done");
  }
	

  //self thread zm_variant_on_death( "engineer" );

  self detachAll();
  self.no_gib = 1;
  self setmodel( "char_ger_zombeng_body1_1" );

  self.animname = "boss_zombie";
  self.moveplaybackrate = 0;
  self.talking = true;
  self hide();
  self.ignore_all_poi = true;
  self.ignoreall = true;
  self.meleeDamage = 130;
  self.flame_damage_time = 0;
  self.is_on_fire = true;
  self.a.disablePain = true;
  self disable_react();
  self.allowpain = false;
  self.no_damage_points = true;
  self.zombie_can_sidestep = false;
  self.noChangeDuringMelee = true;
  self.script_string = undefined;
  self thread magic_bullet_shield();
  self dontinterpolate();
  self.script_disable_bleeder = 1;
  self.script_noteworthy = "find_flesh";
  self.script_moveoverride = true;
  self.first_node.script_noteworthy = "no_blocker";

  self.custom_idle_setup = ::boss_zombie_idle_setup;

  self.set_animarray_standing_override = ::boss_zombie_idle_setup;

  self.a.idleAnimOverrideArray = [];
  self.a.idleAnimOverrideArray["stand"] = [];
  self.a.idleAnimOverrideArray["stand"] = [];
  self.a.idleAnimOverrideArray["stand"][0][0] 	= %ai_zombie_boss_idle_a;
  self.a.idleAnimOverrideWeights["stand"][0][0] 	= 10;
  self.a.idleAnimOverrideArray["stand"][0][1] 	= %ai_zombie_boss_idle_a;
  self.a.idleAnimOverrideWeights["stand"][0][1] 	= 10;

  count = 0;

  while( count < 40 ) // double check to make sure its hiding and not going to be force to teleport to barriers
  {
    self notify( "teleporting" );
    self hide();
    self unlink();
    self.anchor delete();
    self.first_node = undefined;
    self ClearEnemy();
    self ClearGoalVolume();
    self.zombie_move_speed = "walk";
    self.zombie_can_sidestep = false;
    self.zombie_can_forwardstep = false;
    self.shouldSideStepFunc = ::no_reaction;

    count++;
    wait .06;
  }

  count = 0;
  //play boss spawn build up
  Playfx( level._effect["fx_zombie_boss_spawn_buildup"], target );
  Playfx( level._effect["fx_teleporter_pad_glow"], target );
  Playfx( level._effect["fx_transporter_start"], target );
  wait(0.9);
  //play boss spawn ground
  Playfx( level._effect["fx_zombie_boss_spawn_ground"], target );
  Playfx( level._effect["fx_zombie_boss_spawn"], target );

  //level._effect["poltergeist"]
  //Playfx( level._effect["poltergeist"], target );
  playsoundatposition( "zmb_hellhound_prespawn", target );
  playsoundatposition( "zmb_hellhound_bolt", target );
  //Playfx( level._effect["fx_lighting_strike"], target ); //didnt work
  wait(0.5);
  Earthquake( 0.5, 0.75, target, 1000 );
  PlayRumbleOnPosition( "explosion_generic", target );
  playsoundatposition( "zmb_hellhound_spawn", target );

  self ForceTeleport( target );
  //self ForceTeleport( get_players()[0].origin );

  self thread stop_magic_bullet_shield();
  self.health = 9500+level.zombie_health;
  if( self.health >= 12000 )
  {
	self.health = 12000;
  }

  self.health=100;
  //self.actor_full_damage_func = ::heavy_zombie_dmg_function;
  //self.custom_damage_func = ::eng_custom_damage;
  self show();
  self.moveplaybackrate = 1;
  self.needs_run_update = true;
  
  /*
  runAnim = "walk1";
  self.run_combatanim = level.scr_anim["boss_zombie"][runAnim];
  self set_run_anim( runAnim );
  self.marked_for_death = undefined;
  self.ignoreall = false;
  self.ignore_transition = false;
	self.disableArrivals = true;
	self.disableExits = true;
 */

  
  self maps\_zombiemode_spawner::set_zombie_run_cycle("walk");
  self ClearAnim( %exposed_modern, 0 );
  self SetFlaggedAnimKnobAllRestart( "run_anim", animscripts\zombie_run::GetRunAnim(), %body, 1, 0.2, self.moveplaybackrate );
  self.needs_run_update = false;
  self.script_moveoverride = false;
  self.ignoreall = false;
  level.engineer_zms_alive++;

  self eng_determine_poi();
  self eng_attack_properties();
  //self thread animscripts\zombie_combat::main();

  /*
  self notify( "stop_find_flesh" );
  self notify( "zombie_acquire_enemy" );
  self notify( "goal" );

  while( count < 20 )
  {
    self thread maps\_zombiemode_spawner::find_flesh();
	self.following_player = true;
    self thread maps\_zombiemode_spawner::zombie_setup_attack_properties();
    //self thread maps\_zombiemode_spawner::reset_attack_spot();
    count++;

    wait .1;
  }
  */

  self thread watch_eng_goals();

}

eng_determine_poi()
{
	//speed, jug, cherry
	self.eng_perk_poi = [];

	self.eng_trap_activate_poi = array(
		//(-825, -943, 130)			//2
		//,(933, 1646, 36)			//1
		//,(-1626, 1241, 220)		//4 electric upstairs (-1691, 1627, 220) alt upstairs
	);

	self.eng_trap_death_poi = array( 
		(-962,-619,75)		//fire trap stamina
		,(997,1535,-13)		//electric trap stage
		,(-1567,1341,174)		//electric upstairs
	);

	traps = GetEntArray( "zombie_trap", "targetname" );
	//iprintln( "print traps " + traps.size );
	//maps\_zombiemode_traps::print_traps( traps );

	allTraps = get_trap_objects( traps );
	valid_eng_trap_indices = array( 2, 1, 5 );
	//iprintln("All traps size" + allTraps.size );
	self.eng_trap_activate_poi = [];
	    self.eng_trap_activate_poi[0]  = allTraps[2]; //fire trap stamina
		self.eng_trap_activate_poi[1]  = allTraps[1]; //electric trap stage
		self.eng_trap_activate_poi[2]  = allTraps[5]; //electric upstairs

	
	allPerks = GetEntArray("zombie_vending", "targetname");
	for( i = 0; i < allPerks.size; i++ ) {
		//iprintln( "print perk " + allPerks[i].script_noteworthy + " | " + allPerks[i].origin );
	}
	
	self.eng_perk_poi = [];

			jug = SpawnStruct();
			jug.index = 0;
			jug.origin = (-323, -480, 22);
			jug.modelIndex = 0;
			jug.powerupColor = level._effect["powerup_on_red"];
			jug.script_noteworthy = level.JUG_PRK;
		self.eng_perk_poi[0] = jug;

			speed = SpawnStruct();
			speed.index = 1;
			speed.origin = (1281, 168, -6);
			speed.script_noteworthy = level.SPD_PRK;
			speed.powerupColor = level._effect["powerup_on"];
			speed.modelIndex = 2;
		self.eng_perk_poi[1] = speed;

			cherry = SpawnStruct();
			cherry.index = 2;
			cherry.origin = (-1215, 1168, 180);
			cherry.script_noteworthy = level.ECH_PRK;
			cherry.powerupColor = level._effect["powerup_on_solo"];
			cherry.modelIndex = 8;
		self.eng_perk_poi[2] = cherry;
		
	//iprintln( "print perks " + allPerks.size );

}

	get_trap_objects( arr )
	{
		mapObjects = [];
		k = 0;
		for( i = 0; i < arr.size; i++ )
		{
			if( isDefined( arr[i].target ) )
			{
				components = GetEntArray( arr[i].target, "targetname" );
				for( j = 0; j < components.size; j++ )
				{
					if( components[j].classname == "trigger_use" )
					{
						mapObjects[k] = components[j];
						k++;
					}
				}
			}
		}

		return mapObjects;
	}



eng_attack_properties() 
{

	//basic properties
	self.trap_damage = 5000;
	self.enraged_time = undefined; 		//tracks when engineer was enraged
	self.time_to_live = 15; //60				//number of seconds before engineer dies
	self.enraged_time_to_live = 8;	//120	//number of seconds before enraged engineer dies
	self.damaged_by_trap = undefined; 	//tracks which traps damaged engineer

	self.eng_near_perk_threshold = 200; //distance from perk to trigger enrage
	self.eng_near_trap_threshold = 100; //distance from trap to trigger it
	self.player_lookat_threshold = 10.5; //number of seconds player can look at engineer before enraging him


	self maps\_zombiemode_spawner::zombie_setup_attack_properties();
	self.run_combatanim = level.scr_anim["boss_zombie"]["sprint1"];
	self PushPlayer( false );
	self.animplaybackrate = 1;
	self.pathEnemyFightDist = 80;
	self.meleeAttackDist = 80;

	self.script_noteworthy = "find_flesh";
	self.script_moveoverride = false; //spawners will go before fighting
	//self.deathAnim = %ai_zombie_boss_death_a;

	self.activated = false; //variable tracks when he's enraged
	self.performing_activation = false; //variable tracks when he's performing activation
	self.ground_hit = false; //variable tracks when he's performing ground hit
	//self.marked_for_death = true; //makes eng immune to traps, also makes him not attack
	self.eng_perks = array( "", "", "", "" );

}

/**

	Threaded method loops and occaisionally sets new goal for engineer zombie

**/
watch_eng_goals()
{
	i = 0;
	level.valid_eng_states = array( "trap", "perk", "attack", "enrage", "death" );

	self.state = "trap";
	//self.state = "enrage";
	//self.state = "attack";
	//self.state = "perk";
	//self.perkTargetIndex = randomInt(3);
	self.perkTargetIndex = 0;
	iprintln(" Targeting perk: " + self.eng_perk_poi[self.perkTargetIndex].script_noteworthy );	

	while( IsAlive(self) )
	{
		//self maps\_zombiemode_spawner::set_zombie_run_cycle("walk");
		iprintln( "Enge choose new goal: " + self.state );
		self notify( "choose_new_goal" );

		//1. Target POI
		if( self.state == "trap") 
		{
			//iprintln("0");
			self thread eng_watch_trigger_enrage(true, true);
			self eng_target_poi();

		} else if( self.state == "perk" ) {
			//iprintln("1");
			if(!self.activated)
				self thread eng_watch_trigger_enrage(true, false);
			self eng_target_poi();

		} else if( self.state == "attack" ) {
			//iprintln("2");
			self eng_execute_attack();

		} else if( self.state == "enrage" ) {
			//iprintln("3");
			self eng_execute_enrage();

		} else if( self.state == "teleport" ) {
			iprintln("4");
			self eng_tp_death();
			break;
		}

	
		wait(0.05);
	}

	if(isDefined( self.powerup_fx ) )
		self.powerup_fx delete();
	

}

checkDist(a, b, distance ) {
	return maps\_zombiemode::checkDist( a, b, distance );
}

/*
	Eng is enraged on 3 different events
	1. Player looks at engineer too long
	2. Player damages engineer
	3. Engineer spontaneously drinks perk

*/
eng_watch_trigger_enrage(trackEyes, trackPerk)
{
	self endon("death");
	self endon("choose_new_goal");
	//trackEyes = false;

	players = get_players();
	for (i = 0; i < players.size; i++) {
		if(trackEyes)
			players[i] thread eng_track_player_eyes( self );
	}

	if(trackPerk)
		self thread eng_track_near_perk();

	self waittill("activated");
	self.state = "enrage";
}

	//self is player
	eng_track_player_eyes( eng ) 
	{	
		self endon("death");
		self endon("disconnect");
		eng endon("choose_new_goal");
		eng endon("death");

		face_dot = 0.9;
		while(!eng.activated) 
		{
			eng_face = eng.origin + (0,0,40);
			self waittill_player_looking_at( eng_face, face_dot, true);
			iprintln("Player is looking at eng");
			count = 0;
			threshold = 10*eng.player_lookat_threshold;

			while( is_player_looking_at( eng_face, face_dot, true ) ) 
			{
				wait(0.1);
				if( count > threshold )
					break;

				eng_face = eng.origin + (0,0,40);
				count++;
			}
			iprintln("Player stopped looking at eng " + count);
			iprintln("Player stopped looking at eng thresh " + threshold);
			iprintln("decision" + (count >= threshold) );

			if( count >= threshold ) {
				eng.favoriteenemy = self;
				eng notify( "activated" );
				break;
			}

			wait(0.05);
				
		}

		iprintln("Player stopped tracking eng");
	}
	
	//self is eng
	eng_track_near_perk()
	{
		self endon("death");
		self endon("activated");
		self endon("choose_new_goal");

		iprintln("watching near perk");
		while(IsAlive(self)) 
		{
			chosen_perk = self.eng_perk_poi[ self.perkTargetIndex ];
			if( checkDist( self.origin, chosen_perk.origin, self.eng_near_perk_threshold ) ) {
				self notify( "perk" );
				break;
			}
			wait(0.05);
		}
	}



eng_target_poi() 
{

	poi = (0, 0, 0);
	randIndex = 1;

	poi.randIndex = randIndex;
	if(self.state == "trap") {
		poi = self.eng_trap_activate_poi[ randIndex ];
		poi.death_pos = self.eng_trap_death_poi[ randIndex ];
	} else if(self.state == "perk") {
		poi = self.eng_perk_poi[ self.perkTargetIndex ];
		poi.randIndex = self.perkTargetIndex;
	}

	//Get ready to seek goal
	self notify( "stop_find_flesh" );
	self.poi = undefined;
	self.favoriteenemy = undefined;
	self.ignoreall = true;
	self.ignore_transition=true;
	//self notify( "zombie_acquire_enemy" );
	
	//write a for loop to count to 10
	iprintln( "Set goal " );
	iprintln( poi.origin );
	self.goalradius = 60;
	self SetGoalPos( poi.origin );


	//wait
	notif = self waittill_any_return( "goal", "goal_interrupted", "activated",
	 "zombie_start_traverse",  "zombie_end_traverse", "perk" );
	iprintln( "goal reached " + notif ); 

	if( notif == "activated" ) {
		//someone pissed off eng
		self.state = "enrage";
	}
	if( notif == "perk" ) {
		//eng got close to a perk, lets follow that now
		self.state = "perk";
		return;
	}
	else if( notif == "goal_interrupted" ) {
		//goal interrupted, reset
		iprintln( "Goal interrupted, resetting state" );
	}
	else if( notif == "goal" )
	{
		//Goal Reached
		self.immunity = true;
		if(self.state == "trap") {
			self eng_execute_trap( poi );
			self.immunity = false;
		} else if(self.state == "perk") {
			self eng_execute_perk( poi );
		} else {
			//nothing
		}

	} else {
		//Goal Failed
		iprintln( "Goal undefined or unmatched" );
	}
	
	iprintln( "Engineer Zombie: Goal reached, state: " + self.state );

}

eng_execute_trap( poi ) 
{

	//1. Do attack anim
	attackAnim = level._zombie_melee["boss_zombie"][0];
	self animscripted( "overhead_attack", self.origin, self.angles, attackAnim );

	//2. wait for anim to finish
	animscripts\traverse\zombie_shared::wait_anim_length( attackAnim, .02 );

	//3. trigger tap, wait to turn on
	poi notify( "trigger" );

	if(poi.randIndex == 0) {
		self thread boss_fire_death_fx( poi );
	} else {
		self thread boss_shock_death_fx( poi );
	}

	//4. Walk over to Trap
	//iprintln( "Set goal 2" + poi.death_pos );
	self.goalradius = 8;
	self SetGoalPos( poi.death_pos );
	notif = self waittill_any_return( "goal", "goal_interrupted", "activated" );
	//iprintln( "goal 2 reached " + notif );

	if( notif == "activated" ) {
		self.state = "enrage";
		return;
	}
	else if( notif == "goal_interrupted" ) {
		//goal interrupted, reset
		iprintln( "Engineer Zombie: Goal interrupted, resetting state" );
	}

	self.immunity = true;

	deathAnim = undefined;
	if( poi.randIndex == 0 ) 
	{  //fire death
		self.deathAnim = %ai_zombie_boss_death_a;

		enrageAnim = %ai_zombie_boss_enrage_start_scream_coast;
		self animscripted( "enraged", self.origin, self.angles, enrageAnim );
		animscripts\traverse\zombie_shared::wait_anim_length( enrageAnim, 0.02 );
		wait( 0.2 );

		//swing attack
		attackAnim = %ai_zombie_boss_attack_swing_swipe;
		self animscripted( "swing_attack", self.origin, self.angles, attackAnim );
		animscripts\traverse\zombie_shared::wait_anim_length( attackAnim, 0.02 );

	} else {	//tesla death

		self.deathAnim = %ai_zombie_boss_tesla_death_a_coast;
	}

	iprintln( "Engineer Zombie: Death" );
	//self animscripted( "eng_death", self.origin, self.angles, deathAnim );
	//animscripts\traverse\zombie_shared::wait_anim_length( deathAnim, .02 );

	self dodamage(self.health + 666, self.origin, undefined);

}

	boss_close_to_fx_point( point, dist ) 
	{
		self endon("death" );
		self endon("delete" );
		level endon( "end_game" );

		count = 0;
		while(count < 800) 
		{
			if( checkDist( self.origin, point, dist ) ) {
				return true;
			}

			wait(0.1);
			count++;
		}
		return false;
	}

	boss_fire_death_fx( poi ) 
	{
		closeEnough = self boss_close_to_fx_point( poi.death_pos, 128 );
		if( !closeEnough ) {
			return;
		}

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" );
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
		self playsound("evt_zombie_ignite");

		wait(2);
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" );
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
		self playsound("evt_zombie_ignite");
	}

	boss_shock_death_fx( poi ) {

		closeEnough = self boss_close_to_fx_point( poi.death_pos, 8 );
		if( !closeEnough ) {
			return;
		}


		self maps\_zombiemode_perks::electric_cherry_shock_fx();

		wait(2);
		self maps\_zombiemode_perks::electric_cherry_shock_fx();

	}


/*
	Drinking a perk enrages and strengthens the engineer zombie

*/
eng_execute_perk( poi  ) 
{
	self.immunity = true;
	//self thread magic_bullet_shield();
  
	//1. Do attack anim
	bumpAnim = %ai_zombie_boss_headbutt;
	self animscripted( "perk_bump", self.origin, self.angles, bumpAnim );
	animscripts\traverse\zombie_shared::wait_anim_length( bumpAnim, .02 );
	PlaySoundAtPosition( "fly_bump_bottle", self.origin );
	wait(0.2);
	playsoundatposition("evt_bottle_dispense", self.origin);

	//2. Drink the perk
	//self GiveWeapon( "zombie_perk_bottle", poi.modelIndex );
	//self SwitchToWeapon( "zombie_perk_bottle" );
	drinkAnim = %p_zombie_perkacola_drink;
	self animscripted( "perk_drink", self.origin, self.angles, drinkAnim );
	//self TakeWeapon ( "zombie_perk_bottle" );

	wait(0.5);
	
	//3. Start fx on zombie
		if(isDefined( self.powerup_fx ) )
			self.powerup_fx delete();
		self.powerup_fx = Spawn( "script_model", self GetTagOrigin( "j_SpineUpper" ) );
		self.powerup_fx LinkTo( self, "j_SpineUpper" );
		self.powerup_fx SetModel( "tag_origin" );

	PlayFxOnTag( poi.powerupColor, self.powerup_fx, "tag_origin" );
	self.eng_perks[poi.index] = poi.script_noteworthy;

	//4. Set state to enrage and return
	self.state = "enrage";
	
}

	threadAnim( name, sampleAnim ) {
		self endon( "death" );
		self animscripted( name, self.origin, self.angles, sampleAnim );
		animscripts\traverse\zombie_shared::wait_anim_length( sampleAnim, 0.02 );
	}

/**


*/
eng_execute_enrage() 
{
	self endon( "death" );
	
	self.performing_activation = true;
	self notify( "stop_find_flesh" );

	//self thread magic_bullet_shield();
	self.activated = true;
	self.maxHealth = self eng_calculate_enraged_health();
	self.health = self.maxHealth;
	//self.deathAnim = %ai_zombie_boss_death_a;

	
	//if( self.zombie_move_speed != "sprint") 
	{
		self.moveplaybackrate = 1.10;
		if( is_in_array( self.eng_perks, level.SPD_PRK ) )
			self.moveplaybackrate = 1.25;

		iprintln( "Engineer Zombie: Setting run cycle to sprint " + self.zombie_move_speed );
		runAnim = "sprint1";
		if( randomInt(2) > 0 )
			runAnim = "sprint3";
		self.zombie_move_speed = "sprint";
  		self set_run_anim( runAnim );
		self.run_combatanim = level.scr_anim["boss_zombie"][runAnim];
		self.needs_run_update = true;
	}
		

	//Play enrage anim
	screamAnim = %ai_zombie_boss_enrage_start_scream_coast;
	//self animscripted( name, self.origin, self.angles, screamAnim );
	self threadAnim( "scream", screamAnim );
	self.performing_activation = false;

	if( isDefined(self.favoriteenemy) ) 
	{
		self thread magic_bullet_shield();
		iprintln( "Engineer Zombie: Teleporting to favorite enemy" );
		iprintln( "self.favoriteenemy "  + self.favoriteenemy.origin );
		count = 0;
		//while( count < 40 ) // double check to make sure its hiding and not going to be force to teleport to barriers
  		{
			self.ignore_all_poi = true;
			self.using_teleport = true;
			self notify( "stop_find_flesh" );
			self notify( "teleporting" );
			self hide();
			self unlink();
			self.anchor delete();
			self.first_node = undefined;
			self ClearEnemy();
			self ClearGoalVolume();
			/*
			self.zombie_move_speed = "walk";
			self.zombie_can_sidestep = false;
			self.zombie_can_forwardstep = false;
			self.shouldSideStepFunc = ::no_reaction;

			wait(0.05);
			count++;
			*/
		}

		self ForceTeleport( self.favoriteenemy.origin );
		self.ignore_all_poi = false;
		self.using_teleport = false;

	}
	else {
		self.favoriteenemy = get_players()[randomInt(get_players().size)];
	}

	//3. Start enrage anim while hidden
	self thread eng_groundslam();
	wait(0.5);
	self show();

	//self.enemyoverride = self.favoriteenemy;
	self.enraged_time = GetTime();
	self.performing_activation = false;
	self.state = "attack";

}

/**
	Function of round, times died, and perks
*/
	eng_calculate_enraged_health()
	{
		if(!isDefined( level.eng_times_died ) )
			level.eng_times_died = 0;

		//Should be like killing 16 zombies
		zombsScale = 16;
		zombieHealth = level.zombie_health;

		baseHealth = zombieHealth * (zombsScale + level.eng_times_died);
		if( is_in_array( self.eng_perks, level.JUG_PRK ) ) {
			return baseHealth * 2;
		}
		if( is_in_array( self.eng_perks, level.SPD_PRK ) ) {
			return baseHealth * 1.25;
		}
		if( is_in_array( self.eng_perks, level.ECH_PRK ) ) {
			return baseHealth * 1.25;
		}

		return baseHealth;

	}




/**
	1. Engineer chases players relentlessly for 60s or 120s if he has a perk
	2. Attacks player
	3. May stop by perk machine if he doesn't already have one
	4. may activate trap if he runs by it

*/
eng_execute_attack() 
{
	self.activated = true;
	self endon( "death" );	

	//start_find_flesh
	self.ignoreall = false;
	//self.ignore_all_poi = false;	engineer just walks whereever
	self.ignore_transition = false;
	self.disableArrivals = true;
	self.disableExits = true;
	self.goalradius = self.pathEnemyFightDist+10;
	faveEnemy = self.favoriteenemy;
	self SetGoalPos( undefined );
	self ClearGoalVolume();
	self ClearEnemy();
	self.favoriteenemy = faveEnemy;
	
  	self notify( "stop_find_flesh" );
  	self notify( "zombie_acquire_enemy" );
  	self notify( "goal" );
	self notify( "zombie_start_traverse" );
	self notify( "zombie_end_traverse" );


	count = 0;
	while( count < 20 )
	{
		self thread maps\_zombiemode_spawner::find_flesh();
		self.following_player = true;
		//self thread maps\_zombiemode_spawner::reset_attack_spot();
		count++;
		wait .1;
	}

	self thread eng_watch_near_trap();
	self thread eng_watch_near_perk();
	self thread eng_watch_time_alive();

	notif = self waittill_any_return( "stop_find_flesh", "perk", "teleport" );
	if( notif == "perk" ) {
		self.state = "perk";
		iprintln( "Engineer Zombie: Going to perk" );
	} else if( notif == "teleport" ) {
		self.state = "teleport";
		iprintln( "Engineer Zombie: Going to tp death" );
	}

	iprintln( "Stopping attack, notif: " + notif );
	self notify( "stop_eng_watcher" );
	//iprintln( "goal radius: " + self.goalradius );
	//iprintln( "goal: " + self.goal.origin );
	//iprintln( "fave enemy: " + self.favoriteenemy GetEntityNumber() );
	//iprintln( "attacking_spot: " + self.attacking_spot );
	//iprintln( "zombie_move_speed: " + self.zombie_move_speed );



}


	//1. Watch if perk is nearby, maybe grab a drink
	eng_watch_near_perk() 
	{
		self endon( "death" );
		self endon( "stop_eng_watcher" );

		iprintln( "watch near perk" );
		perk = self.eng_perk_poi[ self.perkTargetIndex ];
		while(1) 
		{
			if( !IsDefined( perk ) || !isDefined( perk.origin ) )
				break;

			if( checkDist( self.origin, perk.origin, self.eng_near_perk_threshold ) ) {
				iprintln( "Engineer Zombie: Close to perk, attempting to drink" );
				self notify( "perk" );
				break;
			}
			wait(0.05);
		}
	}

	eng_watch_near_trap() 
	{
		self endon( "death" );
		self endon( "stop_eng_watcher" );

		allTraps = get_trap_objects( GetEntArray( "zombie_trap", "targetname" ) );
		trap = undefined;
		i = 0;
		iprintln( "watch near trap" );
		blackListedTrap = undefined;
		while( IsAlive(self) ) 
		{
			wait(0.05);
			for(i = 0; i < allTraps.size; i++ ) 
			{
				if( !IsDefined( allTraps[i] ) || !isDefined( allTraps[i].origin ) )
					continue;
				trap = allTraps[i];
			
				if( checkDist( self.origin, trap.origin, self.eng_near_trap_threshold ) ) 
				{
					if( isdefined(blackListedTrap) && trap.targetname == blackListedTrap )
						continue;

					if( is_true(trap._trap_in_use) )
						continue;

					if( randomInt(100) < 10 ) 
					{
						wait(0.05);
						self eng_groundslam();
						trap notify( "trigger" );
						break;
					}
					else {
						blackListedTrap = trap.targetname;
						continue;
					}
				}
			}

		}

		if( isDefined( trap ) && isDefined( trap.targetname ) )
		{
			if(trap.targetname == "crematorium_room_trap" ) //crema fire trap
			{
				self.death_pos = self.eng_trap_death_poi[0];
				self boss_fire_death_fx(self);
			} else {
				self.death_pos = self.origin;
				self boss_shock_death_fx(self);
			}
		}

		//self notify( "stop_find_flesh" );
	}

	eng_watch_time_alive() 
	{
		self endon( "death" );
		self endon( "stop_eng_watcher" );
		self endon( "choose_new_goal" );

		while( IsAlive(self) ) 
		{
			wait(1);
			if( !isDefined( self.enraged_time ) )
				continue;

			//iprintln( "Get Time: " + GetTime() );
			//iprintln( "Enraged Time: " + self.enraged_time );
			//iprintln( "diff: " + (GetTime() - self.enraged_time) );
			if( (GetTime() - self.enraged_time) >= (self.enraged_time_to_live * 1000) ) 
			{
				iprintln( "Time to live expired, going to death state" );
				self notify( "teleport" );
				break;
			}
		}
	}

	//maps\_zombiemode_ai_director::player_electrify() for eCherry hits

	eng_groundslam() 
	{	
		self.ground_hit = true;
		enrageAnim = %ai_zombie_boss_enrage_start_slamground_coast;
		self thread threadAnim( "enraged", enrageAnim );
		wait(1.0);
		//electric groundslam fx (magnitude, time, origin, radius)
		Earthquake( 1.5, 1.5, self.origin, 1000 );
		PlayRumbleOnPosition( "explosion_generic", self.origin );
		fxTarget = self.origin - (0,0,10);
		Playfx( level._effect["fx_zombie_boss_grnd_hit"], fxTarget );
		wait(0.3);
		//here
		Playfx( level._effect["fx_transporter_start"], self.origin );
		/*
		Playfx( level._effect["fx_teleporter_pad_glow"], target );

  		//play boss spawn ground
  		Playfx( level._effect["fx_zombie_boss_spawn_ground"], target );
  		Playfx( level._effect["fx_zombie_boss_spawn"], target );
		*/


		//for players in area, shellshock their screen
		players = get_players();
		for( i = 0; i < players.size; i++ ) {
			if( checkDist( players[i].origin, self.origin, 300 ) ) {
				players[i] thread shellShockPlayer();
			}
		}

		wait(0.5);
		//screenShake
		//Earthquake( 0.5, 0.75, self.origin, 1000 );
		//PlayRumbleOnPosition( "explosion_generic", self.origin );

		self.ground_hit = false;
		self notify( "groundslam_done" );
	}

		shellShockPlayer() 
		{
			self shellshock( "explosion", 1.1 );
			self SetMoveSpeedScale( 0.1 );
			wait(.75);
			self SetMoveSpeedScale( 0.6 );
			wait(.25);
			if(!IsDefined(self.move_speed))
				self.move_speed = 1;

			self SetMoveSpeedScale( self.move_speed );
		}

/*
	Eng teleports away just before he dies
*/
eng_tp_death() {

	//1. thread scream anim, no groudhit
	self notify( "stop_find_flesh" );
	self.ignoreall = true;  	
	self.ignore_all_poi = true;
	self ClearEnemy();
    self ClearGoalVolume();


	//1.5 get him walkinging then stop
	runAnim = "walk1";
	self.needs_run_update = true;
	self.zombie_move_speed = "walk";
	self set_run_anim( runAnim );
	self.run_combatanim = level.scr_anim["boss_zombie"][runAnim];
	self.needs_run_update = false;
  	wait(1);

	screamAnim = %ai_zombie_boss_enrage_start_scream_coast;
	//self animscripted( name, self.origin, self.angles, screamAnim );
	self thread threadAnim( "death", screamAnim );
	//playsoundatposition( "zmb_hellhound_spawn", self.origin );
	wait(0.5);
	//playsoundatposition( "zmb_hellhound_spawn", self.origin );
	//wait(0.5);


	//2. poltergeist fx
	//play 8 fx in a circle around the engineer at radius 10
	/*
	r=50;
	a=8;
	for( i = 0; i < a; i++ ) {
		angle = (i * (180/a)) * (3.14159 / 180); //convert to radians
		offset = (r * cos(angle), r * sin(angle), 0);
		fx_pos = self.origin + offset;
		//Playfx( level._effect["poltergeist"], fx_pos );
		//wait(0.05);
	}
	*/
	wait(0.2);
	//Playfx( level._effect["poltergeist"], self.origin );
	Playfx( level._effect["fx_zombie_mainframe_flat_start"], self.origin );
	Playfx( level._effect["fx_teleporter_pad_glow"], self.origin );
	Playfx( level._effect["fx_transporter_start"], self.origin );
	Playfx( level._effect["fx_zombie_mainframe_beam"], self.origin );
	Playfx( level._effect["fx_zombie_mainframe_flat"], self.origin );
	
	
	
	Earthquake( 0.5, 0.75, self.origin, 1000 );
	PlayRumbleOnPosition( "explosion_generic", self.origin );
	playsoundatposition( "zmb_hellhound_spawn", self.origin );
	playsoundatposition( "zmb_hellhound_bolt", self.origin );
	wait(0.5);

	//3. hide model, kill, delete
	death_pos = self.origin;
	powerup = self.powerup;
	if( isDefined(self.powerup_fx) ) {
		self.powerup_fx delete();
	}
	self hide();
	self dodamage(self.health + 666, self.origin, undefined);
	self delete();

	//4. drop powerup
	if(IsDefined(powerup)) {
		maps\_zombiemode_powerups::specific_powerup_drop(powerup, death_pos);
	}

}

/*
eng_custom_damage( player )
{
  if( !isDefined( player.stunned_by_eng ) )
  {
    player thread eng_player_stunned( 1 );
  }
  return self.meleeDamage;
}

eng_player_stunned( stunned_time )
{
	self.stunned_by_eng = true;

	self shellshock( "death", stunned_time );

	wait stunned_time;

  	self stopShellShock();

	self.stunned_by_eng = undefined;
}

eng_enrage_think()
{
	self endon( "death" );
	
	amount_of_dmg_to_rage = 100; // default
	current_dmg = 0;
	
	if( level.round_number <= 15 )
	{
		amount_of_dmg_to_rage = 500;
	}
	else if( level.round_number > 15 )
	{
		amount_of_dmg_to_rage = 250;
	}
	
	while( current_dmg < amount_of_dmg_to_rage )
	{
		self waittill( "damage", amount );
		
		current_dmg += amount;
	}
	
	self animscripted( "enraged", self.origin, self.angles, level.scr_anim["boss_zombie"]["enrage"] );
	self.run_combatanim = level.scr_anim["boss_zombie"]["sprint"+randomintrange( 1, 3 )];
	self.zombie_move_speed = "sprint";
	self.moveplaybackrate = 1.25;
	
	wait 1;
	
	earthquake(0.7,2,self.origin,500);
}

heavy_zombie_dmg_function( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime )
{
	self endon( "death" );
	
	 if( meansofdeath == "MOD_MELEE" )
	{
		return damage*.15;
	}
	
	if( meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_EXPLOSIVE" || meansofdeath == "MOD_PROJECTILE" || meansofdeath == "MOD_PROJECTILE_SPLASH" )
	{
		return damage*.25;
	}
	
	if( ( sHitLoc == "head" || sHitLoc == "neck" ) && meansofdeath != "MOD_PISTOL_BULLET" )
	{
		return damage*3;
	}
	
	if( self.animname == "boss_zombie" )
	{
		damage *= .70;
	}
	else
	{
		damage *= .45;
	}
	

	return damage;
}

*/
no_reaction( player )
{
  // nothing
}

init_boss_zombie_fx()
{
	level._effect["fx_zombie_boss_footstep"] = loadfx( "fx_zombie_boss_footstep" );
	/*
	fx,misc/fx_zombie_powerup_on_red
	fx,fx_zombie_boss_footstep
	fx,fx_zombie_boss_grnd_hit
	fx,fx_zombie_boss_spawn
	fx,fx_zombie_boss_spawn_buildup
	fx,fx_zombie_boss_spawn_ground
	*/
	level._effect["fx_zombie_boss_grnd_hit"] = loadfx( "maps/zombie/fx_zombie_boss_grnd_hit" );
	level._effect["fx_zombie_boss_spawn"] = loadfx( "maps/zombie/fx_zombie_boss_spawn" );
	level._effect["fx_zombie_boss_spawn_buildup"] = loadfx( "maps/zombie/fx_zombie_boss_spawn_buildup" );
	level._effect["fx_zombie_boss_spawn_ground"] = loadfx( "maps/zombie/fx_zombie_boss_spawn_ground" );
}

boss_zombie_idle_setup()
{
	self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
	self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
	self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
	self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
	self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
	self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
	self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
	self.a.array["turn_right_180"] = %exposed_tracking_turn180L;
	self.a.array["exposed_idle"] = array( %ai_zombie_boss_idle_a, %ai_zombie_boss_idle_b );
	self.a.array["straight_level"] = %ai_zombie_boss_idle_a;
	self.a.array["stand_2_crouch"] = %ai_zombie_shot_leg_right_2_crawl;
}


init_boss_zombie_anims()
{
	level.scr_anim["boss_zombie"]["death1"] 	= %ai_zombie_boss_death;
	level.scr_anim["boss_zombie"]["death2"] 	= %ai_zombie_boss_death_a;
	level.scr_anim["boss_zombie"]["death3"] 	= %ai_zombie_boss_death_explode;
	level.scr_anim["boss_zombie"]["death4"] 	= %ai_zombie_boss_death_mg;
	
	
	level.scr_anim["boss_zombie"]["walk1"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk2"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk3"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk4"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk5"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk6"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk7"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk8"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk9"] 	= %ai_zombie_boss_walk_a;

	/*
	level.scr_anim["boss_zombie"]["run1"] 	= %ai_zombie_walk_fast_v1;
	level.scr_anim["boss_zombie"]["run2"] 	= %ai_zombie_walk_fast_v2;
	level.scr_anim["boss_zombie"]["run3"] 	= %ai_zombie_walk_fast_v3;
	level.scr_anim["boss_zombie"]["run4"] 	= %ai_zombie_run_v2;
	level.scr_anim["boss_zombie"]["run5"] 	= %ai_zombie_run_v4;
	level.scr_anim["boss_zombie"]["run6"] 	= %ai_zombie_run_v3;
	level.scr_anim["boss_zombie"]["sprint1"] = %ai_zombie_boss_sprint_a;
	level.scr_anim["boss_zombie"]["sprint2"] = %ai_zombie_boss_sprint_a;
	level.scr_anim["boss_zombie"]["sprint3"] = %ai_zombie_boss_sprint_b;
	level.scr_anim["boss_zombie"]["sprint4"] = %ai_zombie_boss_sprint_b;
	*/
	level.scr_anim["boss_zombie"]["run1"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run2"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run3"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run4"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run5"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run6"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run7"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run8"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["sprint1"] = %ai_zombie_boss_sprint_a;
	level.scr_anim["boss_zombie"]["sprint2"] = %ai_zombie_boss_sprint_a;
	level.scr_anim["boss_zombie"]["sprint3"] = %ai_zombie_boss_sprint_b;
	level.scr_anim["boss_zombie"]["sprint4"] = %ai_zombie_boss_sprint_b;
	level.scr_anim["boss_zombie"]["sprint5"] = %ai_zombie_boss_sprint_b;
	
	level.scr_anim["boss_zombie"]["crawl1"] 	= %ai_zombie_crawl;
	level.scr_anim["boss_zombie"]["crawl2"] 	= %ai_zombie_crawl_v1;
	level.scr_anim["boss_zombie"]["crawl3"] 	= %ai_zombie_crawl_v2;
	level.scr_anim["boss_zombie"]["crawl4"] 	= %ai_zombie_crawl_v3;
	level.scr_anim["boss_zombie"]["crawl5"] 	= %ai_zombie_crawl_v4;
	level.scr_anim["boss_zombie"]["crawl6"] 	= %ai_zombie_crawl_v5;
	level.scr_anim["boss_zombie"]["crawl_hand_1"] = %ai_zombie_walk_on_hands_a;
	level.scr_anim["boss_zombie"]["crawl_hand_2"] = %ai_zombie_walk_on_hands_b;
	level.scr_anim["boss_zombie"]["crawl_sprint1"] 	= %ai_zombie_crawl_sprint;
	level.scr_anim["boss_zombie"]["crawl_sprint2"] 	= %ai_zombie_crawl_sprint_1;
	level.scr_anim["boss_zombie"]["crawl_sprint3"] 	= %ai_zombie_crawl_sprint_2;
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
	level._zombie_melee["boss_zombie"] = [];
	level._zombie_walk_melee["boss_zombie"] = [];
	level._zombie_run_melee["boss_zombie"] = [];
	/*
	level._zombie_melee["boss_zombie"][0] 				= %ai_zombie_boss_attack_multiswing_a; 
	level._zombie_melee["boss_zombie"][1] 				= %ai_zombie_boss_attack_multiswing_b; 
	level._zombie_melee["boss_zombie"][2] 				= %ai_zombie_boss_attack_swing_overhead; 
	level._zombie_melee["boss_zombie"][3] 				= %ai_zombie_boss_attack_swing_swipe;	
	level._zombie_melee["boss_zombie"][4] 				= %ai_zombie_boss_headbutt;	
	*/
	level._zombie_melee["boss_zombie"][0] 				= %ai_zombie_boss_attack_swing_overhead; 
	level._zombie_melee["boss_zombie"][1] 				= %ai_zombie_boss_attack_swing_swipe;	
	level._zombie_melee["boss_zombie"][2] 				= %ai_zombie_boss_attack_swing_overhead;
	level._zombie_melee["boss_zombie"][3] 				= %ai_zombie_boss_attack_swing_swipe;	
	level._zombie_melee["boss_zombie"][4] 				= %ai_zombie_boss_attack_swing_swipe;	
	level._zombie_melee["boss_zombie"][5] 				= %ai_zombie_boss_attack_swing_swipe;

	level._zombie_walk_melee["boss_zombie"][0]				= %ai_zombie_boss_attack_swing_overhead;
	level._zombie_walk_melee["boss_zombie"][1]				= %ai_zombie_boss_attack_swing_swipe;
	level._zombie_walk_melee["boss_zombie"][2]				= %ai_zombie_boss_attack_swing_overhead;
	level._zombie_walk_melee["boss_zombie"][3]				= %ai_zombie_boss_attack_swing_swipe;
	
	if( isDefined( level.boss_zombie_anim_override ) )
	{
		[[ level.boss_zombie_anim_override ]]();
	}
	
	level._zombie_run_melee["boss_zombie"][0]				=	%ai_zombie_boss_attack_running;
	level._zombie_run_melee["boss_zombie"][1]				=	%ai_zombie_boss_attack_sprinting;
	level._zombie_run_melee["boss_zombie"][2]				=	%ai_zombie_boss_attack_running;
	level._zombie_run_melee["boss_zombie"][3]				=	%ai_zombie_boss_attack_running;
	level._zombie_run_melee["boss_zombie"][4]				=	%ai_zombie_boss_attack_running;
	level._zombie_run_melee["boss_zombie"][5]				=	%ai_zombie_boss_attack_running;

	level._zombie_sprint_melee["boss_zombie"][0]			=	%ai_zombie_boss_attack_sprinting;
	level._zombie_sprint_melee["boss_zombie"][1]			=	%ai_zombie_boss_attack_sprinting;
	level._zombie_sprint_melee["boss_zombie"][2]			=	%ai_zombie_boss_attack_sprinting;
	level._zombie_sprint_melee["boss_zombie"][3]			=	%ai_zombie_boss_attack_sprinting;
	level._zombie_sprint_melee["boss_zombie"][4]			=	%ai_zombie_boss_attack_sprinting;
	level._zombie_sprint_melee["boss_zombie"][5]			=	%ai_zombie_boss_attack_sprinting;



	
	if( !isDefined( level._zombie_melee_crawl ) )
	{
		level._zombie_melee_crawl = [];
	}
	level._zombie_melee_crawl["boss_zombie"] = [];
	level._zombie_melee_crawl["boss_zombie"][0] 		= %ai_zombie_attack_crawl; 
	level._zombie_melee_crawl["boss_zombie"][1] 		= %ai_zombie_attack_crawl_lunge;
	if( !isDefined( level._zombie_stumpy_melee ) )
	{
		level._zombie_stumpy_melee = [];
	}
	level._zombie_stumpy_melee["boss_zombie"] = [];
	level._boss_zombie_stumpy_melee["boss_zombie"][0] = %ai_zombie_walk_on_hands_shot_a;
	level._boss_zombie_stumpy_melee["boss_zombie"][1] = %ai_zombie_walk_on_hands_shot_b;
	
	if( !isDefined( level._zombie_tesla_deaths ) )
	{
		level._zombie_tesla_deaths = [];
	}
	level._zombie_tesla_death["boss_zombie"] = [];
	level._zombie_tesla_death["boss_zombie"][0] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][1] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][2] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][3] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][4] = %ai_zombie_boss_tesla_death_a;
	if( !isDefined( level._zombie_tesla_crawl_death ) )
	{
		level._zombie_tesla_crawl_death = [];
	}
	level._zombie_tesla_crawl_death["boss_zombie"] = [];
	level._zombie_tesla_crawl_death["boss_zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_tesla_crawl_death["boss_zombie"][1] = %ai_zombie_tesla_crawl_death_b;
	
	if( !isDefined( level._zombie_deaths ) )
	{
		level._zombie_deaths = [];
	}
	level._zombie_deaths["boss_zombie"] = [];
	level._zombie_deaths["boss_zombie"][0] = %ai_zombie_boss_death;
	level._zombie_deaths["boss_zombie"][1] = %ai_zombie_boss_death_a;
	level._zombie_deaths["boss_zombie"][2] = %ai_zombie_boss_death_explode;
	level._zombie_deaths["boss_zombie"][3] = %ai_zombie_boss_death_mg;
	
	
	if( !isDefined( level._zombie_rise_anims ) )
	{
		level._zombie_rise_anims = [];
	}
	level._zombie_rise_anims["boss_zombie"] = [];
	level._zombie_rise_anims["boss_zombie"][1]["walk"][0]		= %ai_zombie_traverse_ground_v1_walk;
	level._zombie_rise_anims["boss_zombie"][1]["run"][0]		= %ai_zombie_traverse_ground_v1_run;
	level._zombie_rise_anims["boss_zombie"][1]["sprint"][0]	= %ai_zombie_traverse_ground_climbout_fast;
	level._zombie_rise_anims["boss_zombie"][2]["walk"][0]		= %ai_zombie_traverse_ground_v2_walk_altA;
	
	if( !isDefined( level._zombie_rise_death_anims ) )
	{
		level._zombie_rise_death_anims = [];
	}
	level._zombie_rise_death_anims["boss_zombie"] = [];
	level._zombie_rise_death_anims["boss_zombie"][1]["in"][0]		= %ai_zombie_traverse_ground_v1_deathinside;
	level._zombie_rise_death_anims["boss_zombie"][1]["in"][1]		= %ai_zombie_traverse_ground_v1_deathinside_alt;
	level._zombie_rise_death_anims["boss_zombie"][1]["out"][0]		= %ai_zombie_traverse_ground_v1_deathoutside;
	level._zombie_rise_death_anims["boss_zombie"][1]["out"][1]		= %ai_zombie_traverse_ground_v1_deathoutside_alt;
	level._zombie_rise_death_anims["boss_zombie"][2]["in"][0]		= %ai_zombie_traverse_ground_v2_death_low;
	level._zombie_rise_death_anims["boss_zombie"][2]["in"][1]		= %ai_zombie_traverse_ground_v2_death_low_alt;
	level._zombie_rise_death_anims["boss_zombie"][2]["out"][0]		= %ai_zombie_traverse_ground_v2_death_high;
	level._zombie_rise_death_anims["boss_zombie"][2]["out"][1]		= %ai_zombie_traverse_ground_v2_death_high_alt;
	
	
	if( !isDefined( level._zombie_run_taunt ) )
	{
		level._zombie_run_taunt = [];
	}
	if( !isDefined( level._zombie_board_taunt ) )
	{
		level._zombie_board_taunt = [];
	}
	
	level._zombie_run_taunt["boss_zombie"] = [];
	level._zombie_board_taunt["boss_zombie"] = [];
	
	level._zombie_board_taunt["boss_zombie"][0] = %ai_zombie_taunts_4;
	level._zombie_board_taunt["boss_zombie"][1] = %ai_zombie_taunts_7;
	level._zombie_board_taunt["boss_zombie"][2] = %ai_zombie_taunts_9;
	level._zombie_board_taunt["boss_zombie"][3] = %ai_zombie_taunts_5b;
	level._zombie_board_taunt["boss_zombie"][4] = %ai_zombie_taunts_5c;
	level._zombie_board_taunt["boss_zombie"][5] = %ai_zombie_taunts_5d;
	level._zombie_board_taunt["boss_zombie"][6] = %ai_zombie_taunts_5e;
	level._zombie_board_taunt["boss_zombie"][7] = %ai_zombie_taunts_5f;
}


/**
	Entry thread called on level from zombie_theater
	initializes all boss_zombie aspects

*/
init_boss_zombie()
{
	init_boss_zombie_anims();
	init_boss_zombie_fx();
	

	level thread boss_zombie_manager();
}

/*
	Manges boss zombie spawning
	- power must be on
	- all doors except 1 must be open
	- spawns every 3 rounds
	- spawn is guaranteed round after tp is used

*/
boss_zombie_manager()
{

	level endon("end_game");


	//Preconditions
	flag_wait("power_on");
	wait_doors_open();

	level.theater_rounds_until_boss = 0;
	while(1)
	{
		if( level.theater_rounds_until_boss == 0 ) {
			level thread watch_eng_spawn();
			level.theater_rounds_until_boss = level.VALUE_ENGINEER_ZOMBIE_SPAWN_ROUNDS_PER_SPAWN;
		}	
			
		wait(1);
	}

}

	wait_doors_open()
	{
		while(true)
		{
			zkeys = GetArrayKeys( level.zones );

			zonesClosed = 0;
			for( z=0; z<zkeys.size; z++ )
			{
				zone = level.zones[ zkeys[z] ];
				if ( zone.is_enabled )
					continue;

				zonesClosed++;	
			}

			if( zonesClosed < 2 )
				break;

			wait(2);
		}
	}

	watch_eng_spawn()
	{
		level waittill("round_start");
		randWait = randomInt(15, 60);
		if( is_true(level.dev_only))
			randWait = 5;

		wait(randWait);

		//wait for fresh zombie spawn, seize him and force him to engineer
		//zomb zmg_engineer()
		iprintln( "Engineer Zombie: Spawning" );
	}
