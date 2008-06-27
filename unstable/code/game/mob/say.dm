/mob/proc/can_say()
	return !src.muted

/mob/proc/say_dead(message)
	if(src.muted)
		return
	for(var/mob/M in world)
		if (M.is_dead)
			M << "<b>[src.spawn_name]</b> <i>(dead)</i>: [message]"

/mob/proc/stutter(txt)
	var/s = ""
	for(var/i = 0; i < lentext(txt); i++)
		var/c = copytext(txt, i, i + 1)
		var/numrepeats = rand(5) - 1
		for(var/j = 0; j < numrepeats; j++)
			s += c
	return s

/mob/proc/get_default_radio()
	return null

/mob/proc/get_radio(id)
	if(id == "w") // just whispering
		return null
	if(id == "i") //intercom
		for(var/obj/item/weapon/radio/intercom/I in view(1)) // use the first one
			return I
	var/radio_num = text2num(id)
	if(radio_num) //will only be non-null if it's a number
		for(var/obj/item/weapon/radio/intercom/I in view(1))
			if (I.number == radio_num)
				return I

/mob/verb/say(txt as text)
	if(!txt)
		return
	if(!src.curr_language)
		return
	txt = sanitize(txt)
	txt = copytext(txt, 1, 256)
	world.log_say("[src.name]/[src.key] : [txt]")

	if(src.is_dead)
		return src.say_dead(html_encode(txt))

	if(!src.can_say())
		return

	var/obj/item/weapon/radio/target = null
	var/hear_range = null
	if (findtext(txt, "/") == 1) //default target
		//for a human, it's their headset
		//for AI, it's radio #2
		//should be the most common use case, because just using a slash is the easiest thing to type
		//say "/ words" or say "/words"
		txt = copytext(txt, 2)
		target = src.get_default_radio()
		hear_range = 1
	else if (findtext(txt, ":") == 1) //saying into something, don't know what
		//second character indicates what they talk into, third to end indicate actual txt
		txt = copytext(txt, 3)
		target = src.get_radio(copytext(txt, 2, 3))
		hear_range = 1

	if (hear_range == 1)
		txt = "<I>[txt]</I>"
	if (src.is_stuttering())
		txt = stutter(txt)
	txt = html_encode(txt)


	var/datum/message = new(src.voice, txt, src.curr_language)

	if(target && istype(target, /obj/item/weapon/radio))
		target.talk_into(usr, txt)
	for(var/obj/O as obj|mob in view(hear_range))
		spawn(0)
			if (O)
				O.hear_message(usr, message)

/mob/proc/is_stuttering()
	return 0