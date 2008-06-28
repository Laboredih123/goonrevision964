/mob/carbon/proc/can_talk()
	if(!src.is_conscious())
		return 0
	if(istype(src.mask, /obj/item/weapon/clothing/mask/muzzle))
		return 0

	//TODO: completely redo this check so that it isn't absolutely awful
	//seriously, checking the state of an icon on your HUD? jesus christ
	var/turf/T = src.loc
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	if (!((src.hud && src.hud.oxygen && src.hud.oxygen.icon_state == "oxy0") || (istype(T, /turf) || istype(T, /obj/move)) && T.oxygen > 0))
		return 0

	return ..()

/mob/carbon/get_radio(id)
	if(id == "r") //radio in their right hand
		return src.r_hand
	if(id == "l")
		return src.l_hand
	if(id == "h" && src.headset)
		return src.headset
	return ..()

/mob/carbon/get_default_radio()
	if(src.headset)
		return src.headset

/mob/carbon/is_stuttering()
	if(src.knockdown > 0)
		if(prob(50))
			return 1
	return 0

/mob/carbon/say(txt as text)
	if(!src.curr_language)
		src.moan()
	else
		return ..()