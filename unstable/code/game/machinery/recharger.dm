obj/machinery/recharger
	anchored = 1.0
	icon = 'stationobjs.dmi'
	icon_state = "recharger0"
	name = "recharger"

	var
		obj/item/weapon/gun/energy/charging = null

	attackby(obj/item/weapon/G as obj, mob/carbon/user as mob)
		if (src.charging)
			return
		if (istype(G, /obj/item/weapon/gun/energy))
			user.drop_item()
			G.loc = src
			src.charging = G

	interact(mob/user as mob)
		if(!user.check_intelligence())
			return
		if(!istype(user, /mob/carbon))
			return
		src.add_fingerprint(user)
		if (src.charging)
			src.charging.update_icon()
			src.charging.loc = src.loc
			src.charging = null

	process()
		if (src.charging && ! (stat & NOPOWER) )
			if (src.charging.charges < src.charging.maximum_charges)
				src.charging.charges++
				src.icon_state = "recharger1"
				use_power(250)
			else
				src.icon_state = "recharger2"
		else
			src.icon_state = "recharger0"
