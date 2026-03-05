Config						= {}

Config["BaseServer"] = {
	["clinet_shared_obj"] = 'esx:getSharedObject', --คุณสามารถแก้ไขทรัพยากร ของ BaseServer คุณได้ ส่วนของ ฝั้ง client
	["server_shared_obj"] = 'esx:getSharedObject', --คุณสามารถแก้ไขทรัพยากร ของ BaseServer คุณได้ ส่วนของ ฝั้ง Server
	
}

Config.DrawDistance = 20.0
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config['Class_Vehicle'] = {
	[0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains"
}

Config['ColorList'] = {
	[1] = {
		['blue'] = {
			background = '#5DB6E5',
			r = 93,
			g = 182,
			b = 229
		},
		['black'] = {
			background = '#2C2C2C',
			r = 44,
			g = 44,
			b = 44
		},
		['pink'] = {
			background = '#CB3694',
			r = 203,
			g = 54,
			b = 148
		},
		['red'] = {
			background = '#E03232',
			r = 224,
			g = 50,
			b = 50
		},
		['purple'] = {
			background = '#8466E2',
			r = 132,
			g = 102,
			b = 226
		},
		['white'] = {
			background = '#D4D4D4',
			r = 212,
			g = 212,
			b = 212
		},
	},
	[2] = {
		['blue'] = {
			background = '#5DB6E5',
			r = 93,
			g = 182,
			b = 229
		},
		['black'] = {
			background = '#2C2C2C',
			r = 44,
			g = 44,
			b = 44
		},
		['pink'] = {
			background = '#CB3694',
			r = 203,
			g = 54,
			b = 148
		},
		['red'] = {
			background = '#E03232',
			r = 224,
			g = 50,
			b = 50
		},
		['purple'] = {
			background = '#8466E2',
			r = 132,
			g = 102,
			b = 226
		},
		['white'] = {
			background = '#D4D4D4',
			r = 212,
			g = 212,
			b = 212
		},
	},
	
}

Config['ZONE_SHOP'] = {
	{
		shop = 'car',
		ShopEnterShop = {
			Pos = vector4(-56.7774,-1096.98, 26.422,1.0),
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			colormarker = { r = 120, g = 120, b = 240,a = 100 },
			Type  = 20
		},
		ShopInside = {
			Pos     = vector4(-47.570, -1097.221, 25.422,-20.0),
			
		},
		ShopOutside = {
			Pos     = vector4(-11.54, -1083.38, 26.68,165.09),
			
		},
	}
}

Config['Category'] = {
	[1] = {
        label = "Cycles",
		index = 'cycles',
	},
	-- [2] = {
    --     label = "Sport",
	-- 	index = 'sport',
       
	-- },
	-- [4] = {
    --     label = "KG CAR",
	-- 	index = 'kgcar',
	-- },
	[2] = {
		label = "Motorcycles",
		index = 'motorcycles',
	},
	[3] = {
        label = "Sport",
		index = 'sport', 
	},
	[4] = {
        label = "KG CAR",
		index = 'kgcar',
	},
	-- [6] = {
	-- 	label = "MC CLUB",
	-- 	index = 'mcclub',
      
	-- },
	-- [7] = {
	-- 	label = "GANG",
	-- 	index = 'gang',
     
	-- },


	[5] = {
		label = "AMBULANCE",
		index = 'ambulance', --หน่วยงานให้ใส่เป็นชื่อjob
      
	},
	[6] = {
		label = "POLICE",	
		index = 'police', --หน่วยงานให้ใส่เป็นชื่อjob
       
	},
	[7] = {
		label = "COUNCIL",
		index = 'council', --หน่วยงานให้ใส่เป็นชื่อjob
    
	},
	-- [11] = {
	-- 	label = "Gacha",
	-- 	index = 'gacha', --หน่วยงานให้ใส่เป็นชื่อjob
        
	-- },
}

Config['vehicles'] = {
	["srg_corsita"] = {
		name = "Corsita",
		model = "srg_corsita",
		price = 3500000,
		category = "sport",
		kg = 0,
		typecar = 'car'
	},
	-- ["tuktuk"] = {
	-- 	name = "Daily Car",
	-- 	model = "tuktuk",
	-- 	price = 9999999999,
	-- 	category = "gacha",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["adm_apvan"] = {
	-- 	name = "Mother Package",
	-- 	model = "adm_apvan",
	-- 	price = 9999999999,
	-- 	category = "gacha",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["adm_civicfl5"] = {
	-- 	name = "Mother Package",
	-- 	model = "adm_civicfl5",
	-- 	price = 9999999999,
	-- 	category = "gacha",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	["SRG_GUARDIAN"] = {
		name = "GUARDIAN",
		model = "SRG_GUARDIAN",
		price = 1500000,
		category = "kgcar",
		kg = 120,
		typecar = 'car'
	},

	--
	-- ["hover_bike"] = {
	-- 	name = "Ambulance Bike",
	-- 	model = "hover_bike",
	-- 	price = 100000,
	-- 	category = "ambulance",
	-- 	grade = 1, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	["taycan21prmd"] = {
		name = "Taycan Ambulance",
		model = "taycan21prmd",
		price = 5000,
		category = "ambulance",
		grade = 0, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
		kg = 0,
		typecar = 'car'
	},
	
	["adm_t20pd"] = {
		name = "T20 Police",
		model = "adm_t20pd",
		price = 5000,
		category = "police",
		grade = 0, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
		kg = 0,
		typecar = 'car'
	},
	
	["SRG_ITALIGTBPOL"] = {
		name = "Gtb Police",
		model = "SRG_ITALIGTBPOL",
		price = 30000,
		category = "police",
		grade = 1, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
		kg = 0,
		typecar = 'car'
	},
	
	["srg_sentinel5pol"] = {
		name = "Sentinel5 Police",
		model = "srg_sentinel5pol",
		price = 50000,
		category = "police",
		grade = 3, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
		kg = 0,
		typecar = 'car'
	},
	
	["srg_oppressorcon"] = {
		name = "Oppre Council",
		model = "srg_oppressorcon",
		price = 5000,
		category = "council",
		grade = 0, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
		kg = 0,
		typecar = 'car'
	},

	-- ["adm_furiapd"] = {
	-- 	name = "Furia Police",
	-- 	model = "adm_furiapd",
	-- 	price = 5000,
	-- 	category = "police",
	-- 	grade = 0, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["srg_sugoiAG"] = {
	-- 	name = "Sugoi Police",
	-- 	model = "srg_sugoiAG",
	-- 	price = 6000,
	-- 	category = "police",
	-- 	grade = 0, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	
	-------------
	-- ["adm_raidenco"] = {
	-- 	name = "Raidenco Council",
	-- 	model = "adm_raidenco",
	-- 	price = 5000,
	-- 	category = "council",
	-- 	grade = 0, --ถ้าไม่แบ่ง ยศไม่จำเป็นต้องใส่ (คำอธิบายสำหรับคน ไม่เข้าใจ ซูชิ)
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },

	
	-- ["srg_gburrito2"] = {
	-- 	name = "Gburrito2",
	-- 	model = "srg_gburrito2",
	-- 	price = 1500000,
	-- 	category = "mcclub",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	------
	-- ["adm_dynals"] = {
	-- 	name = "MC Dynals",
	-- 	model = "adm_dynals",
	-- 	price = 990000,
	-- 	category = "mcclub",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["adm_soulcarrierb"] = {
	-- 	name = "MC Soulcarrierb",
	-- 	model = "adm_soulcarrierb",
	-- 	price = 990000,
	-- 	category = "mcclub",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	--------------------------------------------------------------
	-- ["SRG_ZORRUSSO"] = {
	-- 	name = "Pegassi Zorrusso",
	-- 	model = "SRG_ZORRUSSO",
	-- 	price = 3000000,
	-- 	category = "super",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["SRG_BRAWLER"] = {
	-- 	name = "Coil Brawler",
	-- 	model = "SRG_BRAWLER",
	-- 	price = 3200000,
	-- 	category = "super",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["SRG_ISSI7"] = {
	-- 	name = "Weeny Issi Sport",
	-- 	model = "SRG_ISSI7",
	-- 	price = 1500000,
	-- 	category = "sport",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
--------------------------------------------------------------
	-- ["pariah"] = {
	-- 	name = "Ocelot Pariah",
	-- 	model = "pariah",
	-- 	price = 1000000,
	-- 	category = "sport",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["comet2"] = {
	-- 	name = "Pfister Comet",
	-- 	model = "comet2",
	-- 	price = 900000,
	-- 	category = "sport",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	-- ["specter"] = {
	-- 	name = "Dewbauchee Specter",
	-- 	model = "specter",
	-- 	price = 900000,
	-- 	category = "sport",
	-- 	kg = 10,
	-- 	typecar = 'car'
	-- },
	["bmx"] = {
		name = "Bmx",
		model = "bmx",
		price = 500,
		category = "cycles",
		kg = 0,
		typecar = 'car'
	},
	["fixter"] = {
		name = "Fixter",
		model = "fixter",
		price = 3500,
		category = "cycles",
		kg = 0,
		typecar = 'car'
	},
	["tribike"] = {
		name = "Tribike",
		model = "tribike",
		price = 5000,
		category = "cycles",
		kg = 0,
		typecar = 'car'
	},
--------------------------------------------------------------
	["bati"] = {
		name = "Pegassi Bati 801",
		model = "bati",
		price = 300000,
		category = "motorcycles",
		kg = 10,
		typecar = 'car'
	},
	["bf400"] = {
		name = "Nagasaki BF400",
		model = "bf400",
		price = 500000,
		category = "motorcycles",
		kg = 10,
		typecar = 'car'
	},
	["faggio3"] = {
		name = "Pegassi Faggio Mod",
		model = "faggio3",
		price = 300000,
		category = "motorcycles",
		kg = 10,
		typecar = 'car'
	},
	
	
} 

Config["DiscordWebhook"] = {
	Enable = false,
	BuyVehicle = '', -- ใส่ Discord Webhook URL
	BotName = 'Val VehicleShop',
	AvatarURL = ''
}
