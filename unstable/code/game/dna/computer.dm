/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon = 'Cryogenic2.dmi'
	icon_state = "dna_computer"
	var/obj/machinery/dna_scanner/connected_scanner = null
	var/state = STATE_DEFAULT
	var/datum/dna_buffer/primary_buf = null
	var/pos_chromosome = 0
	var/pos_locus = 0
	var/pct_complete = 0
	var/const/NUM_BUFFERS = 10
	var/list/buffers = list()
	var/const
		STATE_DEFAULT = 1
		STATE_NO_OCCUPANT = 2
		STATE_SCAN_MENU = 3
		STATE_SCANNING = 4
		STATE_SCAN_COMPLETE = 5
		STATE_REPLACE_MENU = 6
		STATE_REPLACING = 7
		STATE_REPLACE_COMPLETE = 8
		STATE_EMPTY_BUFFER = 9
		STATE_NO_SCANNER = 10
		STATE_VIEW_MENU_BUF = 11
		STATE_VIEW_MENU_CHROM = 12
		STATE_VIEW = 13

		SCAN_SPEED = 5 //5 loci/second
		REPLACE_SPEED = 5 //5 loci/second

/obj/machinery/computer/dna/New()
	..()
	for(var/i = 1; i <= NUM_BUFFERS; i++)
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
			dat += "<a href='?src=\ref[src];operation=replace-menu'>Replace Occupant DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=splice-menu'>Splice DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=view-menu'>View DNA</a><br>"
		if(STATE_NO_OCCUPANT)
			dat += "No occupant!"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_EMPTY_BUFFER)
			dat += "Empty buffer!"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_NO_SCANNER)
			dat += "No DNA scanner detected!"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SCAN_MENU)
			dat += "Please choose a buffer."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				dat += "<br><a href='?src=\ref[src];operation=scan-buffer;buffer-num=[i]'>"
				dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SCANNING)
			dat += "Scanning ([src.pct_complete]% complete)"
		if(STATE_SCAN_COMPLETE)
			dat += "Scan complete!"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_REPLACE_MENU)
			dat += "Please choose a buffer."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				dat += "<br><a href='?src=\ref[src];operation=replace-buffer;buffer-num=[i]'>"
				dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_REPLACING)
			dat += "Replacing ([src.pct_complete]% complete)"
		if(STATE_REPLACE_COMPLETE)
			dat += "Replace complete!"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_VIEW_MENU_BUF)
			dat += "Please choose a buffer."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				dat += "<br><a href='?src=\ref[src];operation=view-buffer;buffer-num=[i]'>"
				dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_VIEW_MENU_CHROM)
			dat += "Please choose a chromosome."
			for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
				dat += "<br><a href='?src=\ref[src];operation=view-chromosome;chromosome-num=[i]'>"
				dat += "Chromosome #[i]</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_VIEW)
			dat += "Chromosome #[src.pos_chromosome]"
			for(var/i = 1; i <= NUM_LOCI; i++)
				dat += "<br>Locus #[i]: [primary_buf.contents.data[pos_chromosome][i]]"
			if(src.pos_chromosome > 1)
				dat += "<br><a href='?src=\ref[src];operation=view-chromosome;chromosome-num=[src.pos_chromosome - 1]'>"
				dat += "Previous chromosome</a>"
			if(src.pos_chromosome < NUM_CHROMOSOMES)
				dat += "<br><a href='?src=\ref[src];operation=view-chromosome;chromosome-num=[src.pos_chromosome + 1]'>"
				dat += "Next chromosome</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
	dat += "<br><br><a href='?src=\ref[user];mach_close=computer'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=computer;size=400x500")
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
			if (!src.connected_scanner)
				src.state = STATE_NO_SCANNER
			else if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
				src.state = STATE_NO_OCCUPANT
			else
				src.state = STATE_SCAN_MENU
		if("scan-buffer")
			if (!src.connected_scanner)
				src.state = STATE_NO_SCANNER
			else if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
				src.state = STATE_NO_OCCUPANT
			else
				src.state = STATE_SCANNING
				src.primary_buf = buffers[text2num(href_list["buffer-num"])]
				src.pos_chromosome = 1
				src.pos_locus = 1
				src.pct_complete = 0
		if("replace-menu")
			if (!src.connected_scanner)
				src.state = STATE_NO_SCANNER
			else if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
				src.state = STATE_NO_OCCUPANT
			else
				src.state = STATE_REPLACE_MENU
		if("replace-buffer")
			if (!src.connected_scanner)
				src.state = STATE_NO_SCANNER
			else if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
				src.state = STATE_NO_OCCUPANT
			else
				src.primary_buf = buffers[text2num(href_list["buffer-num"])]
				if(src.primary_buf.contents)
					src.state = STATE_REPLACING
					src.pos_chromosome = 1
					src.pos_locus = 1
					src.pct_complete = 0
				else
					src.state = STATE_EMPTY_BUFFER
		if("view-menu")
			src.state = STATE_VIEW_MENU_BUF
		if("view-buffer")
			src.primary_buf = buffers[text2num(href_list["buffer-num"])]
			if(src.primary_buf.contents)
				src.state = STATE_VIEW_MENU_CHROM
			else
				src.state = STATE_EMPTY_BUFFER
		if("view-chromosome")
			src.pos_chromosome = text2num(href_list["chromosome-num"])
			if(src.primary_buf.contents)
				src.state = STATE_VIEW
			else
				src.state = STATE_EMPTY_BUFFER
	src.updateUsrDialog()
	return

/obj/machinery/computer/dna/process()
	if(src.state != STATE_SCANNING && src.state != STATE_REPLACING)
		src.updateDialog()
		return
	if(!src.connected_scanner)
		src.state = STATE_NO_SCANNER
		src.updateDialog()
		return
	if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
		src.state = STATE_NO_OCCUPANT
		src.updateDialog()
		return

	if(src.state == STATE_SCANNING)
		if(!src.primary_buf.contents)
			src.primary_buf.contents = new()
		src.copy_dna(src.connected_scanner.occupant.dna, src.primary_buf.contents, SCAN_SPEED, STATE_SCAN_COMPLETE)
		if(src.state == STATE_SCAN_COMPLETE)
			src.primary_buf.desc = "Full"
	else if(src.state == STATE_REPLACING)
		src.copy_dna(src.primary_buf.contents, src.connected_scanner.occupant.dna, REPLACE_SPEED, STATE_REPLACE_COMPLETE)
		src.connected_scanner.occupant.dna.apply(src.connected_scanner.occupant)
	src.updateDialog()

/obj/machinery/computer/dna/proc/copy_dna(datum/dna/origin, datum/dna/dest, speed, state_complete)
	for(var/i = 1; i <= speed; i++)
		if(src.state == state_complete)
			break
		dest.data[src.pos_chromosome][src.pos_locus] = origin.data[src.pos_chromosome][src.pos_locus]
		src.pos_locus++
		if(src.pos_locus > NUM_LOCI)
			src.pos_locus = 1
			src.pos_chromosome++
		if(src.pos_chromosome > NUM_CHROMOSOMES)
			src.state = state_complete
	pct_complete = round((((src.pos_chromosome-1)*NUM_LOCI + (src.pos_locus - 1)) / (NUM_CHROMOSOMES * NUM_LOCI)) * 100)

/obj/machinery/computer/dna/ex_act(severity)
	switch(severity)
		if(1)
			del(src)
			return
		if(2)
			if (prob(50))
				del(src)
				return