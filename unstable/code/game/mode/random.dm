/datum/game_mode/random
	name = "random"
	var/datum/game_mode/m

	proc/ensure_m()
		if(!m)
			m = config.pick_random_mode()

	announce()
		ensure_m()
		return m.announce()

	setup()
		ensure_m()
		return m.setup()

	execute()
		ensure_m()
		return m.execute()