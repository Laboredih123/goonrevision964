/mob/carbon/check_dexterity()
	if(src.is_dextrous && src.can_use_hands())
		return 1
	else
		src.think("\red You aren't dextrous enough to use this!")
		return 0

/mob/carbon/check_intelligence()
	if(src.check_dexterity())
		if(src.is_intelligent)
			return 1
		else
			src.think("\red You aren't smart enough to use this!")
			return 0