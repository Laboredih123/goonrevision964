// return a list of pipes (not including terminating machine)
/proc/pipelist(var/obj/machinery/source, var/obj/machinery/startnode)

	var/list/L = list()

	var/obj/machinery/node = startnode
	var/obj/machinery/prev = source
	var/obj/machinery/newnode

	while(node)
		L += node
		newnode = node.next(prev)
		prev = node

		if(newnode && newnode.ispipe())
			node = newnode
		else
			break

	return L

// flip the nodes of a pipe
/obj/machinery/pipes/proc/flip()
	var/obj/machinery/tempnode = node1
	node1 = node2
	node2 = tempnode

// return the next pipe in the node chain
/obj/machinery/pipes/next(var/obj/machinery/from)
	if(!from)
		if(node1 && node1.ispipe())	return node1
		if(node2 && node2.ispipe()) return node2
		return null
	if(from == node1) return node2
	if(from == node2) return node1
	return null

// set the pipeline obj from the pl-number and global list of pipelines
/obj/machinery/pipes/setline()
	src.pl = plines[plnum]
	return

// returns the pipeline that this line is in

/obj/machinery/pipes/getline()
	return pl

/obj/machinery/pipes/orient_pipe(P as obj)

	if (!( src.node1 ))
		src.node1 = P
	else
		if (!( src.node2 ))
			src.node2 = P
		else
			return 0
	return 1

// returns a list of dir1, dir2 & p_dir for a pipe

/obj/machinery/pipes/proc/get_dirs()
	var/b1
	var/b2

	for(var/d in cardinal)
		if(p_dir & d)
			if(!b1)
				b1 = d
			else if(!b2)
				b2 = d

	return list(b1, b2, p_dir)

// returns a list of the directions of a pipe, matched to nodes (if present)

/obj/machinery/pipes/proc/get_node_dirs()
	var/list/dirs = get_dirs()


	if(!node1 && !node2)		// no nodes - just return the standard dirs
		return dirs				// note extra p_dir on end of list is unimportant
	else
		if(node1)
			var/d1 = get_dir(src, node1)		// find the direction of node1
			if(d1==dirs[1])						// if it matches
				return dirs						// then dirs list is correct
			else
				return list(dirs[2], dirs[1])	// otherwise return the list swapped

		else		// node2 must be valid
			var/d2 = get_dir(src, node2)		// direction of node2
			if(d2==dirs[2])						// matches
				return dirs						// dirs list is correct
			else
				return list(dirs[2], dirs[1])	// otherwise swap order


/obj/machinery/pipes/proc/update()

	var/turf/T = src.loc

	var/list/dirs = get_dirs()

	var/is = "[dirs[3]]"

	if(stat & BROKEN)
		is += "-b"

	if ((src.level == 1 && isturf(src.loc) && T.intact))
		src.invisibility = 101
		is += "-f"

	else
		src.invisibility = null

	src.icon_state = is

	if(node1 && node2)
		overlays = null
	else if(!node1 && !node2)
		overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[1])
		overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[2])
	else if(!node1)
		var/d2 = get_dir(src, node2)
		if(dirs[1] == d2)
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[2])
		else
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[1])
	else if(!node2)
		var/d1 = get_dir(src, node1)
		if(dirs[1] == d1)
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[2])
		else
			overlays += image('pipes.dmi', "discon", FLY_LAYER, dirs[1])


	return

/obj/machinery/pipes/hide(var/i)

	update()

/obj/machinery/pipes/proc/explode()

	//*****
	return

/obj/machinery/pipes/New()

	..()

	if(istype(src, /obj/machinery/pipes/heat_exch))
		h_dir = text2num(icon_state)
	else
		p_dir = text2num(icon_state)


/obj/machinery/pipes/ispipe()		// return true since this is a pipe
	return 1

/obj/machinery/pipes/buildnodes(var/linenum)

	if(plnum)
		return

	var/list/dirs = get_dirs()

	node1 = get_machine(level, src.loc, dirs[1])
	node2 = get_machine(level, src.loc, dirs[2])

	update()

	plnum = linenum

	termination = 0

	if(node1 && node1.ispipe() )

		node1.buildnodes(linenum)
	else
		termination++

	if(node2 && node2.ispipe() )
		node2.buildnodes(linenum)
	else
		termination++

