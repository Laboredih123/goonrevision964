/mob/proc/reset_view(atom/A)

	if (src.client)
		src.client.reset_view(A)
	return

/mob/proc/is_muzzled()
	return 0

/mob/proc/is_blindfolded()
	return 0

/mob/proc/is_handcuffed()
	return 0

/mob/proc/can_use_hands()
	return src.is_active()

/mob/proc/is_active()
	if(src.is_dead)
		return 0
	if(!src.is_conscious())
		return 0
	return 1

/mob/proc/u_equip()
	return 0
