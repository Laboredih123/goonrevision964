/mob/carbon/proc/check_dexterity()
	if(src.is_dextrous)
		return 1
	else
		src.think("\red You aren't dextrous enough to use this!")
		return 0