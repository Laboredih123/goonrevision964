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