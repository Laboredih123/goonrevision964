/obj/item/weapon/radio
	name = "Station Bounced Radio"
	icon_state = "radio"
	var/freq = 145.9
	var/wires = WIRE_SIGNAL | WIRE_RECEIVE | WIRE_TRANSMIT
	var/attachable = 0
	var/last_transmission
	var/transmitting = 0
	var/receiving = 1
	flags = TABLEPASS | FPRINT | ONBELT
	throw_speed = 2
	throw_range = 9
	w_class = 2
	s_istate = "electronic"
	var/const
		WIRE_SIGNAL = 1 //sends a signal, like to set off a bomb or electrocute someone
		WIRE_RECEIVE = 2
		WIRE_TRANSMIT = 4
		TRANSMISSION_DELAY = 5 // only 2/second/radio
	var/listenrange = 2
	var/b_stat = 0

/obj/item/weapon/radio/beacon
	name = "Tracking Beacon"
	icon_state = "beacon"
	var/code = "beacon"
/obj/item/weapon/radio/electropack
	name = "Electropack"
	icon_state = "electropack0"
	var/code = 2
	var/on = 0
	var/e_pads = 0
	freq = 144.9
	w_class = 5
	flags = ONBACK | TABLEPASS | FPRINT
	s_istate = "electropack"
/obj/item/weapon/radio/headset
	name = "Radio Headset"
	icon_state = "headset"
	listenrange = 1
/obj/item/weapon/radio/intercom
	name = "Station Intercom (Radio)"
	icon_state = "intercom"
	anchored = 1
	var/number = 0
	listenrange = 7
/obj/item/weapon/radio/signaler
	name = "Remote Signaling Device"
	icon_state = "signaler"
	var/code = 30
	w_class = 1
	freq = 145.7
	var/delay = 0



/obj/item/weapon/radio/proc/receive(datum/message/M, freq)
	if (freq != src.freq || !M || !src.receiving || !(src.wires & WIRE_RECEIVE))
		return
	for(var/atom/A in hearers(listenrange))
		A.hear_message(M, src)

/obj/item/weapon/radio/proc/transmit(datum/message/M)
	if(!(src.wires & WIRE_TRANSMIT))
		return
	if(last_transmission && world.time < last_transmission + TRANSMISSION_DELAY)
		return
	last_transmission = world.time
	for(var/obj/item/weapon/radio/R in world)
		R.receive(M, src.freq)

/obj/item/weapon/radio/talk_into(datum/message/M, source)
	src.transmit(M, source)

/obj/item/weapon/radio/hear_message(datum/message/M, source)
	if (src.transmitting)
		src.talk_into(M, source)

/obj/item/weapon/radio/examine()
	set src in view()

	..()
	if ((get_dist(src, usr) <= 1 || src.loc == usr))
		if (src.attachable)
			usr.see("\blue The radio can be attached and modified!")
		else
			usr.see("\blue The radio can not be attached or modified!")
	return

/obj/item/weapon/radio/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.machine = src
	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return
	src.b_stat = !( src.b_stat )
	if (src.b_stat)
		user.see("\blue The radio can now be attached and modified!")
	else
		user.see("\blue The radio can no longer be modified or attached!")
	for(var/mob/M in viewers(1, src))
		if (M.client)
			src.attack_self(M)
	src.add_fingerprint(user)
	return

