/datum/game_mode/random/secret
	name = "secret"

	ensure_m()
		if(!m)
			m = config.pick_random_mode()
			world.log_game("Secret mode, mode selected: [m.name]")

	announce()
		return