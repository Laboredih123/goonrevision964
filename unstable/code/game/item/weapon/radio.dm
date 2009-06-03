/var/const/DEFAULT_FREQ = 1459

/obj/item/weapon/radio
	name = "Station Bounced Radio"
	icon_state = "radio"
	var/freq = DEFAULT_FREQ
	var/wires = WIRE_SIGNAL | WIRE_RECEIVE | WIRE_TRANSMIT
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
		WIRE_RECEIVE = 1 << 1
		WIRE_TRANSMIT = 1 << 2
		TRANSMISSION_DELAY = 5 // only 2/second/radio
	var/listenrange = 2
	var/b_stat = 0
	var/traitorfreq = 0
	var/obj/item/weapon/radio/patch_link = null
	var/obj/item/weapon/syndicate_uplink/traitorradio = null

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
	freq = 1449
	w_class = 5
	flags = ONBACK | TABLEPASS | FPRINT
	s_istate = "electropack"

/obj/item/weapon/radio/headset
	name = "Radio Headset"
	icon_state = "headset"
	listenrange = 1
	s_istate = "headset"

/obj/item/weapon/radio/headset/syndicate
	name = "Syndicate Encrypted Headset"

/obj/item/weapon/radio/intercom
	name = "Station Intercom (Radio)"
	icon_state = "intercom"
	anchored = 1
	var/number = 0
	listenrange = 7
	is_ai_interactable = 1

/obj/item/weapon/radio/signaler
	name = "Remote Signaling Device"
	icon_state = "signaler"
	flags = TABLEPASS | FPRINT | ONBELT | SENDSRSIGNAL
	var/code = 30
	w_class = 1
	freq = 1457
	var/delay = 0

/obj/item/weapon/radio/proc/get_freq_text()
	return round(src.freq/10, 0.1)

/obj/item/weapon/radio/proc/receive(datum/message/M, freq)
	if(!M) return
	if(!src.receiving) return
	if(freq != src.freq) return
	if(!(src.wires & WIRE_RECEIVE)) return

	M = convert_message_color(M, COLOR_RADIO)

	for(var/atom/A in view(src.listenrange, get_turf(src)))
		if(A != src)
			A.hear_message(M, src)

/obj/item/weapon/radio/proc/transmit(datum/message/M)
	if(!(src.wires & WIRE_TRANSMIT))	return
	if(last_transmission && world.time < (last_transmission + TRANSMISSION_DELAY))
		return
	last_transmission = world.time
	if(istype(src.loc, /turf) || (istype(src.loc, /mob) && istype(src.loc.loc, /turf))) //closets block transmission
		if(src.patch_link)	return patch_link.receive(M,src.freq)
		for(var/obj/item/weapon/radio/R in world)
			R.receive(M, src.freq)

/obj/item/weapon/radio/talk_into(datum/message/M, atom/source)
	src.transmit(M, source)

/obj/item/weapon/radio/hear_message(datum/message/M, atom/source)
	if(src.transmitting) src.talk_into(M, source)

/obj/item/weapon/radio/examine()
	set src in view()

	..()
	if((get_dist(src, usr) <= 1 || src.loc == usr))
		if(src.b_stat)	usr.see("<font color='blue'>The radio can be attached and modified!</font>")
		else			usr.see("<font color='blue'>The radio can not be attached or modified!</font>")

/obj/item/weapon/radio/proc/can_patch()		{	return 0	}
/obj/item/weapon/radio/intercom/can_patch()	{	return 1	}

