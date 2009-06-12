/obj/item/weapon/radio/signaller
	name = "Remote Signaling Device"
	icon_state = "signaller"
	s_istate = "signaller"
	flags = TABLEPASS | FPRINT | ONBELT | SENDSRSIGNAL
	var/code = 30
	w_class = 1
	freq = 1457
	var/delay = 0
	is_signaller = 1
	is_actor = 1
	assembly_name = "radio"


/obj/item/weapon/radio/signaller/receive(datum/message/M, freq)
	//Sending a code is actually just sending a message in COMPUTER_LANG to the specified frequency, with text of the code number.
	if(!M || freq != src.freq)						return
	if(!(src.wires & WIRE_RECEIVE))					return
	if(M.language != LANGUAGE_COMPUTER)				return
	if(text2num(M.text) != src.code)				return
	if(istype(src.loc, /obj/item/weapon/assembly) && src.wires & WIRE_SIGNAL)
		var/obj/item/weapon/assembly/A = src.loc
		A.signal()
	for(var/atom/A in view(2, get_turf(src)))
		A.hear("\icon[src] *beep beep*")

/obj/item/weapon/radio/signaller/proc/send_signal()
	if(!(src.wires & WIRE_TRANSMIT)) return
	var/datum/message/M = new(voice = "A computer", text = num2text(src.code), language = LANGUAGE_COMPUTER)
	src.transmit(M)

/obj/item/weapon/radio/signaller/attack_self(mob/user as mob, flag1)

	user.machine = src
	var/t1
	if((src.is_attachable && !(flag1)))
		t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
	else
		t1 = "-------"
	var/dat = text("<TT>Speaker: []<BR>\n<A href='?src=\ref[];send=1'>Send Signal</A><BR>\n<B>Frequency/Code</B> for signaller:<BR>\nFrequency: <A href='?src=\ref[];freq=-10'>-</A><A href='?src=\ref[];freq=-2'>-</A> [] <A href='?src=\ref[];freq=2'>+</A><A href='?src=\ref[];freq=10'>+</A><BR>\nCode: <A href='?src=\ref[];code=-5'>-</A><A href='?src=\ref[];code=-1'>-</A> [] <A href='?src=\ref[];code=1'>+</A><A href='?src=\ref[];code=5'>+</A><BR>\n[]</TT>", (src.receiving ? text("<A href='?src=\ref[];listen=0'>Engaged</A>", src) : text("<A href='?src=\ref[];listen=1'>Disengaged</A>", src)), src, src, src, src.get_freq_text(), src, src, src, src, src.code, src, src, t1)
	ss13_browse(user, dat, "window=radio")
	return

/obj/item/weapon/radio/signaller/talk_into()
	return

/obj/item/weapon/radio/signaller/Topic(href, href_list)
	if(!usr.can_use_hands())		return 0
	if(!usr.check_intelligence())	return 0

	if(!usr.contents.Find(src) && !(usr.contents.Find(src.loc) && istype(src.loc, /obj/item/weapon/assembly)))
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

/obj/item/weapon/radio/signaller/signal()
	src.send_signal()