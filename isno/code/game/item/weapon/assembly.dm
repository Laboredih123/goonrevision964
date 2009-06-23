/obj/item/weapon
	var/is_signaller = 0
	var/is_actor = 0
	var/assembly_name = null
	var/is_attachable = 0

/obj/item/weapon/proc/signal()
	return


/obj/item/weapon/attackby(obj/item/weapon/W, mob/carbon/user)
	if(src.is_attachable && W.is_attachable && ((src.is_signaller && W.is_actor) || (W.is_signaller && src.is_actor)))
		var/obj/item/weapon/signaller
		var/obj/item/weapon/actor
		if(src.is_signaller && W.is_actor)
			signaller = src
			actor = W
		else
			signaller = W
			actor = src

		signaller.add_fingerprint(user)
		actor.add_fingerprint(user)

		var/obj/item/weapon/assembly/A = new(W.loc, signaller, actor)
		signaller.loc = A
		actor.loc = A

		if (user.client)
			user.client.screen -= signaller
			user.client.screen -= actor

		if(user.r_hand == W)
			user.u_equip(W)
			user.equip_if_possible(A, SLOT_R_HAND)
		else if(user.l_hand == W)
			user.u_equip(W)
			user.equip_if_possible(A, SLOT_L_HAND)

		if(user.l_hand == src)
			user.l_hand = null
		else if(user.r_hand == src)
			user.r_hand = null

		user.update_clothing()
	else if(istype(W, /obj/item/weapon/screwdriver) && (src.is_signaller || src.is_actor))
		src.is_attachable = !src.is_attachable
		if(src.is_attachable)
			user.see("<font color='blue'>The [src.name] can now be attached and modified!</font>")
		else
			user.see("<font color='blue'>The [src.name] can no longer be modified or attached!</font>")
		src.add_fingerprint(user)
	else
		return ..()

/obj/item/weapon/examine()
	set src in view()

	..()
	if(!src.is_signaller && !src.is_actor)
		return
	if(get_dist(src, usr) <= 1 || src.loc == usr)
		if(src.is_attachable)
			usr.see("<font color='blue'>It can be attached and modified!</font>")
		else
			usr.see("<font color='blue'>It can not be modified or attached!</font>")




/obj/item/weapon/assembly
	name = "Some sort of assembly"
	var/obj/item/weapon/signaller // something like a timer or a prox sensor, tells the actor when to do its thing
	var/obj/item/weapon/actor // something like an igniter-tank assembly or a radio, does something when signaller says
	var/default_icon_state = ""
	var/secured = 0
	icon = 'assemblies.dmi'
	var/datum/assembly/wirebundle/wirebundle = null

	New(loc, obj/item/weapon/signaller, obj/item/weapon/actor, secured = 0)
		..()
		if(signaller)
			src.signaller = signaller
		if(actor)
			src.actor = actor

		if(istype(src.signaller, /obj/item/weapon/infra))
			src.verbs += /obj/item/weapon/assembly/proc/rotate

		src.dir = signaller.dir

		src.secured = secured

		default_icon_state = "[src.signaller.assembly_name]-[src.actor.assembly_name]"
		icon_state = default_icon_state
		s_istate = src.actor.s_istate

		name = "[src.signaller.assembly_name]-[src.actor.assembly_name] assembly"

	Del()
		del(signaller)
		del(actor)
		..()

	proc/c_state(n)
		icon_state = "[default_icon_state][n]"

	examine()
		..()
		signaller.examine()
		actor.examine()

	attackby(obj/item/weapon/W, mob/carbon/user)
		src.add_fingerprint(user)
		if(istype(W, /obj/item/weapon/analyzer) && istype(actor, /obj/item/weapon/igniter_tank))
			return actor.attackby(W, user)
		else if(istype(W, /obj/item/weapon/wrench))
			signaller.loc = src.loc
			if(user.r_hand == src)
				user.r_hand = signaller
				signaller.layer = 20
			else if(user.l_hand == src)
				user.l_hand = signaller
				signaller.layer = 20

			var/turf/T = get_turf(src)
			actor.loc = T
			actor.layer = initial(actor.layer)

			actor = null
			signaller = null
			del src
			return
		else if(istype(W, /obj/item/weapon/weldingtool) && istype(actor, /obj/item/weapon/igniter_tank))
			return actor.attackby(W, user)
		else if(istype(W, /obj/item/weapon/screwdriver))
			src.secured = !src.secured
			if(src.secured)
				user.see("\blue The [src.name] is now secured!")
			else
				user.see("\blue The [src.name] is now unsecured!")
		else
			return ..()

	attack_self(mob/user)
		signaller.attack_self(user, 1)
		add_fingerprint(user)
		return ..()

	signal()
		if(src.secured)
			actor.signal()

	HasProximity(atom/movable/A)
		signaller.HasProximity(A)

	dropped()
		signaller.dropped()

	proc/rotate()
		set src in usr
		if(istype(signaller, /obj/item/weapon/infra))
			var/obj/item/weapon/infra/s = signaller
			s.rotate()
			src.dir = s.dir

	Move()
		var/t = src.dir
		..()
		src.dir = t
		if(istype(signaller, /obj/item/weapon/infra))
			var/obj/item/weapon/infra/infra = signaller
			del infra.first

	interact()
		..()
		if(istype(signaller, /obj/item/weapon/infra))
			var/obj/item/weapon/infra/infra = signaller
			del infra.first