/obj/machinery/pipes/heat_exch/get_dirs()
	var/b1
	var/b2
	for(var/sdir in cardinal)
		if(!(h_dir & sdir)) continue
		if(!b1)			b1 = sdir
		else if(!b2)	b2 = sdir
	return list(b1, b2, h_dir)

/obj/machinery/pipes/heat_exch/buildnodes(var/linenum)
	if(plnum) return
	src.level = 2		// h/e pipe cannot be put underfloor
	return ..()

/obj/machinery/pipes/proc/heat_exchange(var/datum/substance/gas/gas, var/tot_node, var/numnodes, var/temp, var/dbg=0)
	var/turf/T = src.loc		// turf location of pipe
	if(T.density) return
	ASSERT(numnodes)
	ASSERT(insulation)

	// heat exchange less efficient in space (no conduction)
	if(istype(T,/turf/space))
		gas.temp += (T.gas.temp - temp) / (3.0 * insulation * numnodes)
		return

	if(src.level == 1) return	// no heat exchange for under-floor pipes
	var/delta_T = (T.gas.temp - temp) / (insulation)
	gas.temp += delta_T	/ numnodes

	var/tot_turf = max(1, T.gas.total());
	T.gas.temp -= delta_T*min(10,tot_node/tot_turf)		// also heat the turf due to pipe temp
	// should clamp max temp change to prevent thermal runaway if low amount of gas in turf

	T.reset_phases()
