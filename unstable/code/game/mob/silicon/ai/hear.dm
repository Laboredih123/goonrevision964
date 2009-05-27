/mob/silicon/ai/hear_message(datum/message/M, atom/source)
	var/speaker_name = M.voice
	if(source in oview(src) && istype(source, /mob) && source.name != speaker_name) //he's in disguise
		speaker_name += " (disguised as [source.name])"
	else if(istype(source, /obj/item/weapon/radio))
		speaker_name = "[speaker_name] on \icon[source]([source:freq/10])"

	// find the first mob/carbon with this name, if any
	for(var/mob/carbon/C in world)
		if(C.name == M.voice)
			speaker_name = "<a href='?src=\ref[src];track=\ref[C]'>[speaker_name]</a>"
			break

	speaker_name = "<font color='[M.speaker_color]'>[speaker_name]</font>"
	var/text = M.text
	if(!src.is_dead) //dead people understand everything
		if(!M.language)
			return
		if(!(M.language in src.languages) || M.language == LANGUAGE_NONE)
			text = replace_language(text, M.language)
	if(M.language != src.curr_language && (M.language in src.languages || src.is_dead))
		text = text + " <i>([M.language])</i>"
	return src.hear("<b>[speaker_name]:</b> <font color='[M.message_color]'>[text]</font>")
