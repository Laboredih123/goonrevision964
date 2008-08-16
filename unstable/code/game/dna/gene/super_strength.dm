/datum/gene/super_strength
	default = JUNK
	var/const/SUPER_STRONG = "HULK"

	New()
		attributes = list(SUPER_STRONG)

	apply(mob/carbon/M, attribute)
		M.has_super_strength = (attribute == SUPER_STRONG)

	pick_attribute(mob/carbon/M)
		if(M.has_super_strength)
			return SUPER_STRONG
		else
			return JUNK