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

	New(obj/item/weapon/igniter/igniter, obj/item/weapon/tank/plasmatank/tank)
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

	attackby(obj/item/weapon/W, mob/carbon/user)
		if (istype(W, /obj/item/weapon/weldingtool))
			welded = !welded
			if(welded)
				user.see("\blue A pressure hole has been bored to the plasma tank valve. The plasma tank can now be ignited.")
			else
				user.see("\blue The hole has been closed.")
			bombers -= user.ckey
			bombers += user.ckey
			src.add_fingerprint(user)
		else
			return ..()