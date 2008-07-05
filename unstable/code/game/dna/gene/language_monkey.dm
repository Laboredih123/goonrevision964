/datum/gene/language_monkey
	default = JUNK

	New()
		attributes = list(LANGUAGE_MONKEY)

	pre_apply(mob/carbon/M)
		M.languages -= LANGUAGE_MONKEY
		M.languages += LANGUAGE_NONE
		M.curr_language = LANGUAGE_NONE

	apply(mob/carbon/M, attribute)
		if(attribute == LANGUAGE_MONKEY && M.appearance != APPEARANCE_QUIVERING_MASS)
			M.languages -= LANGUAGE_NONE
			M.languages += LANGUAGE_MONKEY
			if(M.curr_language != LANGUAGE_ENGLISH) //english is a higher priority
				M.curr_language = LANGUAGE_MONKEY

	pick_attribute(mob/carbon/M)
		if(LANGUAGE_MONKEY in M.languages)
			return LANGUAGE_MONKEY
		else
			return JUNK