/datum/gene/gender
	default = MALE
	is_noticeable = 1

	New()
		attributes = list(MALE, FEMALE)

	apply(mob/carbon/M, attribute)
		M.gender = attribute

	pick_attribute(mob/carbon/M)
		return M.gender