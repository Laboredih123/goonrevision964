/obj/item/weapon/implantpad/proc/update()

	if (src.case)
		src.icon_state = "implantpad-1"
	else
		src.icon_state = "implantpad-0"
	return

/obj/item/weapon/implantpad/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))
		return

	if ((src.case && (user.l_hand == src || user.r_hand == src)))
		if (user.hand)
			user.l_hand = src.case
		else
			user.r_hand = src.case
		src.case.loc = user
		src.case.layer = 20
		src.case.add_fingerprint(user)
		src.case = null
		user.update_clothing()
		src.add_fingerprint(user)
		update()
	else
		if (user.contents.Find(src))
			spawn( 0 )
				src.attack_self(user)
				return
		else
			return ..()
	return

/obj/item/weapon/implantpad/attackby(obj/item/weapon/implantcase/C as obj, mob/carbon/user as mob)

	if (istype(C, /obj/item/weapon/implantcase))
		if (!( src.case ))
			user.drop_item()
			C.loc = src
			src.case = C
	else
		return
	src.update()
	return

/obj/item/weapon/implantpad/attack_self(mob/user as mob)

	user.machine = src
	var/dat = "<B>Implant Mini-Computer:</B><HR>"
	if (src.case)
		if (src.case.imp)
			if (istype(src.case.imp, /obj/item/weapon/implant/tracking))
				var/obj/item/weapon/implant/tracking/T = src.case.imp
				dat += "<b>Implant Specifications:</b><br>"
				dat += "<b>Name:</b> Tracking Beacon<br>"
				dat += "<b>Zone:</b> Spinal Column> 2-5 vertebrae<BR>"
				dat += "<b>Power Source:</b> Nervous System Ion Withdrawl Gradient<BR>"
				dat += "<b>Life:</b> 10 minutes after death of host<BR>"
				dat += "<b>Important Notes:</b> None<BR>"
				dat += "<HR><b>Implant Details:</b> <BR>"
				dat += "<b>Function:</b> Continuously transmits low power signal on frequency- Useful for tracking.<BR>"
				dat += "Range: 35-40 meters<BR>"
				dat += "<b>Special Features:</b><BR>"
				dat += "<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if a malfunction occurs thereby securing safety of subject. The implant will melt and disintegrate into bio-safe elements.<BR>"
				dat += "<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the circuitry. As a result neurotoxins can cause massive damage.<HR>"
				dat += "Implant Specifics:\nFrequency (144.1-148.9):"
				dat += "<A href='?src=\ref[src];freq=-10'>-</A><A href='?src=\ref[src];freq=-2'>-</A> [T.get_freq_text()] <A href='?src=\ref[src];freq=2'>+</A><A href='?src=\ref[src];freq=10'>+</A><BR>"
				dat += "ID (1-100): <A href='?src=\ref[src];id=-10'>-</A><A href='?src=\ref[src];id=-1'>-</A> [T.id] <A href='?src=\ref[src];id=1'>+</A><A href='?src=\ref[src];id=10'>+</A><BR>"
			else
				if (istype(src.case.imp, /obj/item/weapon/implant/freedom))
					dat += "<b>Implant Specifications:</b><BR>"
					dat += "<b>Name:</b> Freedom Beacon<BR>"
					dat += "<b>Zone:</b> Right Hand> Near wrist<BR>"
					dat += "<b>Power Source:</b> Lithium Ion Battery<BR>"
					dat += "<b>Life:</b> optimum 5 uses<BR>"
					dat += "<b>Important Notes: <font color='red'>Illegal</font></b><BR>"
					dat += "<HR>\n<b>Implant Details:</b> <BR>"
					dat += "<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking mechanisms<BR>"
					dat += "<b>Special Features:</b><BR>"
					dat += "<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system along the dark joy sectors which respond mainly to chuckling<BR>"
					dat += "<b>Integrity:</b> The battery is extremely weak and commonly after injection its life can drive down to only 1 use.<HR>"
					dat += "No Implant Specifics"
				else
					dat += "Implant ID not in database"
		else
			dat += "The implant casing is empty."
	else
		dat += "Please insert an implant casing!"
	ss13_browse(user, dat, "window=implantpad")
	return

/obj/item/weapon/implantpad/Topic(href, href_list)
	..()
	if (!usr.is_active())
		return
	if ((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["freq"])
			if ((istype(src.case, /obj/item/weapon/implantcase) && istype(src.case.imp, /obj/item/weapon/implant/tracking)))
				var/obj/item/weapon/implant/tracking/T = src.case.imp
				T.freq += text2num(href_list["freq"])
				T.freq = min(1489, T.freq)
				T.freq = max(1441, T.freq)
		if (href_list["id"])
			if ((istype(src.case, /obj/item/weapon/implantcase) && istype(src.case.imp, /obj/item/weapon/implant/tracking)))
				var/obj/item/weapon/implant/tracking/T = src.case.imp
				T.id += text2num(href_list["id"])
				T.id = min(100, T.id)
				T.id = max(1, T.id)
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
				//Foreach goto(290)
		src.add_fingerprint(usr)
	else
		ss13_browse(usr, null, "window=implantpad")
		return
	return
