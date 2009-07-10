/datum/game_mode/blob
	config_name = "blob"
	long_name = "Blob"
	desc = "Kill the dangerous blob before it eats everything."

	announce()
		world << "<B>A dangerous alien organism is rapidly spreading throughout the station!</B>"
		world << "You must kill it before it destroys the station."

	setup()
		missions += new /datum/mission/station_integrity(min_remaining = 5)

	execute()
		new /datum/effect/blob(1)
		src.add_termination_condition(new /datum/termination_condition/blob_destroyed())
