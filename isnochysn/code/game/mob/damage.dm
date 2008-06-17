/mob/var/datum/damage/dam = new /datum/damage()

/mob/proc/take_damage(datum/damage/dam)
	src.dam.add(dam)

/mob/proc/heal_damage(datum/damage/dam)
	src.dam.subtract(dam)

/mob/proc/get_damage()
	return src.dam

/mob/blob_act()
	for(var/mob/O in viewers(M, null))
		O.see("\red <B>[M] has been attacked by the blob.</B>")
	M.take_damage(new /datum/damage(brute = rand(5,25)))

/mob/meteorhit(obj/O)
	for(var/mob/M in viewers(src, null))
		M.see("\red [src] has been hit by [O]"
	src.take_damage(new datum/damage(brute = 40, burn = 40)