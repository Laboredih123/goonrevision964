/datum/gene/language_english
	default = JUNK

	New()
		attributes = list(LANGUAGE_ENGLISH)

	pre_apply(mob/carbon/M)
		M.languages -= LANGUAGE_ENGLISH
		M.languages += LANGUAGE_NONE
		M.curr_language = LANGUAGE_NONE

	apply(mob/carbon/M, attribute)
		if(attribute == LANGUAGE_ENGLISH && M.appearance != APPEARANCE_QUIVERING_MASS)
			M.languages -= LANGUAGE_NONE
			M.languages += LANGUAGE_ENGLISH
			M.curr_language = LANGUAGE_ENGLISH

	pick_attribute(mob/carbon/M)
		if(LANGUAGE_ENGLISH in M.languages)
			return LANGUAGE_ENGLISH
		else
			return JUNK