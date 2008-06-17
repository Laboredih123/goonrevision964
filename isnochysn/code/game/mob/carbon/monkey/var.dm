/mob/carbon/monkey
	name = "monkey"
	icon = 'monkey.dmi'
	icon_state = "monkey1"
	var/t_plasma = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null
	var/now_pushing = null
	flags = FPRINT & TABLEPASS
	var/cameraFollow = null

	New()
		src.name = "monkey ([rand(26)][rand(26)][rand(26)][rand(26)])"
		..()