/obj/item/weapon/radio/attack_self(mob/user as mob)
	user.machine = src
	var/t1 = "-------"
	if(src.b_stat)
		t1 = text({"-------<BR>
					Green Wire: <A href='?src=\ref[src];wires=4'>[]</A><BR>
					Red Wire:   <A href='?src=\ref[src];wires=2'>[]</A><BR>
					Blue Wire:  <A href='?src=\ref[src];wires=1'>[]</A><BR>"},
					(src.wires & 4 ? "Cut Wire" : "Mend Wire"),
					(src.wires & 2 ? "Cut Wire" : "Mend Wire"),
					(src.wires & 1 ? "Cut Wire" : "Mend Wire"))

	var/dat = text({"<TT>Microphone: <A href='?src=\ref[src];talk=[]</A><BR>
					 Speaker: <A href='?src=\ref[src];listen=[]</A><BR>
					 []
					 Frequency: <A href='?src=\ref[];freq=-10'>-</A><A href='?src=\ref[];freq=-2'>-</A> [] <A href='?src=\ref[];freq=2'>+</A><A href='?src=\ref[];freq=10'>+</A><BR>
					 []</TT>"},
					 (src.transmitting ? "0'>Engaged" : "1'>Disengaged"),
					 (src.receiving   ? "0'>Engaged" : "1'>Disengaged"),
					 (!src.can_patch() ? "" : text("Patch: <A href='?src=\ref[src];patch=0'>[]</A><BR>",(src.patch_link ? "[patch_link]" : "Disengaged"))),
					 src, src, src.get_freq_text(), src, src, t1)
	ss13_browse(user, dat, "window=radio")
	return

/obj/item/weapon/radio/Topic(href, href_list)
	if(!usr.can_use_hands())		return 0
	if(!usr.check_intelligence())	return 0

	if(!usr.contents.Find(src))
		if(!istype(usr, /mob/silicon/ai))
			if(!(istype(src.loc,/turf) || get_dist(src,usr)<=1))
				ss13_browse(usr, null, "window=radio")
				return 0

	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["freq"])
		src.patch_link = null
		src.freq += text2num(href_list["freq"])
		src.freq = dd_range(1441,1489,src.freq)
		if(src.traitorfreq && src.freq == src.traitorfreq)
			usr.machine = null
			ss13_browse(usr, null, "window=radio")
			// now transform the regular radio, into a (disguised)syndicate uplink!
			var/obj/item/weapon/syndicate_uplink/T = src.traitorradio
			var/obj/item/weapon/radio/R = src
			R.loc = T
			T.loc = usr
			R.layer = 0
			if(usr.client)
				usr.client.screen -= R
			var/mob/carbon/user = usr
			if(user.r_hand == R)
				user.u_equip(R)
				user.equip_if_possible(T, SLOT_R_HAND)
			else
				user.u_equip(R)
				user.equip_if_possible(T, SLOT_L_HAND)
			R.loc = T
			T.layer = 20
			T.attack_self(user)
			return
	else if(href_list["talk"])		src.transmitting = text2num(href_list["talk"])
	else if(href_list["listen"])	src.receiving = text2num(href_list["listen"])
	else if(href_list["patch"])
		var/list/radios = new()
		for(var/obj/item/weapon/radio/A in world)
			if(!istype(A,src.type)) continue
			radios += A
		patch_link = input("Select Patch", "Radio Patch", null) in radios
		if(src.patch_link) src.freq = src.patch_link.freq
	else if(href_list["wires"])
		if(istype(usr, /mob/carbon))
			var/mob/carbon/M = usr
			if(istype(M.equipped(), /obj/item/weapon/wirecutters))
				src.wires ^= text2num(href_list["wires"])

	var/tloc = src.loc
	if(src.master) tloc = src.master.loc
	if(istype(tloc, /mob))	src.attack_self(tloc)
	else					src.updateDialog()

/obj/item/weapon/radio/beacon/talk_into()		{		return		}
/obj/item/weapon/radio/beacon/receive()			{		return		}
/obj/item/weapon/radio/beacon/attack_self()		{		return		}
/obj/item/weapon/radio/beacon/attackby()		{		return		}

/obj/item/weapon/radio/beacon/verb/alter_signal(t as text)
	set src in usr
	if(!usr.is_active()) return
	if(!usr.can_use_hands()) return

	if(usr.canmove && !usr.is_handcuffed())
		src.code = t
	if(!src.code)
		src.code = "beacon"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/radio/headset/attackby(obj/item/weapon/W as obj, mob/carbon/user)
	if(W.loc != user) return ..()
	if(src.loc != user) return ..()
	if(src.type != W.type) return ..()
	if(!istype(user,/mob/carbon)) return ..()
	if(user.db_click("headset",null)) return null
	return ..()

/obj/item/weapon/radio/signaler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.machine = src
	if(!istype(W, /obj/item/weapon/screwdriver)) return ..()
	src.b_stat = !(src.b_stat)
	if(src.b_stat)	user.see("<font color='blue'>The radio can now be attached and modified!</font>")
	else			user.see("<font color='blue'>The radio can no longer be modified or attached!</font>")
	src.add_fingerprint(user)

/obj/item/weapon/radio/signaler/receive(datum/message/M, freq)
	//Sending a code is actually just sending a message in COMPUTER_LANG to the specified frequency, with text of the code number.
	if(!M || freq != src.freq)						return
	if(!(src.wires & WIRE_RECEIVE))					return
	if(M.language != LANGUAGE_COMPUTER)				return
	if(text2num(M.text) != src.code)				return
	if(src.master && src.wires & WIRE_SIGNAL)		src.master:r_signal(1, src)
	if(src.assmaster && src.wires & WIRE_SIGNAL)	src.assmaster:r_signal(1, src)
	for(var/atom/A in view(2, src))					A.hear("\icon[src] *beep beep*")

/obj/item/weapon/radio/signaler/proc/send_signal()
	if(!(src.wires & WIRE_TRANSMIT)) return
	var/datum/message/M = new(voice = "A computer", text = num2text(src.code), language = LANGUAGE_COMPUTER)
	src.transmit(M)

/obj/item/weapon/radio/signaler/examine()
	set src in view()

	..()
	if(get_dist(src, usr) <= 1 || src.loc == usr)
		if(src.b_stat)	usr.see("<font color='blue'>The signaler can be attached and modified!</font>")
		else			usr.see("<font color='blue'>The signaler can not be modified or attached!</font>")
	return

/obj/item/weapon/radio/signaler/attack_self(mob/user as mob, flag1)

	user.machine = src
	var/t1
	if((src.b_stat && !(flag1)))
		t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
	else
		t1 = "-------"
	var/dat = text("<TT>Speaker: []<BR>\n<A href='?src=\ref[];send=1'>Send Signal</A><BR>\n<B>Frequency/Code</B> for signaler:<BR>\nFrequency: <A href='?src=\ref[];freq=-10'>-</A><A href='?src=\ref[];freq=-2'>-</A> [] <A href='?src=\ref[];freq=2'>+</A><A href='?src=\ref[];freq=10'>+</A><BR>\nCode: <A href='?src=\ref[];code=-5'>-</A><A href='?src=\ref[];code=-1'>-</A> [] <A href='?src=\ref[];code=1'>+</A><A href='?src=\ref[];code=5'>+</A><BR>\n[]</TT>", (src.receiving ? text("<A href='?src=\ref[];listen=0'>Engaged</A>", src) : text("<A href='?src=\ref[];listen=1'>Disengaged</A>", src)), src, src, src, src.get_freq_text(), src, src, src, src, src.code, src, src, t1)
	ss13_browse(user, dat, "window=radio")
	return

/obj/item/weapon/radio/signaler/talk_into()
	return

/obj/item/weapon/radio/signaler/Topic(href, href_list)
	if(!usr.can_use_hands())		return 0
	if(!usr.check_intelligence())	return 0

	if(!usr.contents.Find(src))
		if(!istype(usr, /mob/silicon/ai))
			if(!(istype(src.loc,/turf) || get_dist(src,usr)<=1))
				ss13_browse(usr, null, "window=radio")
				return 0

	usr.machine = src
	if(href_list["code"])
		src.code += text2num(href_list["code"])
		src.code = round(src.code)
		src.code = min(100, src.code)
		src.code = max(1, src.code)
	else if(href_list["send"])
		var/t1 = round(text2num(href_list["send"]))
		spawn(0) src.send_signal(t1)
	else
		return ..()

/obj/item/weapon/radio/intercom/interact(mob/user as mob)
	if(!user.check_intelligence()) return
	src.add_fingerprint(user)
	spawn(0) src.attack_self(user)

/obj/item/weapon/radio/electropack/examine()
	set src in view()

	..()
	if((get_dist(src, usr) <= 1 || src.loc == usr))
		if(src.e_pads)	usr << "<font color='blue'>The electric pads are exposed!</font>"
	return

/obj/item/weapon/radio/electropack/interact(mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))	return
	if(src == user.back)
		user << "<font color='blue'>You need help taking this off!</font>"
		return
	return ..()

