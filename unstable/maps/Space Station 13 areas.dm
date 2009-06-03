/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)

*/

/area/maintenance/north
	name = "North Maintenance"
	icon_state = "green"

/area/maintenance/northeast
	name = "NorthEast Maintenance"
	icon_state = "green"

/area/maintenance/west
	name = "West Maintenance"
	icon_state = "green"

/area/maintenance/south
	name = "South Maintenance"
	icon_state = "green"

/area/maintenance/storage
	name = "Maintenance Storage"
	icon_state = "green"

/area/hallway/primary/north
	name = "North Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/primary/east
	name = "East Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/primary/south
	name = "South Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/primary/west
	name = "West Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/secondary/exit
	name = "Exit Shuttle Hallway"
	icon_state = "yellow"

/area/hallway/secondary/entry
	name = "Entry Shuttle Hallway"
	icon_state = "yellow"

/area/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/crew_quarters/male
	name = "Male Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/female
	name = "Female Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/heads
	name = "Head of Staff's Quarters"
	icon_state = "crew_quarters"

/area/engine/engine_smes
	name = "Engine SMES Room"
	icon_state = "engine"

/area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"
	requires_power = 0

/area/engine/engine_gas_storage
	name = "Engine Storage"
	icon_state = "engine_gas_storage"

/area/engine/engine_hallway
	name = "Engine Hallway"
	icon_state = "engine_hallway"

/area/engine/engine_mon
	name = "Engine Monitoring"
	icon_state = "engine_monitoring"

/area/engine/combustion
	name = "Combustion Chamber"
	icon_state = "combustion"

/area/engine/engine_control
	name = "Engine Control"
	icon_state = "engine_control"

/area/prototype/prototype_engine
	name = "Prototype Engine"
	icon_state = "prototype_engine"

/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"

/area/medical/research
	name = "Genetic Research"
	icon_state = "medresearch"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"

/area/security/main
	name = "Main Security"
	icon_state = "security"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/forensics
	name = "Forensics"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/solar/north
	name = "North Solar Array"
	icon_state = "yellow"

/area/solar/south
	name = "South Solar Array"
	icon_state = "south"

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"

/area/toxins/lab
	name = "Toxin Lab"
	icon_state = "toxlab"

/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxlab"

/area/toxins/test_chamber
	name = "Toxin Test Chamber"
	icon_state = "toxlab"

/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapel"

/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "storage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "storage"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "storage"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_upload"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai"

/area/shuttle
	requires_power = 0
	name = "Escape Shuttle"
	icon_state = "shuttle"

/area/death_commando_shuttle
	requires_power = 0
	name = "Death Commando Shuttle"
	icon_state = "shuttle"

/area/prespawn
	requires_power = 0
	name = "Prespawn Area"