// amount of gas that can be received = pipe capacity - amount already present
/*
/obj/machinery/pipes/receive_amount()
	if(gas)
		return max(0, capacity - gas.total())
	return 0

/obj/machinery/pipes/receive_gas(var/datum/substance/gas/t_gas as obj, from as obj, amount)
	//new pipe logic
	// src receives (up to) 'amount' of gas 't_gas' from 'from'
	// uses receive_amount to find actual amount of gas to transfer
	// note any excess must bem left in from.gas - need t_gas = from.gas


	amount = max(0, min( amount, src.receive_amount(src) ))	// limit amount of gas transfered to that able to receive

	gas.transfer_from(t_gas, amount)	// transfer from incoming gas to local gas reservoir. Remainder left in t_gas

	var/tot = gas.total() // total amount of gas now in reservoir

	var/turf/T = src.loc		// turf location of pipe

	if( level != 1)				// no heat exchange for under-floor pipes
		if(istype(T,/turf/space))		// heat exchange less efficient in space (no conduction)
			gas.temp += ( T.temp - gas.temp) / (3.0 * insulation)
		else
			var/delta_T = (T.temp - gas.temp) / insulation	// normal turf
			gas.temp += delta_T // heat the pipe due to turf temperature

			T.temp -= delta_T*tot/T.total() // also heat the turf due to pipe temp

	last_flow = amount		// for metering of flow rate

	spawn( 2 )

		if (from == src.node1)		// recieved from node1
			spawn( 0 )
				if(node2)
					src.node2.receive_gas(gas, src, tot*PIPEFRAC)	// so forward to node2, if present
				else
					src.leak_to_turf()		// otherwise leak
				return
		else
			spawn( 0 )
				if(node1)
					src.node1.receive_gas(gas, src, tot*PIPEFRAC)
				else
					src.explode()
				return

	return


*/

/proc/calc_delta(obj/machinery/source, datum/substance/gas/sgas, datum/substance/gas/sngas, obj/machinery/target, amount, dbg=0)
	var/datum/substance/gas/tgas = target.get_gas(source)
	var/datum/substance/gas/ndelta = new()

	if(amount < 0)							// flowing from source to target
		var/sTotal = sgas.total()
		if(!sTotal) return
		ndelta.copy_all(sgas)
		ndelta.multiply_gas(-amount/sTotal) // this is fraction of the gas which will be transfered to other node
		sngas.sub_delta(ndelta)				// subtract off the fraction which is gone
	else									// flowing from target to source
		var/tTotal = tgas.total()
		if(!tTotal) return
		ndelta.copy_all(tgas)
		ndelta.multiply_gas(amount/tTotal)	// fraction of gas from the other node
		sngas.add_delta(ndelta)				// add the fraction to the new gas resv

// standard proc for all machines - passed gas/ngas as arguments
// equilibrate a pipe object and a turf's gas content

/obj/machinery/proc/flow_to_turf(var/datum/substance/gas/sgas, var/datum/substance/gas/sngas, var/turf/T, var/dbg = 0)

	if(dbg) world.log << "FTT: G=[sgas.tostring()] ~ N=[sngas.tostring()]"
	if(dbg) world.log << "T=[T.tostring()]"

	var/t_tot = T.gas.total() * 0.2		// partial pressure of turf gas at pipe, for the moment
	var/delta_gt = FLOWFRAC * ( t_tot - sgas.total() / capmult )

	if(dbg) world.log << "FTT: dgt=[delta_gt]"

	var/datum/substance/gas/ndelta = new()

	if(delta_gt < 0)	// flow from pipe to turf
		var/sTotal = sgas.total()
		if(!sTotal)
			return
		ndelta.copy_gas(sgas)
		ndelta.multiply_gas(-delta_gt/sTotal)		// ndelta contains gas to transfer to turf
		sngas.sub_delta(ndelta)			// update new gas to remove the amount transfered
		ndelta.turf_add(T, -1)			// add all of ndelta to turf
	else
		sngas.turf_take(T,delta_gt)			// flow from turf to pipe

	T.reset_phases()	// update turf gas vars for both cases

/turf/proc/tostring()
	return src.gas.tostring()
