/datum/job/plasmologist // TODO: come up with less retarded name that isn't "scientist"
	name = "Plasmologist"
	max = 2
	responsibilities = {"<html>Test incendiary devices in the test chamber, and make them for the heads if they
	    require any. You may wish to experiment with devices containing gases other than pure plasma, particularly
	    their effects on monkey test subjects. DON'T FUCKING BOMB THE STATION YOU DICK."}

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/toxinswhite(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/bio_suit(M), SLOT_SUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/head/bio_hood(M), SLOT_HELMET)
		M.equip_if_possible(new /obj/item/weapon/clothing/mask/gasmask(M), SLOT_MASK)
		M.equip_if_possible(new /obj/item/weapon/tank/oxygentank(M), SLOT_L_HAND)
		..()

	get_access()
		return list(access_tox, access_tox_storage)