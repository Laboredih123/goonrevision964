/datum/hud/carbon
	var/mob/carbon/owner
	var/obj/screen/g_dither
	var/obj/screen/vitals
	var/obj/screen/actions
	var/obj/screen/drop
	var/obj/screen/throw
	var/obj/screen/swap
	var/obj/screen/resist
	var/obj/screen/mask
	var/obj/screen/back
	var/obj/screen/r_hand
	var/obj/screen/jumpsuit
	var/obj/screen/l_hand
	var/obj/screen/gloves
	var/obj/screen/shoes
	var/obj/screen/glasses
	var/obj/screen/helmet
	var/obj/screen/belt
	var/obj/screen/id
	var/obj/screen/suit
	var/obj/screen/headset
	var/obj/screen/storage1
	var/obj/screen/storage2
	var/obj/screen/grab
	var/obj/screen/help
	var/obj/screen/disarm
	var/obj/screen/hurt
	var/obj/screen/flash
	var/obj/screen/blind
	var/obj/screen/hand
	var/obj/screen/machine
	var/obj/screen/sleep
	var/obj/screen/rest
	var/obj/screen/pull
	var/obj/screen/internal
	var/obj/screen/oxygen
	var/obj/screen/intent
	var/obj/screen/toxin
	var/obj/screen/fire
	var/obj/screen/health
	var/obj/screen/leftdither50
	var/obj/screen/bottomdither50
	var/obj/screen/topdither50
	var/obj/screen/rightdither50

/datum/hud/carbon/New(mob/carbon/owner)
	src.owner = owner

	//overlays
	src.g_dither = new /obj/screen(src, "Mask", null, "1,1 to 15,15", 18, "dither12g", 1)
	//src.blurry = new /obj/screen(src, "Blurry", null, "1,1 to 15,15", 17, "blurry", 1)
	src.leftdither50 = new /obj/screen(src, null, null, "1,1 to 5,15", 17, "dither50", 1)
	src.bottomdither50 = new /obj/screen(src, null, null, "5,1 to 10,5", 17, "dither50", 1)
	src.topdither50 = new /obj/screen(src, null, null, "6,11 to 10,15", 17, "dither50", 1)
	src.rightdither50 = new /obj/screen(src, null, null, "11,1 to 15,15", 17, "dither50", 1)
	src.flash = new /obj/screen(src, "flash", null, "1,1 to 15,5", 17, "blank")
	src.blind = new /obj/screen(src, " ", null, "1,1 to 15,5", 0, "black")

	// bars along sides
	src.vitals = new /obj/screen(src, "vitals", SOUTH, "15,1 to 15,15", 19)
	src.actions = new /obj/screen(src, "actions", EAST, "1,1 to 14,1", 19)

	// buttons
	src.drop = new /obj/screen(src, "drop", null, "7,1", 19, "act_drop")
	src.throw = new /obj/screen(src, "throw", null, "9,1", 19, "act_throw_off")
	src.swap = new /obj/screen(src, "swap", null, "11,1", 19, "act_hand")
	src.resist = new /obj/screen(src, "resist", null, "13,1", 19, "act_resist")
	src.machine = new /obj/screen(src, "Reset Machine", null, "14,1", null)
	src.sleep = new /obj/screen(src, "sleep", null, "15,3", null, "sleep0")
	src.rest = new /obj/screen(src, "rest", null, "15,2", null, "rest0")
	src.pull = new /obj/screen(src, "pull", null, "15,1", null, "pull0")

	//indicators
	src.oxygen = new /obj/screen(src, "oxygen", null, "15,2", null, "oxy0")
	src.toxin = new /obj/screen(src, "toxin", null, "15,10", null, "toxin0")
	src.internal = new /obj/screen(src, "internal", null, "15,14", null, "internal0")
	src.fire = new /obj/screen(src, "fire", null, "15,8", null, "fire0")
	src.health = new /obj/screen(src, "health", null, "15,5", null, "health0")

	// inventory stuff
	src.hand = new /obj/screen(src, "hand", NORTH, "1,3", 19, "hand")
	src.mask = new /obj/screen(src, "mask", NORTH, "2,3", 19, "equip")
	src.back = new /obj/screen(src, "back", NORTHEAST, "3,3", 19, "equip")
	src.r_hand = new /obj/screen(src, "r_hand", WEST, "1,2", 19, "equip")
	src.jumpsuit = new /obj/screen(src, "i_clothing", null, "2,2", 19, "center")
	src.l_hand = new /obj/screen(src, "l_hand", EAST, "3,2", 19, "equip")
	src.gloves = new /obj/screen(src, "gloves", null, "4,2", 19, "gloves")
	src.shoes = new /obj/screen(src, "shoes", null, "5,2", 19, "shoes")
	src.glasses = new /obj/screen(src, "eyes", null, "6,2", 19, "glasses")
	src.helmet = new /obj/screen(src, "head", null, "7,2", 19, "hair")
	src.belt = new /obj/screen(src, "belt", null, "8,2", 19, "belt")
	src.id = new /obj/screen(src, "id", SOUTHEAST, "1,1", 19, "equip")
	src.suit = new /obj/screen(src, "o_clothing", SOUTH, "2,1", 19, "equip")
	src.headset = new /obj/screen(src, "headset", SOUTHEAST, "3,1", 19, "equip")
	src.storage1 = new /obj/screen(src, "storage1", null, "4,1", 19, "block")
	src.storage2 = new /obj/screen(src, "storage2", null, "5,1", 19, "block")

	// make the slots they can't use have the "block" icon
	var/list/slots = list(
		src.mask = src.owner.can_wear_mask,
		src.back = src.owner.can_wear_back,
		src.r_hand = src.owner.can_wear_r_hand,
		src.jumpsuit = src.owner.can_wear_jumpsuit,
		src.l_hand = src.owner.can_wear_l_hand,
		src.gloves = src.owner.can_wear_gloves,
		src.shoes = src.owner.can_wear_shoes,
		src.glasses = src.owner.can_wear_glasses,
		src.helmet = src.owner.can_wear_helmet,
		src.belt = src.owner.can_wear_belt,
		src.id = src.owner.can_wear_id,
		src.suit = src.owner.can_wear_suit,
		src.headset = src.owner.can_wear_headset,
		src.storage1 = src.owner.can_wear_l_store,
		src.storage2 = src.owner.can_wear_r_store
	)
	for(var/obj/screen/x in slots)
		if(!slots[x])
			x.icon_state = "block"
			x.name = "blocked"

	// intents
	src.grab = new /obj/screen(src, "grab", null, "11,15", 19, "grab")
	src.help = new /obj/screen(src, "help", null, "12,15", 19, "help")
	src.disarm = new /obj/screen(src, "disarm", null, "13,15", 19, "disarm")
	src.hurt = new /obj/screen(src, "hurt", null, "14,15", 19, "harm")
	src.intent = new /obj/screen(src, "intent", null, "14,15", null, "selector")

	src.owner.client.screen += list(vitals, actions, drop, throw, swap, resist, mask, back,
		r_hand, jumpsuit, l_hand, gloves, shoes, glasses, helmet, belt, id, suit, headset,
		storage1, storage2, grab, help, disarm, hurt, flash, blind, hand, machine, sleep, rest,
		pull, internal, oxygen, intent, toxin, fire, health, leftdither50, bottomdither50,
		topdither50, rightdither50
	)

