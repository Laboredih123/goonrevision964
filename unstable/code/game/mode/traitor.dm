/datum/game_mode/random/traitor
	name = "traitor"
	min_players = 1

	ensure_m()
		if(!m)
			m = new /datum/game_mode/multitraitor(1)

	announce()
		return "LOOK OUT, THERE'S A TRAITOR ON BOARD!"