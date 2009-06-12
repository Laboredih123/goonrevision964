/var/const
	COLOR_DEFAULT = "black"
	COLOR_RADIO = "green"
	COLOR_EMOTE = "#ff00ff" // magenta
	COLOR_HEAD = "teal"
	COLOR_SECURITY = "maroon"
	COLOR_CAPTAIN = "navy"
	COLOR_DEATH_COMMANDO = "red"
	COLOR_ANNOUNCEMENT = "red"

/datum/message
	var/text = null
	var/voice = null
	var/language = null
	var/origlanguage = null
	var/origvoice = null
	var/message_color = null
	var/speaker_color = null
	New(voice, text, language, speaker_color = COLOR_DEFAULT, message_color = COLOR_DEFAULT)
		src.voice = voice
		src.text = text
		src.language = language
		// orig variables for encrypted transmissions
		src.origlanguage = language
		src.origvoice = voice
		src.speaker_color = speaker_color
		src.message_color = message_color

/proc/convert_message_color(datum/message/M, color)
	var/datum/message/m = new(M.voice, M.text, M.language, M.speaker_color, color)
	m.origlanguage = M.origlanguage
	m.origvoice = M.origvoice
	return m
