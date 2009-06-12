/**
 * Multitool -- A multitool is used for hacking electronic devices.
 *
 */
/obj/item/weapon/multitool
	name = "multitool"
	icon_state = "multitool"
	s_istate = "multitool"
	flags = 322.0
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."
	is_actor = 1
	assembly_name = "multitool"

	signal()
		if(istype(src.loc, /obj/item/weapon/assembly))
			var/obj/item/weapon/assembly/A = src.loc
			if(A.wirebundle)
				A.wirebundle.r_signal(1, A)