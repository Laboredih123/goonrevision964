/var/const/MONKEY_LANG = 1
/var/const/ENGLISH_LANG = 2
/var/const/COMPUTER_LANG = 3

/mob/proc/hear(message)
	if(src.deaf)
		return
	if(src.stat == 1 || src.sleeping == 0)
		src << "<i>You hear a faint noise.</i>"
		return 1
	else
		src << message
		return 1

/mob/proc/hear_message(datum/message/M, atom/source)
	var/speaker_name = M.voice
	if(source in view(src) && istype(source, /mob) && source.name != speaker_name) //he's in disguise
		name += " (disguised as [source.name])"
	else if(istype(source, /obj/item/weapon/radio))
		name += " broadcasts \icon[source]"
	var/text = M.text
	if(!M.language in src.languages)
		text = replace_language(text, M.language)
	src.hear("<b>[speaker_name]</b>: [text]")

/mob/proc/replace_language(message, language)
	var/list/words = dd_text2list(message, " ")
	var/list/replaced_words = list()
	var/list/language_words
	switch(language)
		if(MONKEY_LANG)
			language_words = get_monkey_words()
		if(ENGLISH_LANG)
			language_words = get_english_words()
		if(COMPUTER_LANG)
			language_words = get_computer_words()
	for(var/word in words)
		if(!word) //blank string (occurs when multiple spaces are in a row) isn't replaced
			continue
		replaced_words += pick(language_words)
	return dd_list2text(replaced_words, " ")