/obj/item/weapon/radio/attack_self(mob/user as mob)
	user.machine = src
	var/t1
	if (src.b_stat)
		t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
	else
		t1 = "-------"
	var/dat = text("<TT>Microphone: []<BR>\nSpeaker: []<BR>\nFrequency: <A href='?src=\ref[];freq=-1'>-</A><A href='?src=\ref[];freq=-0.2'>-</A> [] <A href='?src=\ref[];freq=0.2'>+</A><A href='?src=\ref[];freq=1'>+</A><BR>\n[]</TT>", (src.broadcasting ? text("<A href='?src=\ref[];talk=0'>Engaged</A>", src) : text("<A href='?src=\ref[];talk=1'>Disengaged</A>", src)), (src.listening ? text("<A href='?src=\ref[];listen=0'>Engaged</A>", src) : text("<A href='?src=\ref[];listen=1'>Disengaged</A>", src)), src, src, src.freq, src, src, t1)
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/radio/Topic(href, href_list)
	if (usr.stat)
		return
	if ((usr.contents.Find(src) || get_dist(src, usr) <= 1 && istype(src.loc, /turf)) || (istype(usr, /mob/silicon/ai)))
		usr.machine = src
		if (href_list["freq"])
			src.freq += text2num(href_list["freq"])
			if (src.freq * 10 % 2 == 0)
				src.freq += 0.1
			src.freq = min(148.9, src.freq)
			src.freq = max(144.1, src.freq)
		else if (href_list["talk"])
			src.transmitting = text2num(href_list["talk"])
		else if (href_list["listen"])
			src.receiving = text2num(href_list["listen"])
		else if (href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if (!istype(usr.equipped(), /obj/item/weapon/wirecutters))
				return
			src.wires ^= t1
		if (!src.master)
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				src.updateDialog()
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				src.updateDialog()
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/weapon/radio/beacon/talk_into()
	return

/obj/item/weapon/radio/beacon/verb/alter_signal(t as text)
	set src in usr

	if (usr.canmove && !usr.is_handcuffed())
		src.code = t
	if (!src.code)
		src.code = "beacon"
	src.add_fingerprint(usr)
	return


/obj/item/weapon/radio/signaler/receive(datum/message/M, freq)
	//Sending a code is actually just sending a message in COMPUTER_LANG to the specified frequency, with text of the code number.
	if (freq != src.freq || !M || !(src.wires & WIRE_RECEIVE))
		return
	if(M.language != COMPUTER_LANG)
		return
	if(text2num(M.text) != src.code)
		return
	if(src.master && src.wires & WIRE_SIGNAL)
		src.master:r_signal()
	for(var/atom/A in hearers(2))
		A.hear("\icon[src] *beep beep*")

/obj/item/weapon/radio/signaler/proc/send_signal()
	if (!( src.wires & WIRE_TRANSMIT))
		return
	var/datum/message/M = new(voice = "A computer", message = num2text(src.code), language = COMPUTER_LANG)
	src.broadcast(M)

/obj/item/weapon/radio/signaler/examine()
	set src in view()

	..()
	if ((get_dist(src, usr) <= 1 || src.loc == usr))
		if (src.attachable)
			usr.see("\blue The signaler can be attached and modified!")
		else
			usr.see("\blue The signaler can not be modified or attached!")
	return

/obj/item/weapon/radio/signaler/attack_self(mob/user as mob, flag1)

	user.machine = src
	var/t1
	if ((src.b_stat && !( flag1 )))
		t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
	else
		t1 = "-------"
	var/dat = text("<TT>Speaker: []<BR>\n<A href='?src=\ref[];send=1'>Send Signal</A><BR>\n<B>Frequency/Code</B> for signaler:<BR>\nFrequency: <A href='?src=\ref[];freq=-1'>-</A><A href='?src=\ref[];freq=-0.2'>-</A> [] <A href='?src=\ref[];freq=0.2'>+</A><A href='?src=\ref[];freq=1'>+</A><BR>\nCode: <A href='?src=\ref[];code=-5'>-</A><A href='?src=\ref[];code=-1'>-</A> [] <A href='?src=\ref[];code=1'>+</A><A href='?src=\ref[];code=5'>+</A><BR>\n[]</TT>", (src.listening ? text("<A href='?src=\ref[];listen=0'>Engaged</A>", src) : text("<A href='?src=\ref[];listen=1'>Disengaged</A>", src)), src, src, src, src.freq, src, src, src, src, src.code, src, src, t1)
	user << browse(dat, "window=radio")
	return

/obj/item/weapon/radio/signaler/talk_into()
	return

/obj/item/weapon/radio/signaler/Topic(href, href_list)
	if (usr.stat)
		return
	if ((usr.contents.Find(src) || (usr.contents.Find(src.master) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf)))))
		usr.machine = src
		if (href_list["freq"])
			src.freq += text2num(href_list["freq"])
			if (src.freq * 10 % 2 == 0)
				src.freq += 0.1
			src.freq = min(148.9, src.freq)
			src.freq = max(144.1, src.freq)
		else
			if (href_list["code"])
				src.code += text2num(href_list["code"])
				src.code = round(src.code)
				src.code = min(100, src.code)
				src.code = max(1, src.code)
			else
				if (href_list["send"])
					var/t1 = round(text2num(href_list["send"]))
					spawn( 0 )
						src.send_signal(t1)

						return
				else
					if (href_list["listen"])
						src.listening = text2num(href_list["listen"])
					else
						if (href_list["wires"])
							var/t1 = text2num(href_list["wires"])
							if (!( istype(usr.equipped(), /obj/item/weapon/wirecutters) ))
								return
							if ((!( src.b_stat ) && !( src.master )))
								return
							if (t1 & 1)
								if (src.wires & 1)
									src.wires &= 65534
								else
									src.wires |= 1
							else
								if (t1 & 2)
									if (src.wires & 2)
										src.wires &= 65533
									else
										src.wires |= 2
								else
									if (t1 & 4)
										if (src.wires & 4)
											src.wires &= 65531
										else
											src.wires |= 4
		src.add_fingerprint(usr)
		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(501)
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				for(var/mob/M in viewers(1, src.master))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(577)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/weapon/radio/intercom/interact(mob/user as mob)
	if(src.check_intelligence())
		src.add_fingerprint(user)
		spawn( 0 )
			attack_self(user)

