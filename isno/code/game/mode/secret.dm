/datum/game_mode/random/secret
	config_name = "secret"
	long_name = "Secret"
	desc = "Who knows? Nobody!"

	ensure_m()
		if(!m)
			m = config.pick_random_mode()
			world.log_game("Secret mode, mode selected: [m.long_name]")

	announce()
		return