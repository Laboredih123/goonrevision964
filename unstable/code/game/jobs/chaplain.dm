/datum/job/chaplain
	name = "Chaplain"
	max = 1

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/chapblack(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/black(M), SLOT_SHOES)
		..()

	get_access()
		return list(access_morgue, access_chaplain_office)