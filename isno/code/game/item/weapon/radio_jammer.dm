/obj/item/weapon/radio_jammer
	name = "Radio Jammer"
	desc = "When active, creates an EM field that prevents radios from operating within [JAMMER_RANGE] tiles."
	icon_state = "jammer0"
	flags = FPRINT|ONBELT
	w_class = 2
	s_istate = "electronic"
	var/on = 0

	attack_self(mob/user)
		on = !on
		src.add_fingerprint(user)
		icon_state = "jammer[on]"