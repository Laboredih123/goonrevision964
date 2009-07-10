/obj/machinery/pipeline/New()
	..()
	gas = new/datum/substance/gas(src)
	ngas = new/datum/substance/gas()
	gasflowlist += src

// find the pipeline that contains the /obj/machine (including pipe)
/proc/findline(var/obj/machinery/M)
	for(var/obj/machinery/pipeline/P in plines)
		for(var/obj/machinery/O in P.nodes)
			if(M==O) return P
	return null

// sets the vnode1&2 terminators to the joining machines (or null)
/obj/machinery/pipeline/proc/setterm()
	var/obj/machinery/M = null
	for(var/obj/machinery/pipes/P in nodes)
		if(!M)	if(P.node1 && P.node1.ispipe())	P.flip()	// flip if node1 is a pipe
		else	if(P.node1 != M)				P.flip()	// (including if it is null)
		M = P

	// pipes are now ordered so that n1/n2 is in same order as pipeline list
	var/obj/machinery/pipes/P = nodes[1]		// 1st node in list
	vnode1 = P.node1							// n1 points to 1st machine
	P = nodes[nodes.len]						// last node in list
	vnode2 = P.node2							// n2 points to last machine

/obj/machinery/pipeline/get_gas_val(from)	{	return gas.total()/capmult		}
/obj/machinery/pipeline/get_gas(from)		{	return gas						}
/obj/machinery/pipeline/gas_flow()			{	gas.replace_by(ngas)			}

/obj/machinery/pipeline/process()
	var/tot_node = ngas.total() / numnodes

	if(tot_node>0.1)		// no pipe contents, don't heat
		for(var/obj/machinery/pipes/P in src.nodes)		// for each segment of pipe
			P.heat_exchange(ngas, tot_node, numnodes) //, dbg)	// exchange heat with its turf

	var/delta_gt
	if(!vnode1) leak_to_turf(1)
	else
		delta_gt = FLOWFRAC * (vnode1.get_gas_val(src) - gas.total() / capmult)
		calc_delta(src, gas, ngas, vnode1, delta_gt)//, dbg)
		flow = delta_gt

	if(!vnode2) leak_to_turf(2)
	else
		delta_gt = FLOWFRAC * (vnode2.get_gas_val(src) - gas.total() / capmult)
		calc_delta(src, gas, ngas, vnode2, delta_gt)//, dbg)
		flow -= delta_gt

/obj/machinery/pipeline/proc/leak_to_turf(var/port)

	var/turf/T
	var/obj/machinery/pipes/P
	var/list/ndirs

	switch(port)
		if(1)
			P = nodes[1]		// 1st node in list
			if(!P) T = src.loc
			else
				ndirs = P.get_node_dirs()
				T = get_step(P, ndirs[1])

		if(2)
			P = nodes[nodes.len]	// last node in list
			if(!P) T = src.loc
			else
				ndirs = P.get_node_dirs()
				T = get_step(P, ndirs[2])
	if(!T)	return
	if(T.density)	return
	flow_to_turf(gas, ngas, T)

// build the pipelines
/proc/makepipelines()
	var/linecount = 0		// the line number
	for(var/obj/machinery/pipes/P in machines)		// look for a pipe
		if(!P.plnum) P.buildnodes(++linecount)
	for(var/L = 1 to linecount)					// for count of lines found
		var/obj/machinery/pipeline/PL = new()	// make a pipeline virtual object
		PL.name = "pipeline #[L]"
		plines += PL							// and add it to the list

	for(var/obj/machinery/pipes/P in machines)		// look for pipes
		if(P.termination)						// true if pipe is terminated (ends in blank or a machine)
			var/obj/machinery/pipeline/PL = plines[P.plnum]		// get the pipeline from the pipe's pl-number

			var/list/pipes = pipelist(null, P)	// get a list of pipes from P until terminated

			PL.nodes = pipes					// pipeline is this list of nodes
			PL.numnodes = pipes.len				// with this many nodes
			PL.capmult = PL.numnodes+1	// with this flow multiplier

	for(var/obj/machinery/pipes/P in machines)			// all pipes
		P.setline()										// 	set the pipeline object for this pipe
		if(P.tag == "dbg")	P.pl.tag = "dbg"			//add debug tag to line containing debug pipe
		if(P.suffix == "dbgpp")	P.pl.suffix = "dbgp"	//add debug tag to line containing debug pipe
		if(P.suffix == "d")	P.pl.suffix = "d"			//add debug tag to line containing debug pipe

	for(var/obj/machinery/M in machines)			// for all machines
		if(M.p_dir)								// which are pipe-connected
			if(!M.ispipe())						// is not a pipe itself
				M.buildnodes()					// build the nodes, setting the links to the virtual pipelines
												// also sets the vnodes for the pipelines

	for(var/obj/machinery/pipeline/PL in plines)	// for all lines
		PL.setterm()								// orient the pipes and set the pipeline vnodes to the terminating machines