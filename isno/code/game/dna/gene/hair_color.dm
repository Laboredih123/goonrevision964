/datum/gene/hair_color
	default = HAIR_COLOR_GREY
	is_noticeable = 1

	New()
		attributes = get_hair_colors()

	apply(mob/carbon/M, attribute)
		M.hair_color = attribute

	pick_attribute(mob/carbon/M)
		return M.hair_color