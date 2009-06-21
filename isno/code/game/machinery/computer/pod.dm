/obj/machinery/computer/pod/proc/alarm()
	if(stat & (NOPOWER|BROKEN)) return
	if(!src.connected)
		viewers(null, null) << "Cannot locate mass driver connector. Cancelling firing sequence!"
		return

	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id != src.id) continue
		spawn(0)
			M.do_open()

	sleep(20)
	for(var/obj/machinery/mass_driver/M in machines)
		if(M.id != src.id) continue
		M.power = src.connected.power
		M.drive()

	sleep(50)
	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id != src.id) continue
		spawn(0)
			M.do_close()

/obj/machinery/computer/pod/New()
	..()
	spawn(5)
		for(var/obj/machinery/mass_driver/M in machines)
			if(M.id == src.id)
				src.connected = M

/obj/machinery/computer/pod/interact(var/mob/user as mob)
	if(!..()) return 0

	user.machine = src
	var/second = src.time % 60
	var/minute = (src.time - second) / 60

	var/dat = "<HTML><BODY><TT><B>Mass Driver Controls</B>"

	var/d2
	if(src.timing)	d2 = text("<A href='?src=\ref[];time=0'>Stop Time Launch</A>", src)
	else			d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Launch</A>", src)

	dat += text("<HR>\nTimer System: []\nTime Left: [][] <A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>", d2, (minute ? text("[]:", minute) : null), second, src, src, src, src)
	if(!src.connected)
		dat += text("<BR>\n<A href = '?src=\ref[];door=1'>Toggle Outer Door</A><BR>", src)
	else
		var/temp = ""
		var/list/L = list( 0.25, 0.5, 1, 2, 4, 8, 16 )
		for(var/t in L)
			if(t != src.connected.power)
				temp += "<A href = '?src=\ref[src];power=[t]'>[t]</A> "
			else
				temp += "[t] "

		dat += text("<HR>\nPower Level: []<BR>\n<A href = '?src=\ref[];alarm=1'>Firing Sequence</A><BR>\n<A href = '?src=\ref[];drive=1'>Test Fire Driver</A><BR>\n<A href = '?src=\ref[];door=1'>Toggle Outer Door</A><BR>", temp, src, src, src)

	dat += text("<BR><BR><A href='?src=\ref[];mach_close=computer'>Close</A></TT></BODY></HTML>", user)
	ss13_browse(user, dat, "window=computer;size=400x500")
	return

/obj/machinery/computer/pod/process()
	..()
	if(!src.timing) return
	if(src.time > 0)
		--src.time
	else
		alarm()
		src.time = 0
		src.timing = 0
	src.updateDialog()

/obj/machinery/computer/pod/Topic(href, href_list)
	if(!..())	return 0

	usr.machine = src
	if(href_list["power"])
		var/t = text2num(href_list["power"])
		t = min(max(0.25, t), 16)
		if(src.connected)
			src.connected.power = t
	else if(href_list["alarm"])
		src.alarm()
	else if(href_list["time"])
		src.timing = text2num(href_list["time"])
	else if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		src.time += tp
		src.time = min(max(round(src.time), 0), 120)
	else if(href_list["door"])
		for(var/obj/machinery/door/poddoor/M in machines)
			if(M.id != src.id) continue
			spawn(0)
				if(M.density) M.do_open()
				else M.do_close()

	src.updateUsrDialog()

/obj/machinery/door/poddoor/try_open()
	usr << "This is a remote controlled door!"

/obj/machinery/door/poddoor/try_close()
	usr << "This is a remote controlled door!"

/obj/machinery/door/poddoor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(!istype(C, /obj/item/weapon/crowbar)) return
	spawn(0) src.do_open()

/obj/machinery/door/poddoor/do_open()
	if(!src.density)	return 0
	if(src.operating)	return 0
	if(stat & NOPOWER)	return 0

	use_power(50)
	src.operating = 1
	flick("pdoorc0", src)
	src.icon_state = "pdoor0"
	sleep(15)
	src.density = 0
	src.opacity = 0
	var/turf/T = src.loc
	if(istype(T, /turf))
		T.updatecell = 1
		T.buildlinks()
	src.operating = 0
	return 1

/obj/machinery/door/poddoor/do_close()
	set src in oview(1)

	if(src.density)		return 0
	if(src.operating)	return 0
	if(stat & NOPOWER)	return 0

	use_power(50)
	src.operating = 1
	flick("pdoorc1", src)
	src.icon_state = "pdoor1"
	src.density = 1
	src.opacity = 1
	var/turf/T = src.loc
	if(istype(T, /turf))
		T.updatecell = 0
		T.buildlinks()
	sleep(15)
	src.operating = 0
	return 1
