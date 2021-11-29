QBShared = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

QBShared.RandomStr = function(length) -- QBShared.RandomStr falls under GPL License here: [esxlicense]/LICENSE
	if length > 0 then
		return QBShared.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

QBShared.RandomInt = function(length)
	if length > 0 then
		return QBShared.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

QBShared.SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

QBShared.StarterItems = {
    ["apple"] = {amount = 3, item = "apple"},
	["id_card"] = {amount = 1, item = "id_card"},
    ["weapon_lantern01"] = {amount = 1, item = "weapon_lantern01"},
}

QBShared.Items = {
	--[[
	Template									The name used for scripts															The name that the								The weight of the	What sort of item it		If the item is								The imagie used for the item								Is the item			Can you actively	The required level				The description of the item
	Spawn name									to know which item to call															player sees in his inv							item (inventory)	is (item | weapon)			supposed to have ammo						(inventory)													stackable?			use the item?		to use the item(if useable)	(inventory)				 ]]
	["water_bottle"] 				 			= {["name"] = "water_bottle", 			  	  										["label"] = "Bottle of Water", 					["weight"] = 500, 	["type"] = "item", 			["image"] = "water_bottle.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "For all the thirsty out there"},
	["sandwich"] 					 			= {["name"] = "sandwich", 			 	  	  										["label"] = "Sandwich", 						["weight"] = 125, 	["type"] = "item", 			["image"] = "bread.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "A sandwich with toppings."},
	["beer"] 				 					= {["name"] = "beer", 			  	  												["label"] = "Beer", 							["weight"] = 500, 	["type"] = "item", 			["image"] = "beer.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "For all the thirsty out there"},
	["whiskey"] 				 	 			= {["name"] = "whiskey", 			  	  											["label"] = "Whiskey", 							["weight"] = 500, 	["type"] = "item", 			["image"] = "whiskey.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "For all the thirsty out there"},
	["vodka"] 				 		 			= {["name"] = "vodka", 			  	  												["label"] = "Vodka", 							["weight"] = 500, 	["type"] = "item", 			["image"] = "vodka.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "For all the thirsty out there"},
	["coffee"] 				 		 			= {["name"] = "coffee", 															["label"] = "Coffee", 							["weight"] = 200, 	["type"] = "item", 			["image"] = "coffee.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "S rustic pick me up"},
	["cigarette"] 								= {["name"] = "cigarette", 			 	  											["label"] = "Cigarette",	    				["weight"] = 1,		["type"] = "item", 			["image"] = "cigarette.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "A little bit of goodness"},
	["cigar"] 					 	 			= {["name"] = "cigar", 			 	  												["label"] = "Cigar",	    					["weight"] = 1,		["type"] = "item", 			["image"] = "cigar.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "A relief from stress"},
	["lighter"] 				 	 			= {["name"] = "lighter", 			  	  											["label"] = "Lighter", 							["weight"] = 0, 	["type"] = "item", 			["image"] = "lighter.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "On new years eve a nice fire to stand next to"},
	["apple"] 									= {["name"] = "apple", 																["label"] = "Apple",							["weight"] = 100,	["type"] = "item", 			["ammotype"] = nil, 					["image"] = "apple.png",									["unique"] = false,	["useable"] = true,	["level"] = 0,				["description"] = "An apple a day keeps my stomach filled. No worries about a fricking scurvy. It is only natural that it keeps the doctor away"},
	["id_card"] 								= {["name"] = "id_card", 															["label"] = "ID Card", 		    				["weight"] = 0, 	["type"] = "item", 			["ammotype"] = nil,  					["image"] = "id_card.png", 		    						["unique"] = false, ["useable"] = true, ["level"] = 0,     			["description"] = "A card containing all your information to identify yourself."},
	["bandage"] 								= {["name"] = "bandage", 															["label"] = "Bandage", 		    				["weight"] = 0, 	["type"] = "item", 			["ammotype"] = nil,  					["image"] = "bandage.png", 		    						["unique"] = false, ["useable"] = true, ["level"] = 0,      		["description"] = "bandage."},
	["painkillers"] 							= {["name"] = "painkillers", 														["label"] = "painkillers", 						["weight"] = 0, 	["type"] = "item", 			["ammotype"] = nil,  					["image"] = "painkillers.png", 								["unique"] = false, ["useable"] = true, ["level"] = 0,      		["description"] = "painkillers."},
	["firstaid"] 								= {["name"] = "firstaid", 															["label"] = "firstaid", 						["weight"] = 0, 	["type"] = "item", 			["ammotype"] = nil,  					["image"] = "firstaid.png", 								["unique"] = false, ["useable"] = true, ["level"] = 0,      		["description"] = "firstaid."},
	["cannedbeans"] 							= {["name"] = "cannedbeans", 														["label"] = "Beans in a can",					["weight"] = 100,	["type"] = "item", 			["ammotype"] = nil, 					["image"] = "cannedbeans.png",								["unique"] = false,	["useable"] = true,	["level"] = 0,				["description"] = "Canned beans, not something somebody would want to eat willingly. Atleast I can now make a bean joke about it"},		
	
	--Ammo
	["ammo_repeater"] 							= {["name"] = "ammo_repeater", 														["label"] = "Ammo Repeater", 					["weight"] = 200, 	["type"] = "item", 			["ammotype"] = nil, 						["image"] = "ammo_bullet_normal.png", 						["unique"] = false, ["useable"] = true, ["level"] = 0, 				["description"] = "Repeater Ammo"},
	["ammo_revolver"] 							= {["name"] = "ammo_revolver", 														["label"] = "Ammo Revolver", 					["weight"] = 200, 	["type"] = "item", 			["ammotype"] = nil, 						["image"] = "ammo_bullet_normal.png", 						["unique"] = false, ["useable"] = true, ["level"] = 0, 				["description"] = "Revolver Ammo"},
	["ammo_rifle"] 								= {["name"] = "ammo_rifle", 														["label"] = "Ammo Rifle", 						["weight"] = 200, 	["type"] = "item", 			["ammotype"] = nil, 						["image"] = "ammo_bullet_normal.png", 						["unique"] = false, ["useable"] = true, ["level"] = 0, 				["description"] = "Rifle Ammo"},

	-- Weapons
	["dual"] 								    = {["name"] = "dual", 														        ["label"] = "dual", 						    ["weight"] = 200, 	["type"] = "item", 			["ammotype"] = nil, 						["image"] = "dual.png", 						            ["unique"] = false, ["useable"] = true, ["level"] = 0, 				["description"] = "dual"},
	["weapon_revolver_cattleman"] 				= {["name"] = "weapon_revolver_cattleman", 				["attachPoint"] = 2,  		["label"] = "Colt M1873 Single Action",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver_cattleman.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Every cowboy has a first. And this revolver will probably be it"},
	["weapon_revolver_cattleman_mexican"] 		= {["name"] = "weapon_revolver_cattleman_mexican", 		["attachPoint"] = 2,		["label"] = "Steel Colt M1873",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver_cattleman_mexican.png",		["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Every cowboy has a first. And this revolver will probably be it, for the rich cowboys atleast"},
	["weapon_revolver_doubleaction_gambler"] 	= {["name"] = "weapon_revolver_doubleaction_gambler", 	["attachPoint"] = 2, 		["label"] = "Colt M1892 Double-action",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver_doubleaction_gambler.png",		["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_revolver_schofield"] 				= {["name"] = "weapon_revolver_schofield", 				["attachPoint"] = 2,		["label"] = "Smith & Wesson No. 3",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver_schofield.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_revolver_lemat"] 					= {["name"] = "weapon_revolver_lemat", 					["attachPoint"] = 2, 		["label"] = "LeMat Revolver",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver_lemat.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_revolver_navy"] 					= {["name"] = "weapon_revolver_navy", 					["attachPoint"] = 2,		["label"] = "Navy Revolver 1851",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver_navy.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_pistol_volcanic"] 					= {["name"] = "weapon_pistol_volcanic", 				["attachPoint"] = 2, 		["label"] = "Volcanic Pistol",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol_volcanic.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_pistol_m1899"] 					= {["name"] = "weapon_pistol_m1899", 					["attachPoint"] = 2,		["label"] = "FN Browning M1900",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol_m1899.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_pistol_mauser"] 					= {["name"] = "weapon_pistol_mauser", 					["attachPoint"] = 2,		["label"] = "Mauser C96",						["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol_mauser.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_pistol_semiauto"] 					= {["name"] = "weapon_pistol_semiauto", 				["attachPoint"] = 2,		["label"] = "Borchardt C-93",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol_semiauto.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_repeater_carbine"] 				= {["name"] = "weapon_repeater_carbine", 				["attachPoint"] = 9, 		["label"] = "Spencer Model 1865",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater_carbine.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_repeater_winchester"] 				= {["name"] = "weapon_repeater_winchester", 			["attachPoint"] = 9,		["label"] = "Winchester Model 1866",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater_winchester.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_repeater_henry"] 					= {["name"] = "weapon_repeater_henry", 					["attachPoint"] = 9,		["label"] = "Henry Model 1860",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater_henry.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_repeater_evans"] 					= {["name"] = "weapon_repeater_evans", 					["attachPoint"] = 9,		["label"] = "Evans Repeating Rifle",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater_evans.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_rifle_varmint"] 					= {["name"] = "weapon_rifle_varmint", 					["attachPoint"] = 9,		["label"] = "Winchester Model 1890",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle_varmint.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_rifle_springfield"] 				= {["name"] = "weapon_rifle_springfield", 				["attachPoint"] = 9,		["label"] = "Springfield Model 1873",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle_springfield.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_rifle_boltaction"] 				= {["name"] = "weapon_rifle_boltaction", 				["attachPoint"] = 9,		["label"] = "Springfield Model 1892",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle_boltaction.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_rifle_elephant"] 					= {["name"] = "weapon_rifle_elephant", 					["attachPoint"] = 9,		["label"] = "Elephant Rifle",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle_elephant.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_shotgun_doublebarrel"] 			= {["name"] = "weapon_shotgun_doublebarrel", 			["attachPoint"] = 9,		["label"] = "Colt Hammer Shotgun 1878",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun_doublebarrel.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_shotgun_doublebarrel_exotic"] 		= {["name"] = "weapon_shotgun_doublebarrel_exotic", 	["attachPoint"] = 9,		["label"] = "Steel Hammer Shotgun 1878",		["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun_doublebarrel_exotic.png",		["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_shotgun_sawedoff"] 				= {["name"] = "weapon_shotgun_sawedoff", 				["attachPoint"] = 9,		["label"] = "Hamerless Shotgun 1883",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun_sawedoff.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_shotgun04"] 						= {["name"] = "weapon_shotgun04", 						["attachPoint"] = 9,		["label"] = "Winchester Model 1887",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun04.png",							["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_shotgun05"] 						= {["name"] = "weapon_shotgun05", 						["attachPoint"] = 9,		["label"] = "Winchester Model 1897",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun05.png",							["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_shotgun_semiauto"] 				= {["name"] = "weapon_shotgun_semiauto", 				["attachPoint"] = 9,		["label"] = "Browning Auto-5",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun_semiauto.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_sniperrifle_rollingblock"] 		= {["name"] = "weapon_sniperrifle_rollingblock", 		["attachPoint"] = 10, 		["label"] = "Remington M1867",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_sniperrifle_rollingblock.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_sniperrifle_rollingblock_exotic"] 	= {["name"] = "weapon_sniperrifle_rollingblock_exotic", ["attachPoint"] = 10, 		["label"] = "Steel Remington M1867",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_sniperrifle_rollingblock_exotic.png",	["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_sniperrifle_carcano"] 				= {["name"] = "weapon_sniperrifle_carcano",				["attachPoint"] = 10, 	 	["label"] = "Carcano 1891 Short Rifle",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_sniperrifle_carcano.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_bow"] 								= {["name"] = "weapon_bow", 							["attachPoint"] = 7,		["label"] = "Flatbow",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = "AMMO_ARROW",	 			["image"] = "weapon_bow.png",								["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_bow_improved"] 					= {["name"] = "weapon_bow_improved", 					["attachPoint"] = 7,		["label"] = "Sturdy Flatbow",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = "AMMO_ARROW",	 			["image"] = "weapon_bow_improved.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_lasso"] 							= {["name"] = "weapon_lasso", 							["attachPoint"] = 5, 		["label"] = "Lasso",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_lasso.png",								["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_lasso_reinforced"] 				= {["name"] = "weapon_lasso_reinforced",  				["attachPoint"] = 5,		["label"] = "Sturdy Lasso",						["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_lasso_reinforced.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_knife"] 						= {["name"] = "weapon_melee_knife", 					["attachPoint"] = 4, 		["label"] = "Knife",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_knife.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_knife_jawbone"] 				= {["name"] = "weapon_melee_knife_jawbone", 			["attachPoint"] = 4, 		["label"] = "Jawbone Knife",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_knife_jawbone.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_hammer"] 					= {["name"] = "weapon_melee_hammer", 					["attachPoint"] = 13,		["label"] = "Hammer",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_hammer.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_thrown_dynamite"]					= {["name"] = "weapon_thrown_dynamite", 				["attachPoint"] = 6,		["label"] = "Throwable Dynamite",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_thrown_dynamite.png",					["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_thrown_molotov"]					= {["name"] = "weapon_thrown_molotov",					["attachPoint"] = 6, 		["label"] = "Throwable Molotov",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_thrown_molotov.png",					["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_thrown_throwing_knives"] 			= {["name"] = "weapon_thrown_throwing_knives", 			["attachPoint"] = 6,		["label"] = "Throwing Knives",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_thrown_throwing_knives.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_thrown_tomahawk"] 					= {["name"] = "weapon_thrown_tomahawk",					["attachPoint"] = 6,		["label"] = "Throwable Axe",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_thrown_tomahawk.png",					["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_thrown_tomahawk_ancient"] 			= {["name"] = "weapon_thrown_tomahawk_ancient", 		["attachPoint"] = 6,		["label"] = "Throwable Old Axe",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_thrown_tomahawk_ancient.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_thrown_bolas"] 					= {["name"] = "weapon_thrown_bolas",					["attachPoint"] = 6,		["label"] = "Throwable Bolas",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_thrown_bolas.png",						["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_cleaver"] 					= {["name"] = "weapon_melee_cleaver",		 			["attachPoint"] = 3,		["label"] = "Throwable Cleaver", 				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_cleaver.png",						["unique"] = false,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_lantern"] 					= {["name"] = "weapon_melee_lantern",					["attachPoint"] = 11,		["label"] = "Silver Lantern",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_lantern.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_davy_lantern"] 				= {["name"] = "weapon_melee_davy_lantern",				["attachPoint"] = 11,		["label"] = "Golden Lantern", 					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_davy_lantern.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_torch"] 						= {["name"] = "weapon_melee_torch",						["attachPoint"] = 13, 		["label"] = "Wooden Torch",  					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_torch.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_hatchet"] 					= {["name"] = "weapon_melee_hatchet",					["attachPoint"] = 13, 		["label"] = "Hatchet",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_hatchet.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"},
	["weapon_melee_machete"] 					= {["name"] = "weapon_melee_machete",					["attachPoint"] = 13, 		["label"] = "Machete",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,	 						["image"] = "weapon_melee_machete.png",						["unique"] = true,	["usable"] = true,	["level"] = 0,				["description"] = "Placeholder"}
}

-- // HASH WEAPON ITEMS, NEED SOMETIMES TO GET INFO FOR CLIENT

QBShared.Weapons = {
	[GetHashKey("WEAPON_REVOLVER_CATTLEMAN")] 					= {["name"] = "weapon_revolver_cattleman",				["attachPoint"] = 2, 	["label"] = "Colt M1873 Single Action",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver01.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Every cowboy has a first. And this revolver will probably be it"},
	[GetHashKey("WEAPON_REVOLVER_CATTLEMAN_MEXICAN")] 			= {["name"] = "weapon_revolver_cattleman_mexican",		["attachPoint"] = 2, 	["label"] = "Steel Colt M1873",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver02.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Every cowboy has a first. And this revolver will probably be it, for the rich cowboys atleast"},
	[GetHashKey("WEAPON_REVOLVER_DOUBLEACTION_GAMBLER")] 		= {["name"] = "weapon_revolver03", 						["attachPoint"] = 2,	["label"] = "Colt M1892 Double-action",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver03.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_REVOLVER_SCHOFIELD")] 					= {["name"] = "weapon_revolver_doubleaction_gambler",	["attachPoint"] = 2, 	["label"] = "Smith & Wesson No. 3",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver04.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_REVOLVER_LEMAT")] 						= {["name"] = "weapon_revolver_lemat",					["attachPoint"] = 2, 	["label"] = "LeMat Revolver",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REVOLVER", 			["image"] = "weapon_revolver05.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_PISTOL_VOLCANIC")] 						= {["name"] = "weapon_pistol_volcanic",					["attachPoint"] = 2, 	["label"] = "Volcanic Pistol",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_PISTOL_M1899")] 						= {["name"] = "weapon_pistol_m1899", 					["attachPoint"] = 2,	["label"] = "FN Browning M1900",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_PISTOL_MAUSER")] 						= {["name"] = "weapon_pistol_mauser", 					["attachPoint"] = 2,	["label"] = "Mauser C96",						["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol03.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_PISTOL_SEMIAUTO")] 						= {["name"] = "weapon_pistol_semiauto",					["attachPoint"] = 2, 	["label"] = "Borchardt C-93",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_PISTOL",	 			["image"] = "weapon_pistol04.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_REPEATER_CARBINE")] 					= {["name"] = "weapon_repeater_carbine", 				["attachPoint"] = 9,	["label"] = "Spencer Model 1865",				["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater01.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_REPEATER_WINCHESTER")] 					= {["name"] = "weapon_repeater_winchester", 			["attachPoint"] = 9,	["label"] = "Winchester Model 1866",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater02.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_REPEATER_HENRY")] 						= {["name"] = "weapon_repeater_henry", 					["attachPoint"] = 9,	["label"] = "Henry Model 1860",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater03.png",			["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_REPEATER_EVANS")] 						= {["name"] = "weapon_repeater_evans", 					["attachPoint"] = 9,	["label"] = "Evans Repeating Rifle",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_REPEATER",	 			["image"] = "weapon_repeater_evans.png",		["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_RIFLE_VARMINT")] 						= {["name"] = "weapon_rifle_varmint", 					["attachPoint"] = 9,	["label"] = "Winchester Model 1890",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_RIFLE_SPRINGFIELD")] 					= {["name"] = "weapon_rifle_springfield", 				["attachPoint"] = 9,	["label"] = "Springfield Model 1873",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_RIFLE_BOLTACTION")] 					= {["name"] = "weapon_rifle_boltaction", 				["attachPoint"] = 9,	["label"] = "Springfield Model 1892",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle03.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_RIFLE_ELEPHANT")] 						= {["name"] = "weapon_rifle_elephant", 					["attachPoint"] = 9,	["label"] = "Elephant Rifle",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_rifle04.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SHOTGUN_DOUBLEBARREL")] 				= {["name"] = "weapon_shotgun_doublebarrel", 			["attachPoint"] = 9,	["label"] = "Colt Hammer Shotgun 1878",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SHOTGUN_DOUBLEBARREL_EXOTIC")] 			= {["name"] = "weapon_shotgun_doublebarrel_exotic", 	["attachPoint"] = 9,	["label"] = "Steel Hammer Shotgun 1878",		["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SHOTGUN_SAWEDOFF")] 					= {["name"] = "weapon_shotgun03", 						["attachPoint"] = 9,	["label"] = "Hamerless Shotgun 1883",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun03.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SHOTGUN_SAWEDOFF")] 					= {["name"] = "weapon_shotgun04", 						["attachPoint"] = 9,	["label"] = "Winchester Model 1887",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun04.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SHOTGUN_SAWEDOFF")] 					= {["name"] = "weapon_shotgun05", 						["attachPoint"] = 9,	["label"] = "Winchester Model 1897",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun05.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SHOTGUN_SEMIAUTO")] 					= {["name"] = "weapon_shotgun_semiauto", 				["attachPoint"] = 9,	["label"] = "Browning Auto-5",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_SHOTGUN",	 			["image"] = "weapon_shotgun06.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SNIPERRIFLE_ROLLINGBLOCK")] 			= {["name"] = "weapon_sniperrifle_rollingblock", 		["attachPoint"] = 10,	["label"] = "Remington M1867",					["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_sniper01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SNIPERRIFLE_ROLLINGBLOCK_EXOTIC")]		= {["name"] = "weapon_sniperrifle_rollingblock_exotic", ["attachPoint"] = 10,	["label"] = "Steel Remington M1867",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_sniper02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_SNIPERRIFLE_CARCANO")]					= {["name"] = "weapon_sniperrifle_carcano", 			["attachPoint"] = 10,	["label"] = "Carcano 1891 Short Rifle",			["weight"] = 1000,	["type"] = "weapon", 		["ammotype"] = "AMMO_RIFLE",	 			["image"] = "weapon_sniper03.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_BOW")]									= {["name"] = "weapon_bow", 							["attachPoint"] = 7,	["label"] = "Flatbow",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = "AMMO_ARROW",	 			["image"] = "weapon_bow01.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_BOW_IMPROVED")]							= {["name"] = "weapon_bow_improved", 					["attachPoint"] = 7,	["label"] = "Sturdy Flatbow",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = "AMMO_ARROW",	 			["image"] = "weapon_bow02.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_LASSO")]								= {["name"] = "weapon_lasso", 							["attachPoint"] = 5,	["label"] = "Lasso",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_lasso01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_LASSO_REINFORCED")]						= {["name"] = "weapon_lasso_reinforced", 				["attachPoint"] = 5,	["label"] = "Sturdy Lasso",						["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_lasso02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_KNIFE")]							= {["name"] = "weapon_melee_knife", 					["attachPoint"] = 4, 	["label"] = "Knife",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_knife01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_KNIFE_JAWBONE")]					= {["name"] = "weapon_melee_knife_jawbone",				["attachPoint"] = 4, 	["label"] = "Jawbone Knife",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_knife02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_HAMMER")]							= {["name"] = "weapon_melee_hammer",					["attachPoint"] = 13, 	["label"] = "Hammer",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_hammer.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_THROWN_DYNAMITE")]						= {["name"] = "weapon_thrown_dynamite",					["attachPoint"] = 6,	["label"] = "Throwable Dynamite",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_dynamite.png",		["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_THROWN_MOLOTOV")]						= {["name"] = "weapon_thrown_molotov",					["attachPoint"] = 6,	["label"] = "Throwable Molotov",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_molotov.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_THROWN_THROWING_KNIVES")]				= {["name"] = "weapon_thrown_throwing_knives",			["attachPoint"] = 6,	["label"] = "Throwing Knives",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_knives.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_THROWN_TOMAHAWK")]						= {["name"] = "weapon_thrown_tomahawk",					["attachPoint"] = 6,	["label"] = "Throwable Axe",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_axe01.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_THROWN_TOMAHAWK_ANCIENT")]				= {["name"] = "weapon_thrown_tomahawk_ancient",			["attachPoint"] = 6,	["label"] = "Throwable Old Axe",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_axe02.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_THROWN_BOLAS")]							= {["name"] = "weapon_thrown_bolas",					["attachPoint"] = 6,	["label"] = "Throwable Bolas",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_bolas.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_CLEAVER")]						= {["name"] = "weapon_melee_cleaver",					["attachPoint"] = 3,	["label"] = "Throwable Cleaver",				["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_throw_cleaver.png",			["unique"] = false,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_LANTERN")]						= {["name"] = "weapon_melee_lantern",					["attachPoint"] = 11,	["label"] = "Silver Lantern",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_lantern01.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_DAVY_LANTERN")]					= {["name"] = "weapon_melee_davy_lantern",				["attachPoint"] = 11,	["label"] = "Golden Lantern",					["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_lantern02.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_TORCH")]							= {["name"] = "weapon_melee_torch",						["attachPoint"] = 13,	["label"] = "Wooden Torch",						["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_torch.png",					["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_HATCHET")]						= {["name"] = "weapon_melee_hatchet",					["attachPoint"] = 13,	["label"] = "Hatchet",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_hatchet.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"},
	[GetHashKey("WEAPON_MELEE_MACHETE")]						= {["name"] = "weapon_melee_machete",					["attachPoint"] = 13,	["label"] = "Machete",							["weight"] = 100,	["type"] = "weapon", 		["ammotype"] = nil,				 			["image"] = "weapon_machete.png",				["unique"] = true,	["usable"] = true,	["level"] = 0,		["description"] = "Placeholder"}
}

-- Gangs
QBShared.Gangs = {
	["none"] = {
		label = "No Gang"
	}
}

-- Jobs
QBShared.Jobs = {
	["unemployed"] = {
		label = "Civilian",
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Rural Settler",
                payment = 0.2
            },
        },
	},
	["police"] = {
		label = "Law Enforcement",
		bossmenu = vector3(448.4, -973.2, 30.6),
		grades = {
            ['0'] = {
                name = "Constable",
                payment = 1
            },
			['1'] = {
                name = "Lawman",
                payment = 2
            },
			['2'] = {
                name = "Deputy",
                payment = 4
            },
			['3'] = {
                name = "Sheriff",
                payment = 7
            },
			['4'] = {
                name = "Chief",
                payment = 10
            },
        },
	},
	["ambulance"] = {
		label = "EMS",
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Intern",
                payment = 1
            },
			['1'] = {
                name = "Pioneer Physician",
                payment = 2
            },
			['2'] = {
                name = "Doctor",
                payment = 4
            },
			['3'] = {
                name = "Surgeon",
                payment = 7
            },
			['4'] = {
                name = "Chief",
                payment = 10
            },
        },
	},
	["judge"] = {
		label = "Honorary",
		defaultDuty = true,
		grades = {
			['0'] = {
                name = "Solicitor General",
                payment = 10
            },
            ['1'] = {
                name = "Judge",
                payment = 15
            },
        },
	}
}

-- Vehicles
QBShared.Vehicles = {
["CART01"] = {

		["name"] = "Wooden Cart 1",
		["brand"] = "?",
		["model"] = "CART01",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "-824257932",
		["shop"] = "cart",
	},
	["CART02"] = {
		["name"] = "Wooden Cart 2",
		["brand"] = "?",
		["model"] = "CART02",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "-2053881888",
		["shop"] = "cart",
	},
	["CART03"] = {
		["name"] = "Wooden Cart 3",
		["brand"] = "?",
		["model"] = "CART03",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "-1347283941",
		["shop"] = "cart",
	},
	["CART04"] = {
		["name"] = "Wooden Cart 4",
		["brand"] = "?",
		["model"] = "CART04",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "-570691410",
		["shop"] = "cart",
	},
	["CART05"] = {
		["name"] = "Wooden Cart 5",
		["brand"] = "?",
		["model"] = "CART05",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "374792535",
		["shop"] = "cart",
	},
	["CART06"] = {
		["name"] = "Wooden Cart 6",
		["brand"] = "?",
		["model"] = "CART06",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "219205323",
		["shop"] = "cart",
	},
	["CART07"] = {
		["name"] = "Wooden Cart 7",
		["brand"] = "?",
		["model"] = "CART07",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "47200842",
		["shop"] = "cart",
	},
	["CART08"] = {
		["name"] = "Wooden Cart 8",
		["brand"] = "?",
		["model"] = "CART08",
		["price"] = 10,
		["category"] = "Carts",
		["hash"] = "-377157708",
		["shop"] = "cart",
	},
	["BUGGY01"] = {
		["name"] = "Luxurious Buggy 1",
		["brand"] = "?",
		["model"] = "BUGGY01",
		["price"] = 10,
		["category"] = "Buggies",
		["hash"] = "-1278978750",
		["shop"] = "cart",
	},
	["BUGGY02"] = {
		["name"] = "Luxurious Buggy 2",
		["brand"] = "?",
		["model"] = "BUGGY02",
		["price"] = 10,
		["category"] = "Buggies",
		["hash"] = "-1100387700",
		["shop"] = "cart",
	},
	["BUGGY03"] = {
		["name"] = "Luxurious Buggy 3",
		["brand"] = "?",
		["model"] = "BUGGY03",
		["price"] = 10,
		["category"] = "Buggies",
		["hash"] = "-1861840953",
		["shop"] = "cart",
	},
	["COACH2"] = {
		["name"] = "Special Transport 1",
		["brand"] = "?",
		["model"] = "COACH2",
		["price"] = 10,
		["category"] = "Specials",
		["hash"] = "1761016051",
		["shop"] = "cart",
	},
	["COACH3"] = {
		["name"] = "Special Transport 2",
		["brand"] = "?",
		["model"] = "COACH3",
		["price"] = 10,
		["category"] = "Specials",
		["hash"] = "-136833353",
		["shop"] = "cart",
	},
	["COACH4"] = {
		["name"] = "Special Transport 3",
		["brand"] = "?",
		["model"] = "COACH4",
		["price"] = 10,
		["category"] = "Specials",
		["hash"] = "93893176",
		["shop"] = "cart",
	},
	["COACH5"] = {
		["name"] = "Special Transport 4",
		["brand"] = "?",
		["model"] = "COACH5",
		["price"] = 10,
		["category"] = "Specials",
		["hash"] = "-1826304690",
		["shop"] = "cart",
	},
	["COACH6"] = {
		["name"] = "Special Transport 5",
		["brand"] = "?",
		["model"] = "COACH6",
		["price"] = 10,
		["category"] = "Specials",
		["hash"] = "-1544786211",
		["shop"] = "cart",
	}
}
