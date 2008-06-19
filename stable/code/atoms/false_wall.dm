/turf/station/wall/false_wall
	name = "wall"
	icon = 'Doorf.dmi'
	var/operating = null
	var/visible = 1
	var/const/delay = 15
	var/const/prob_opens = 25
	//TODO: implement a way to track which users have seen which false walls open, and let them always open them

/turf/station/wall/false_wall/attack_paw(mob/user as mob)
	if ((ticker && ticker.mode == "monkey"))
		return src.attack_hand(user)
	return

/turf/station/wall/false_wall/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if (src.density) //door is closed
		if (prob(prob_opens)) //it's hard to open
			if (open()) //it successfully opens, i.e. wasn't operating
				user << "\blue The wall slides open!"
		else
			return ..()
	else
		if (close())
			user << "\blue The wall slides shut."
	return

/turf/station/wall/false_wall/attackby(obj/item/weapon/screwdriver/S as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(S, /obj/item/weapon/screwdriver))
		//try to disassemble the false wall
		if (!src.density || prob(prob_opens)) //without this, you can detect a false wall just by going down the line with screwdrivers
			//if it's already open, you can disassemble it no problem
			if (src.density) //if it was closed, let them know that they did something
				user << "\blue It was a false wall!"
			//disassemble it
			user << "\blue Now dismantling false wall."
			var/turf/station/floor/F = src.ReplaceWithFloor()
			F.oxygen = O2STANDARD
			//a false wall turns into a sheet of metal and displaced girders
			new /obj/item/weapon/sheet/metal( F )
			new /obj/d_girders( F )
			F.buildlinks()
			F.levelupdate()
			return
		else
			return ..()
	else
		return src.attack_hand(user)

/turf/station/wall/false_wall/proc/open()
	if (src.operating)
		return 0
	src.operating = 1
	src.name = "false wall"
	flick("doorc0", src) //show the door opening animation
	src.icon_state = "door0"
	spawn(delay) //we want to return 1 without waiting for the animation to finish - the textual cue seems sloppy if it waits
		//actually do the opening things
		src.density = 0
		src.opacity = 0
		src.updatecell = 1
		src.buildlinks()
		src.operating = 0
	return 1

/turf/station/wall/false_wall/proc/close()
	if (src.operating)
		return 0
	src.operating = 1
	src.name = "wall"
	flick("doorc1", src) //show the door closing animation
	src.icon_state = "door1"
	src.density = 1
	if (src.visible)
		src.opacity = 1
	src.updatecell = 0
	src.buildlinks()
	spawn(delay) //we want to return 1 without waiting for the animation to finish - the textual cue seems sloppy if it waits
		src.operating = 0
	return 1

/turf/station/wall/false_wall/examine()
	set src in oview(1)
	if (src.density) //door is closed
		..()
	else
		usr << "It's a false wall. It's open."
	return
