/datum/gene/hair_style
	default = HAIR_STYLE_SHORT

/datum/gene/hair_style/New()
	attributes = get_hair_styles()

/datum/gene/hair_style/apply(mob/carbon/M, attribute)
	M.hair_style = attribute

/datum/gene/hair_style/pick_attribute(mob/carbon/M)
	return M.hair_style