/mob/proc/can_emote()
	return 1

/mob/verb/emote(message as text)
	if (!src.can_emote())
		return
