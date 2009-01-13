/datum/game_mode/traitor
	name = "traitor"

	announce()
		world << "<B>A dangerous alien organism is rapidly spreading throughout the station!</B>"
		world << "You must kill it before it destroys the station."

	setup()
		blobs = list()
		new/obj/blob(pick(blobstart))
		missions[new/datum/mission/station_damage(5)] = MISSION_ACTIVE
		missions[new/datum/mission/destroy("blob",blobs)] = MISSION_ACTIVE
