/datum/game_mode/secret
	name = "secret"
	var/datum/game_mode/m = null

	proc/ensure_m()
		if(!m)
			m = config.pick_random_mode()
			world.log_game("Secret mode, mode selected: [m.name]")

	announce()
		return

	setup()
		ensure_m()
		return m.setup()

	execute()
		ensure_m()
		return m.execute()

	add_mission(datum/mission/mission)
		ensure_m()
		m.add_mission(mission)

	get_traitors()
		ensure_m()
		return m.get_traitors()