/mob/silicon/take_damage(brute, burn, suffocation, toxin, electric)
	toxin = 0
	suffocation = 0
	..(brute, burn, suffocation, toxin, electric)

/mob/silicon/ex_act(severity)
	switch(severity)
		if(1.0)
			src.take_damage(brute = 100, burn = 100)
		if(2.0)
			src.take_damage(brute = 60, burn = 60)
		if(3.0)
			src.take_damage(brute = 30, burn = 30)