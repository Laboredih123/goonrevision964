/mob/carbon/Life()
	set invisibility = 0
	set background = 1

	..()
	if(src.client && src.hud)
		src.hud.update()
	src.lying = 0
	if (src.is_dead)
		src.lying = 1
		src.is_blind = 1
		src.canmove = 0
		if (src.buckled)
			src.lying = (istype(src.buckled, /obj/stool/bed)) ? 1 : 0
		if(src.lying)
			src.icon = src.lying_icon
			src.update_clothing()
		else
			src.icon = src.stand_icon
			src.update_clothing()
		return

	src.canmove = 1

	src.is_blind = src.is_perma_blind

	if (!src.m_flag)
		src.moved_recently = 0
	src.m_flag = null

	if (src.hud && src.hud.machine)
		if (src.machine)
			src.hud.machine.icon_state = "mach1"
		else
			src.hud.machine.icon_state = "blank"

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
	if(src.antitoxs >= 1)
		src.antitoxs--
		src.heal_damage(toxin = 3)
	if(src.plasma >= 1)
		src.plasma--
		src.take_damage(toxin = 1)

	if (src.drowsyness > 0)
		src.drowsyness--
		if(prob(5))
			src.sleeping = 1
			src.knockout += 5


	src.handle_knockout()
	src.handle_knockdown()

	if (src.buckled)
		src.lying = (istype(src.buckled, /obj/stool/bed)) ? 1 : 0
		src.density = 1
	else
		src.density = !src.lying

	src.update_grabs()

	if(src.lying)
		src.icon = src.lying_icon
		src.update_clothing()
		src.canmove = 0
	else
		src.icon = src.stand_icon
		src.update_clothing()
	return
