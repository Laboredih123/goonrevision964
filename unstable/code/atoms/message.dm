/datum/message
	var/text = null
	var/color = null
	var/voice = null
	var/language = null
	var/origlanguage = null
	var/origvoice = null
	New(voice, text, language)
		src.text = text
		src.voice = voice
		src.language = language
		// orig variables for encrypted transmissions
		src.origlanguage = language
		src.origvoice = voice
