/datum/gene/hair_color
	default = HAIR_COLOR_GREY

/datum/gene/hair_color/New()
	attributes = get_hair_colors()

/datum/gene/hair_color/apply(mob/carbon/M, attribute)
	M.hair_color = attribute

/datum/gene/hair_color/pick_attribute(mob/carbon/M)
	return M.hair_color