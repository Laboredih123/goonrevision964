/mob/carbon/monkey
	name = "monkey"
	gender = NEUTER

	New(loc)
		if(src.name == "monkey")
			src.name += " ([rand(10000)])"
		if(src.gender == NEUTER)
			src.gender = pick(MALE, FEMALE)
		..(loc, src.name)