/obj/item/weapon/radio/electropack/attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)
	if(!istype(user, /mob/carbon))	return
	if(istype(W, /obj/item/weapon/screwdriver))
		src.e_pads = !src.e_pads
		if(src.e_pads)	user.see("<font color='blue'>The electric pads have been exposed!</font>")
		else			user.see("<font color='blue'>The electric pads have been reinserted!</font>")
		src.add_fingerprint(user)
	else if(istype(W, /obj/item/weapon/clothing/head/helmet))
		var/obj/item/weapon/assembly/shock_kit/A = new /obj/item/weapon/assembly/shock_kit(user)
		W.loc = A
		A.part1 = W
		W.layer = initial(W.layer)
		if(user.client)
			user.client.screen -= W
		if(user.r_hand == W)
			user.u_equip(W)
			user.r_hand = A
		else
			user.u_equip(W)
			user.l_hand = A
		W.master = A
		src.master = A
		src.layer = initial(src.layer)
		user.u_equip(src)
		if(user.client)
			user.client.screen -= src
		src.loc = A
		A.part2 = src
		A.layer = 20
		src.add_fingerprint(user)
		A.add_fingerprint(user)
	return

/obj/item/weapon/radio/electropack/Topic(href, href_list)
	//..()
	if(!usr.can_use_hands())		return 0
	if(!usr.check_intelligence())	return 0

	if(!usr.contents.Find(src))
		if(!istype(usr, /mob/silicon/ai))
			if(!(istype(src.loc,/turf) || get_dist(src,usr)<=1))
				ss13_browse(usr, null, "window=radio")
				return 0

	usr.machine = src
	if(href_list["freq"])
		src.freq += text2num(href_list["freq"])
		src.freq = min(1489, src.freq)
		src.freq = max(1441, src.freq)
	else if(href_list["code"])
		src.code += text2num(href_list["code"])
		src.code = round(src.code)
		src.code = min(100, src.code)
		src.code = max(1, src.code)
	else if(href_list["power"])
		src.on = !src.on
		src.icon_state = "electropack[src.on]"

	var/atom/tsrc = src
	if(src.master) tsrc = src.master
	if(istype(tsrc.loc, /mob)) src.attack_self(tsrc.loc)
	else for(var/mob/M in viewers(1,tsrc)) if(M.client) src.attack_self(M)

