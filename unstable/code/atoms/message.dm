/datum/message
	var/voice = null
	var/text = null
	var/language = null
	New(voice, text, language)
		src.voice = voice
		src.text = text
		src.language = language