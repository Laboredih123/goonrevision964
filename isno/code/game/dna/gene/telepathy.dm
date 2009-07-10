/datum/gene/telepathy
	default = JUNK
	var/const/TELEPATHIC = "BIGBROTHER"
	is_superpower = 1

	New()
		attributes = list(TELEPATHIC)

	apply(mob/carbon/M, attribute)
		M.is_telepathic = (attribute == TELEPATHIC)

	pick_attribute(mob/carbon/M)
		if(M.is_telepathic)
			return TELEPATHIC
		else
			return JUNK