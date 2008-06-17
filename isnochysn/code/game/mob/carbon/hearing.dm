/mob/carbon/proc/update_hearing()
	if (istype(src.ears, /obj/item/weapon/clothing/ears/earmuffs))
		src.deaf = 1