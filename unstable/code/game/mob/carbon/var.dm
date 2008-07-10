/var/const/RIGHT = 0
/var/const/LEFT = 1

/mob/carbon
	var/intent = "disarm"

	var/drowsyness = 0

	var/hand = RIGHT //the active hand - note that tons of code just says "if(hand)" or "if(!hand)", which sucks
	var/body_name

	var/rejuv = 0
	var/antitoxs = 0
	var/sleeping = 0
	var/resting = 0
	var/lying = 0
	canmove = 1
	var/timeofdeath = 0
	var/cpr_time = 1
	var/losebreath = 0.0
	var/obj/stool/chair/buckled = null
	var/obj/item/weapon/tank/internal = null
	var/obj/item/weapon/storage/s_active = null

	var/obj/item/weapon/handcuffs/handcuffs = null
	var/can_wear_handcuffs = 1

	var/obj/item/weapon/l_hand = null
	var/can_wear_l_hand = 1

	var/obj/item/weapon/r_hand = null
	var/can_wear_r_hand = 1

	var/obj/item/weapon/back = null
	var/can_wear_back = 1

	var/obj/item/weapon/clothing/mask/mask = null
	var/can_wear_mask = 1

	var/obj/item/weapon/clothing/suit/suit = null
	var/can_wear_suit = 0

	var/obj/item/weapon/clothing/under/jumpsuit = null
	var/can_wear_jumpsuit = 0

	var/obj/item/weapon/radio/headset/headset = null
	var/can_wear_headset = 0

	var/obj/item/weapon/clothing/shoes/shoes = null
	var/can_wear_shoes = 0

	var/obj/item/weapon/belt = null
	var/can_wear_belt = 0

	var/obj/item/weapon/clothing/gloves/gloves = null
	var/can_wear_gloves = 0

	var/obj/item/weapon/clothing/glasses/glasses = null
	var/can_wear_glasses = 0

	var/obj/item/weapon/clothing/head/helmet = null
	var/can_wear_helmet = 0

	var/obj/item/weapon/card/id/id = null
	var/can_wear_id = 0

	var/obj/item/weapon/r_store = null
	var/can_wear_r_store = 0

	var/obj/item/weapon/l_store = null
	var/can_wear_l_store = 0

	var/icon/stand_icon
	var/icon/lying_icon
	var/now_pushing = null

	var/list/grabbed_by = list()

	var/hair_color
	var/hair_style
	var/skin_color

	var/appearance = APPEARANCE_MONKEY

	var/list/body_standing = list()
	var/list/body_lying = list()
	var/list/organs = list()

	var/blackout_threshold = 80

	var/attack_type = ATTACK_BITE

	var/knockout = 0
	var/knockdown = 0

	var/inertia_dir = null

	var/datum/dna/dna = null

	var/plasma = 0

	var/datum/hud/carbon/hud = null

	var/is_infectious = 0

	var/icon/face = null
	var/icon/face2 = null

	var/sl_gas_breathed = 0

	var/is_dextrous = 0
	is_intelligent = 0

	var/list/lostorgans = list() // organs be gone

	var/has_super_strength = 0
	var/is_fire_immune = 0
	var/has_xray_vision = 0
	var/is_telepathic = 0

	languages = list(LANGUAGE_MONKEY)
	curr_language = LANGUAGE_MONKEY

	icon = 'monkey.dmi'
	icon_state = "monkey1"
