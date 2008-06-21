/var/const/RIGHT = 0
/var/const/LEFT = 1

/mob/carbon
	var/intent = null
	var/a_intent = "disarm"
	var/m_int = null
	var/m_intent = "run"

	var/atom/movable/pulling = null
	var/next_move = null
	var/prev_move = null

	var/other = 0
	var/hand = RIGHT //the active hand - note that tons of code just says "if(hand)" or "if(!hand)", which sucks
	var/body_name

	var/blind = null
	var/rejuv = null
	var/sleeping = 0
	var/resting = 0
	var/lying = 0
	var/canmove = 1
	var/timeofdeath = 0
	var/cpr_time = 1
	var/losebreath = 0.0
	var/obj/stool/chair/buckled = null
	var/obj/item/weapon/tank/internal = null
	var/obj/item/weapon/storage/s_active = null
	var/obj/item/weapon/handcuffs/handcuffs = null

	var/obj/item/weapon/l_hand = null
	var/can_wear_l_hand = 0

	var/obj/item/weapon/r_hand = null
	var/can_wear_r_hand = 0

	var/obj/item/weapon/back = null
	var/can_wear_back = 0

	var/obj/item/weapon/clothing/mask/mask = null
	var/can_wear_mask = 0

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

	var/icon/stand_icon = null
	var/icon/lying_icon = null
	var/now_pushing = null

	var/grabbed_by = list()
	var/datum/chemical/chemicals = null

	var/const
		SLOT_BACK = 1
		SLOT_MASK = 2
		SLOT_HANDCUFFS = 3
		SLOT_L_HAND = 4
		SLOT_R_HAND = 5
		SLOT_BELT = 6
		SLOT_ID = 7
		SLOT_GLASSES = 9
		SLOT_GLOVES = 10
		SLOT_HELMET = 11
		SLOT_SHOES = 12
		SLOT_SUIT = 13
		SLOT_JUMPSUIT = 14
		SLOT_L_STORE = 15
		SLOT_R_STORE = 16
		SLOT_HEADSET = 17
		SLOT_IN_BACKPACK = 18


	var/hair_color = HAIR_COLOR_BROWN
	var/hair_style = HAIR_STYLE_SHORT
	var/appearance = APPEARANCE_MONKEY
	var/cameraFollow = null

	var/list/body_standing = list()
	var/list/body_lying = list()
	var/list/organs = list()

	var/blackout_threshold = 80

	var/attack_type = ATTACK_BITE

	var/knockout = 0
	var/knockdown = 0

/mob/carbon/New()
	spawn (1)
		var/atom/organ/chest/chest = new /atom/organ/chest( src )
		chest.owner = src
		var/atom/organ/diaper/diaper = new /atom/organ/diaper( src )
		diaper.owner = src
		var/atom/organ/head/head = new /atom/organ/head( src )
		head.owner = src
		var/atom/organ/l_arm/l_arm = new /atom/organ/l_arm( src )
		l_arm.owner = src
		var/atom/organ/r_arm/r_arm = new /atom/organ/r_arm( src )
		r_arm.owner = src
		var/atom/organ/l_hand/l_hand = new /atom/organ/l_hand( src )
		l_hand.owner = src
		var/atom/organ/r_hand/r_hand = new /atom/organ/r_hand( src )
		r_hand.owner = src
		var/atom/organ/l_leg/l_leg = new /atom/organ/l_leg( src )
		l_leg.owner = src
		var/atom/organ/r_leg/r_leg = new /atom/organ/r_leg( src )
		r_leg.owner = src
		var/atom/organ/l_foot/l_foot = new /atom/organ/l_foot( src )
		l_foot.owner = src
		var/atom/organ/r_foot/r_foot = new /atom/organ/r_foot( src )
		r_foot.owner = src
		src.organs += chest
		src.organs += diaper
		src.organs += head
		src.organs += l_arm
		src.organs += r_arm
		src.organs += l_hand
		src.organs += r_hand
		src.organs += l_leg
		src.organs += r_leg
		src.organs += l_foot
		src.organs += r_foot