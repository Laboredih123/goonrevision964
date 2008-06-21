/obj/hud/var/mob/carbon/owner

/obj/hud/New(owner)
	src.owner = owner
	src.instantiate()
	..()
	return

/obj/hud/proc/instantiate()

	src.adding = list(  )
	src.other = list(  )
	src.intents = list(  )
	src.mon_blo = list(  )
	src.m_ints = list(  )
	src.mov_int = list(  )
	src.vimpaired = list(  )
	src.darkMask = list(  )
	src.g_dither = new src.h_type( src )
	src.g_dither.screen_loc = "1,1 to 15,15"
	src.g_dither.name = "Mask"
	src.g_dither.icon_state = "dither12g"
	src.g_dither.layer = 18
	src.g_dither.mouse_opacity = 0
	src.blurry = new src.h_type( src )
	src.blurry.screen_loc = "1,1 to 15,15"
	src.blurry.name = "Blurry"
	src.blurry.icon_state = "blurry"
	src.blurry.layer = 17
	src.blurry.mouse_opacity = 0
	var/obj/hud/using = new src.h_type( src )
	using.name = "vitals"
	using.dir = SOUTH
	using.screen_loc = "15,2 to 15,15"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "actions"
	using.dir = EAST
	using.screen_loc = "4,1 to 14,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.dir = NORTHWEST
	using.screen_loc = "15,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.dir = WEST
	using.screen_loc = "1,3 to 2,3"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.dir = NORTHEAST
	using.screen_loc = "3,3"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.dir = NORTH
	using.screen_loc = "3,2"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.dir = SOUTHEAST
	using.screen_loc = "3,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.dir = SOUTHWEST
	using.screen_loc = "1,1 to 2,2"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "drop"
	using.icon_state = "act_drop"
	using.screen_loc = "7,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "swap"
	using.icon_state = "act_hand"
	using.screen_loc = "11,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "i_clothing"
	using.dir = SOUTH
	using.icon_state = "center"
	using.screen_loc = "2,2"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "o_clothing"
	using.dir = SOUTH
	using.icon_state = "equip"
	using.screen_loc = "2,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "headset"
	using.dir = SOUTHEAST
	using.icon_state = "equip"
	using.screen_loc = "3,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "r_hand"
	using.dir = WEST
	using.icon_state = "equip"
	using.screen_loc = "1,2"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "l_hand"
	using.dir = EAST
	using.icon_state = "equip"
	using.screen_loc = "3,2"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "id"
	using.dir = SOUTHWEST
	using.icon_state = "equip"
	using.screen_loc = "1,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "mask"
	using.dir = NORTH
	using.icon_state = "equip"
	using.screen_loc = "2,3"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "back"
	using.dir = NORTHEAST
	using.icon_state = "equip"
	using.screen_loc = "3,3"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "storage1"
	using.icon_state = "block"
	using.screen_loc = "4,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "storage2"
	using.icon_state = "block"
	using.screen_loc = "5,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "resist"
	using.icon_state = "act_resist"
	using.screen_loc = "13,1"
	using.layer = 19
	src.adding += using
	using = new src.h_type( src )
	using.name = "other"
	using.icon_state = "other"
	using.screen_loc = "4,2"
	using.layer = 20
	src.adding += using
	using = new src.h_type( src )
	using.name = "intent"
	using.icon_state = "intent"
	using.screen_loc = "14,15"
	using.layer = 20
	src.adding += using
	using = new src.h_type( src )
	using.name = "m_intent"
	using.icon_state = "move"
	using.screen_loc = "14,14"
	using.layer = 20
	src.adding += using
	using = new src.h_type( src )
	using.name = "gloves"
	using.icon_state = "gloves"
	using.screen_loc = "4,2"
	using.layer = 19
	src.other += using
	using = new src.h_type( src )
	using.name = "eyes"
	using.icon_state = "glasses"
	using.screen_loc = "6,2"
	using.layer = 19
	src.other += using
	using = new src.h_type( src )
	using.name = "head"
	using.icon_state = "hair"
	using.screen_loc = "7,2"
	using.layer = 19
	src.other += using
	using = new src.h_type( src )
	using.name = "shoes"
	using.icon_state = "shoes"
	using.screen_loc = "5,2"
	using.layer = 19
	src.other += using
	using = new src.h_type( src )
	using.name = "belt"
	using.icon_state = "belt"
	using.screen_loc = "8,2"
	using.layer = 19
	src.other += using
	using = new src.h_type( src )
	using.name = "grab"
	using.icon_state = "grab"
	using.screen_loc = "11,15"
	using.layer = 19
	src.intents += using
	using = new src.h_type( src )
	using.name = "hurt"
	using.icon_state = "harm"
	using.screen_loc = "14,15"
	using.layer = 19
	src.intents += using
	src.m_ints += using
	using = new src.h_type( src )
	using.name = "disarm"
	using.icon_state = "disarm"
	using.screen_loc = "13,15"
	using.layer = 19
	src.intents += using
	using = new src.h_type( src )
	using.name = "help"
	using.icon_state = "help"
	using.screen_loc = "12,15"
	using.layer = 19
	src.intents += using
	src.m_ints += using
	using = new src.h_type( src )
	using.name = "face"
	using.icon_state = "facing"
	using.screen_loc = "14,14"
	using.layer = 19
	src.mov_int += using
	using = new src.h_type( src )
	using.name = "walk"
	using.icon_state = "walking"
	using.screen_loc = "13,14"
	using.layer = 19
	src.mov_int += using
	using = new src.h_type( src )
	using.name = "run"
	using.icon_state = "running"
	using.screen_loc = "12,14"
	using.layer = 19
	src.mov_int += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "2,2"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "1,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "2,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "3,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "4,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "5,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "1,1 to 5,15"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "5,1 to 10,5"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "6,11 to 10,15"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "11,1 to 15,15"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	return

