/obj/overlay/New(icon, istate, xpix, ypix)
	src.icon_state = istate
	src.pixel_x = xpix
	src.pixel_y = ypix
	src.icon = icon

/obj/machinery/cryo_cell/New()
	..()
	src.layer = 5
	src.pixel_y	= 32
	O1 = new /obj/overlay("Cryogenic2.dmi","cellconsole",0,-32)
	O2 = new /obj/overlay("Cryogenic2.dmi","cellbottom",0,-32)
	O1.layer	= 4
	add_overlays()
	gasflowlist += src

/obj/machinery/cryo_cell/broken()
	src.eject_occupant()
	..()

/obj/machinery/cryo_cell/blob_act()
	src.eject_occupant()
	..()

/obj/machinery/cryo_cell/orient_pipe(P as obj)
	if(src.line_in) return 0
	src.line_in = P
	return 1

/obj/machinery/cryo_cell/allow_drop()
	return 0

/obj/machinery/cryo_cell/proc/add_overlays()
	src.overlays = list(O1, O2)

/obj/machinery/cryo_cell/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "celltop-p"
		O1.icon_state="cellconsole-p"
		O2.icon_state="cellbottom-p"
	else
		icon_state = "celltop[ occupant ? "_1" : ""]"
		O1.icon_state ="cellconsole"
		O2.icon_state ="cellbottom"

	add_overlays()

/obj/machinery/cryo_cell/process()
	if(stat & (BROKEN|NOPOWER))	return
	if(!vnode) src.leak_to_turf()
	else
		var/delta_gt = FLOWFRAC*(vnode.get_gas_val(src) - src.gas.total() / capmult)
		calc_delta(src, gas, ngas, vnode, delta_gt)
	use_power(500)
	src.updateDialog()

/obj/machinery/cryo_cell/proc/leak_to_turf()
	var/turf/T = get_step(src, WEST)

	if(T.density)
		T = src.loc
		if(T.density)
			return

	flow_to_turf(gas, ngas, T)

/obj/machinery/cryo_cell/buildnodes()
	var/turf/T = src.loc
	line_in = get_machine(level, T, p_dir)
	if(line_in) vnode = line_in.getline()

/obj/machinery/cryo_cell/get_gas_val(from)	{	return gas.total()		}
/obj/machinery/cryo_cell/get_gas(from)		{	return gas				}
/obj/machinery/cryo_cell/gas_flow()			{	gas.replace_by(ngas)	}

/obj/machinery/cryo_cell/verb/enter_capsule()
	set src in oview(1)
	if(!usr.can_use_hands())	return
	if(stat & (BROKEN|NOPOWER))	return
	if(src.occupant)
		usr << "<font color='blue'><B>The cell is already occupied!</B></font>"
		return
	if(usr.abiotic())
		usr << "Subject may not have abiotic items on."
		return
	src.add_fingerprint(usr)
	usr.pulling = null
	add_occupant(usr)
	return

/obj/machinery/cryo_cell/verb/empty_capsule()
	set src in oview(1)
	if(!usr.can_use_hands()) return
	add_fingerprint(usr)
	src.eject_occupant()

/obj/machinery/cryo_cell/proc/add_occupant(var/mob/carbon/user)
	if(stat & (BROKEN|NOPOWER))	return 0
	if(user.abiotic())	return 0
	if(src.occupant)	return 0

	if(user.client)
		user.client.eye = src
		user.client.perspective = EYE_PERSPECTIVE
	for(var/obj/O in src)	O.loc = src.loc
	src.icon_state = "celltop_1"
	src.occupant = user
	occupant.loc = src
	return 1

/obj/machinery/cryo_cell/proc/eject_occupant()
	if(!src.occupant)		return 0
	for(var/obj/O in src)	O.loc = src.loc

	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.add_fingerprint(src.occupant)
	src.occupant.loc = src.loc
	src.icon_state = "celltop"
	src.occupant = null
	return 1

/obj/machinery/cryo_cell/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if(stat & (BROKEN|NOPOWER))				return
	if(!istype(G, /obj/item/weapon/grab))	return
	if(!ismob(G.affecting))					return
	if(G.affecting.abiotic())
		user << "Subject may not have abiotic items on."
		return
	if(src.occupant)
		user << "<font color='blue'><B>The cell is already occupied!</B></font>"
		return
	src.add_occupant(G.affecting)
	src.add_fingerprint(user)
	del(G)

