/datum/game_mode/meteor
	name = "meteor"

	announce()
		world << "<B>A major meteor shower is approaching the station! You must escape from the station, or survive the onslaught.</B>"

	setup()
		missions += new /datum/mission/survival()
		termination_conditions += new /datum/termination_condition/shuttle()

	execute()
		new /datum/effect/meteors(rand(30,100),rand(1,15),30)
		..()
