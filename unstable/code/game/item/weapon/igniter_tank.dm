/obj/item/weapon/igniter_tank
	var/obj/item/weapon/igniter/igniter
	var/obj/item/weapon/tank/plasmatank/tank
	name = "igniter-plasma tank assembly"
	assembly_name = "igniter-plasma tank"
	icon = 'assemblies.dmi'
	icon_state = "igniter_tank"
	s_istate = "igniter_tank"
	is_actor = 1
	assembly_name = "igniter-tank"

	signal()
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