/mob/carbon/Life()
	set invisibility = 0
	set background = 1

	..()
	if(src.client && src.hud)
		src.hud.update()

	if (src.is_dead)
		src.lying = 1
		src.is_blind = 1
		src.canmove = 0
		if (src.buckled)
			src.lying = 0
		return

	src.is_blind = 0

	if (!src.m_flag)
		src.moved_recently = 0
	src.m_flag = null

	if (src.hud && src.hud.machine)
		if (src.machine)
			src.hud.machine.icon_state = "mach1"
		else
			src.hud.machine.icon_state = null

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

	src.handle_knockout()
	src.handle_knockdown()

	if (src.buckled)
		src.lying = 0
	src.density = !src.lying

	src.update_grabs()

	return