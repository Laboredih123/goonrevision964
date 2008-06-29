/datum/gene/hair_color
	default = HAIR_COLOR_GREY

	New()
		attributes = get_hair_colors()

	apply(mob/carbon/M, attribute)
		M.hair_color = attribute

	pick_attribute(mob/carbon/M)
		return M.hair_color