/datum/game_mode/virus
	name = "virus"
	config_tag = "virus"

/datum/game_mode/virus/announce()
	world << "<B>The current game mode is - Virus!</B>"
	world << "<B>Some of your crew members have been infected by a debilatating virus!</B>"
	world << "<B>How many can escape alive? No one with the virus can escape!</B>"

/datum/game_mode/virus/post_setup()
	spawn (50)
		var/list/mobs = list()
		for(var/mob/carbon/M in world)
			if (M.client && M.start)
				mobs += M

		if (mobs.len > 3)
			var/amount = round(mobs.len / 3)
			amount = min(3, amount)
			while(amount > 0)
				var/mob/carbon/H = pick(mobs)
				H.virus = 1
				mobs -= H
				amount--
	spawn (0)
		ticker.extend_process()

/datum/game_mode/virus/check_win()
	var/humanwin = 1
	var/area/A = locate(/area/shuttle)
	var/list/shuttle = list(  )
	for(var/mob/carbon/M in world)
		var/T = M.loc
		if (istype(T, /turf))
			if ((T in A))
				shuttle += M
				if (M.virus > 0)
					humanwin = 0
		//Foreach goto(1540)
	var/dead = list(  )
	var/alive = list(  )
	var/escapees = list(  )
	for(var/mob/M in world)
		if (M.stat == 2)
			if (M.client)
				if (M.virus > 0)
					dead += text("<B>[]</B> died. \red (Had Stage [] Infection)", M.rname, round(M.virus))
				else
					dead += text("<B>[]</B> died.", M.rname)
		else
			if (shuttle.Find(M))
				if (M.virus > 0)
					escapees += text("<B>[] escaped on the shuttle. \red (Has Stage [] Infection)</B>", M.rname, round(M.virus))
				else
					escapees += text("<B>[] escaped on the shuttle.</B>", M.rname)
			else
				if (M.virus > 0)
					alive += text("<B>[]</B> was left infected. \red (Has Stage [] Infection)", M.rname, round(M.virus))
				else
					alive += text("<B>[]</B> was left to be infected on Space Station 13.", M.rname)
	if (humanwin)
		world << "<FONT size = 3><B>The Research Staff have won!</B></FONT>"
	else
		world << "<FONT size = 3><B>The Virus has won!</B></FONT>"
	for(var/I in escapees)
		world << text("<FONT size = 2>[]</FONT>", I)
	for(var/I in alive)
		world << text("<FONT size = 2>[]</FONT>", I)
	for(var/I in dead)
		world << text("<FONT size = 1>[]</FONT>", I)
	return 1