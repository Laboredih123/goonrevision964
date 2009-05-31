/datum/game_mode/traitor
	name = "traitor"
	min_players = 1
	var/datum/game_mode/m = null

	proc/ensure_m()
		if(!m)
			m = new /datum/game_mode/multitraitor(1)

	announce()
		return "LOOK OUT, THERE'S A TRAITOR ON BOARD!"

	setup()
		ensure_m()
		return m.setup()

	execute()
		ensure_m()
		return m.execute()

	add_mission(datum/mission/mission)
		m.add_mission(mission)

	get_traitors()
		return m.get_traitors()