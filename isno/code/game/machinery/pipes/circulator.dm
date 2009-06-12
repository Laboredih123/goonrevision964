// finds the machine with compatible p_dir in 1 step in dir from S
/proc/get_machine(var/level, var/turf/S, mdir)

	var/flip = turn(mdir, 180)

	var/turf/T = get_step(S, mdir)

	for(var/obj/machinery/M in T.contents)
		if(M.level == level)
			if(M.p_dir & flip)
				return M

	return null

// finds the machine with compatible h_dir in 1 step in dir from S
/proc/get_he_machine(var/level, var/turf/S, mdir)

	var/flip = turn(mdir, 180)

	var/turf/T = get_step(S, mdir)

	for(var/obj/machinery/M in T.contents)
		if(M.level == level)
			if(M.h_dir & flip)
				return M

	return null




// ***** circulator

/obj/machinery/circulator/New()
	..()
	gas1 = new/datum/substance/gas(src)
	gas1.maximum = capacity
	gas2 = new/datum/substance/gas(src)
	gas2.maximum = capacity

	ngas1 = new/datum/substance/gas()
	ngas2 = new/datum/substance/gas()

	gasflowlist += src

	//gas.co2 = capacity

	updateicon()

/obj/machinery/circulator/buildnodes()

	var/turf/TS = get_step(src, SOUTH)
	var/turf/TN = get_step(src, NORTH)

	for(var/obj/machinery/M in TS)

		if(M && (M.p_dir & 1))
			node1 = M
			break

	for(var/obj/machinery/M in TN)

		if(M && (M.p_dir & 2))
			node2 = M
			break


	if(node1) vnode1 = node1.getline()

	if(node2) vnode2 = node2.getline()


/*
/obj/machinery/circulator/verb/toggle_power()
	set src in view(1)

	if(status == 1)
		status = 2
		spawn(30)				// 3 second delay for slow-off
			if(status == 2)
				status = 0
				updateicon()
	else if(status == 0)
		status =1

	updateicon()



/obj/machinery/circulator/verb/set_rate(r as num)
	set src in view(1)
	rate = r/100.0*capacity
*/

/obj/machinery/circulator/proc/control(var/on, var/prate)

	rate = prate/100*capacity

	if(status == 1)
		if(!on)
			status = 2
			spawn(30)
				if(status == 2)
					status = 0
					updateicon()
	else if(status == 0)
		if(on)
			status = 1
	else	// status ==2
		if(on)
			status = 1

	updateicon()


/obj/machinery/circulator/proc/updateicon()

	if(stat & NOPOWER)
		icon_state = "circ[side]-p"
		return

	var/is
	switch(status)
		if(0)
			is = "off"
		if(1)
			is = "run"
		if(2)
			is = "slow"

	icon_state = "circ[side]-[is]"



/obj/machinery/circulator/power_change()
	..()
	updateicon()

/*
/obj/machinery/circulator/receive_gas(var/datum/substance/gas/t_gas as obj, from as obj, amount)


	if(from != src.node1)
		return

	amount = min(receive_amount(src), amount)


	//src.gas.transfer_from(t_gas, amount)

	return
*/
/obj/machinery/circulator/gas_flow()

	gas1.replace_by(ngas1)
	gas2.replace_by(ngas2)

/obj/machinery/circulator/process()

	// if operating, pump from resv1 to resv2

	if(! (stat & NOPOWER) )				// only do circulator step if powered; still do rest of gas flow at all times
		if(status==1 || status==2)
			gas2.transfer_from(gas1, status==1? rate : rate/2)
			use_power(rate/capacity * 100)
		ngas1.replace_by(gas1)
		ngas2.replace_by(gas2)


	// now do standard process

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


/obj/machinery/circulator/proc/leak_to_turf(var/port)

	var/turf/T

	switch(port)
		if(1)
			T = get_step(src, SOUTH)
		if(2)
			T = get_step(src, NORTH)

	if(T.density)
		T = src.loc
		if(T.density)
			return

	switch(port)
		if(1)
			flow_to_turf(gas1, ngas1, T)
		if(2)
			flow_to_turf(gas2, ngas2, T)


	// do leak

/obj/machinery/circulator/get_gas_val(from)
	return ((from==vnode1)?gas1.total() : gas2.total()) / capmult
/obj/machinery/circulator/get_gas(from)
	return ((from==vnode1)?gas1 : gas2)