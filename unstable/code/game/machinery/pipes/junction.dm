/obj/machinery/junction/New()
	..()
	gas = new/datum/substance/gas(src)
	ngas = new/datum/substance/gas()
	gasflowlist += src
	p_dir = turn(dir, 180)		// the reg pipe is in opposite dir
	h_dir = dir					// the h/e pipe is in obj dir

/obj/machinery/junction/buildnodes()
	var/turf/T = src.loc
	node1 = get_he_machine(level, T, h_dir)	// the h/e pipe
	node2 = get_machine(level, T , p_dir)	// the regular pipe
	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()

/obj/machinery/junction/gas_flow()
	gas.replace_by(ngas)

/obj/machinery/junction/process()
	var/delta_gt

	if(!vnode1)	leak_to_turf(1)
	else
		delta_gt = FLOWFRAC * (vnode1.get_gas_val(src) - gas.total() / capmult)
		calc_delta(src, gas, ngas, vnode1, delta_gt)

	if(!vnode2) leak_to_turf(2)
	else
		delta_gt = FLOWFRAC * (vnode2.get_gas_val(src) - gas.total() / capmult)
		calc_delta(src, gas, ngas, vnode2, delta_gt)


/obj/machinery/junction/get_gas_val(from)	{	return gas.total()/capmult	}
/obj/machinery/junction/get_gas(from)		{	return gas					}

/obj/machinery/junction/proc/leak_to_turf(var/port)
	var/turf/T
	switch(port)
		if(1)	T = get_step(src, dir)
		if(2)	T = get_step(src, turn(dir, 180))
	if(T.density)
		T = src.loc
		if(T.density) return
	flow_to_turf(gas, ngas, T)