/obj/item/weapon/radio/electropack/examine()
	set src in view()

	..()
	if ((get_dist(src, usr) <= 1 || src.loc == usr))
		if (src.e_pads)
			usr << "\blue The electric pads are exposed!"
	return

/obj/item/weapon/radio/electropack/interact(mob/user as mob)
	if (src == user.back)
		user << "\blue You need help taking this off!"
		return
	else
		..()

/obj/item/weapon/radio/electropack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		src.e_pads = !src.e_pads
		if (src.e_pads)
			user.see("\blue The electric pads have been exposed!")
		else
			user.see("\blue The electric pads have been reinserted!")
		src.add_fingerprint(user)
	else if (istype(W, /obj/item/weapon/clothing/head/helmet))
		var/obj/item/weapon/assembly/shock_kit/A = new /obj/item/weapon/assembly/shock_kit( user )
		W.loc = A
		A.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = A
		else
			user.u_equip(W)
			user.l_hand = A
		W.master = A
		src.master = A
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = A
		A.part2 = src
		A.layer = 20
		src.add_fingerprint(user)
		A.add_fingerprint(user)
	return

/obj/item/weapon/radio/electropack/Topic(href, href_list)
	//..()
	if (!usr.is_active() || !usr.can_use_hands())
		return
	if (!usr.check_dexterity())
		usr << browse(null, "window=radio")
		return
	if (usr.contents.Find(src) || (usr.contents.Find(src.master) || (get_dist(src, usr) <= 1 && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["freq"])
			src.freq += text2num(href_list["freq"])
			if (src.freq * 10 % 2 == 0)
				src.freq += 0.1
			src.freq = min(148.9, src.freq)
			src.freq = max(144.1, src.freq)
		else if (href_list["code"])
			src.code += text2num(href_list["code"])
			src.code = round(src.code)
			src.code = min(100, src.code)
			src.code = max(1, src.code)
		else if (href_list["power"])
			src.on = !src.on
			src.icon_state = "electropack[src.on]"
		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(308)
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				for(var/mob/M in viewers(1, src.master))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(384)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/weapon/radio/signaler/receive(datum/message/M, freq)
	if (freq != src.freq || !M || !(src.wires & WIRE_RECEIVE))
		return
	if(M.language != COMPUTER_LANG)
		return
	if(text2num(M.text) != src.code)
		return
	if(src.master && src.wires & WIRE_SIGNAL)
		src.master:r_signal()
	if ((ismob(src.loc) && src.on))
		var/mob/M = src.loc
		var/turf/T = M.loc
		if ((istype(T, /turf) || istype(T, /obj/move)))
			if (M.moved_recently && M.last_move)
				step(M, M.last_move)
		M.think("\red <B>You feel a sharp shock!</B>")

		if (M.weakened < 10)
			M.weakened = 10
	return

/obj/item/weapon/radio/electropack/attack_self(mob/user as mob, flag1)

	if (!user.is_dextrous())
		return
	user.machine = src
	var/dat = text("<TT><A href='?src=\ref[];power=1'>[]</A><BR>\n<B>Frequency/Code</B> for electropack:<BR>\nFrequency: <A href='?src=\ref[];freq=-1'>-</A><A href='?src=\ref[];freq=-0.2'>-</A> [] <A href='?src=\ref[];freq=0.2'>+</A><A href='?src=\ref[];freq=1'>+</A><BR>\nCode: <A href='?src=\ref[];code=-5'>-</A><A href='?src=\ref[];code=-1'>-</A> [] <A href='?src=\ref[];code=1'>+</A><A href='?src=\ref[];code=5'>+</A><BR>\n</TT>", src, (src.on ? "Turn Off" : "Turn On"), src, src, src.freq, src, src, src, src, src.code, src, src)
	user << browse(dat, "window=radio")
	return