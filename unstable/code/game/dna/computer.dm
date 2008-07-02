/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon = 'Cryogenic2.dmi'
	icon_state = "dna_computer"
	var/obj/machinery/dna_scanner/connected_scanner = null
	var/state = STATE_DEFAULT
	var/datum/dna_buffer/primary_buf = null
	var/primary_buf_pos = 0
	var/const/NUM_BUFFERS = 10
	var/list/buffers = list()
	var/const
		STATE_DEFAULT = 1
		STATE_NO_OCCUPANT_ERROR = 2
		STATE_SCAN_MENU = 3
		STATE_SCANNING = 4

/obj/machinery/computer/dna/New()
	..()
	for(var/i = 1; i < NUM_BUFFERS; i++)
		buffers += new /datum/dna_buffer()
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
			dat += "<a href='?src=\ref[src];operation=scan-menu'>Scan Occupant DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=replace'>Replace Occupant DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=merge'>Merge DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=view'>View DNA</a><br>"
		if(STATE_NO_OCCUPANT_ERROR)
			dat += "No occupant!<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SCAN_MENU)
			dat += "Please choose a buffer."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				dat += "<br><a href='?src=\ref[src];operation=scan-buffer;buffer-num=[i]'>"
				dat += "Buffer #[i] ([buffer.desc])</a>"
	dat += "</body></html>"
	user << browse(dat, "window=dna_comp")
	src.add_fingerprint(usr)

/obj/machinery/computer/dna/Topic(href, href_list)
	. = ..()
	if(!.)
		return
	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		if("main")
			src.state = STATE_DEFAULT
		if("scan-menu")
			if (src.connected_scanner && src.connected_scanner.occupant)
				src.state = STATE_SCAN_MENU
			else
				src.state = STATE_NO_OCCUPANT_ERROR
		if("scan-buffer")
			src.state = STATE_SCANNING
			src.primary_buf = buffers[text2num(href_list["buffer-num"])]
			src.primary_buf_pos = 0


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