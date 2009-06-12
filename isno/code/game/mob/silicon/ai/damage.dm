/mob/silicon/ai/death()
	src.icon_state = "teg-broken"
	return ..()

/mob/silicon/ai/proc/firecheck(turf/T as turf)

	if (T.firelevel < 900000.0)
		return 0
	var/total = 0
	total += 0.25
	return total
	return