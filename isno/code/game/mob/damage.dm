/mob/var/datum/damage/dam = new /datum/damage()

/mob/proc/take_damage(brute, burn, suffocation, toxin, electric)
	var/datum/damage/dam = new(brute, burn, suffocation, toxin, electric)
	src.dam.add(dam)

/mob/proc/heal_damage(brute, burn, suffocation, toxin, electric)
	var/datum/damage/dam = new(brute, burn, suffocation, toxin, electric)
	src.dam.subtract(dam)

/mob/proc/get_damage()
	return src.dam.total

/mob/blob_act()
	src.show_viewers("\red <B>[src] has been attacked by the blob.</B>")
	src.take_damage(brute = rand(5,25))

/mob/meteorhit(obj/O)
	for(var/mob/M in viewers(src, null))
		M.see("\red [src] has been hit by [O]")
	src.take_damage(brute = 40, burn = 40)

/mob/burn(fi_amount)

	for(var/atom/movable/A in src)
		A.burn(fi_amount)
		//Foreach goto(15)
	return
