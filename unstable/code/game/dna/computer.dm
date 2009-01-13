/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon = 'Cryogenic2.dmi'
	icon_state = "dna_computer"
	req_access = list(access_genetics)
	var/obj/machinery/dna_scanner/connected_scanner = null
	var/state = STATE_DEFAULT
	var/datum/dna_buffer/primary_buf = null
	var/datum/dna_buffer/secondary_buf = null
	var/datum/dna_buffer/output_buf = null
	var/pos_chromosome = 0
	var/pos_locus = 0
	var/pct_complete = 0
	var/const/NUM_BUFFERS = 10
	var/list/buffers = list()
	var/secs_gamma
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
		STATE_SPLICE_MENU = 14
		STATE_SPLICE_MENU_BUF1 = 15
		STATE_SPLICE_MENU_BUF2 = 16
		STATE_SPLICE_MENU_BUF_OUT = 17
		STATE_SPLICE_MENU_CHROM = 18
		STATE_SPLICE = 19
		STATE_GAMMA_MENU = 20
		STATE_GAMMA = 21
		STATE_GAMMA_DONE = 22
		STATE_DIFF_MENU_BUF1 = 23
		STATE_DIFF_MENU_BUF2 = 24
		STATE_DIFF_DONE = 25
		STATE_DELETE = 26

		SCAN_SPEED = 50 //loci/second
		//TODO: adjust to be lower (when not debugging)
		REPLACE_SPEED = 50

