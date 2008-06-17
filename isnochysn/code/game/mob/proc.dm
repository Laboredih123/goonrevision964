/mob/proc/show_ctf()
	if (ticker)
		usr << "Too late... The game has already started!"
		return
	else
		if (!( ctf ))
			ctf = new /obj/ctf_assist(  )
		ctf.show_screen(usr)
	return