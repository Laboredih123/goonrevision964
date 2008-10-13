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

/obj/machinery/pipes/proc/heat_exchange(var/datum/substance/gas/ngas, var/tot_node, var/numnodes)
	var/total = ngas.total()
	if(!total) return
	var/turf/T = src.loc		// turf location of pipe
	if(T.density) return
	ASSERT(numnodes)
	ASSERT(insulation)

	// pipes radiate energy in space
	if(istype(T,/turf/space))
		var/radiation = (ngas.temp ** 4) - (TCMB ** 4)
		radiation *= 5.6703e-8	//	Stefen Boltzman constant
		radiation *= 0.97		//	emissivity of our future oxidized Ni/Cr/Fe pipe
		radiation *= 3.14*3		//	surface area of the pipe (1ft diameter, 3 ft long)
		ngas.temp -= (radiation * numnodes) / total
		T.reset_phases()
		return

	if(src.level == 1) return	// no heat exchange for under-floor pipes
	var/delta_T = (T.gas.temp - ngas.temp) / (insulation)
	ngas.temp += delta_T	/ numnodes

	var/tot_turf = max(1, T.gas.total());
	T.gas.temp -= delta_T*min(10,tot_node/tot_turf)		// also heat the turf due to pipe temp
	// should clamp max temp change to prevent thermal runaway if low amount of gas in turf

	T.reset_phases()

/obj/machinery/pipes/heat_exch/update()
	var/turf/T = src.loc
	var/list/dirs = get_dirs()
	var/is = "[dirs[3]]"
	if(stat & BROKEN)	is += "-b"

	if ((src.level == 1 && isturf(src.loc) && T.intact))
		src.invisibility = 101
		is += "-f"
	else
		src.invisibility = null

	src.icon_state = is

