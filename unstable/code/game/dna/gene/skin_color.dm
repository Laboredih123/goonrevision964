/datum/gene/skin_color
	default = SKIN_COLOR_LIGHT

	New()
		attributes = get_skin_colors()

	apply(mob/carbon/M, attribute)
		M.skin_color = attribute

	pick_attribute(mob/carbon/M)
		return M.skin_color