/obj/screen/attack_hand(mob/user as mob, using)
	return user.db_click(src.name, using)

/obj/screen/attack_paw(mob/user as mob, using)
	return user.db_click(src.name, using)




//////////////////////////////////




obj/screen/flash = null
		obj/screen/blind = null
		obj/screen/hands = null
		obj/screen/mach = null
		obj/screen/sleep = null
		obj/screen/rest = null
		obj/screen/pullin = null
		obj/screen/internals = null
		obj/screen/oxygen = null
		obj/screen/i_select = null
		obj/screen/m_select = null
		obj/screen/toxin = null
		obj/screen/fire = null
		obj/screen/healths = null
		obj/screen/zone_sel/zone_sel = null
/datum/hud/carbon/New()
	src.throw_icon = new /obj/screen(null)
	src.oxygen = new /obj/screen( null )
	src.i_select = new /obj/screen( null )
	src.m_select = new /obj/screen( null )
	src.toxin = new /obj/screen( null )
	src.internals = new /obj/screen( null )
	src.mach = new /obj/screen( null )
	src.fire = new /obj/screen( null )
	src.healths = new /obj/screen( null )
	src.pullin = new /obj/screen( null )
	src.blind = new /obj/screen( null )
	src.flash = new /obj/screen( null )
	src.hands = new /obj/screen( null )
	src.sleep = new /obj/screen( null )
	src.rest = new /obj/screen( null )
	src.zone_sel = new /obj/screen/zone_sel( null )
	src.throw_icon.icon_state = "act_throw_off"
	src.oxygen.icon_state = "oxy0"
	src.i_select.icon_state = "selector"
	src.m_select.icon_state = "selector"
	src.toxin.icon_state = "toxin0"
	src.internals.icon_state = "internal0"
	src.mach.icon_state = null
	src.fire.icon_state = "fire0"
	src.healths.icon_state = "health0"
	src.pullin.icon_state = "pull0"
	src.blind.icon_state = "black"
	src.hands.icon_state = "hand"
	src.flash.icon_state = "blank"
	src.sleep.icon_state = "sleep0"
	src.rest.icon_state = "rest0"
	src.hands.dir = NORTH
	src.throw_icon.name = "throw"
	src.oxygen.name = "oxygen"
	src.i_select.name = "intent"
	src.m_select.name = "moving"
	src.toxin.name = "toxin"
	src.internals.name = "internal"
	src.mach.name = "Reset Machine"
	src.fire.name = "fire"
	src.healths.name = "health"
	src.pullin.name = "pull"
	src.blind.name = " "
	src.hands.name = "hand"
	src.flash.name = "flash"
	src.sleep.name = "sleep"
	src.rest.name = "rest"
	src.throw_icon.screen_loc = "9,1"
	src.oxygen.screen_loc = "15,12"
	src.i_select.screen_loc = "14,15"
	src.m_select.screen_loc = "14,14"
	src.toxin.screen_loc = "15,10"
	src.internals.screen_loc = "15,14"
	src.mach.screen_loc = "14,1"
	src.fire.screen_loc = "15,8"
	src.healths.screen_loc = "15,5"
	src.sleep.screen_loc = "15,3"
	src.rest.screen_loc = "15,2"
	src.pullin.screen_loc = "15,1"
	src.hands.screen_loc = "1,3"
	src.blind.screen_loc = "1,1 to 15,15"
	src.flash.screen_loc = "1,1 to 15,15"
	src.blind.layer = 0
	src.flash.layer = 17
	src.client.screen.len = null
	src.client.screen -= list( src.throw_icon, src.zone_sel, src.oxygen, src.i_select, src.m_select, src.toxin, src.internals, src.fire, src.hands, src.healths, src.pullin, src.blind, src.flash, src.rest, src.sleep, src.mach )
	src.client.screen += list( src.throw_icon, src.zone_sel, src.oxygen, src.i_select, src.m_select, src.toxin, src.internals, src.fire, src.hands, src.healths, src.pullin, src.blind, src.flash, src.rest, src.sleep, src.mach )
	src.client.screen -= src.hud_used.adding
	src.client.screen += src.hud_used.adding

/datum/hud/carbon/update_hud()


	if (!src.is_dead && istype(src.mask, /obj/item/weapon/clothing/mask/gasmask))
		src.client.screen += src.g_dither
	else
		src.client.screen -= src.g_dither

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
		if (src.taking_tox_damage)
			src.toxin.icon_state = "toxin1"
		else
			src.toxin.icon_state = "toxin0"
	if (src.oxygen)
		if (src.taking_suff_damage)
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