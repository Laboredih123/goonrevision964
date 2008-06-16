/mob/silicon/proc/take_damage(damage)
	damage.toxin = 0
	damage.suffocation = 0
	damage.electric *= 10
	src.damage.add(damage)

/mob/silicon/ex_act(severity)
	flick("flash", src.flash)

	switch(severity)
		if(1.0)
			src.take_damage(new datum/damage(brute = 100, burn = 100)
		if(2.0)
			src.take_damage(new datum/damage(brute = 60, burn = 60)
		if(3.0)
			src.take_damage(new datum/damage(brute = 30, burn = 30)