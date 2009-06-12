/datum/gene/xray_vision
	default = JUNK
	var/const/XRAY_VISION = "SUPERMAN"
	is_superpower = 1

	New()
		attributes = list(XRAY_VISION)

	apply(mob/carbon/M, attribute)
		M.has_xray_vision = (attribute == XRAY_VISION)

	pick_attribute(mob/carbon/M)
		if(M.has_xray_vision)
			return XRAY_VISION
		else
			return JUNK