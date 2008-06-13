/mob/proc/hear(message)
	if(src.sdisabilities & deafness)
		return
	if(src.stat == 1 || src.sleeping == 0)
		src << "<i>You hear a faint noise.</i>"
	else
		src << message

/mob/proc/hear_talk(speaker, alt_name, message)
	var/alt_name = ""
	if(speaker in view(src) && speaker.name != speaker.rname) //he's in disguise
		//TODO: improve handling of people in disguise speaking, let them disguise their voices
		alt_name = " (disguised as [speaker.name])"
	src.hear("<b>[speaker.rname][alt_name]</b>: [message]", src.rname, alt_name, message)