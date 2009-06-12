/obj/machinery/freezer/New()
	..()
	var/obj/overlay/O1 = new /obj/overlay("Cryogenic2.dmi","canister connector_0",0,-16)
	src.overlays += O1
	src.connector = O1
	new /obj/item/weapon/flasks/coolant(src)
	new /obj/item/weapon/flasks/oxygen(src)
	new /obj/item/weapon/flasks/plasma(src)
	rebuild_overlay()
	gasflowlist += src

/obj/machinery/freezer/proc/rebuild_overlay()
	var/counter = 0
	src.overlays.len = 0
	src.overlays += src.connector
	for(var/obj/item/weapon/flasks/F in src.contents)
		src.overlays += new /obj/overlay(F.icon,F.icon_state,counter*12,-17)
		if(++counter >= 3) break
	return

/obj/machinery/freezer/interact(mob/user as mob)
	if(!..()) return 0
	user.machine = src

	var/dat=text("<HEAD>Freezer Console</HEAD><PRE><TT>")
	dat +=	text("<B>Cryogenic Temperature</B>: []&deg;C<BR>", src.temp-T0C)
	dat +=	text("<B>Cryogenic Connector</B>: [] (<A href='?src=\ref[src];transfer=[]</A>)<BR><BR>",
				(src.transfer?"Active" : "Inactive"), (src.transfer?"0'>disable" : "1'>enable"))

	dat +=	text("<BR> <BR><B>Cryogenic Chemicals</B>:<BR>")
	dat +=	text("  Coolant: []<BR>", rate_control(src,"coolant",src.rate["coolant"]))
	dat +=	text("  Oxygen:  []<BR>", rate_control(src,"oxygen", src.rate["oxygen"]))
	dat +=	text("  Plasma:  []<BR>", rate_control(src,"plasma", src.rate["plasma"]))

	dat +=	text("<BR> <BR><B>Chemical Flasks</B>:<BR>")
	if(!locate(/obj/item/weapon/flasks, src)) dat += text("None<BR>")
	else
		var/counter = 1
		for(var/obj/item/weapon/flasks/F in src)
			dat += text("  <A href='?src=\ref[src];flask=[counter]'><B>Flask [counter]</B></A>: ")
			if(F.coolant)	dat += text("Coolant ([]) ", F.coolant)
			if(F.oxygen)	dat += text("Oxygen ([]) ",  F.oxygen)
			if(F.plasma)	dat += text("Plasma ([]) ",  F.plasma)
			if(!F.coolant && !F.oxygen && !F.plasma)
				dat += "(empty)"
			dat += "<BR>"
			++counter

	dat +=	text("<BR> <BR><A href='?src=\ref[user];mach_close=freezer'>Close</A></TT></PRE>")
	ss13_browse(user, dat, "window=freezer;size=400x500")
	return 1

/obj/machinery/freezer/Topic(href, href_list)
	if(!..()) return 0
	usr.machine = src

	if(href_list["rate control"])
		if(href_list["coolant"])	src.rate["coolant"]= dd_range(0,10,rate["coolant"]+text2num(href_list["coolant"]))
		if(href_list["oxygen"])		src.rate["oxygen"] = dd_range(0,10,rate["oxygen"] +text2num(href_list["oxygen"]))
		if(href_list["plasma"])		src.rate["plasma"] = dd_range(0,10,rate["plasma"] +text2num(href_list["plasma"]))

	if(href_list["transfer"])
		src.transfer = text2num(href_list["transfer"])
		if(!src.transfer) stabilize_temperature(5,20+T0C)

	if(href_list["flask"])
		var/t1 = text2num(href_list["flask"])
		if(t1 <= src.contents.len)
			var/obj/F = src.contents[t1]
			F.loc = src.loc
			src.rebuild_overlay()
	src.updateDialog()
	return 1

/obj/machinery/freezer/proc/stabilize_temperature(var/rate,var/goal)
	if(src.temp >= goal) return
	spawn(10)
		while(src.temp<goal && !src.transfer)
			src.temp = min(src.temp+rate,goal)
			src.updateDialog()
			sleep(10)

/obj/machinery/freezer/process()
	if(stat & (BROKEN|NOPOWER))	return
	use_power(50)
	if(!src.transfer) return

	var/tGas
	var/tOxygen = 0
	var/tPlasma = 0
	var/tCoolant = 0

	for(var/obj/item/weapon/flasks/flask in src.contents)
		tGas = min(src.rate["coolant"]-tCoolant,flask.coolant)
		if(tGas > 0) { flask.coolant -= tGas; tCoolant += tGas }

		tGas = min(src.rate["oxygen"]-tOxygen,flask.oxygen)
		if(tGas > 0) { flask.oxygen -= tGas; tCoolant += tGas }

		tGas = min(src.rate["plasma"]-tPlasma,flask.plasma)
		if(tGas > 0) { flask.plasma -= tGas; tCoolant += tGas }

	src.rate["coolant"] = min(tCoolant,src.rate["coolant"])
	src.rate["oxygen"]  = min(tOxygen, src.rate["oxygen"])
	src.rate["plasma"]  = min(tPlasma, src.rate["plasma"])

	if(tCoolant)
		src.temp = max(T0C-100, src.temp-(tCoolant*5))
		use_power(200)

	src.temp = min(src.temp + 5, 20+T0C)

	if(tOxygen || tPlasma)
		ngas.oxygen += tOxygen
		ngas.plasma += tPlasma
		ngas.temp = src.temp

	if(ngas.oxygen || ngas.plasma)
		spawn(1)
			if(!src.line_out) return
			if(!vnode) leak_to_turf()
			else
				var/delta_gt = FLOWFRAC * ( vnode.get_gas_val(src) - gas.total() / capmult)
				calc_delta( src, gas, ngas, vnode, delta_gt)
			return
	if(!tCoolant && !tOxygen && !tPlasma)
		stabilize_temperature(T0C+20)
		src.transfer = 0

	src.updateDialog()
	return

/obj/machinery/freezer/power_change()
	..()
	if(stat & (BROKEN|NOPOWER))	src.icon_state = "freezer_0"
	else						src.icon_state = "freezer_[status]"

/obj/machinery/freezer/proc/leak_to_turf()
	var/turf/T = get_step(src, EAST)
	if(T.density)
		T = src.loc
		if(T.density) return
	flow_to_turf(gas, ngas, T)

/obj/machinery/freezer/orient_pipe(P as obj)
	if(src.line_out) return 0
	src.line_out = P
	return 1

/obj/machinery/freezer/buildnodes()
	var/turf/T = src.loc
	line_out = get_machine(level, T, p_dir )
	if(line_out) vnode = line_out.getline()

/obj/machinery/freezer/gas_flow()				{	gas.replace_by(ngas)	}
/obj/machinery/freezer/get_gas_val(from)		{	return gas.total()		}
/obj/machinery/freezer/get_gas(from)			{	return gas				}

/obj/machinery/freezer/attackby(obj/item/weapon/flasks/F as obj, mob/carbon/user as mob)
	if(!istype(F, /obj/item/weapon/flasks))	return ..(F,user)
	if(src.contents.len >= 3) return user << "<font color='blue'>All slots are full!</font>"
	user.drop_item()
	F.loc = src
	src.rebuild_overlay()
