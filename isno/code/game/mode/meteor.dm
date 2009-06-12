/datum/game_mode/meteor
	config_name = "meteor"
	long_name = "Meteor"
	desc = "Survive all the meteors that hit the station."

	announce()
		world << "<B>A major meteor shower is approaching the station! You must escape from the station.</B>"

	setup()
		missions += new /datum/mission/escape()
		termination_conditions += new /datum/termination_condition/shuttle(emergency_shuttle)

	execute()
		new /datum/effect/meteors(70,15,30)
		..()
