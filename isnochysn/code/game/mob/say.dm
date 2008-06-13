/mob/proc/can_say()
	return !src.muted

/mob/proc/say_dead(message)
	if(src.muted)
		return
	for(var/mob/M in world)
		if (M.stat == 2)
			M << "<b>[src.rname]</b> <i>(dead)</i>: [message]"

/mob/proc/stutter(txt)
	var/s = ""
	for(var/i = 0; i < txt.len; i++)
		var/c = copytext(txt, i, i + 1)
		var/numrepeats = rand(5) - 1
		for(var/j = 0; j < numrepeats; j++)
			s += c
	return s

/mob/proc/default_radio()
	return null

/mob/proc/get_fave_radio(id)
	if(id == "w") // just whispering
		return null
	if(id == "i") //intercom
		for(var/obj/item/weapon/radio/intercom/I in view(1)) // use the first one
			return I
	var/radio_num = text2num(copytext(message, 2, 3))
	if(radio_num) //will only be non-null if it's a number
		for(var/obj/item/weapon/radio/intercom/I in view(1))
			if (I.number == radionum)
				return I


/mob/verb/say(message as text)
	if(!message)
		return
	message = sanitize(message)
	message = copytext(message, 1, 256)
	world.log_say("[src.name]/[src.key] : [message]")

	if(src.stat == 2)
		return src.say_dead(html_encode(message))

	if(!src.can_say())
		return

	var/obj/item/weapon/radio/target = null
	var/hear_range = null
	if (findtext(message, "/") == 1) //default target
		//for a human, it's their headset
		//for AI, it's radio #2
		//should be the most common use case, because just using a slash is the easiest thing to type
		//say "/ words" or say "/words"
		message = copytext(message, 2)
		target = src.default_radio()
		hear_range = 1
	else if (findtext(message, ":") == 1) //saying into something, don't know what
		message = copytext(message, 3)
		target = src.get_fave_radio(copytext(message, 2, 3))
		hear_range = 1

	if (hear_range == 1)
		message = "<I>[message]</I>"
	if (src.stuttering)
		message = stutter(message)
	message = html_encode(message)

	if(target && istype(target, /obj/item/weapon/radio))
		target.talk_into(usr, message)
	for(var/O as obj|mob in view(hear_range))
		spawn(0)
			if (O)
				O.hear_talk(usr, message)