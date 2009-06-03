/datum/effect/death_commandos/New(time_start = 300, time_offset = 300, chance = 50)
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
		world << "DEATH COMMANDOS INCOMING"