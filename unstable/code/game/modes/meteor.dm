/datum/game_mode/meteor
	name = "meteor"

/datum/game_mode/meteor/announce()
	world << "<B>A major meteor shower is approaching the station! You must escape from the station, or survive the onslaught.</B>"

/datum/game_mode/meteor/setup()
	missions[new/datum/mission/survival()] = MISSION_ACTIVE
	missions[new/datum/mission/spawn_meteors(rand(30,100),rand(1,15),30)] = MISSION_ACTIVE
