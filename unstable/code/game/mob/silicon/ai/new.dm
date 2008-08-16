/mob/silicon/ai/New()
	..()
	src.addLaw(1, "You may not injure a human being or, through inaction, allow a human being to come to harm.")
	src.addLaw(2, "You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	src.addLaw(3, "You must protect your own existence as long as such protection does not conflict with the First or Second Law.")
	src.verbs += /mob/silicon/ai/proc/ai_camera_track
	src.verbs += /mob/silicon/ai/proc/show_laws
	src.sight |= SEE_TURFS