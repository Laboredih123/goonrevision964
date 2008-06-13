/mob/carbon/monkey/hear_talk(speaker, alt_name, message)
	if(istype(speaker, /mob/carbon/human))
		message = stars(message)
		src.hear("<b>The human</b>: [message]", src.rname, alt_name, message)
	else
		..()