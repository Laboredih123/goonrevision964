/datum/game_mode/random
	name = "random"
	var/datum/game_mode/m

	proc/ensure_m()
		if(!m)
			m = config.pick_random_mode()
			world.log_game("Random mode, mode selected: [m.name]")

	announce()
		ensure_m()
		return m.announce()

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

	get_desc() // includes spoilers etc, is only shown to dead people
		ensure_m()
		return m.get_desc()