/datum/gene/language_computer
	default = JUNK

	New()
		attributes = list(LANGUAGE_COMPUTER)

	pre_apply(mob/carbon/M)
		M.languages -= LANGUAGE_COMPUTER
		M.languages = uniquelist(M.languages + LANGUAGE_NONE)
		M.curr_language = LANGUAGE_NONE
		M.verbs -= /mob/verb/switch_language

	apply(mob/carbon/M, attribute)
		M.languages = uniquelist(M.languages)
		if(attribute == LANGUAGE_COMPUTER && M.appearance != APPEARANCE_QUIVERING_MASS)
			M.languages -= LANGUAGE_NONE
			M.languages += LANGUAGE_COMPUTER
			if(M.curr_language != LANGUAGE_ENGLISH && M.curr_language != LANGUAGE_MONKEY)
				M.curr_language = LANGUAGE_COMPUTER
			if(M.languages.len > 1 && !(/mob/verb/switch_language in M.verbs))
				M.verbs += /mob/verb/switch_language

	pick_attribute(mob/carbon/M)
		if(LANGUAGE_COMPUTER in M.languages)
			return LANGUAGE_COMPUTER
		else
			return JUNK