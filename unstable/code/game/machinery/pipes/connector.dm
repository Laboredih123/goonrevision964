/obj/machinery/connector/New()

	..()

	gas = new/datum/substance/gas(src)
	gas.maximum = capacity
	ngas = new/datum/substance/gas()
	//agas = new/datum/substance/gas()

	gasflowlist += src
	spawn(5)
		var/obj/machinery/atmoalter/A = locate(/obj/machinery/atmoalter, src.loc)

		if(A && A.c_status != 0)
			connected = A
			A.anchored = 1



/obj/machinery/connector/buildnodes()

	var/turf/T = get_step(src.loc, src.dir)
	var/fdir = turn(src.p_dir, 180)

	for(var/obj/machinery/M in T)
		if(M.p_dir & fdir)
			src.node = M
			break

	if(node) vnode = node.getline()


	return



/obj/machinery/connector/examine()
	set src in oview(1)
	..()
	if(connected)
		usr << "It is connected to \an [connected.name]."
	else
		usr << "It is unconnected."


/obj/machinery/connector/get_gas_val(from)
	return gas.total()/capmult
/obj/machinery/connector/get_gas(from)
	return gas


/obj/machinery/connector/gas_flow()

//	var/dbg = (suffix == "d") && Debug
	//if(dbg) world.log << "CF0: ngas=[ngas.total()]"

	//ngas.transfer_from(agas, -1)

	//if(dbg)	world.log << "CF1: ngas=[gas.total()]"
	gas.replace_by(ngas)
	//if(dbg)	world.log << "CF2: gas=[gas.total()]"
	flag = 0

/obj/machinery/connector/process()

	//if(suffix=="dbgp")
	//	world.log << "CP"
	//	Plasma()

	var/delta_gt
//	var/dbg = (suffix == "d") && Debug

	//if(dbg) world.log << "C[tag]P: [gas.total()] ~ [ngas.total()]"
	//if(dbg && connected) world.log << "C[tag]PC: [connected.gas.total()]"

	if(vnode)

		delta_gt = FLOWFRAC * ( vnode.get_gas_val(src) - gas.total() / capmult)
		//if(dbg) world.log << "C[tag]P0: [delta_gt]"

		//var/datum/substance/gas/vgas = vnode.get_gas(src)

		//if(dbg) world.log << "C[tag]P1: [gas.total()], [ngas.total()] -> [vgas.total()]"
		calc_delta( src, gas, ngas, vnode, delta_gt)//, dbg)
		//if(dbg) world.log << "C[tag]P2: [gas.total()], [ngas.total()] -> [vgas.total()]"

	else
		leak_to_turf()

	if(connected)
		var/amount
		if(connected.c_status == 1)				// canister set to release

			//if(dbg) world.log << "C[tag]PC1: [gas.total()], [ngas.total()] <- [connected.gas.total()]"
			amount = min(connected.c_per, capacity - gas.total() )	// limit to space in connector
			amount = max(0, min(amount, connected.gas.total() ) )		// limit to amount in canister, or 0
			//if(dbg) world.log << "C[tag]PC2: a=[amount]"
			//var/ng = ngas.total()
			ngas.transfer_from( connected.gas, amount)
			//if(dbg) world.log <<"[ngas.total()-ng] from siph to connector"
			//if(dbg) world.log << "C[tag]PC3: [gas.total()], [ngas.total()] <- [connected.gas.total()]"
		else if(connected.c_status == 2)		// canister set to accept

			amount = min(connected.c_per, connected.gas.maximum - connected.gas.total())	//limit to space in canister
			amount = max(0, min(amount, gas.total() ) )				// limit to amount in connector, or 0

			connected.gas.transfer_from( ngas, amount)

	//flag = 1

	//if(suffix=="dbgp")
	//	world.log << "CP"
	//	Plasma()




/obj/machinery/connector/proc/leak_to_turf()

	//var/dbg = (tag == "dbg") && Debug

	var/turf/T = get_step(src, dir)
	if(T && !T.density)

		//if(dbg) world.log << "CLT1: [gas.tostring()] ~ [ngas.tostring()]\nTg = [T.tostring()]"


		flow_to_turf(gas, ngas, T)

		//if(dbg) world.log << "CLT2: [gas.tostring()] ~ [ngas.tostring()]\nTg = [T.tostring()]"