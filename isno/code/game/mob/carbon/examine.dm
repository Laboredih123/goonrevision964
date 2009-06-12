/mob/carbon/examine()
	set src in view()

	usr << "\blue *---------*"
	usr << "\blue This is \icon[src] <B>[src.name]</B>!"
	if (src.jumpsuit)
		usr << "\blue \t[src.name] is wearing \icon[src.jumpsuit] [src.jumpsuit.name]."
	if (src.handcuffs)
		usr << "\blue \t[src.name] is handcuffed! \icon[src.handcuffs]"
	if (src.suit)
		usr << "\blue \t[src.name] has a \icon[src.suit] [src.suit.name] on."
	if (src.headset)
		usr << "\blue \t[src.name] has a \icon[src.headset] [src.headset.name] by \his mouth."
	if (src.mask)
		usr << "\blue \t[src.name] has a \icon[src.mask] [src.mask.name] on \his head."
	if (src.l_hand)
		usr << "\blue \t[src.name] has a \icon[src.l_hand] [src.l_hand.name] in \his left hand."
	if (src.r_hand)
		usr << "\blue [src.name] has a \icon[src.r_hand] [src.r_hand.name] in \his right hand."
	if (src.belt)
		usr << text("\blue [] has a \icon[] [] on \his[] belt!", src.name, src.belt, src.belt.name, src)
	if (src.gloves)
		usr << text("\blue [] has a \icon[] [] on \his[] hands!", src.name, src.gloves, src.gloves.name, src)
	if (src.back)
		usr << "\blue [src.name] has a \icon[src.back] [src.back] on \his back."
	if (src.id)
		if ((src.id.registered != src.body_name && get_dist(src, usr) <= 1 && prob(10)))
			usr << "\blue [src.name] is wearing \icon[src.id] [src.id.name], but doesn't seem to be that person."
		else
			usr << "\blue [src.name] is wearing \icon[src.id] [src.id.name]."
	if (src.dam.brute)
		if (src.dam.brute < 30)
			usr << "\red [src.name] looks slightly bruised."
		else
			usr << "\red <B>[src.name] looks severely bruised.</B>"
	if (src.dam.burn)
		if (src.dam.burn < 30)
			usr << "\red [src.name] looks slightly burnt."
		else
			usr << "\red <B>[src.name] looks severely burnt.</B>"
	usr << "\blue *---------*"
	return

