/obj/machinery/vent/New()
	..()
	p_dir = dir
	gas = new/datum/substance/gas(src)
	gas.maximum = capacity
	ngas = new/datum/substance/gas()
	gasflowlist += src


/obj/machinery/vent/buildnodes()

	var/turf/T = get_step(src.loc, src.dir)
	var/fdir = turn(src.p_dir, 180)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node) vnode = node.getline()

	return


/obj/machinery/vent/get_gas_val(from)
	return gas.total()/2
/obj/machinery/vent/get_gas(from)
	return gas


/obj/machinery/vent/gas_flow()

//	var/dbg = (suffix=="d") && Debug
	//if(dbg) world.log << "V[tag]F1: [gas.total()] ~ [ngas.total()]"
	gas.replace_by(ngas)
	//if(dbg) world.log << "V[tag]F2: [gas.total()] ~ [ngas.total()]"

/obj/machinery/vent/process()


//	var/dbg = (suffix=="d") && Debug
	//if(dbg)	world.log << "V[tag]T1: [gas.total()] ~ [ngas.total()]"

	//if(suffix=="dbgp")
	//	world.log << "VP"
	//	Plasma()

	var/delta_gt

	var/turf/T = src.loc

	delta_gt = FLOWFRAC * (gas.total() / capmult)
	//var/ng = ngas.total()
	ngas.turf_add(T, delta_gt)

	//if(dbg) world.log << "[num2text(ng-ngas.total(),10)] from vent to turf"
	//if(dbg)	world.log << "V[tag]T2: [gas.total()] ~ [ngas.total()]"

	if(vnode)

		//if(dbg)	world.log << "V[tag]N1: [gas.total()] ~ [ngas.total()]"

		delta_gt = FLOWFRAC * ( vnode.get_gas_val(src) - gas.total() / capmult)

		calc_delta( src, gas, ngas, vnode, delta_gt)//, dbg)

		//if(dbg)	world.log << "V[tag]N2: [gas.total()] ~ [ngas.total()]"

	else
		leak_to_turf()



/obj/machinery/vent/proc/leak_to_turf()
// note this is a leak from the node, not the vent itself
// thus acts as a link between the vent turf and the turf in step(dir)

	var/turf/T = get_step(src, dir)
	if(T && !T.density)
		flow_to_turf(gas, ngas, T)


// inlet - equilibrates between pipe contents and turf
// very similar to vent, except that a vent always dumps pipe gas into turf
/obj/machinery/inlet/New()

	..()

	p_dir = dir
	gas = new/datum/substance/gas(src)
	gas.maximum = capacity
	ngas = new/datum/substance/gas()
	gasflowlist += src


/obj/machinery/inlet/buildnodes()

	var/turf/T = get_step(src.loc, src.dir)
	var/fdir = turn(src.p_dir, 180)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node) vnode = node.getline()

	return


/obj/machinery/inlet/get_gas_val(from)
	return gas.total()/2
/obj/machinery/inlet/get_gas(from)
	return gas


/obj/machinery/inlet/gas_flow()

	var/dbg = (suffix=="d") && Debug
	if(dbg) world.log << "I[tag]F1: [gas.total()] ~ [ngas.total()]"
	gas.replace_by(ngas)
	if(dbg) world.log << "I[tag]F2: [gas.total()] ~ [ngas.total()]"

/obj/machinery/inlet/process()


	var/dbg = (suffix=="d") && Debug
	if(dbg)	world.log << "I[tag]T1: [gas.total()] ~ [ngas.total()]"

	//if(suffix=="dbgp")
	//	world.log << "VP"
	//	Plasma()

	var/delta_gt

	var/turf/T = src.loc

	// this is the difference between vent and inlet

	if(T && !T.density)
		flow_to_turf(gas, ngas, T, dbg)		// act as gas leak

	if(dbg)	world.log << "I[tag]T2: [gas.total()] ~ [ngas.total()]"

	if(vnode)

		//if(dbg)	world.log << "V[tag]N1: [gas.total()] ~ [ngas.total()]"

		delta_gt = FLOWFRAC * ( vnode.get_gas_val(src) - gas.total() / capmult)

		calc_delta( src, gas, ngas, vnode, delta_gt)//, dbg)

		//if(dbg)	world.log << "V[tag]N2: [gas.total()] ~ [ngas.total()]"

	else
		leak_to_turf()



/obj/machinery/inlet/proc/leak_to_turf()
// note this is a leak from the node, not the inlet itself
// thus acts as a link between the inlet turf and the turf in step(dir)

	var/turf/T = get_step(src, dir)
	if(T && !T.density)
		flow_to_turf(gas, ngas, T)