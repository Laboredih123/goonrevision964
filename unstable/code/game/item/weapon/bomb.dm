/obj/bomb
	name = "bomb"
	icon = 'screen1.dmi'
	icon_state = "x"
	var/btype = 0  //0 = radio, 1= prox, 2=time
	var/btemp = 500	// bomb temperature (degC)

	New()
		var/bombtype = /obj/item/weapon/radio
		if(src.btype == 1)
			bombtype = /obj/item/weapon/prox_sensor
		else if(src.btype == 2)
			bombtype = /obj/item/weapon/timer

		var/obj/signaller = new bombtype()
		var/obj/item/weapon/igniter_tank/actor = new()
		actor.tank.loc = actor
		actor.igniter.loc = actor
		actor.welded = 1
		actor.tank.gas.temp = btemp + T0C
		var/obj/item/weapon/assembly/A = new(src.loc, signaller, actor, 1)
		signaller.loc = A
		actor.loc = A
		del(src)