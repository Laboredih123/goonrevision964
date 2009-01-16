/obj/machinery/New()
	..()
	machines += src

/obj/machinery/Del()
	machines -= src
	..()

/obj/machinery/interact(mob/user as mob)
	..()
	if(stat & (NOPOWER|BROKEN))		return 0
	if(!user.can_use_hands())		return 0
	if(!user.check_intelligence())	return 0
	if(istype(user, /mob/carbon))
		if(!user in viewers(1))
			return 0
	return 1

/obj/machinery/Topic(href, href_list)
	..()
	if(stat & (NOPOWER|BROKEN))		return 0
	if(!usr.can_use_hands())		return 0
	if(!usr.check_intelligence())	return 0

	if(!usr.contents.Find(src))
		if(!istype(usr, /mob/silicon/ai))
			if(!(istype(src.loc,/turf) || get_dist(src,usr)<=1))
				return 0
	src.add_fingerprint(usr)
	return 1

/obj/machinery/blob_act()
	if(prob(25)) del(src)

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1)	del(src)
		if(2)	if(!prob(50))	return
		if(3)	if(!prob(25))	return
	src.broken()

/obj/machinery/proc/broken()
	src.icon_state = "broken"
	src.stat |= BROKEN
	src.verbs.len = 0

/obj/machinery/mass_driver/broken()
	..()
	src.icon_state = "mass_driver-disabled"

/obj/machinery/pipes/broken()
	src.icon_state += "-b"
	src.stat |= BROKEN
	src.verbs.len = 0

/obj/machinery/door/broken()
	del(src)

/proc/rate_control(var/S, var/V, var/C, var/Min=1, var/Max=5, var/Limit=null)
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit) return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate
