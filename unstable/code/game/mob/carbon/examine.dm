/mob/carbon/examine()
	set src in viewers()

	usr << "\blue *---------*"
	usr << "\blue This is \icon[src] <B>[src.name]</B>!"
	if (src.jumpsuit)
		usr << "\blue \t[src.name] is wearing \icon[src.jumpsuit] [src.jumpsuit.name]."
	if (src.handcuffed)
		usr << "\blue \t[src.name] is handcuffed! \icon[src.handcuffed]"
	if (src.suit)
		usr << "\blue \t[src.name] has a \icon[src.suit] [src.suit.name] on!"
	if (src.headset)
		usr << "\blue \t[src.name] has a \icon[src.headset] [src.headset.name] by \his[src] mouth!"
	if (src.mask)
		usr << "\blue \t[src.name] has a \icon[src.mask] [src.mask.name] on \his[src] head!"
	if (src.l_hand)
		usr << "\blue \t[src.name] has a \icon[src.l_hand] [src.l_hand.name] in \his[src] left hand!"
	if (src.r_hand)
		usr << "\blue [src.name] has a \icon[src.r_hand] [src.r_hand.name] in \his[src] right hand!"
	if (src.back)
		usr << "\blue [src.name] has a \icon[src.back] [src.back] on \his[src] back!"
	if (src.id)
		if ((src.id.registered != src.rname && get_dist(src, usr) <= 1 && prob(10)))
			usr << "\blue [src.name] is wearing \icon[src.id] [src.id.name] yet doesn't seem to be that person!!!"
		else
			usr << "\blue [src.name] is wearing \icon[src.id] [src.id.name]!"
	if (src.damage.brute)
		if (src.damage.brute < 30)
			usr << "\red [src.name] looks slightly bruised!"
		else
			usr << "\red <B>[src.name] looks severely bruised!</B>"
	if (src.damage.burn)
		if (src.damage.burn < 30)
			usr << "\red [src.name] looks slightly burnt!"
		else
			usr << "\red <B>[src.name] looks severely burnt!</B>"
	usr << "\blue *---------*"
	return

