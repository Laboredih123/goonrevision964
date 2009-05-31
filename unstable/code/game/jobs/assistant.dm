/datum/job/assistant
	priority = 0
	max = INFINITY
	name = "Assistant"

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/white(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(M), SLOT_SUIT)
		M.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(M), SLOT_L_HAND)
		..()

	get_access()
		return list(access_genetics, access_maint_tunnels, access_external_airlocks)
