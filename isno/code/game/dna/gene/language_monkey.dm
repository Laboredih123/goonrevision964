/datum/gene/language_monkey
	default = JUNK

	New()
		attributes = list(LANGUAGE_MONKEY)

	pre_apply(mob/carbon/M)
		M.languages -= LANGUAGE_MONKEY
		M.languages = uniquelist(M.languages + LANGUAGE_NONE)
		M.curr_language = LANGUAGE_NONE
		M.verbs -= /mob/verb/switch_language

	apply(mob/carbon/M, attribute)
		M.languages = uniquelist(M.languages)
		if(attribute == LANGUAGE_MONKEY && M.appearance != APPEARANCE_QUIVERING_MASS)
			M.languages -= LANGUAGE_NONE
			M.languages += LANGUAGE_MONKEY
			if(M.curr_language != LANGUAGE_ENGLISH) //english is a higher priority
				M.curr_language = LANGUAGE_MONKEY
			if(M.languages.len > 1 && !(/mob/verb/switch_language in M.verbs))
				M.verbs += /mob/verb/switch_language

	pick_attribute(mob/carbon/M)
		if(LANGUAGE_MONKEY in M.languages)
			return LANGUAGE_MONKEY
		else
			return JUNK