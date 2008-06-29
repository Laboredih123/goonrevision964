/datum/gene/hair_style
	default = HAIR_STYLE_SHORT

	New()
		attributes = get_hair_styles()

	apply(mob/carbon/M, attribute)
		M.hair_style = attribute

	pick_attribute(mob/carbon/M)
		return M.hair_style