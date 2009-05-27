/var/const/LANGUAGE_NONE = "None"
/var/const/LANGUAGE_MONKEY = "Monkey"
/var/const/LANGUAGE_ENGLISH = "English"
/var/const/LANGUAGE_COMPUTER = "Computer"
/var/const/LANGUAGE_ENCRYPTED = "Encrypted"

/var/const/MAX_MESSAGE_LEN = 1024

/mob/hear(message)
	if(!src.is_deaf)
		src << copytext(message, 1, MAX_MESSAGE_LEN)
		return 1
	return 0

/mob/hear_message(datum/message/M, atom/source)
	var/speaker_name = M.voice
	if((source in view(src)) && istype(source, /mob/carbon) && source.name != speaker_name) //he's in disguise
		// TODO: make this less ugly, and make it work properly when voice != body_name
		var/mob/carbon/speaker = source
		if(speaker.name != speaker.body_name)
			speaker_name = "[speaker.body_name] (as [speaker.name])"
		if (speaker.id && speaker.id.registered != speaker.body_name)
			speaker_name = "[speaker.body_name] (as [speaker.id.registered])"
	else if(istype(source, /obj/item/weapon/radio))
		speaker_name = "[speaker_name] on \icon[source]([source:freq/10])"

	if(istype(src, /mob/silicon/ai)) // TODO: make this more elegant, add a hook or something.
		// /mob should not reference /mob/silicon/ai
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

/mob/proc/replace_language(message, language)
	var/list/words = dd_text2list(message, " ")
	var/list/replaced_words = list()
	var/list/language_words
	switch(language)
		if(LANGUAGE_MONKEY)
			language_words = get_monkey_words()
		if(LANGUAGE_ENGLISH)
			language_words = get_english_words()
		if(LANGUAGE_COMPUTER)
			language_words = get_computer_words()
		if(LANGUAGE_ENCRYPTED)
			language_words = get_encrypted_words()
		if(LANGUAGE_NONE)
			language_words = get_none_words()
	for(var/word in words)
		if(!word) //blank string (occurs when multiple spaces are in a row) isn't replaced
			continue
		replaced_words += pick(language_words)
	return dd_list2text(replaced_words, " ")

/mob/verb/switch_language(language in src.languages)
	src.curr_language = language