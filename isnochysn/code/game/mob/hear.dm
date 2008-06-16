/var/const/MONKEY_LANG = 1
/var/const/ENGLISH_LANG = 2
/var/const/COMPUTER_LANG = 3

/mob/proc/hear(message)
	if(src.sdisabilities & deafness)
		return
	if(src.stat == 1 || src.sleeping == 0)
		src << "<i>You hear a faint noise.</i>"
		return 1
	else
		src << message
		return 1

/mob/proc/hear_message(datum/message/M, source)
	var/speaker_name = M.voice
	if(source in view(src) && istype(source, mob) && source.name != speaker_name) //he's in disguise
		name += " (disguised as [source.name])"
	else if(istype(source, /item/weapon/radio))
		name += " broadcasts \icon[source]"
	var/message = M.message
	if(!M.language in src.languages)
		message = replace_language(message, language)
	src.hear("<b>[speaker_name]</b>: [message]")

/mob/proc/replace_language(message, language)
	var/list/words = dd_text2list(message, " ")
	var/list/replaced_words = list()
	for(var/word in words)
		if(!word) //blank string (occurs when multiple spaces are in a row) isn't replaced
			continue
		switch(language)
			if(MONKEY_LANG)
				replaced_words += pick(monkey_words)
			if(ENGLISH_LANG)
				replaced_words += pick(english_words)
			if(COMPUTER_LANG)
				var/word = ""
				for(var/i = 0; i < 16; i++)
					word += rand(0, 1)
				replaced_words += word
	return dd_list2text(replaced_words, " ")