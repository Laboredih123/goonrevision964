/mob/var/datum/damage/dam = new /datum/damage()

/mob/proc/take_damage(datum/damage/dam)
	src.dam.add(dam)

/mob/proc/heal_damage(datum/damage/dam)
	src.dam.subtract(dam)

/mob/proc/get_damage()
	return src.dam

/mob/blob_act()
	for(var/mob/O in viewers(M, null))
		O.see("\red <B>[M] has been attacked by the blob.</B>")
	M.take_damage(new /datum/damage(brute = rand(5,25)))

/mob/meteorhit(obj/O)
	for(var/mob/M in viewers(src, null))
		M.see("\red [src] has been hit by [O]"
	src.take_damage(new datum/damage(brute = 40, burn = 40)

/mob/death()
	src.is_dead = 1
	src.canmove = 0
	src.lying = 1

	//let dead people see anything, there's no resurrection any more anyways
	src.blind.layer = 0
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