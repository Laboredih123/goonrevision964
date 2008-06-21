/mob/carbon/Life()
	set invisibility = 0
	set background = 1

	var/turf/T = src.loc

	if (src.client)
		src.hud.update()
		if (src.machine)
			if (!src.machine.check_eye(src))
				src.reset_view(null)
		else
			if(!client.adminobs)
				reset_view(null)

	if (src.is_dead)
		src.lying = 1
		src.blinded = 1
		src.stat = 2
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

	src.breathe()
	src.check_decompression()

	if (src.get_damage() > death_threshold)
		death()
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
		src.heal_damage(new datum/damage(toxin = 3))

	src.handle_knockout()
	src.handle_knockdown()

	if (src.buckled)
		src.lying = 0
	src.density = !src.lying

	src.update_grabs()

	return