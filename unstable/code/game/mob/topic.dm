/mob/Topic(href, href_list)
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)


	if(href_list["priv_msg"])
		var/mob/M = locate(href_list["priv_msg"])
		if(M)
			if (!( ismob(M) ))
				return
			var/t = input("Message:", text("Private message to []", M.key), null, null)  as text
			if (!( t ))
				return
			if (usr.client && usr.client.holder)
				M << "\blue Admin PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
				usr << "\blue Admin PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"
			else
				M << "\blue Reply PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
				usr << "\blue Reply PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"

			world.log_admin("PM: [usr.key]->[M.key] : [t]")

	..()
	return