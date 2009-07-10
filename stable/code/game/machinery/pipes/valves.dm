// on-off valve
/obj/machinery/valve/New()
	..()
	gas1 = new/datum/substance/gas(src)
	ngas1 = new/datum/substance/gas()
	gas2 = new/datum/substance/gas(src)
	ngas2 = new/datum/substance/gas()

	gasflowlist += src
	switch(dir)
		if(1, 2)
			p_dir = 3
		if(4,8)
			p_dir = 12

/obj/machinery/valve/mvalve/New()
	..()
	icon_state = "valve[open]"

/obj/machinery/valve/dvalve/New()
	..()
	icon_state = "dvalve[open]"

/obj/machinery/valve/examine()
	set src in oview(1)

	usr << "[desc] It is [ open? "open" : "closed"]."


/obj/machinery/valve/buildnodes()

	var/turf/T = src.loc

	node1 = get_machine(level, T, dir )		// the h/e pipe

	node2 = get_machine(level, T , turn(dir, 180) )	// the regular pipe

	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()

	return

/obj/machinery/valve/gas_flow()

	gas1.replace_by(ngas1)
	gas2.replace_by(ngas2)

/obj/machinery/valve/process()

	var/delta_gt

	if(vnode1)
		delta_gt = FLOWFRAC * ( vnode1.get_gas_val(src) - gas1.total() / capmult)
		calc_delta( src, gas1, ngas1, vnode1, delta_gt)

	else
		leak_to_turf(1)

	if(vnode2)
		delta_gt = FLOWFRAC * ( vnode2.get_gas_val(src) - gas2.total() / capmult)
		calc_delta( src, gas2, ngas2, vnode2, delta_gt)

	else
		leak_to_turf(2)


	if(open)		// valve operating, so transfer btwen resv1 & 2

		delta_gt = FLOWFRAC * (gas1.total() / capmult - gas2.total() / capmult)

		var/datum/substance/gas/ndelta = new()

		if(delta_gt < 0)		// then flowing from R2 to R1
			var/gas2_total = gas2.total()
			if(!gas2_total)
				return
			ndelta.copy_gas(gas2)
			ndelta.multiply_gas(-delta_gt/gas2_total)

			ngas2.sub_delta(ndelta)
			ngas1.add_delta(ndelta)

		else				// flowing from R1 to R2
			var/gas1_total = gas1.total()
			if(!gas1_total)
				return
			ndelta.copy_gas(gas1)
			ndelta.multiply_gas(delta_gt/gas1_total)
			ngas2.add_delta(ndelta)
			ngas1.sub_delta(ndelta)

/obj/machinery/valve/get_gas_val(from)
	return ((from == vnode2) ? gas2.total() : gas1.total())/capmult
/obj/machinery/valve/get_gas(from)
	return ((from == vnode2) ? gas2 : gas1)

/obj/machinery/valve/proc/leak_to_turf(var/port)

	var/turf/T

	switch(port)
		if(1)
			T = get_step(src, dir)
		if(2)
			T = get_step(src, turn(dir, 180) )

	if(T.density)
		T = src.loc
		if(T.density)
			return

	if(port==1)
		flow_to_turf(gas1, ngas1, T)
	else
		flow_to_turf(gas2, ngas2, T)

/obj/machinery/valve/mvalve/interact(mob/user)
	..()
	add_fingerprint(user)

	if(!open)		// now opening
		flick("valve01", src)
		icon_state = "valve1"
		sleep(10)
	else			// now closing
		flick("valve10", src)
		icon_state = "valve0"
		sleep(10)
	open = !open

/obj/machinery/valve/dvalve/interact(mob/user)
	..()
	add_fingerprint(user)
	if(stat & NOPOWER) return

	if(!open)		// now opening
		flick("dvalve01", src)
		icon_state = "dvalve1"
		sleep(10)
	else			// now closing
		flick("dvalve10", src)
		icon_state = "dvalve0"
		sleep(10)
	open = !open

// one way pipe

/obj/machinery/oneway/New()
	..()
	gas1 = new/datum/substance/gas(src)
	ngas1 = new/datum/substance/gas()
	gas2 = new/datum/substance/gas(src)
	ngas2 = new/datum/substance/gas()

	gasflowlist += src
	p_dir = dir|turn(dir, 180)

/obj/machinery/oneway/buildnodes()
	var/turf/T = src.loc

	node1 = get_machine(level, T, dir )
	node2 = get_machine(level, T , turn(dir, 180) )

	if(node1) vnode1 = node1.getline()
	if(node2) vnode2 = node2.getline()

	return

/obj/machinery/oneway/gas_flow()
	gas1.replace_by(ngas1)
	gas2.replace_by(ngas2)

/obj/machinery/oneway/process()

	var/delta_gt

	if(vnode1)
		delta_gt = FLOWFRAC * ( vnode1.get_gas_val(src) - gas1.total() / capmult)
		calc_delta( src, gas1, ngas1, vnode1, delta_gt)

	else
		leak_to_turf(1)

	if(vnode2)
		delta_gt = FLOWFRAC * ( vnode2.get_gas_val(src) - gas2.total() / capmult)
		calc_delta( src, gas2, ngas2, vnode2, delta_gt)

	else
		leak_to_turf(2)


	delta_gt = FLOWFRAC * (gas1.total() / capmult - gas2.total() / capmult)
	var/datum/substance/gas/ndelta = new()
	var/gas2_total = gas2.total()
	if(!gas2_total) return

	if(delta_gt < 0)		// then flowing from R2 to R1
		ndelta.copy_gas(gas2)
		ndelta.multiply_gas(-delta_gt/gas2_total)
		ngas2.sub_delta(ndelta)
		ngas1.add_delta(ndelta)

/obj/machinery/oneway/get_gas_val(from)
	if(from == vnode2)
		return gas2.total()/capmult
	else
		return gas1.total()/capmult

/obj/machinery/oneway/get_gas(from)
	if(from == vnode2)
		return gas2
	return gas1

/obj/machinery/oneway/proc/leak_to_turf(var/port)
	var/turf/T

	switch(port)
		if(1)
			T = get_step(src, dir)
		if(2)
			T = get_step(src, turn(dir, 180) )

	if(T.density)
		T = src.loc
		if(T.density)
			return

	if(port==1)
		flow_to_turf(gas1, ngas1, T)
	else
		flow_to_turf(gas2, ngas2, T)

/obj/machinery/oneway/pipepump/process()

	if(! (stat & NOPOWER) )  // pump if power
		gas1.transfer_from(gas2, rate)
		use_power(rate/capacity * 1000, EQUIP)
		ngas1.replace_by(gas1)
		ngas2.replace_by(gas2)

	var/delta_gt

	if(vnode1)
		delta_gt = FLOWFRAC * ( vnode1.get_gas_val(src) - gas1.total() / capmult)
		calc_delta( src, gas1, ngas1, vnode1, delta_gt)

	else
		leak_to_turf(1)

	if(vnode2)
		delta_gt = FLOWFRAC * ( vnode2.get_gas_val(src) - gas2.total() / capmult)
		calc_delta( src, gas2, ngas2, vnode2, delta_gt)

	else
		leak_to_turf(2)

/obj/machinery/oneway/pipepump/proc/updateicon()
	icon_state = "pipepump-[(stat & NOPOWER) ? "stop" : "run"]"


/obj/machinery/oneway/pipepump/power_change()
	..()
	updateicon()
