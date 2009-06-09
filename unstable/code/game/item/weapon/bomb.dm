/obj/bomb
	name = "bomb"
	icon = 'screen1.dmi'
	icon_state = "x"
	var/btype = 0  //0 = radio, 1= prox, 2=time
	var/explosive = 1	// 0= firebomb
	var/btemp = 500	// bomb temperature (degC)
	var/active = 0

	New()
		var/bombtype = /obj/item/weapon/radio
		if(src.btype == 1)
			bombtype = /obj/item/weapon/prox_sensor
		else if(src.btype == 2)
			bombtype = /obj/item/weapon/timer

		var/signaller = new bombtype()
		var/obj/item/weapon/igniter_tank/actor = new()
		var/obj/item/weapon/assembly/A = new(signaller, actor)
		A.loc = src.loc
		del(src)