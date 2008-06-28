/datum/organ
	var/name = "chest"
	var/datum/damage/dam = new /datum/damage()
	var/icon/dam_icon_standing = null
	var/icon/dam_icon_lying = null
	var/curr_damage_state = null

/datum/organ/New(name)
	src.name = name

/datum/organ/proc/take_damage(datum/damage/dam)
	src.dam.add(dam)
	src.update_icons()

/datum/organ/proc/heal_damage(datum/damage/dam)
	src.dam.subtract(dam)
	src.update_icons()

/datum/organ/proc/get_damage_state()
	var/burn = 0
	var/brute = 0

	if(src.dam.burn == 0)
		burn = 0
	else if (src.dam.burn < 15)
		burn = 1
	else if (src.dam.burn < 30)
		burn = 2
	else
		burn = 3

	if (src.dam.brute == 0)
		brute = 0
	else if (src.dam.brute < 15)
		brute = 1
	else if (src.dam.brute < 30)
		brute = 2
	else
		brute = 3

	return "[brute][burn]"

/datum/organ/proc/update_icons()
	var/new_damage_state = src.get_damage_state()
	if(new_damage_state == curr_damage_state)
		return
	curr_damage_state = new_damage_state

	dam_icon_standing = new /icon('dam_human.dmi', new_damage_state)
	dam_icon_standing.Blend(new /icon('dam_mask.dmi', src.name), ICON_MULTIPLY)

	dam_icon_lying = new /icon('dam_human.dmi', "[new_damage_state]-2")
	dam_icon_lying.Blend(new /icon('dam_mask.dmi', "[src.name]2"), ICON_MULTIPLY)