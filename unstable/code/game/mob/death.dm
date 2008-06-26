/mob/proc/death()
	src.is_dead = 1
	src.canmove = 0

	//let dead people see anything, there's no resurrection any more anyways
	src.sight |= SEE_TURFS
	src.sight |= SEE_MOBS
	src.sight |= SEE_INFRA
	src.sight |= SEE_OBJS
	src.see_in_dark = 8
	src.see_invisible = 2
	src.see_infrared = 8

	var/cancel
	spawn(50)
		for(var/mob/M in world)
			if (M.client && !M.is_dead)
				cancel = 1
		if (!( cancel ))
			world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"
			if ((ticker && ticker.timing))
				ticker.check_win()
			else
				spawn( 300 )
					world.log_game("Rebooting because of no live players")
					world.Reboot()
	return ..()