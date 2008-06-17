/mob/carbon/update_hud()
	if (!src.is_dead && istype(src.mask, /obj/item/weapon/clothing/mask/gasmask))
		src.client.screen += main_hud1.g_dither
	else
		src.client.screen -= main_hud1.g_dither

	if (src.sleep_icon)
		src.sleep_icon.icon_state = text("sleep[]", src.sleeping)
	if (src.rest_icon)
		src.rest_icon.icon_state = text("rest[]", src.resting)
	if (src.health_icon)
		if (src.is_dead)
			src.health_icon.icon_state = "dead"
		else if (src.dam.total == 0)
			src.healths.icon_state = "health0"
		else if (src.dam.total <= 25)
			src.healths.icon_state = "health1"
		else if (src.dam.total <= 50)
			src.health_icon.icon_state = "health2"
		else if (src.dam.total <= 70)
			src.health_icon.icon_state = "health3"
		else
			src.healths_icon.icon_state = "health4"
	if (src.pullin)
		if (src.pulling)
			src.pullin.icon_state = "pull1"
		else
			src.pullin.icon_state = "pull0"
	if (src.toxin)
		if (plcheck)
			src.toxin.icon_state = "toxin1"
		else
			src.toxin.icon_state = "toxin0"
	if (src.oxygen)
		if (oxcheck)
			src.oxygen.icon_state = "oxy1"
		else
			src.oxygen.icon_state = "oxy0"
	src.client.screen -= src.hud_used.blurry
	src.client.screen -= src.hud_used.vimpaired
	if ((src.blind && src.stat != 2))
		if (src.blinded)
			src.blind.layer = 18
		else
			src.blind.layer = 0
			if ((src.disabilities & 1 && !( istype(src.glasses, /obj/item/weapon/clothing/glasses/regular) )))
				src.client.screen -= src.hud_used.vimpaired
				src.client.screen += src.hud_used.vimpaired
			else
				src.client.screen -= src.hud_used.vimpaired
			if (src.eye_blurry)
				src.client.screen -= src.hud_used.blurry
				src.client.screen += src.hud_used.blurry
			else
				src.client.screen -= src.hud_used.blurry