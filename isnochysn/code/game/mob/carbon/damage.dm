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
		else
	src.take_damage(new damage(brute = brute_loss, burn = burn_loss))
	return

/mob/carbon/take_damage(datum/damage/dam)
	if(src.appearance == HUMAN)
		var/atom/organ/O = src.choose_organ()
		if (istype(O, /atom/organ))
			O.take_damage(dam)
			src.update_damage()
	else
		return ..()

/mob/carbon/heal_damage(datum/damage/dam)
	if(src.appearance == HUMAN)
		for(var/atom/organ/O in src.organs)
			dam = O.heal_damage(dam) //returns a smaller damage, or null if it's all used up
			if(!dam) //all done!
				break
		src.update_damage()
	else
		return ..()

/mob/carbon/proc/update_damage()
	if(src.appearance == HUMAN)
		src.dam = new damage()
		for(var/atom/organ/O in src.organs)
			src.dam.add(x.dam)
		src.update_damage_icon()
	else
		return ..()

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
	if(src.appearance == HUMAN)
		return pick(src.organs)