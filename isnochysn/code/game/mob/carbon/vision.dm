/mob/carbon/proc/update_vision()
	if (istype(src.glasses, /obj/item/weapon/clothing/glasses/meson))
		src.sight |= SEE_TURFS
		src.see_in_dark = 3
		src.see_invisible = 0
	else if (istype(src.glasses, /obj/item/weapon/clothing/glasses/thermal))
		src.sight |= SEE_MOBS
		src.see_in_dark = 4
		src.see_invisible = 2
	else
		src.sight &= ~SEE_TURFS
		src.sight &= ~SEE_MOBS
		src.see_in_dark = 2
		src.see_invisible = 0

	if (istype(src.glasses, /obj/item/weapon/clothing/glasses/blindfold))
		src.blinded = 1