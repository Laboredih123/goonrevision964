/mob/carbon/proc/check_dexterity()
	if(src.is_dextrous && src.can_use_hands())
		return 1
	else
		src.think("\red You aren't dextrous enough to use this!")
		return 0

/mob/carbon/proc/check_computer()
	if(src.check_dexterity())
		if(src.can_use_computer())
			return 1
		else
			src.think("\red You aren't smart enough to use this!")
			return 0