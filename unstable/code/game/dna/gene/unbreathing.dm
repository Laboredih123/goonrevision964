/datum/gene/unbreathing
	default = JUNK
	var/const/UNBREATHING = "THAT THING IS NOT BREATHING AUGH"
	is_superpower = 1

	New()
		attributes = list(UNBREATHING)

	apply(mob/carbon/M, attribute)
		M.unbreathing = (attribute == UNBREATHING)

	pick_attribute(mob/carbon/M)
		if(M.unbreathing)
			return UNBREATHING
		else
			return JUNK