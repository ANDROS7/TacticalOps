#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

/*
* TODO:
* Homefront M4 HUD icons for attachments
*/

doDvars()
{
	self takeAllWeapons();
	self clearPerks();
	self.numPerks = 0;

	setDvar("sv_cheats", 1);
	self setClientDvar("sv_cheats", 1);
	
	setDvar("cg_scoreboardPingText", 1);
	setDvar("com_maxfps", 0);
	setDvar("cg_everyoneHearsEveryone", 1);
	
	self setClientDvar("cg_scoreboardPingText", 1);
	self setClientDvar("com_maxfps", 0);
	self setClientDvar("cg_everyoneHearsEveryone", 1);
	
	setDvar("cg_drawcrosshair", 0);
	setDvar("cg_fov", 80);
	setDvar("r_brightness", "-0.25");
	
	self setClientDvar("cg_drawcrosshair", 0);
	self setClientDvar("cg_fov", 80);
	self setClientDvar("r_brightness", "-0.25");
	
	setDvar("sv_cheats", 0);
	self setClientDvar("sv_cheats", 0);
}

giveLoadout( team )
{
	if (team == "allies")
	{
		loadout = level.attackerLoadout;
	}
	else
	{
		loadout = level.defenderLoadout;
	}
	
	primaryTokens = strtok( loadout.primaryWeapon, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];
	
	self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
	
	self GiveWeapon( loadout.primaryWeapon );
	self setWeaponAmmoOverall( loadout.primaryWeapon, 60 );
	self setSpawnWeapon( loadout.primaryWeapon );
	
	// give secondary weapon
	self GiveWeapon( loadout.secondaryWeapon );
	self setWeaponAmmoOverall( loadout.primaryWeapon, 20 );
	self giveMaxAmmo( loadout.secondaryWeapon );
	
	// give third weapon
	self GiveWeapon( loadout.thirdWeapon );
	self giveStartAmmo( loadout.primaryWeapon );
	
	self SetActionSlot( 1, "nightvision" );
	
	if ( loadout.inventoryWeapon != "" )
	{
		self GiveWeapon( loadout.inventoryWeapon );
		self maps\mp\gametypes\_class::setWeaponAmmoOverall( loadout.inventoryWeapon, loadout.inventoryWeaponAmmo );
		
		self.inventoryWeapon = loadout.inventoryWeapon;
		
		self setActionSlot( 3, "weapon", loadout.inventoryWeapon );
		self setActionSlot( 4, "" );
	}
	else
	{
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );
	}
	
	if ( loadout.grenadeTypePrimary != "" )
	{
		grenadeTypePrimary = level.weapons[ loadout.grenadeTypePrimary ];
		
		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, loadout.grenadeCountPrimary );
		self SwitchToOffhand( grenadeTypePrimary );
	}
	
	if ( loadout.grenadeTypeSecondary != "" )
	{
		grenadeTypeSecondary = level.weapons[ loadout.grenadeTypeSecondary ];
		
		if ( grenadeTypeSecondary == level.weapons["flash"])
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
		
		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, loadout.grenadeCountSecondary );
	}
}

initLoadout()
{
	// attacker loadout
	attackerLoadout = spawnstruct();
	
	attackerLoadout.primaryWeapon = "m4_silencer_mp";
	attackerLoadout.secondaryWeapon = "m21_mp";
	attackerLoadout.thirdWeapon = "colt45_silencer_mp";
	
	attackerLoadout.inventoryWeapon = "";
	attackerLoadout.inventoryWeaponAmmo = 0;
	
	attackerLoadout.grenadeTypePrimary = "frag";
	attackerLoadout.grenadeCountPrimary = 2;
	
	attackerLoadout.grenadeTypeSecondary = "flash";
	attackerLoadout.grenadeCountSecondary = 4;
	
	// attacker loadout
	defenderLoadout = spawnstruct();
	
	defenderLoadout.primaryWeapon = "g36c_silencer_mp";
	defenderLoadout.secondaryWeapon = "m21_mp";
	defenderLoadout.thirdWeapon = "colt45_silencer_mp";
	
	defenderLoadout.inventoryWeapon = "claymore_mp";
	defenderLoadout.inventoryWeaponAmmo = 2;
	
	defenderLoadout.grenadeTypePrimary = "frag";
	defenderLoadout.grenadeCountPrimary = 2;
	
	defenderLoadout.grenadeTypeSecondary = "smoke";
	defenderLoadout.grenadeCountSecondary = 4;
	
	level.attackerLoadout = attackerLoadout;
	level.defenderLoadout = defenderLoadout;
}

customSpawnLogic()
{
	locs = [];
	
	locs[0] = (1438.51, 1671.29, -127.876); // allies base
	locs[1] = (7243.88, 544.938, 6.14204); // axis base 
	
	return locs;
}

main()
{
	//initPerkData( "claymore_mp" );

	level thread onPlayerConnect();
	
	//initLoadout();
	
	locs = customSpawnLogic();
	
	/*
	Objective_Add( 0, "active", "Attack the enemy base.", locs[0] );
	Objective_Team( 0, "allies" );
	Objective_Position( 0, locs[1] );
	
	Objective_Add( 1, "active", "Defend the base.", locs[1] );
	Objective_Team( 1, "axis" );
	Objective_Position( 1, locs[1] );
	*/
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player thread onPlayerSpawned();
	}
}

doLoc()
{
	for(;;)
	{
		self iPrintln( self.origin );
		wait 1;
	}
} 

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill("spawned_player");
		self thread doDvars();
		//self thread doLoc();
		
		//self thread clearPerksOnDeath();
		
		while( !isdefined(self.pers["team"]) )
			wait 1;
		
		locs = customSpawnLogic();
		
		if (self.pers["team"] == "allies")
		{
			// teleport
			self SetOrigin(locs[0]);
			
			self iPrintLnBold( "^1Attack the enemy base." );
		}
		else
		{
			// teleport
			self SetOrigin(locs[1]);
			
			self iPrintLnBold( "^1Defend the base." );
		}
		
		giveLoadout( self.pers["team"] );
	}
}

/* clearPerksOnDeath()
{
	self endon("disconnect");
	self waittill("death");
	
	self clearPerks();
	for ( i = 0; i < self.numPerks; i++ )
	{
		self hidePerk( i, 0.05 );
	}
	self.numPerks = 0;
} */