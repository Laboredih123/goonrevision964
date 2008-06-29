/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon = 'Cryogenic2.dmi'
	icon_state = "dna_computer"
	var/mode = null
	var/temp = null
	var/obj/machinery/dna_scanner/connected_scanner = null
	var/state = STATE_DEFAULT
	var/primary_buf = null
	var/secondary_buf = null
	var/const/NUM_BUFFERS = 10
	var/list/buffers[NUM_BUFFERS]
	var/const
		STATE_DEFAULT = 1
		STATE_NO_OCCUPANT_ERROR = 2
		STATE_SCAN_MENU = 3
		STATE_SCANNING = 4

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
	var/dat = "<html><head><title>DNA Machine</title></head><body>"
	switch(src.state)
		if(STATE_DEFAULT)
			dat += "<a href='?src=\ref[src];scan=1'>Scan Occupant</a><br>"
			dat += "<a href='?src=\ref[src];scan=1'></a><br>"
	dat += "</body></html>"
	user << browse(dat, "window=dna_comp")
	src.add_fingerprint(usr)

/obj/machinery/computer/dna/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if (href_list["scan"])
		if (src.connected_scanner && src.connected_scanner.occupant)
			src.state = STATE_SCANNING
		else
			src.state = STATE_NO_OCCUPANT_ERROR
	if(href_list[""])
		src.state = STATE_SCAN_MENU
	if(href_list["scan_buf"])
		src.state = STATE_SCANNING
		src.primary_buf = text2num(href_list["scan_buf"])
		//buffers[primary_buf]


	src.updateUsrDialog()
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
			src.connected_scanner = x
			return
	return