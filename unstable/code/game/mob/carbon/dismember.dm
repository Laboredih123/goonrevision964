/mob/carbon/proc/sever(trgt)

	for(var/datum/organ/OOO in src.organs)				// This whole thing looks pretty damn bad
		if (trgt == OOO)
			if (OOO.name == "chest" || OOO.name == "diaper")
				return
			if (OOO.name == "head")
				var/obj/item/weapon/limb/head/O = new /obj/item/weapon/limb/head( src.loc )
				O.setup_limb(src)
				src.hair_style = "bald"		// "removes" hair from the mob icon
				src.update_face()
			else if (OOO.name == "r_arm")
				for(var/datum/organ/OO in src.organs)
					if (OO.name == "r_hand")
						src.organs -= OO
						src.lostorgans += OO
						var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/r_arm( src.loc )
						O.setup_limb(src)
						finish_dismember(trgt)
						return
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/r_arm_stump( src.loc )
				O.setup_limb(src)
			else if (OOO.name == "l_arm")
				for(var/datum/organ/OO in src.organs)
					if (OO.name == "l_hand")
						src.organs -= OO
						src.lostorgans += OO
						var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/l_arm( src.loc )
						O.setup_limb(src)
						finish_dismember(trgt)
						return
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/l_arm_stump( src.loc )
				O.setup_limb(src)
			else if (OOO.name == "r_leg")
				for(var/datum/organ/OO in src.organs)
					if (OO.name == "r_foot")
						src.organs -= OO
						src.lostorgans += OO
						var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/r_leg( src.loc )
						O.setup_limb(src)
						finish_dismember(trgt)
						src.knockdown_until(4)
						return
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/r_leg_stump( src.loc )
				O.setup_limb(src)
				src.knockdown_until(4)
			else if (OOO.name == "l_leg")
				for(var/datum/organ/OO in src.organs)
					if (OO.name == "l_foot")
						src.organs -= OO
						src.lostorgans += OO
						var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/l_leg( src.loc )
						O.setup_limb(src)
						finish_dismember(trgt)
						src.knockdown_until(4)
						return
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/l_leg_stump( src.loc )
				O.setup_limb(src)
				src.knockdown_until(4)
			else if (OOO.name == "r_hand")
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/r_hand( src.loc )
				O.setup_limb(src)
			else if (OOO.name == "l_hand")
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/l_hand( src.loc )
				O.setup_limb(src)
			else if (OOO.name == "r_foot")
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/r_foot( src.loc )
				O.setup_limb(src)
				src.knockdown_until(4)
			else if (OOO.name == "l_foot")
				var/obj/item/weapon/limb/O = new /obj/item/weapon/limb/l_foot( src.loc )
				O.setup_limb(src)
				src.knockdown_until(4)
	finish_dismember(trgt)

/mob/carbon/proc/finish_dismember(trgt)
	src.organs -= trgt
	src.lostorgans += trgt
	src.check_limbs()
	src.update_body()
	src.update_clothing_icons()

/mob/carbon/proc/check_limbs()
	for(var/datum/organ/O in src.lostorgans)
		if (O.name == "r_foot")
			for(var/datum/organ/OO in src.lostorgans)
				if (OO.name == "l_foot")	// only drop shoes if both feet are gone
					src.drop(SLOT_SHOES)
					src.can_wear_shoes = 0
		if (O.name == "r_hand")
			src.drop(SLOT_R_HAND)
			src.drop(SLOT_HANDCUFFS)
			src.can_wear_r_hand = 0
			src.can_wear_handcuffs = 0
			for(var/datum/organ/OO in src.lostorgans)
				if (OO.name == "l_hand")	// also for hands
					src.drop(SLOT_GLOVES)
					src.can_wear_gloves = 0
		if (O.name == "l_hand")
			src.drop(SLOT_L_HAND)
			src.drop(SLOT_HANDCUFFS)
			src.can_wear_l_hand = 0
			src.can_wear_handcuffs = 0
		if (O.name == "head")
			src.drop(SLOT_MASK)
			src.drop(SLOT_GLASSES)
			src.drop(SLOT_HELMET)
			src.drop(SLOT_HEADSET)
			can_wear_mask = 0
			can_wear_glasses = 0
			can_wear_helmet = 0
			can_wear_headset = 0
	src.hud.update_slots()


/mob/carbon/proc/check_clothing_icons(suffix)
	var/icon/clothing_icon_mask = null
	clothing_icon_mask = new /icon('humansevered.dmi', "empty_mask")
	for(var/datum/organ/O in src.lostorgans)
		if (O.name != "head")																				// remove those limbs
			clothing_icon_mask.Blend(new /icon('humansevered.dmi', "[O.name]_mask[suffix]"), ICON_MULTIPLY) // from the clothing icon that
	return clothing_icon_mask																				// have been severed
