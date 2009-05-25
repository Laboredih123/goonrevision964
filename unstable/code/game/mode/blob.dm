/datum/game_mode/blob
	name = "blob"

	announce()
		world << "<B>A dangerous alien organism is rapidly spreading throughout the station!</B>"
		world << "You must kill it before it destroys the station."

	setup()
		new /datum/effect/blob(1)
		missions += new /datum/mission/station_integrity(min_remaining = 5)
		termination_conditions += new /datum/termination_condition/blob_destroyed()
