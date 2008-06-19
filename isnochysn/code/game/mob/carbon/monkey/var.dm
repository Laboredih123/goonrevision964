/mob/carbon/monkey
	name = "monkey"
	icon = 'monkey.dmi'
	icon_state = "monkey1"
	flags = FPRINT & TABLEPASS

	New()
		if(src.name == "monkey")
			src.name += " ([rand(1000)])"
		..()