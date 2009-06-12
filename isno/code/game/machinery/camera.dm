/obj/machinery/camera
	name = "Security Camera"
	icon = 'stationobjs.dmi'
	icon_state = "camera"
	var/network = "SS13"
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = 1.0
	var/invuln = null
	var/list/viewers = list()

	interact(mob/silicon/ai/user as mob)
		if(!istype(user, /mob/silicon/ai))
			return ..()
		if (src.network != user.network || !(src.status))
			return
		user.current = src
		user.reset_view(src)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/wirecutters))
			src.status = !( src.status )
			if (!( src.status ))
				user.show_viewers(text("\red [] has deactivated []!", user, src))
				src.icon_state = "camera1"
			else
				user.show_viewers(text("\red [] has reactivated []!", user, src))
				src.icon_state = "camera"
			// now disconnect anyone using the camera
			for(var/mob/silicon/ai/O in world)
				if (O.current == src)
					O.cancel_camera()
					O << "Your connection to the camera has been lost."
			for (var/mob/O in world)
				if (istype(O.machine, /obj/machinery/computer/security))
					var/obj/machinery/computer/security/S = O.machine
					if (S.current == src)
						O.machine = null
						S.current = null
						O.reset_view(null)
						O << "The screen bursts into static."
		else if (istype(W, /obj/item/weapon/paper))
			var/obj/item/weapon/paper/X = W
			for(var/mob/silicon/ai/O in world)
				if (O.current == src)
					O << "[user] holds a paper up to the camera ..."
					ss13_browse(O, text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
			for (var/mob/O in world)
				if (istype(O.machine, /obj/machinery/computer/security))
					var/obj/machinery/computer/security/S = O.machine
					if (S.current == src)
						O << "[user] holds a paper up to the camera ..."
						ss13_browse(O, text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", X.name, X.info), text("window=[]", X.name))
	ex_act(severity)
		if(src.invuln) return
		return ..(severity)

	blob_act()
		return

	broken()
		..()
		src.icon_state = "camera1"

	hear(datum/message/message)
		..()
		for(var/mob/M in src.viewers)
			M.hear(message)

	hear_message(datum/message/message, atom/speaker)
		..()
		for(var/mob/M in src.viewers)
			M.hear_message(message, speaker)