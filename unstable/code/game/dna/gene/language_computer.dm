/datum/gene/language_computer
	default = JUNK

	New()
		attributes = list(LANGUAGE_COMPUTER)

	pre_apply(mob/carbon/M)
		M.languages -= LANGUAGE_COMPUTER
		M.languages += LANGUAGE_NONE
		M.curr_language = LANGUAGE_NONE

	apply(mob/carbon/M, attribute)
		if(attribute == LANGUAGE_COMPUTER && M.appearance != APPEARANCE_QUIVERING_MASS)
			M.languages -= LANGUAGE_NONE
			M.languages += LANGUAGE_COMPUTER
			if(M.curr_language != LANGUAGE_ENGLISH && M.curr_language != LANGUAGE_MONKEY)
				M.curr_language = LANGUAGE_COMPUTER

	pick_attribute(mob/carbon/M)
		if(LANGUAGE_COMPUTER in M.languages)
			return LANGUAGE_COMPUTER
		else
			return JUNK