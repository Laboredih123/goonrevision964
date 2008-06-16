/datum/message
	var/voice
	var/message
	var/language
	New(voice, message, language)
		src.voice = voice
		src.message = message
		src.language = language