/mob/carbon/monkey
	name = "monkey"

	New()
		if(src.name == "monkey")
			src.name += " ([rand(10000)])"
		..()