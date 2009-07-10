/obj/item/weapon/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	flags = 322.0
	s_istate = "igniter"
	is_actor = 1
	assembly_name = "igniter"

	signal()
		src.ignite()

	attack_self(mob/user as mob)
		src.add_fingerprint(user)
		spawn( 5 )
			ignite()

	proc/ignite()
		var/turf/T = get_turf(src) // works properly even if in an assembly!
		if (T && T.firelevel < 900000.0)
			T.firelevel = T.gas.plasma


	attackby(obj/item/weapon/W, mob/carbon/user)
		if(istype(W, /obj/item/weapon/tank/plasmatank) && src.is_attachable)
			src.add_fingerprint(user)
			W.add_fingerprint(user)

			var/obj/item/weapon/igniter_tank/A = new(W.loc, src, W)
			W.loc = A
			src.loc = A

			if (user.client)
				user.client.screen -= src
				user.client.screen -= W

			if(user.r_hand == W)
				user.r_hand = A
				A.layer = 20
			else if(user.l_hand == W)
				user.l_hand = A
				A.layer = 20

			if(user.l_hand == src)
				user.l_hand = null
			else if(user.r_hand == src)
				user.r_hand = null

			user.update_clothing()
		else
			return ..()