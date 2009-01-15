/obj/machinery/computer/communications
	name = "Communications Console"
	icon = 'stationobjs.dmi'
	icon_state = "comm_computer"
	req_access = list(access_heads)
	var/prints_intercept = 1
	var/authenticated = 0
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/const
		STATE_DEFAULT = 1
		STATE_CALLSHUTTLE = 2
		STATE_CANCELSHUTTLE = 3
		STATE_MESSAGELIST = 4
		STATE_VIEWMESSAGE = 5
		STATE_DELMESSAGE = 6

/obj/machinery/computer/communications/process()
	if(stat & (NOPOWER|BROKEN))
		return
	..()
	if(shuttle_status != SHUTTLE_COMING && shuttle_status != SHUTTLE_RETURNING)
		return
	src.updateUsrDialog()

/obj/machinery/computer/communications/Topic(href, href_list)
	if(!..()) return

	usr.machine = src
	if(!href_list["operation"]) return
	switch(href_list["operation"])
		// main interface
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/carbon/M = usr
			var/obj/item/weapon/card/id/I = M.equipped()
			if(!I || !istype(I,/obj/item/weapon/card/id)) I = M.id
			if(I && istype(I,/obj/item/weapon/card/id))
				if(src.check_access(I))
					authenticated = 1
		if("logout")
			authenticated = 0
		if("messagelist")
			src.currmsg = 0
			src.state = STATE_MESSAGELIST
		if("viewmessage")
			src.state = STATE_VIEWMESSAGE
			if(!src.currmsg)
				if(href_list["message-num"])
					src.currmsg = text2num(href_list["message-num"])
				else
					src.state = STATE_MESSAGELIST
		if("delmessage")
			src.state = (src.currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("delmessage2")
			if(src.authenticated)
				if(src.currmsg)
					var/title = src.messagetitle[src.currmsg]
					var/text  = src.messagetext[src.currmsg]
					src.messagetitle.Remove(title)
					src.messagetext.Remove(text)
					if(src.currmsg == src.aicurrmsg)
						src.aicurrmsg = 0
					src.currmsg = 0
				src.state = STATE_MESSAGELIST
			else
				src.state = STATE_VIEWMESSAGE
		// AI interface
		if("ai-main")
			src.aicurrmsg = 0
			src.aistate = STATE_DEFAULT
		if("ai-messagelist")
			src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-viewmessage")
			src.aistate = STATE_VIEWMESSAGE
			if(!src.aicurrmsg)
				if(href_list["message-num"])
					src.aicurrmsg = text2num(href_list["message-num"])
				else
					src.aistate = STATE_MESSAGELIST
		if("ai-delmessage")
			src.aistate = (src.aicurrmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("ai-delmessage2")
			if(src.aicurrmsg)
				var/title = src.messagetitle[src.aicurrmsg]
				var/text  = src.messagetext[src.aicurrmsg]
				src.messagetitle.Remove(title)
				src.messagetext.Remove(text)
				if(src.currmsg == src.aicurrmsg)
					src.currmsg = 0
				src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("callshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CALLSHUTTLE
		if("callshuttle2")
			if(src.authenticated)
				call_shuttle()
			src.state = STATE_DEFAULT
		if("cancelshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CANCELSHUTTLE
		if("cancelshuttle2")
			if(src.authenticated)
				uncall_shuttle()
			src.state = STATE_DEFAULT


	src.updateUsrDialog()

/obj/machinery/computer/communications/interact(var/mob/user as mob)
	if(!..()) return
	user.machine = src

	var/dat = "<head><title>Communications Console</title></head><body>"

	if(istype(user, /mob/silicon/ai))
		var/dat2 = src.interact_ai(user) // give the AI a different interact proc to limit its access
		if(dat2)
			dat += dat2
			ss13_browse(user, dat, "window=communications;size=400x500")
		return

	switch(src.state)
		if(STATE_DEFAULT)
			if(src.authenticated)
				if(shuttle_status == SHUTTLE_WAITING || shuttle_status == SHUTTLE_RETURNING)
					dat += "<br>\[<a href='?src=\ref[src];operation=callshuttle'> Call Emergency Shuttle </a>\]"
				else if(shuttle_status == SHUTTLE_COMING)
					dat += "<BR>\[ <A HREF='?src=\ref[src];operation=cancelshuttle'>Cancel Shuttle Call</A> \]"
				dat += "<br>\[<a href='?src=\ref[src];operation=logout'> Log Out </a>\]"
			else
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=login'>Log In</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=messagelist'>Message List</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if(src.currmsg)
				dat += "<B>[src.messagetitle[src.currmsg]]</B><BR><BR>[src.messagetext[src.currmsg]]"
				if(src.authenticated)
					dat += "<BR><BR>\[ <A HREF='?src=\ref[src];operation=delmessage'>Delete \]"
			else
				src.state = STATE_MESSAGELIST
				src.interact(user)
				return
		if(STATE_DELMESSAGE)
			if(src.currmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=\ref[src];operation=delmessage2'>OK</A> | <A HREF='?src=\ref[src];operation=viewmessage'>Cancel</A> \]"
			else
				src.state = STATE_MESSAGELIST
				src.interact(user)
				return
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to call the shuttle? \[ <A HREF='?src=\ref[src];operation=callshuttle2'>OK</A> | <A HREF='?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_CANCELSHUTTLE)
			dat += "Are you sure you want to cancel the shuttle? \[ <A HREF='?src=\ref[src];operation=cancelshuttle2'>OK</A> | <A HREF='?src=\ref[src];operation=main'>Cancel</A> \]"


	dat += "<BR>\[ [(src.state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> \]"
	ss13_browse(user, dat, "window=communications;size=450x500")

/obj/machinery/computer/communications/proc/interact_ai(var/mob/silicon/ai/user as mob)
	var/dat = ""
	switch(src.aistate)
		if(STATE_DEFAULT)
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-messagelist'>Message List</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=ai-viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if(src.aicurrmsg)
				dat += "<B>[src.messagetitle[src.aicurrmsg]]</B><BR><BR>[src.messagetext[src.aicurrmsg]]"
				dat += "<BR><BR>\[ <A HREF='?src=\ref[src];operation=ai-delmessage'>Delete</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.interact(user)
				return null
		if(STATE_DELMESSAGE)
			if(src.aicurrmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=\ref[src];operation=ai-delmessage2'>OK</A> | <A HREF='?src=\ref[src];operation=ai-viewmessage'>Cancel</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.interact(user)
				return

	dat += "<BR>\[ [(src.aistate != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=ai-main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> \]"
	return dat
