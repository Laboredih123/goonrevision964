/mob/Topic(href, href_list)
	if (href_list["mach_close"])
		src.machine = null
		ss13_browse(src, null, "window=[href_list["mach_close"]]")
	if(href_list["priv_msg"])
		var/mob/M = locate(href_list["priv_msg"])
		if(M)
			if(!ismob(M))	return
			var/t = text_input("Message:", text("Private message to []", M.key), null, null)  as text
			if(!t)			return
			M << "\blue PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
			usr << "\blue PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"

			world.log_admin("PM: [usr.key]->[M.key] : [t]")
	return ..()
