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