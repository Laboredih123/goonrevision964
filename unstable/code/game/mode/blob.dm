/datum/game_mode/blob
	name = "blob"

/datum/game_mode/blob/announce()
	world << "<B>A dangerous alien organism is rapidly spreading throughout the station!</B>"
	world << "You must kill it before it destroys the station."

/datum/game_mode/blob/setup()
	new /datum/effect/blob(1)
	missions[new/datum/mission/station_integrity(5)] = MISSION_ACTIVE
	missions[new/datum/mission/destroy("blob",blobs)] = MISSION_ACTIVE
