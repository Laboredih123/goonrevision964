/mob/carbon/Life()
	set background = 1

	..()
	if(src.client && src.hud)	src.hud.update()

	if(src.is_dead)
		src.canmove = 0
		if(src.lying)	src.icon = src.lying_icon
		else			src.icon = src.stand_icon
		if(!src.buckled)
			src.density = !src.lying
		else
			src.density = 1
		src.update_grabs()
		src.update_clothing()
		return

	src.lying = 0
	src.canmove = 1
	src.is_blind = src.is_perma_blind

	if(!src.m_flag)	src.moved_recently = 0
	src.m_flag = null

	if(src.hud && src.hud.machine)
		src.hud.machine.icon_state = (src.machine ? "mach1" : "blank")

	src.breathe()
	src.check_burning()
	src.check_decompression()

	if(src.get_damage() > death_threshold)	src.death()
	else if(src.get_damage() > unconsciousness_threshold)
		if(prob(1))	src.gasp()
		src.knockout_until(5)
		if(src.rejuv <= 0)
			src.take_damage(suffocation = 2)
	else if(src.get_damage() > blackout_threshold)
		if(prob(5))
			if(prob(1)) src.gasp()
			src.knockout_until(2)
	else if(src.sleeping)
		if(prob(1))	src.snore()
		src.knockout_until(2)
	else if(src.resting)
		src.knockdown_until(5)

	src.rejuv = max(0, src.rejuv - 1)
	if(src.antitoxs >= 1)
		src.antitoxs--
		src.heal_damage(toxin = 3)
	if(src.plasma >= 1)
		src.plasma--
		src.take_damage(toxin = 1)

	src.heal_damage(suff = 1)

	if(src.drowsyness > 0)
		src.drowsyness--
		if(prob(5))
			src.sleeping = 1
			src.knockout += 5

	src.handle_knockout()
	src.handle_knockdown()

	if(!src.buckled)
		src.density = !src.lying
	else
		src.density = 1

	src.update_grabs()

	if(!src.lying) src.icon = stand_icon
	else
		src.canmove = 0
		src.icon = src.lying_icon
	src.update_clothing()

	if(!src.client)
		if(src.is_active() && src.canmove && prob(1) && isturf(src.loc) && !src.resting)
			step(src, pick(NORTH, SOUTH, EAST, WEST))
		if(prob(0.1) && src.is_conscious())
			pick(src.sigh(), src.yawn(), src.cough(), src.tail())

/mob/carbon/proc/check_burning()
	if(!src.loc) return
	var/turf/T = src.loc
	if(!isturf(T)) return
	if(T.firelevel < 900000) return
	if(!T.gas || !T.gas.total()) return
	var/resist = T0C + 80	//	highest non-burning temperature
	var/fire_dam = T.gas.temp
	if(src.suit) resist = src.suit.fire_resist
	if(fire_dam < resist) return
	src.take_damage(burn = (fire_dam-resist)/50)