/datum/hud/carbon/Del()
	src.owner.client.screen -= list(vitals, actions, drop, throw, swap, resist, mask, back,
		r_hand, jumpsuit, l_hand, gloves, shoes, glasses, helmet, belt, id, suit, headset,
		storage1, storage2, grab, help, disarm, hurt, flash, blind, hand, machine, sleep, rest,
		pull, internal, oxygen, intent, toxin, fire, health, leftdither50, bottomdither50,
		topdither50, rightdither50, g_dither
	)

/datum/hud/carbon/proc/update()
	if (!src.owner.is_dead && istype(src.owner.mask, /obj/item/weapon/clothing/mask/gasmask))
		src.owner.client.screen += src.g_dither
	else
		src.owner.client.screen -= src.g_dither

	if (src.sleep)
		src.sleep.icon_state = text("sleep[]", src.owner.sleeping)
	if (src.rest)
		src.rest.icon_state = text("rest[]", src.owner.resting)
	if (src.health)
		if (src.owner.is_dead)
			src.health.icon_state = "health5"
		else if (src.owner.get_damage() == 0)
			src.health.icon_state = "health0"
		else if (src.owner.get_damage() <= 25)
			src.health.icon_state = "health1"
		else if (src.owner.get_damage() <= 50)
			src.health.icon_state = "health2"
		else if (src.owner.get_damage() <= 70)
			src.health.icon_state = "health3"
		else
			src.health.icon_state = "health4"
	if (src.pull)
		if (src.owner.pulling)
			src.pull.icon_state = "pull1"
		else
			src.pull.icon_state = "pull0"
	if (src.toxin)
		if (src.owner.taking_tox_damage)
			src.toxin.icon_state = "toxin1"
		else
			src.toxin.icon_state = "toxin0"
	if (src.oxygen)
		if (src.owner.taking_suff_damage)
			src.oxygen.icon_state = "oxy1"
		else
			src.oxygen.icon_state = "oxy0"

	if (src.owner.is_blind && !src.owner.is_dead)
		src.blind.layer = 18
	else
		src.blind.layer = 0