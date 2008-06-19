/mob/carbon/monkey/megamonkey
	name = "mutant monkey"
	icon = 'monkey.dmi'
	icon_state = "megamonkey1"
	gender = MALE
	var/lastattacktime			// world.time that last p-attack happened - for tuning firing rate
	var/activecount				// count-down before mob goes into idle mode