/obj/machinery/computer/dna/New()
	..()
	for(var/i = 1; i <= NUM_BUFFERS; i++)
		buffers += new /datum/dna_buffer(i)
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
			if(src.connected_scanner.locked)
				dat += "<a href='?src=\ref[src];operation=unlock'>Unlock Scanner</a><br>"
			else
				dat += "<a href='?src=\ref[src];operation=lock'>Lock Scanner</a><br>"
			dat += "<a href='?src=\ref[src];operation=scan-menu'>Scan Occupant DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=replace-menu'>Replace Occupant DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=gamma-menu'>Subject Occupant to Gamma Radiation</a><br>"
			dat += "<a href='?src=\ref[src];operation=splice-menu'>Splice DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=view-menu'>View/Delete/Rename DNA</a><br>"
			dat += "<a href='?src=\ref[src];operation=diff-menu'>Compare DNA</a><br>"
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
				if(!buffer.contents)
					continue
				dat += "<br>Buffer #[i] ([buffer.desc])"
				dat += " \[ <a href='?src=\ref[src];operation=view-buffer;buffer-num=[i]'>View</a>"
				dat += " | <a href='?src=\ref[src];operation=rename-buffer;buffer-num=[i]'>Rename</a>"
				dat += " | <a href='?src=\ref[src];operation=delete-buffer;buffer-num=[i]'>Delete</a> \]"
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
			dat += "<br>"
			if(src.pos_chromosome > 1)
				dat += "<a href='?src=\ref[src];operation=view-chromosome;chromosome-num=[src.pos_chromosome - 1]'>"
				dat += "Previous chromosome</a>"
			dat += "<br>"
			if(src.pos_chromosome < NUM_CHROMOSOMES)
				dat += "<a href='?src=\ref[src];operation=view-chromosome;chromosome-num=[src.pos_chromosome + 1]'>"
				dat += "Next chromosome</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SPLICE_MENU_BUF1)
			dat += "Please choose the main buffer to splice from."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				if(buffer.contents)
					dat += "<br><a href='?src=\ref[src];operation=splice-buffer-primary;buffer-num=[i]'>"
					dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SPLICE_MENU_BUF2)
			dat += "Please choose the secondary buffer to splice from."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				if(buffer != src.primary_buf && buffer.contents)
					dat += "<br><a href='?src=\ref[src];operation=splice-buffer-secondary;buffer-num=[i]'>"
					dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SPLICE_MENU_BUF_OUT)
			dat += "Please choose the buffer to splice into."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				if(buffer != src.primary_buf && buffer != src.secondary_buf)
					dat += "<br><a href='?src=\ref[src];operation=splice-buffer-output;buffer-num=[i]'>"
					dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SPLICE_MENU_CHROM)
			dat += "Please choose a chromosome."
			for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
				dat += "<br><a href='?src=\ref[src];operation=splice-chromosome;chromosome-num=[i]'>"
				dat += "Chromosome #[i]</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_SPLICE)
			dat += "Chromosome #[src.pos_chromosome]"
			dat += "<table>"
			dat += "<tr><th>Locus</th><th>Primary</th><th>Secondary</th><th>Output</th></tr>"
			for(var/i = 1; i <= NUM_LOCI; i++)
				dat += "<tr>"
				dat += "<th>Locus #[i]</th>"
				for(var/allele in list(primary_buf.contents.data[pos_chromosome][i], secondary_buf.contents.data[pos_chromosome][i]))
					if(allele == output_buf.contents.data[pos_chromosome][i])
						dat += "<td><b>[primary_buf.contents.data[pos_chromosome][i]]</b></td>"
					else
						dat += "<td><a href='?src=\ref[src];operation=splice-chromosome;chromosome-num=[src.pos_chromosome];"
						dat += "locus-num=[i];locus-contents=[allele]'>[allele]</a></td>"
				dat += "<td>[output_buf.contents.data[pos_chromosome][i]]</td>"
				dat += "</tr>"
			dat += "</table>"
			dat += "<br>"
			if(src.pos_chromosome > 1)
				dat += "<a href='?src=\ref[src];operation=splice-chromosome;chromosome-num=[src.pos_chromosome - 1]'>"
				dat += "Previous chromosome</a>"
			dat += "<br>"
			if(src.pos_chromosome < NUM_CHROMOSOMES)
				dat += "<a href='?src=\ref[src];operation=splice-chromosome;chromosome-num=[src.pos_chromosome + 1]'>"
				dat += "Next chromosome</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_GAMMA_MENU)
			dat += "How many seconds of gamma radiation would you like to expose the occupant to?<br>"
			for(var/i = 5; i <= 100; i+= 5)
				dat += "<a href='?src=\ref[src];operation=gamma;num-secs=[i]'>[i]</a> "
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_GAMMA)
			dat += "Exposing occupant to gamma radiation..."
		if(STATE_GAMMA_DONE)
			dat += "Gamma radiation complete!"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_DIFF_MENU_BUF1)
			dat += "Please choose the first buffer to compare."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				if(buffer.contents)
					dat += "<br><a href='?src=\ref[src];operation=diff-buffer-primary;buffer-num=[i]'>"
					dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_DIFF_MENU_BUF2)
			dat += "Please choose the second buffer to compare."
			for(var/i = 1; i <= buffers.len; i++)
				var/datum/dna_buffer/buffer = src.buffers[i]
				if(buffer != src.primary_buf && buffer.contents)
					dat += "<br><a href='?src=\ref[src];operation=diff-buffer-secondary;buffer-num=[i]'>"
					dat += "Buffer #[i] ([buffer.desc])</a>"
			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_DIFF_DONE)
			dat += "Comparison Complete!<BR>Differences:"
			var/dat2 = ""
			for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
				var/dat3 = ""
				for (var/j = 1; j <= NUM_LOCI; j++)
					// dat3 += "<BR>Locus #[j]"
					if (primary_buf.contents.data[i][j] != secondary_buf.contents.data[i][j])
						dat3 += "<BR>Locus #[j] [primary_buf.contents.data[i][j]] - [secondary_buf.contents.data[i][j]]"
				if (dat3 != "")
					dat2 += "<BR><BR>Chromosome #[i][dat3]"
			dat += (dat2 != "") ? dat2 : "<BR><BR>None Found"

			dat += "<br><br><a href='?src=\ref[src];operation=main'>Main Menu</a>"
		if(STATE_DELETE)
			dat += "Are you sure you want to delete Buffer #[src.primary_buf.index] - [src.primary_buf.desc]?"
			dat += "<br>\[ <a href='?src=\ref[src];operation=delete-buffer2'>OK</a> |  <a href='?src=\ref[src];operation=view-buffer'>Cancel</a> \]"
	dat += "<br><br><a href='?src=\ref[user];mach_close=computer'>Close</a>"
	dat += "</body></html>"
	ss13_browse(user, dat, "window=computer;size=400x500")
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
		if("lock")
			src.connected_scanner.locked = 1
		if("unlock")
			src.connected_scanner.locked = 0
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
			src.state = STATE_VIEW
		if("delete-buffer")
			src.primary_buf = buffers[text2num(href_list["buffer-num"])]
			src.state = STATE_DELETE
		if("delete-buffer2")
			src.state = STATE_VIEW_MENU_BUF
			src.primary_buf.desc = "Empty"
			del(src.primary_buf.contents)
		if("rename-buffer")
			src.primary_buf = buffers[text2num(href_list["buffer-num"])]
			var/newdesc = text_input("Enter new buffer description", "Buffer #[src.primary_buf.index] Description", "[src.primary_buf.desc]")
			if(newdesc && newdesc != "[src.primary_buf.desc]")
				src.primary_buf.desc = newdesc
		if("splice-menu")
			src.state = STATE_SPLICE_MENU_BUF1
		if("splice-buffer-primary")
			src.primary_buf = buffers[text2num(href_list["buffer-num"])]
			src.state = STATE_SPLICE_MENU_BUF2
		if("splice-buffer-secondary")
			src.secondary_buf = buffers[text2num(href_list["buffer-num"])]
			src.state = STATE_SPLICE_MENU_BUF_OUT
		if("splice-buffer-output")
			src.output_buf = buffers[text2num(href_list["buffer-num"])]
			src.output_buf.contents = src.primary_buf.contents.copy()
			src.output_buf.desc = "Full (Splice #[src.primary_buf.index] / #[src.secondary_buf.index])"
			src.state = STATE_SPLICE_MENU_CHROM
		if("splice-chromosome")
			src.pos_chromosome = text2num(href_list["chromosome-num"])
			src.state = STATE_SPLICE
			if(href_list["locus-num"] && href_list["locus-contents"])
				src.output_buf.contents.data[src.pos_chromosome][text2num(href_list["locus-num"])] = href_list["locus-contents"]
		if("gamma-menu")
			if (!src.connected_scanner)
				src.state = STATE_NO_SCANNER
			else if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
				src.state = STATE_NO_OCCUPANT
			else
				src.state = STATE_GAMMA_MENU
		if("gamma")
			if (!src.connected_scanner)
				src.state = STATE_NO_SCANNER
			else if(!src.connected_scanner.occupant || !istype(src.connected_scanner.occupant, /mob/carbon) || !src.connected_scanner.occupant.dna)
				src.state = STATE_NO_OCCUPANT
			else
				src.state = STATE_GAMMA
				src.secs_gamma = text2num(href_list["num-secs"])
		if("diff-menu")
			src.state = STATE_DIFF_MENU_BUF1
		if("diff-buffer-primary")
			src.primary_buf = buffers[text2num(href_list["buffer-num"])]
			src.state = STATE_DIFF_MENU_BUF2
		if("diff-buffer-secondary")
			src.secondary_buf = buffers[text2num(href_list["buffer-num"])]
			src.state = STATE_DIFF_DONE

	src.updateUsrDialog()
	return

/obj/machinery/computer/dna/process()
	if(src.state != STATE_SCANNING && src.state != STATE_REPLACING && src.state != STATE_GAMMA)
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
	else if(src.state == STATE_GAMMA)
		if(src.secs_gamma <= 0)
			state = STATE_GAMMA_DONE
		src.secs_gamma--
		src.connected_scanner.occupant.dna.mutate()
		src.connected_scanner.occupant.take_damage(electric = 2)
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
