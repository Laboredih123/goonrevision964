/datum/message
	var/voice = null
	var/text = null
	var/language = null
	var/origlanguage = null
	var/origvoice = null
	New(voice, text, language)
		src.voice = voice
		src.text = text
		src.language = language
		// orig variables for encrypted transmissions
		src.origlanguage = language
		src.origvoice = voice
