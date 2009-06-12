/obj/machinery/pipefilter/New()
	..()

	p_dir = (NORTH|SOUTH|EAST|WEST) ^ turn(dir, 180)

	src.gas = new /datum/substance/gas( src )
	src.gas.maximum = src.capacity
	src.ngas = new /datum/substance/gas()

	src.f_gas = new /datum/substance/gas( src )
	src.f_gas.maximum = src.capacity
	src.f_ngas = new /datum/substance/gas()

	gasflowlist += src

/obj/machinery/pipefilter/buildnodes()
	var/turf/T = src.loc

	n1dir = turn(dir, 90)
	n2dir = turn(dir,-90)

	node1 = get_machine( level, T , n1dir )	// the main flow dir
	node2 = get_machine( level, T , n2dir )
	node3 = get_machine( level, T, dir )	// the ejector port

	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()
	if(node3) vnode3 = node3.getline()

/obj/machinery/pipefilter/gas_flow()
	gas.replace_by(ngas)
	f_gas.replace_by(f_ngas)

/obj/machinery/pipefilter/process()
	var/delta_gt

	if(vnode1)
		delta_gt = FLOWFRAC * ( vnode1.get_gas_val(src) - gas.total() / capmult)
		calc_delta( src, gas, ngas, vnode1, delta_gt)
	else
		leak_to_turf(1)
	if(vnode2)
		delta_gt = FLOWFRAC * ( vnode2.get_gas_val(src) - gas.total() / capmult)
		calc_delta( src, gas, ngas, vnode2, delta_gt)
	else
		leak_to_turf(2)
	if(vnode3)
		delta_gt = FLOWFRAC * ( vnode3.get_gas_val(src) - f_gas.total() / capmult)
		calc_delta( src, f_gas, f_ngas, vnode3, delta_gt)
	else
		leak_to_turf(3)

	// transfer gas from ngas->f_ngas according to extraction rate, but only if we have power
	if(! (stat & NOPOWER) )
		var/datum/substance/gas/ndelta = src.get_extract()
		ngas.sub_delta(ndelta)
		f_ngas.add_delta(ndelta)

/obj/machinery/pipefilter/get_gas_val(from)
	return ((from == vnode3) ? f_gas.total() : gas.total())/capmult

/obj/machinery/pipefilter/get_gas(from)
	return (from == vnode3) ? f_gas : gas

/obj/machinery/pipefilter/proc/leak_to_turf(var/port)
	var/turf/T

	switch(port)
		if(1)
			T = get_step(src, n1dir)
		if(2)
			T = get_step(src, n2dir)
		if(3)
			T = get_step(src, dir)
			if(T.density)
				T = src.loc
				if(T.density)
					return
			flow_to_turf(f_gas, f_ngas, T)
			return

	if(T.density)
		T = src.loc
		if(T.density)
			return

	flow_to_turf(gas, ngas, T)

/obj/machinery/pipefilter/proc/get_extract()
	var/datum/substance/gas/ndelta = new()
	if(src.f_mask & GAS_O2)
		ndelta.oxygen = min(src.f_per, src.ngas.oxygen)
	if(src.f_mask & GAS_N2)
		ndelta.nitrogen = min(src.f_per, src.ngas.nitrogen)
	if(src.f_mask & GAS_PL)
		ndelta.plasma = min(src.f_per, src.ngas.plasma)
	if(src.f_mask & GAS_CO2)
		ndelta.co2 = min(src.f_per, src.ngas.co2)
	if(src.f_mask & GAS_N2O)
		ndelta.no2 = min(src.f_per, src.ngas.no2)
	return ndelta

// pipefilter interact/topic
/obj/machinery/pipefilter/interact(mob/user as mob)
	var/list/gases = list("O2", "N2", "Plasma", "CO2", "N2O")
	user.machine = src
	var/dat = "Filter Extraction Rate:<BR>\n<A href='?src=\ref[src];fp=-[num2text(1000000.0, 7)]'>M</A> <A href='?src=\ref[src];fp=-10000'>-</A> <A href='?src=\ref[src];fp=-1000'>-</A> <A href='?src=\ref[src];fp=-100'>-</A> <A href='?src=\ref[src];fp=-1'>-</A> [src.f_per] <A href='?src=\ref[src];fp=1'>+</A> <A href='?src=\ref[src];fp=100'>+</A> <A href='?src=\ref[src];fp=1000'>+</A> <A href='?src=\ref[src];fp=10000'>+</A> <A href='?src=\ref[src];fp=[num2text(1000000.0, 7)]'>M</A><BR>\n"
	for (var/i = 1; i <= gases.len; i++)
		dat += "[gases[i]]: <A HREF='?src=\ref[src];tg=[1 << (i - 1)]'>[(src.f_mask & 1 << (i - 1)) ? "Extracting" : "Passing"]</A><BR>\n"
	dat += "<A HREF='?src=\ref[src];mach_close=pipefilter'>Close</A><BR><BR>"
	ss13_browse(user, dat, "window=pipefilter;size=600x300;can_close=0")

/obj/machinery/pipefilter/Topic(href, href_list)
	..()
	if (!usr.can_use_hands())
		return
	if (((get_dist(src, usr) <= 1 || istype(usr, /mob/silicon/ai)) && istype(src.loc, /turf)))
		usr.machine = src
		if (src.allowed(usr))
			if (href_list["fp"])
				src.f_per = min(max(round(src.f_per + text2num(href_list["fp"])), 0), 1000000.0)
			else if (href_list["tg"])
				// toggle gas
				src.f_mask ^= text2num(href_list["tg"])
				src.updateicon()
		else
			usr.see("\red Access Denied- Pipe Filter operation restricted to authorized atmospheric technicians.")
		src.updateUsrDialog()
		src.add_fingerprint(usr)
	else
		ss13_browse(usr, null, "window=pipefilter")

/obj/machinery/pipefilter/power_change()
	..()
	updateicon()

/obj/machinery/pipefilter/proc/updateicon()
	src.overlays = null
	if(stat & NOPOWER)
		icon_state = "filter-off"
	else
		icon_state = "filter"
		if (src.f_mask & (GAS_N2O|GAS_PL))
			src.overlays += image('pipes2.dmi', "filter-tox")
		if (src.f_mask & GAS_O2)
			src.overlays += image('pipes2.dmi', "filter-o2")
		if (src.f_mask & GAS_N2)
			src.overlays += image('pipes2.dmi', "filter-n2")
		if (src.f_mask & GAS_CO2)
			src.overlays += image('pipes2.dmi', "filter-co2")