/obj/item/weapon/radio/electropack/receive(datum/message/M, freq)
	if(freq != src.freq || !M || !(src.wires & WIRE_RECEIVE))
		return
	if(M.language != LANGUAGE_COMPUTER)	return
	if(text2num(M.text) != src.code)	return
	if(src.master && src.wires & WIRE_SIGNAL)
		src.master:r_signal()
	if((istype(src.loc, /mob/carbon) && src.on))
		var/mob/carbon/H = src.loc
		var/turf/T = H.loc
		if (istype(T, /turf))
			if (H.moved_recently && H.last_move)
				step(H, H.last_move)
		H.think("<font color='red'><B>You feel a sharp shock!</B></font>")
		H.knockdown_until(5)
	return

/obj/item/weapon/radio/electropack/attack_self(mob/carbon/user as mob, flag1)
	if(!istype(user, /mob/carbon))	return
	if(!user.check_dexterity())		return
	user.machine = src
	var/dat = text("<TT><A href='?src=\ref[];power=1'>[]</A><BR>\n<B>Frequency/Code</B> for electropack:<BR>\nFrequency: <A href='?src=\ref[];freq=-10'>-</A><A href='?src=\ref[];freq=-2'>-</A> [] <A href='?src=\ref[];freq=2'>+</A><A href='?src=\ref[];freq=10'>+</A><BR>\nCode: <A href='?src=\ref[];code=-5'>-</A><A href='?src=\ref[];code=-1'>-</A> [] <A href='?src=\ref[];code=1'>+</A><A href='?src=\ref[];code=5'>+</A><BR>\n</TT>", src, (src.on ? "Turn Off" : "Turn On"), src, src, src.get_freq_text(), src, src, src, src, src.code, src, src)
	ss13_browse(user, dat, "window=radio")
	return

/obj/item/weapon/radio/headset/syndicate/receive(datum/message/M, freq)
	if(M.language == LANGUAGE_ENCRYPTED)
		M.voice = M.origvoice
		M.language = M.origlanguage
		M.text += "&nbsp;&nbsp;&nbsp;(encrypted)"
	return ..(M, freq)

/obj/item/weapon/radio/headset/syndicate/transmit(datum/message/M, freq)
	M.language = LANGUAGE_ENCRYPTED
	M.voice = "Unknown"
	return ..(M, freq)

/proc/station_announce(message)
	var/datum/message/M = new("A computer", message, LANGUAGE_ENGLISH, COLOR_ANNOUNCEMENT, COLOR_ANNOUNCEMENT)
	for(var/obj/item/weapon/radio/R in world)
		R.receive(M, DEFAULT_FREQ)
	for(var/mob/observer/O in world)
		O.hear_message(M)