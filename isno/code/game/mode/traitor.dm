/datum/game_mode/random/traitor
	config_name = "traitor"
	long_name = "Traitor"
	desc = "There's a traitor on the station somewhere!"
	min_players = 1

	ensure_m()
		if(!m)
			m = new /datum/game_mode/multitraitor(1)

	announce()
		return "LOOK OUT, THERE'S A TRAITOR ON BOARD!"