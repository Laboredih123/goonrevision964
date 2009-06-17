/mob/proc/can_say()
	if(src.client)
		return !src.client.muted
	else
		return 1

/mob/proc/say_dead(message)
	if(!src.can_say())
		return
	var/msg = "<b>[src.spawn_name]</b> <i>(dead)</i>: [message]"
	if(!msg) return	//	sanitized in /mob/verb/say
	for(var/mob/M in world)
		if(M.is_dead) M << msg

/mob/proc/stutter(txt)
	var/s = ""
	if(!txt) return
	txt = html_decode(txt)
	// we html_encoded in /mob/verb/say
	for(var/i = 1; i <= lentext(txt); i++)
		var/c = copytext(txt, i, i + 1)
		var/numrepeats = rand(5) - 1
		for(var/j = 0; j < numrepeats; j++)
			s += c
	return sanitize(s)

/mob/proc/get_default_radio()
	return null

/mob/proc/get_radio(id)
	if(!src.is_active())
		return null
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
	txt = sanitize(txt)
	if(!txt) return
	world.log_say("[src.name]/[src.key] says '[txt]'")

	if(src.is_dead)
		return src.say_dead(txt)
	if(!src.can_say())
		return

	var/obj/item/weapon/radio/target = null
	var/hear_range = 7

	if(findtext(txt, ";") == 1) //default target
		// headset for a human; radio #2 for the AI
		// should be the most common use case, because just ; is the easiest thing to type that you wouldnt start
		// a line with ever
		// say "; words" or say ";words"
		txt = copytext(txt, 2)
		target = src.get_default_radio()
		hear_range = 1
	else if (findtext(txt, ":") == 1) //saying into something, don't know what
		//second character indicates what they talk into, third to end indicate actual txt
		target = src.get_radio(copytext(txt, 2, 3))
		if(target)
			txt = copytext(txt, 3)
		hear_range = 1

	if(src.is_stuttering())
		txt = stutter(txt)

	var/datum/message/msg = new /datum/message(src.voice, txt, src.curr_language)
	var/datum/job/j = spawn_jobs[src.voice]
	if(j)
		msg.speaker_color = j.speaker_color

	if(target && istype(target, /obj/item/weapon/radio))
		target.talk_into(msg, usr)
	var/heard = list()
	var/turf/T = get_turf(src) //if you're in a closet, people can still hear you talk
	for(var/obj/O as obj|mob in view(hear_range, T)) // BYOND lacks a hear proc grrrrrr
		O.hear_message(msg, usr)
		heard += O
	for(var/mob/carbon/M in world)
		if(!(M in heard) && (M.is_telepathic || M.is_dead))
			M.hear_message(msg, usr)
	for(var/mob/observer/M in world)
		if(!(M in heard))
			M.hear_message(msg, usr)

/mob/proc/is_stuttering()
	return 0
