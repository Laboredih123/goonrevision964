/mob/carbon/Life()
	..()
	if(src.client)
		src.hud.update()
	set invisibility = 0
	set background = 1

	var/turf/T = src.loc

	if (src.is_dead)
		src.lying = 1
		src.blinded = 1
		src.canmove = 0
		if (src.buckled)
			src.lying = 0
		return

	src.blinded = 0

	if (!src.m_flag)
		src.moved_recently = 0
	src.m_flag = null

	if (src.mach)
		if (src.machine)
			src.mach.icon_state = "mach1"
		else
			src.mach.icon_state = null

	var/turf/T = src.loc
	if (istype(T, /turf))
		var/ficheck = src.firecheck(T)
		if (ficheck)
			src.take_damage(burn = ficheck * 10)

	src.breathe()
	src.check_decompression()

	if (src.get_damage() > death_threshold)
		src.death()
	else if (src.get_damage() > unconsciousness_threshold)
		if (prob(1))
			src.gasp()
		src.knockout_until(5)
		if(src.rejuv <= 0)
			src.take_damage(suffocation = 2)
	else if (src.get_damage() > blackout_threshold)
		if (prob(5))
			if(prob(1))
				src.gasp()
			src.knockout_until(2)
	else if (src.sleeping)
		if (prob(1))
			src.snore()
		src.knockout_until(2)
	else if (src.resting)
		src.knockdown_until(5)

	src.rejuv = max(0, src.rejuv - 1)
	src.blinded = null
	if(src.antitoxs >= 1)
		src.antitoxs -= 1
		src.heal_damage(toxin = 3)

	src.handle_knockout()
	src.handle_knockdown()

	if (src.buckled)
		src.lying = 0
	src.density = !src.lying

	src.update_grabs()

	return