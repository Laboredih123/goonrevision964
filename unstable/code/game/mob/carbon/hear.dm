/mob/carbon/hear(message)
	if(src.knockout > 0 || src.sleeping)
		src << "<i>You hear a faint noise.</i>"
		return 1
	else
		return ..()