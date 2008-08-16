/mob/proc/death()
	src.is_dead = 1
	src.canmove = 0

	//let dead people see anything, there's no resurrection any more anyways
	if(src.client)
		src.client.mob = new/mob/observer(src)

	var/cancel
	spawn(50)
		for(var/mob/M in world)
			if(M.client && !M.is_dead)
				cancel = 1
		if(cancel)
			return
		world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"
		if(ticker && ticker.timing)
			ticker.check_win()
			return
		spawn(300)
			for(var/mob/M in world)
				if(M.client && !M.is_dead)
					cancel = 1
			if(!cancel)
				world.log_game("Rebooting because of no live players")
				world.Reboot()
	return ..()
