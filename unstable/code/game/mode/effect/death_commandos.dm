/datum/effect/death_commandos/New(time_start = 600 * 60, time_offset = 600 * 10, chance = 25)
	// starting at time_start and every time_offset after that, has a chance chance of calling in...
	// _____ _  _ ___   ___  ___   _ _____ _  _    ___ ___  __  __ __  __   _   _  _ ___   ___  ___
	//|_   _| || | __| |   \| __| /_\_   _| || |  / __/ _ \|  \/  |  \/  | /_\ | \| |   \ / _ \/ __|
	//  | | | __ | _|  | |) | _| / _ \| | | __ | | (_| (_) | |\/| | |\/| |/ _ \| .` | |) | (_) \__ \
	//  |_| |_||_|___| |___/|___/_/ \_\_| |_||_|  \___\___/|_|  |_|_|  |_/_/ \_\_|\_|___/ \___/|___/
	// time_start and time_offset are both in 1/10 seconds
	// chance is a percent
	spawn(time_start)
		while(1)
			if(prob(chance))
				break
			sleep(time_offset)

		station_announce("Central Command has learned that subversive elements are present on Space Station 13.")
		station_announce("Trained commandos will arrive to liquidate the station shortly.")

		commando_shuttle.callize()
		station_announce("Central Command battleships will arrive in five minutes.")
		current_mode.termination_conditions += new /datum/termination_condition/time_limit(5 * 600, "Battleships have arrived. No way you guys are escaping now.")