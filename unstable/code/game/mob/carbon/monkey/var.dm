/mob/carbon/monkey
	name = "monkey"

	New(loc)
		if(src.name == "monkey")
			src.name += " ([rand(10000)])"
		..(loc, src.name)