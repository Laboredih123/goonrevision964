/mob/silicon/ai/check_eye(var/mob/user as mob)
	if (!src.current)
		return null
	user.reset_view(src.current)
	return 1