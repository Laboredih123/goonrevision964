/obj/machinery/computer/meteorhit(var/obj/O as obj)
	var/obj/effects/smoke/fog = new /obj/effects/smoke( src.loc )
	fog.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn()
		fog.Life()
	src.broken()

/obj/machinery/computer/attackby(I as obj, user as mob)
	src.interact(user)

/obj/machinery/computer/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
		return
	if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
		return
	spawn(rand(0, 15))
		src.icon_state = "c_unpowered"
		stat |= NOPOWER

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))	return 0
	use_power(250)
//	src.updateUsrDialog()
	return 1

/obj/datacore/proc/manifest() // TODO: OH JESUS CHRIST MAKE THIS NOT TERRIBLE
	for(var/mob/carbon/H in world)
		if(!findtext(H.spawn_name, "Syndicate ", 1, null) && H.client)
			var/datum/data/record/G = new /datum/data/record()
			var/datum/data/record/M = new /datum/data/record()
			var/datum/data/record/S = new /datum/data/record()
			var/obj/item/weapon/card/id/C = H.id
			G.fields["job"]	= (C ? C.assignment : "Unassigned")
			G.fields["name"]	= H.spawn_name
			G.fields["id"]		= text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
			M.fields["name"]	= G.fields["name"]
			S.fields["name"]	= G.fields["name"]
			M.fields["id"]		= G.fields["id"]
			S.fields["id"]		= G.fields["id"]
			G.fields["sex"]		= ((H.gender == "female")? "Female" : "Male")
			G.fields["p_stat"]	= "Active"
			G.fields["m_stat"]	= "Stable"
			M.fields["b_type"]	= "[H.bloodtype]"
			M.fields["mi_dis"]	= "None"
			M.fields["ma_dis"]	= "None"
			M.fields["alg"]		= "None"
			M.fields["cdi"]		= "None"
			M.fields["notes"]	= "No notes."
			S.fields["criminal"]= "None"
			S.fields["mi_crim"]	= "None"
			S.fields["ma_crim"]	= "None"
			S.fields["notes"]	= "No notes."
			M.fields["alg_d"]	= "No allergies detected."
			M.fields["cdi_d"]	= "No diagnosed diseases."
			M.fields["mi_dis_d"]= "No declared disabilities."
			M.fields["ma_dis_d"]= "No diagnosed disabilities."
			S.fields["mi_crim_d"] = "No minor crime convictions."
			S.fields["ma_crim_d"] = "No major crime convictions."
			G.fields["fingerprint"] = text("[]", H.fingerprint)
			src.general += G
			src.medical += M
			src.security += S

/obj/machinery/mass_driver/proc/drive(amount)
	if(stat & (BROKEN|NOPOWER))	return
	use_power(500)

	for(var/atom/movable/O in src.loc)
		if(!O.anchored)
			var/atom/targetarea = locate(src.x, src.y, src.z)
			if(src.dir & NORTH)	targetarea = locate(targetarea.x, world.maxy, targetarea.z)
			if(src.dir & SOUTH)	targetarea = locate(targetarea.x, 1, targetarea.z)
			if(src.dir & EAST)	targetarea = locate(world.maxx, targetarea.y, targetarea.z)
			if(src.dir & WEST)	targetarea = locate(1, targetarea.y, targetarea.z)
			O.throw_at(targetarea, drive_range * src.power, src.power)
	flick("mass_driver1", src)

