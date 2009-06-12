/mob/silicon/examine()
	set src in view()

	usr << "\blue *---------*"
	usr << "\blue This is \icon[src] <B>[src.name]</B>!"
	if (src.dam.brute)
		if (src.dam.brute < 30)
			usr << "\red [src.name]'s case looks slightly battered!"
		else
			usr << "\red <B>[src.name]'s case looks severely battered!</B>"
	if (src.dam.burn)
		if (src.dam.burn < 30)
			usr << "\red [src.name]'s case looks slightly burnt!"
		else
			usr << "\red <B>[src.name]'s case looks severely burnt!</B>"
	usr << "\blue *---------*"
	return

