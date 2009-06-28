//This gene determines whether they look like a human or a monkey
//It does NOT determine if they're a quivering mass - that is a different gene entirely

/var/const
	APPEARANCE_MONKEY = "monkey"
	APPEARANCE_HUMAN = "human"
	APPEARANCE_QUIVERING_MASS = "ugh"

/datum/gene/appearance
	default = APPEARANCE_MONKEY
	is_noticeable = 1

	New()
		attributes = list(APPEARANCE_MONKEY, APPEARANCE_HUMAN)

	pre_apply(mob/carbon/M)
		M.appearance = APPEARANCE_HUMAN
		M.can_wear_jumpsuit = 1
		M.can_wear_suit = 1
		M.can_wear_l_store = 1
		M.can_wear_r_store = 1
		M.can_wear_headset = 1
		M.can_wear_shoes = 1
		M.can_wear_helmet = 1
		M.can_wear_gloves = 1
		M.can_wear_glasses = 1
		M.can_wear_id = 1
		M.attack_type = M.ATTACK_PUNCH

	apply(mob/carbon/M, attribute)
		if(M.appearance != APPEARANCE_QUIVERING_MASS)
			M.appearance = attribute
		if(M.appearance == APPEARANCE_MONKEY) //TODO: update the icons so monkeys CAN wear jumpsuits, etc
			//right now the DNA system is kind of silly because there's no icons for "monkey wearing jumpsuit"
			//so it just has to be uniformly (lol) disallowed
			M.attack_type = M.ATTACK_BITE
			M.can_wear_jumpsuit = 0
			M.can_wear_suit = 0
			M.can_wear_l_store = 0
			M.can_wear_r_store = 0
			M.can_wear_headset = 0
			M.can_wear_shoes = 0
			M.can_wear_helmet = 0
			M.can_wear_gloves = 0
			M.can_wear_glasses = 0
			M.can_wear_id = 0

	pick_attribute(mob/carbon/M)
		return M.appearance