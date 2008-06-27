/mob/carbon/monkey
	name = "monkey"

	flags = FPRINT & TABLEPASS

	New()
		if(src.name == "monkey")
			src.name += " ([rand(10000)])"
		..()