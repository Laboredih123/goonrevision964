/mob/carbon/human/hear_talk(speaker, alt_name, message)
	if(istype(speaker, /mob/carbon/monkey))
		src.hear("<b>[speaker.rname]</b> chimpers")
	else
		..()