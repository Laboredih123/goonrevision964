// these are strings instead of integers both because it makes selecting them in prespawn simpler,
// and because BYOND doesn't allow integer keys into hashes (well, lists)

/var/const
	HAIR_STYLE_SHORT = "short"
	HAIR_STYLE_LONG = "long"
	HAIR_STYLE_CUT = "cut"
	HAIR_STYLE_BALD = "bald"

/proc/get_hair_styles()
	return list(
		HAIR_STYLE_SHORT,
		HAIR_STYLE_LONG,
		HAIR_STYLE_CUT,
		HAIR_STYLE_BALD
	)

/datum/gene/hair_style
	default = HAIR_STYLE_SHORT

	New()
		attributes = get_hair_styles()

/datum/gene/hair_style/apply(mob/carbon/M, attribute)
	. = ..()
	if(!.) return
	M.hair_style = attribute