/obj/machinery/cryo_cell/interact(mob/user as mob)
	if(!..()) return
	user.machine = src

	var/t1
	var/dat = "<font color='blue'> <B>System Statistics:</B></FONT><BR>"
	dat += text("<font color='[]'>Temperature: [] &deg;C</FONT><BR>",	(src.gas.temp > T0C)?"red" : "blue", round(src.gas.temp-T0C, 0.1))
	dat += text("<font color='[]'>Oxygen Units: []</FONT><BR>",			(src.gas.oxygen < 1)?"red" : "blue", round(src.gas.oxygen, 0.1))
	dat += text("<font color='[]'>Plasma Units: []</FONT><BR>",			(src.gas.plasma < 1)?"red" : "blue", round(src.gas.plasma, 0.1))
	dat += text("<A href = '?src=\ref[];drain=1'>Drain</A><BR><BR>", src)
	if(src.occupant)
		dat += "<font color='blue'><B>Occupant Statistics:</B></FONT><BR>"
		if(src.occupant.is_conscious())		t1 = "<font color='blue>conscious</font>"
		else if(src.occupant.is_dead)		t1 = "<font color='red'>*DEAD*</font>"
		else								t1 = "<font color='blue'>unconscious</font>"
		dat += text("<font color='[]'>Health: []% ([])</FONT><BR>",			(occupant.get_damage() < 50 ?"blue" : "red"), (src.occupant.death_threshold - src.occupant.get_damage())/src.occupant.death_threshold*100, t1)
		dat += text("<font color='[]'>- Respiratory Damage: []%</FONT><BR>",(occupant.dam.suffocation < 60 ?"blue" : "red"), src.occupant.dam.suffocation)
		dat += text("<font color='[]'>- Toxin Content: []%</FONT><BR>",		(occupant.dam.toxin < 60 ?"blue" : "red"), src.occupant.dam.toxin)
		dat += text("<font color='[]'>- Burn Severity: []%</FONT><BR>",		(occupant.dam.burn < 60 ?"blue" : "red"), src.occupant.dam.burn)
		dat += text("<A href = '?src=\ref[];eject=1'>Eject</A><BR><BR>", src)
	dat += text("<A href='?src=\ref[];mach_close=cryo'>Close</A>", user)
	ss13_browse(user, dat, "window=cryo;size=400x500")

/obj/machinery/cryo_cell/Topic(href, href_list)
	if(!..()) return
	usr.machine = src

	if(href_list["eject"])
		src.eject_occupant()
		src.updateUsrDialog()
		return

	if(!href_list["drain"]) return

	//leak_to_turf()
	if(!vnode) return leak_to_turf()

	//vnode:leak_to_turf()
	var/obj/machinery/freezer/target = vnode:vnode2
	if(!target)	return

	//target.leak_to_turf()
	var/sendplasma = src.gas.plasma + vnode:gas:plasma + vnode:vnode2:gas:plasma
	var/sendoxygen = src.gas.oxygen + vnode:gas:oxygen + vnode:vnode2:gas:oxygen
	for(var/obj/item/weapon/flasks/flask in target.contents)
		if(istype(flask, /obj/item/weapon/flasks/plasma))
			flask.plasma += sendplasma
			src.gas.plasma = 0
			src.ngas.plasma = 0
			src.vnode:gas.plasma = 0
			src.vnode:ngas.plasma = 0
			src.vnode:vnode2:gas.plasma = 0
			src.vnode:vnode2:ngas.plasma = 0
		else if(istype(flask, /obj/item/weapon/flasks/oxygen))
			flask.oxygen += sendoxygen
			src.gas.oxygen = 0
			src.ngas.oxygen = 0
			src.vnode:gas.oxygen = 0
			src.vnode:ngas.oxygen = 0
			src.vnode:vnode2:gas.oxygen = 0
			src.vnode:vnode2:ngas.oxygen = 0

		//we ignore co2, sl_gas, and n2
	return

/obj/machinery/cryo_cell/relaymove(mob/user as mob)
	if(!user.can_use_hands()) return
	src.eject_occupant()

/obj/machinery/cryo_cell/alter_health(mob/carbon/M as mob)
	if(M.is_dead)	return
	if(stat & (BROKEN|NOPOWER)) return

	M.knockdown_until(20)

	if(src.ngas.oxygen > 0)
		M.heal_damage(suffocation = 5)
		--src.ngas.oxygen

	if(src.gas.temp < T0C && src.gas.plasma > 0)
		M.heal_damage(toxin = 5, brute = 5, burn = 5)
		--src.ngas.plasma

	if(src.gas.temp < (T0C+60))	++src.gas.temp
	src.updateDialog()
	return
