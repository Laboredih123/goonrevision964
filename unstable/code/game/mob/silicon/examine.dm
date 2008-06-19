/mob/silicon/examine()
	set src in viewers()

	usr << "\blue *---------*"
	usr << "\blue This is \icon[src] <B>[src.name]</B>!"
	if (src.damage.brute)
		if (src.damage.brute < 30)
			usr << "\red [src.name]'s case looks slightly battered!"
		else
			usr << "\red <B>[src.name]'s case looks severely battered!</B>"
	if (src.damage.burn)
		if (src.damage.burn < 30)
			usr << "\red [src.name]'s case looks slightly burnt!"
		else
			usr << "\red <B>[src.name]'s case looks severely burnt!</B>"
	usr << "\blue *---------*"
	return

