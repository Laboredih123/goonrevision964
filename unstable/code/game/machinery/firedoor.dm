/var/const/OPEN = 1
/var/const/CLOSED = 2

/obj/machinery/door/firedoor
	name = "Firelock"
	icon = 'Door1.dmi'
	icon_state = "door0"
	var/blocked = null
	opacity = 0
	density = 0
	var/nextstate = null

/obj/machinery/door/firedoor/power_change()
	if( powered(ENVIRON) )
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

/obj/machinery/door/firedoor/attackby(obj/item/weapon/C as obj, mob/user as mob)

	src.add_fingerprint(user)
	if ((istype(C, /obj/item/weapon/weldingtool) && !( src.operating ) && src.density))
		var/obj/item/weapon/weldingtool/W = C
		if(W.welding)
			if (W.weldfuel > 2)
				W.weldfuel -= 2
			if (!( src.blocked ))
				src.blocked = 1
				src.icon_state = "doorl"
			else
				src.blocked = 0
				src.icon_state = "door1"
			return
	if (!( istype(C, /obj/item/weapon/crowbar) ))
		return
	if (!src.blocked && !src.operating)
		if(src.density)
			spawn( 0 )
				src.operating = 1
				flick("doorc0", src)
				src.icon_state = "door0"
				sleep(15)
				src.density = 0
				src.opacity = 0
				if(isturf(src.loc))
					src.loc:updatecell = 1
					src.loc:buildlinks()
				src.operating = 0
				return
		else //close it up again
			spawn( 0 )
				src.operating = 1
				flick("doorc1", src)
				src.icon_state = "door1"
				sleep(15)
				src.density = 1
				src.opacity = 1
				if(isturf(src.loc))
					src.loc:updatecell = 1
					src.loc:buildlinks()
				src.operating = 0
				return
	return

/obj/machinery/door/firedoor/close()
	if(src.density)
		return 0
	if(src.operating)
		return 0
	if(stat & NOPOWER)
		return 0
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.firelevel = 0
	return ..()

/obj/machinery/door/firedoor/open()
	if(!src.density)
		return 0
	if(src.operating)
		return 0
	if(stat & NOPOWER)
		return 0
	return ..()

/obj/machinery/door/firedoor/process()
	if(src.operating)
		return
	if(src.nextstate)
		if(src.nextstate == OPEN && src.density)
			spawn()
				src.open()
		else if(src.nextstate == CLOSED && !src.density)
			spawn()
				src.close()
		src.nextstate = null
