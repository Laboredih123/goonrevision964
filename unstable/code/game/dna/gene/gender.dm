/datum/gene/gender
	default = MALE

	New()
		attributes = list(MALE, FEMALE)

	apply(mob/carbon/M, attribute)
		M.gender = attribute

	pick_attribute(mob/carbon/M)
		return M.gender