/datum/gene/fire_immune
	default = JUNK
	var/const/FIRE_IMMUNE = "BURN"

	New()
		attributes = list(FIRE_IMMUNE)

	apply(mob/carbon/M, attribute)
		M.is_fire_immune = (attribute == FIRE_IMMUNE)

	pick_attribute(mob/carbon/M)
		if(M.is_fire_immune)
			return FIRE_IMMUNE
		else
			return JUNK