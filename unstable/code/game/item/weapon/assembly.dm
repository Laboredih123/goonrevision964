/obj/item/weapon
	var/is_signaller = 0
	var/is_actor = 0
	var/assembly_name = null
	var/is_attachable = 0
	var/obj/item/weapon/assembly/master = null

/obj/item/weapon/proc/signal()
	return

/obj/item/weapon/proc/get_icon_state_suffix()
	return

/obj/item/weapon/attackby(obj/item/weapon/W, mob/carbon/user)
	if(src.is_attachable && W.is_attachable && ((src.is_signaller && W.is_actor) || (W.is_signaller && src.is_actor)))
		var/obj/item/weapon/signaller
		var/obj/item/weapon/actor
		if(src.is_signaller)
			signaller = src
			actor = W
		else
			signaller = W
			actor = src
		var/obj/item/weapon/assembly/A = new(signaller, actor)
		A.loc = src.loc

		if (user.client)
			user.client.screen -= signaller
			user.client.screen -= actor

		if(user.r_hand == src)
			user.r_hand = A
			A.layer = 20
		else if(user.l_hand == src)
			user.l_hand = A
			A.layer = 20

	else if(istype(W, /obj/item/weapon/screwdriver) && (src.is_signaller || src.is_actor))
		src.is_attachable = !src.is_attachable
		if(src.is_attachable)
			user.see("<font color='blue'>The signaller can now be attached and modified!</font>")
		else
			user.see("<font color='blue'>The signaller can no longer be modified or attached!</font>")
		src.add_fingerprint(user)

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

	New(obj/item/weapon/signaller, obj/item/weapon/actor, secured = 0)
		if(signaller)
			src.signaller = signaller
		if(actor)
			src.actor = actor

		signaller.master = src
		signaller.loc = src
		actor.master = src
		actor.loc = src

		signaller.layer = initial(signaller.layer)
		actor.layer = initial(actor.layer)

		signaller.add_fingerprint(user)
		actor.add_fingerprint(user)

		src.dir = signaller.dir

		src.secured = secured

		default_icon_state = "[signaller.s_istate]-[actor.s_istate]"
		update_icon()

		name = "[signaller.assembly_name]-[actor.assembly_name] assembly"

	Del()
		del(signaller)
		del(actor)
		..()

	proc/update_icon()
		icon_state = "[default_icon_state][signaller.get_icon_state_suffix()]"

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

			actor = null
			signaller = null
			del src
			return
		else if(istype(W, /obj/item/weapon/weldingtool) && istype(actor, /obj/item/weapon/igniter_tank))
			return actor.attackby(W)
		else if(istype(W, /obj/item/weapon/screwdriver))
			src.secured = !src.secured
			if(src.secured)
				user.see("\blue The [src.name] is now secured!")
			else
				user.see("\blue The [src.name] is now unsecured!")
		return ..()

	attack_self(mob/user)
		signaller.attack_self(user, 1)
		add_fingerprint(user)

	signal()
		if(src.secured)
			actor.signal()