/datum/admin_power/private_message
	name = "PM"
	panel_type = PANEL_TYPE_PLAYER
	allowed_for = ADMIN_ALL

	get_desc(mob/M)
		return "<A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A>"

/client/proc/private_message(mob/M as mob)
	var/t = text_input("Message:", "Private message to [M.key]")  as text
	if(!t)
		return
	M << "\blue PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
	usr << "\blue PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"
	world.log_admin("PM: [usr.key]->[M.key] : [t]")