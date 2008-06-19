/mob/carbon/can_talk()
	if(src.stat != 0)
		return 0
	if(src.sdisabilites & muteness)
		return 0
	if(istype(src.mask, /obj/item/weapon/clothing/mask/muzzle))
		return 0

	//TODO: completely redo this check so that it isn't absolutely awful
	//seriously, checking the state of an icon on your HUD? jesus christ
	var/turf/T = src.loc
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	if (!((src.oxygen && src.oxygen.icon_state == "oxy0") || (istype(T, /turf) || istype(T, /obj/move)) && T.oxygen > 0))
		return 0

	return ..()

/mob/carbon/get_radio(id)
	if(id == "r") //radio in their right hand
		return src.r_hand
	if(id == "l")
		return src.l_hand
	if(id == "h" && src.has_headset)
		return src.headset
	return ..()

/mob/carbon/get_default_radio()
	if(src.has_headset)
		return src.headset