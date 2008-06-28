/datum/gene/blobbishness
	default = APPEARANCE_QUIVERING_MASS

/datum/gene/appearance/New()
	attributes = list(APPEARANCE_QUIVERING_MASS, APPEARANCE_HUMAN)

/datum/gene/appearance/pre_apply(mob/carbon/M)
	M.appearance = APPEARANCE_HUMAN

/datum/gene/appearance/apply(mob/carbon/M, attribute)
	if(attribute == APPEARANCE_QUIVERING_MASS)
		M.appearance = attribute
		M.can_wear_handcuffs = 0
		M.can_wear_l_hand = 0
		M.can_wear_r_hand = 0
		M.can_wear_mask = 0
		M.can_wear_back = 0
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
		M.is_intelligent = 0
		M.is_dextrous = 0
		M.languages = list()

/datum/gene/appearance/pick_attribute(mob/carbon/M)
	return M.appearance