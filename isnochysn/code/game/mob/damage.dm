/mob/proc/take_damage(damage)
	src.damage.add(damage)

/mob/proc/heal_damage(damage)
	src.damage.subtract(damage)

/mob/proc/get_damage()
	return src.damage