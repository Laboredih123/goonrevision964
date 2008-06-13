/mob/var/datum/damage/dam = new /datum/damage()

/mob/proc/take_damage(datum/damage/dam)
	src.dam.add(dam)

/mob/proc/heal_damage(datum/damage/dam)
	src.dam.subtract(dam)

/mob/proc/get_damage()
	return src.dam