/obj/machinery/computer/brig
	name = "Brig Control"
	icon = 'stationobjs.dmi'
	icon_state = "sec_computer"
	req_access = list(access_brig)
	var/authenticated = 0
	var/processing = 0
	var/const/default_time = 3000 // 5 minutes
	var/const/default_reason = "Miscellaneous criminality"

	var/state = STATE_DEFAULT
	var/cur_cellname = null

	var/const
		STATE_DEFAULT = 1
		STATE_SENTENCE = 2

	var/list/cells_by_name = list()
	var/list/reason_by_name = list()
	var/list/time_by_name = list()
	var/list/served_by_name = list()

	New()
		spawn src.process_cells()

	Topic(href, href_list)
		if(!..()) return

		usr.machine = src
		if(!href_list["operation"]) return
		switch(href_list["operation"])
			if("login")
				var/mob/carbon/M = usr
				var/obj/item/weapon/card/id/I = M.equipped()
				if(!I || !istype(I,/obj/item/weapon/card/id)) I = M.id
				if(I && istype(I,/obj/item/weapon/card/id))
					if(src.check_access(I))
						src.authenticated = 1
			if("logout")
				src.authenticated = 0
			if("open")
				var/obj/machinery/door/window/W = cells_by_name[href_list["cell"]]
				if(W)
					spawn W.try_open()
			if("close")
				var/obj/machinery/door/window/W = cells_by_name[href_list["cell"]]
				if(W)
					spawn W.try_close()
			if("set")
				src.state = STATE_SENTENCE
				src.cur_cellname = href_list["cell"]
			if("set-sentence")
				src.state = STATE_DEFAULT
				var/cell = href_list["cell"]
				var/mins = text2num(href_list["length-min"])
				var/secs = text2num(href_list["length-sec"])
				var/reason = href_list["reason"]
				var/length = secs * 10 + mins * 600
				if(length)
					src.reason_by_name[cell] = reason
					src.time_by_name[cell] = length
			if("close-window")
				usr.machine = null
				ss13_browse(usr, null, "window=brig")
				return
		spawn src.process_cells()
		src.updateUsrDialog()

	interact(var/mob/user as mob)
		if(!..()) return
		user.machine = src

		var/dat = "<head><title>Brig Control</title></head><body>"

		if(src.authenticated)
			dat += "<a href='?src=\ref[src];operation=logout'>Log Out</a><br>"
		else if(!istype(user, /mob/silicon/ai))
			dat += "<a href='?src=\ref[src];operation=login'>Log In</a><br>"

		if(src.authenticated || istype(user, /mob/silicon/ai))
			if(src.state == STATE_DEFAULT)
				dat += "<br>"
				for(var/name in src.cells_by_name)
					var/obj/machinery/door/window/W = cells_by_name[name]
					if(!W)
						continue
					dat += "<b>[name]</b><br>"
					dat += "Sentence: <a href='?src=\ref[src];operation=set;cell=[name]'>[reason_by_name[name]]</a><br>"
					dat += "Sentence length: [time2text(time_by_name[name], "mm:ss")]<br>"
					if(W.density)
						dat += "Served: [time2text(served_by_name[name], "mm:ss")]<br>"
						dat += "<a href='?src=\ref[src];operation=open;cell=[name]'>Open Cell</a>"
					else
						dat += "<a href='?src=\ref[src];operation=close;cell=[name]'>Close Cell</a>"
					dat += "<br><br>"
			else if(src.state == STATE_SENTENCE)
				dat += "<form action='byond://' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='cell' value='[cur_cellname]'>"
				dat += "<input type='hidden' name='operation' value='set-sentence'>"
				dat += "Sentence length:<br><input type='text' name='length-min' value='0' size='5'> minutes <input type='text' name='length-sec' value='60' size='5'> seconds<br>"
				dat += "Reason:<br><textarea name='reason' rows='5' cols='40'>Miscellaneous criminality</textarea><br>"
				dat += "<br><input type='submit' value='Submit'>"
				dat += "</form>"
		dat += "<a href='?src=\ref[src];operation=close-window'>Close</a>"
		ss13_browse(user, dat, "window=brig")

	proc/get_doors(cellname)
		var/list/L = list()
		for(var/obj/machinery/door/window/W in get_area(src))
			if(W.cellname == cellname)
				L += W
		return L

	proc/process_cells()
		if(processing)
			return
		processing = 1
		var/last_processed = ss13time()
		while(1)
			var/curtime = ss13time()
			for(var/name in cells_by_name)
				var/obj/machinery/door/window/W = cells_by_name[name]
				if(!W)
					continue
				if(!W.density)
					served_by_name[name] = 0
					continue
				served_by_name[name] += curtime - last_processed
				if(served_by_name[name] > time_by_name[name])
					release(name)
			last_processed = curtime
			if(src.state == STATE_DEFAULT) // they can see the updates
				src.updateUsrDialog()
			sleep(10)

	proc/register_door(obj/machinery/door/window/W)
		cells_by_name[W.cellname] = W
		time_by_name[W.cellname] = default_time
		reason_by_name[W.cellname] = default_reason
		served_by_name[W.cellname] = 0

	proc/release(name)
		var/obj/machinery/door/window/W = cells_by_name[name]
		if(!W)
			return
		station_announce("The prisoner in cell [name] is being released after [time2text(served_by_name[name], "mm minutes and ss seconds")]. He was imprisoned for [reason_by_name[name]].")
		served_by_name[W.cellname] = 0
		W.try_open()