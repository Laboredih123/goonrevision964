/obj/item/weapon/igniter_tank
	var/obj/item/weapon/igniter/igniter
	var/obj/item/weapon/tank/plasmatank/tank
	name = "igniter-plasma tank assembly"
	assembly_name = "igniter-plasma tank"
	icon = 'assemblies.dmi'
	icon_state = "igniter-tank"
	s_istate = "igniter-tank"
	is_actor = 1
	assembly_name = "igniter-tank"
	var/welded = 0

	signal()
		if(welded)
			tank.ignite()

	New(loc, obj/item/weapon/igniter/igniter, obj/item/weapon/tank/plasmatank/tank)
		if(igniter)
			src.igniter = igniter
		else
			src.igniter = new /obj/item/weapon/igniter()

		if(tank)
			src.tank = tank
		else
			src.tank = new /obj/item/weapon/tank/plasmatank()

		src.tank.layer = initial(src.tank.layer)
		src.igniter.layer = initial(src.igniter.layer)

		..()

	attackby(obj/item/weapon/W, mob/carbon/user)
		if (istype(W, /obj/item/weapon/weldingtool))
			welded = !welded
			if(welded)
				user.see("\blue A pressure hole has been bored to the plasma tank valve. The plasma tank can now be ignited.")
				bombers -= user.ckey
				bombers += user.ckey
				world.log_bomb("[user] ([user.ckey]) welded an igniter-tank assembly with temperature [src.tank.gas.temp - T0C]")
			else
				user.see("\blue The hole has been closed.")
			src.add_fingerprint(user)
		else if(istype(W, /obj/item/weapon/wrench))
			tank.loc = src.loc
			if(user.r_hand == src)
				user.r_hand = tank
				tank.layer = 20
			else if(user.l_hand == src)
				user.l_hand = tank
				tank.layer = 20

			var/turf/T = get_turf(src)
			igniter.loc = T
			igniter.layer = initial(igniter.layer)

			igniter = null
			tank = null
			del src
		else
			return ..()