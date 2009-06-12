/mob/silicon/ai/check_eye(var/mob/user as mob)
	if (!src.current)
		return null
	user.reset_view(src.current)
	return 1

/mob/silicon/ai/is_active()
	if(!src.has_power)
		return 0
	if(src.get_damage() > src.unconsciousness_threshold)
		return 0
	return ..()