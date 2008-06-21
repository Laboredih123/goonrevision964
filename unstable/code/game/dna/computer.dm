/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon = 'Cryogenic2.dmi'
	icon_state = "dna_computer"
	var/mode = null
	var/temp = null
	var/obj/machinery/dna_scanner/connected_scanner = null
	var/state = null
	var/primary_buf = null
	var/secondary_buf = null
	var/const/NUM_BUFFERS = 10
	var/list/buffers[NUM_BUFFERS]
	var/const
		STATE_SCAN_INPUT = 1
		STATE_SCANNING

/obj/machinery/computer/dna/New()
	..()
	spawn(5)
		//connect to first scanner it sees
		for(var/obj/machinery/dna_scanner/scanner in view(src, 1))
			src.connected_scanner = scanner
			return


/obj/machinery/computer/dna/interact(mob/user as mob)
	. = ..()
	if(!.)
		return

	user.machine = src

	var/dat = {"<I>Please Insert the cards into the slots</I>
		<BR>Function Disk: <A href='?src=\ref[src];scan=1'>[src.scan ? src.scan.name : "----------"]</A>
		<BR>Target Disk: <A href='?src=\ref[src];modify=1'>[src.modify ? src.modify.name : "----------"]</A>
		<BR>Aux. Data Disk: <A href='?src=\ref[src];modify2=1'>[src.modify2 ? src.modify2.name : "----------"]</A>
		<BR>[src.scan ? "<A href='?src=\ref[src];execute=1'>Execute Function</A>" : "No function disk inserted!"]"}
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='?src=\ref[src];clear=1'>Clear Message</A>"
	user << browse(dat, "window=dna_comp")
	src.add_fingerprint(usr)

/obj/machinery/computer/dna/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if (href_list["locked"])
		if (src.connected_scanner && src.connected_scanner.occupant)
			src.connected_scanner.locked = !( src.connected_scanner.locked )
	if(href_list["scan"])
		src.state = STATE_SCAN_INPUT
	if(href_list["scan_buf"])
		src.state = STATE_SCANNING
		src.primary_buf = text2num(href_list["scan_buf"])
		buffers[primary_buf]


	src.UpdateUsrDialog()
	return

/obj/machinery/computer/dna/ex_act(severity)
	switch(severity)
		if(1)
			del(src)
			return
		if(2)
			if (prob(50))
				del(src)
				return

/obj/machinery/computer/dna/New()
	..()
	spawn( 5 )
		for(var/obj/machinery/dna_scanner/x in oview(src, 1)) //connect it to the first one it sees
			src.connected = x
			return
	return