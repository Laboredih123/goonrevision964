/mob/carbon/ex_act(severity)

	flick("flash", src.flash)
	var/brute_loss = 0
	var/burn_loss = 0
	var/ear_loss = 0
	switch(severity)
		if(1)
			brute_loss = 100
			burn_loss = 100
			ear_loss = 50
		if(2)
			brute_loss = 60
			burn_loss = 60
			ear_loss = 30
			if (prob(50))
				src.paralysis += 30
		if(3)
			brute_loss = 30
			ear_loss = 15
			if (prob(50))
				src.paralysis += 10
	src.take_damage(new damage(brute = brute_loss, burn = burn_loss))
	return

/mob/carbon/take_damage(datum/damage/dam)
	var/atom/organ/O = src.choose_organ()
	if (istype(O, /atom/organ))
		O.take_damage(dam)
		src.update_damage()

/mob/carbon/heal_damage(datum/damage/dam)
	for(var/atom/organ/O in src.organs)
		dam = O.heal_damage(dam) //returns a smaller damage, or null if it's all used up
		if(!dam) //all done!
			break
	src.update_damage()

/mob/carbon/proc/update_damage()
	src.dam = new damage()
	for(var/atom/organ/O in src.organs)
		src.dam.add(x.dam)
	src.update_damage_icon()

/mob/carbon/proc/update_damage_icon()
	if(src.appearance == HUMAN)
		src.body_standing = list()
		src.body_lying = list()
		var/icon/dam_icon
		for(var/atom/organ/O in src.organs)
			body_standing += O.dam_icon_standing
			body_lying += O.dam_icon_lying
	else
		return ..()

/mob/carbon/proc/choose_organ()
	return pick(src.organs)

/mob/carbon/blob_act()
	for(var/mob/O in viewers(M, null))
		O.see("\red <B>[M] has been attacked by the blob.</B>")
	var/datum/damage/dam = new /datum/damage(brute = rand(5,25))
	if(!istype(/mob/carbon/, M))
		M.take_damage(dam)
		return
	if ((M.helmet && M.helmet.brute_protect & 1) || (M.mask && M.mask.brute_protect & 1) && prob(5))
		M.think("\red Your helmet softened the blow.")
		dam.brute /= 2
	else if((M.suit && M.suit.brute_protect & 2) || (M.jumpsuit && M.jumpsuit.brute_protect & 2) && prob(20))
		M.think("\red Your armor softened the blow.")
		dam.brute /= 2

	if (prob(dam.brute + M.dam.brute/5)) //knock 'em out
		if(M.conscious())
			for(var/mob/O in oviewers(M))
				O.see("\red <B>[M] has been knocked unconscious!</B>")
		var/time = rand(10, 120)
		if (H.paralysis < time)
			H.paralysis = time
		else if (H.weakened < time)
			H.weakened = time
			H.stat = 1

	src.take_damage(dam)

/mob/carbon/death()

	if(src.healths)
		src.healths.icon_state = "dead"
	src.is_dead = 1
	src.canmove = 0
	src.blind.layer = 0
	src.lying = 1
	//src.icon_state = "dead"
	var/cancel
	for(var/mob/M in world)
		if ((M.client && !( M.stat )))
			cancel = 1
		//Foreach goto(67)
	if (!( cancel ))




		spawn(50)
			cancel = 0
			for(var/mob/M in world)
				if ((M.client && !( M.stat )))
					cancel = 1
				//Foreach goto(67)
			if (!( cancel ))

				world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"
				if ((ticker && ticker.timing))
					ticker.check_win()
				else
					spawn( 300 )
						world.log_game("Rebooting because of no live players")
						world.Reboot()
						return
	return ..()