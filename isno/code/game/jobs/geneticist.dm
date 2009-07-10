/datum/job/geneticist
	name = "Geneticist"
	max = 2
	responsibilities = {"<html>Experiment on monkeys and any willing test subjects. One of your monkeys has a
	    superpower, perhaps you should try to find out which?</html>"}

	give_equipment(mob/carbon/M)
		M.equip_if_possible(new /obj/item/weapon/clothing/under/geneticswhite(M), SLOT_JUMPSUIT)
		M.equip_if_possible(new /obj/item/weapon/clothing/shoes/white(M), SLOT_SHOES)
		M.equip_if_possible(new /obj/item/weapon/clothing/suit/labcoat(M), SLOT_SUIT)
		..()

	get_access()
		return list(access_medical_supplies, access_medical_records, access_morgue, access_genetics)