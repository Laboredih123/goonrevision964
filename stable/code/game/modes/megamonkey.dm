/datum/game_mode/megamonkey
	name = "mega monkey"
	config_tag = "megamonkey"

/datum/game_mode/megamonkey/announce()
	world << "<B>The current game mode is - Mega Monkey!</B>"
	world << "<B>Retake the station from the mutant monkeys!</B>"
	world << "You must disable or kill all monkeys on the station to win."

/datum/game_mode/megamonkey/post_setup()
	spawn (1)
		for(var/mob/monkey/M in world)
			del(M)

		for (var/turf/T in monkeystart)
			new /mob/megamonkey(T)

	spawn (50)
		ticker.megamonkey_process()

/datum/game_mode/megamonkey/check_win()
	var/success = 1
	for(var/mob/megamonkey/M in world)
		if(M.stat == 0 && M.z == 1)				// check for concious, alive monkeys in SS13 maplevel
			success = 0
			break

	if(success)
		world << "<FONT size = 3><B>The humans have won!</B></FONT>"
		world << "<B>The station has been retaken from the mutant monkeys</B>"
		world.log_game("Humans have destroyed all monkeys")
	return 1