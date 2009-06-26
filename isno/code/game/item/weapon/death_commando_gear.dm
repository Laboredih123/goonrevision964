/obj/item/weapon/clothing/suit/swat_suit/death_commando
	name = "Death Commando Suit"
	icon = 'death_commando.dmi'
	icon_state = "death_commando_suit"
	s_istate = "death_commando_suit"
	flags = FPRINT | TABLEPASS | SUITSPACE

/obj/item/weapon/clothing/mask/gasmask/death_commando
	name = "Death Commando Mask"
	icon = 'death_commando.dmi'
	icon_state = "death_commando_mask"
	s_istate = "death_commando_mask"

/var/const/PROJECTILE_TASER = 1
/var/const/PROJECTILE_LASER = 2
/var/const/PROJECTILE_BULLET = 3
/var/const/PROJECTILE_PULSE= 4


/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	icon_state = "pulse_rifle"
	w_class = 3
	throw_speed = 2
	throw_range = 3
	force = 15

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if (flag)
			return
		if (!user.check_dexterity())
			return
		src.add_fingerprint(user)


		var/turf/curloc = user.loc
		var/atom/targloc = get_turf(target)
		if (!targloc || !istype(targloc, /turf) || !curloc || targloc == curloc)
			return

		var/obj/beam/a_laser/A = new /obj/beam/a_laser/pulse_laser(user.loc)
		A.current = curloc
		A.yo = targloc.y - curloc.y
		A.xo = targloc.x - curloc.x
		user.next_move = world.time + 4
		spawn()
			A.process()

	attack(mob/carbon/M as mob, mob/user as mob)
		..()
		src.add_fingerprint(user)
		if(!istype(M, /mob/carbon))
			return
		if (prob(50) && !M.is_dead)
			var/mob/carbon/H = M
			if (istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80))
				H.think("\red The helmet protects you from being hit hard in the head!")
				return
			H.knockdown_until(rand(1,12))
			H.show_viewers(text("\red <B>[] has been knocked down!</B>", M))
		return


/obj/beam/a_laser/pulse_laser
	name = "pulse laser"
	icon_state = "u_laser"

	Bump(atom/A)
		spawn()
			if(A)
				A.las_act(PROJECTILE_PULSE)
			del(src)