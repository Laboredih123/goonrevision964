// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network

/obj/machinery/power/apc
	name = "area power controller"
	icon_state = "apc0"
	anchored = 1
	var/area/area
	var/obj/item/weapon/cell/cell
	var/start_charge = 90				// initial cell charge %
	var/cell_type = 2500				// 0=no cell, 1=regular, 2=high-cap (x5) <- old, now it's just 0=no cell, otherwise dictate cellcapacity by changing this value. 1 used to be 1000, 2 was 2500
	var/opened = 0
	var/lighting = 3
	var/equipment = 3
	var/environ = 3
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/tdir = null
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_total = 0
	var/main_status = 0
	var/light_consumption = 0
	var/equip_consumption = 0
	var/environ_consumption = 0
	netnum = -1		// set so that APCs aren't found as powernet nodes
	req_access = list(access_apcs)
	luminosity = 2

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto

/obj/machinery/power/apc/updateUsrDialog()
	var/list/nearby = viewers(1, src)
	if (!(stat & BROKEN)) // unbroken
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				src.interact(M)
	if (istype(usr, /mob/silicon/ai))
		if (!(usr in nearby))
			if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
				src.interact(usr)

/obj/machinery/power/apc/updateDialog()
	if(!(stat & BROKEN)) // unbroken
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if (M.client && M.machine == src)
				src.interact(M)
	AutoUpdateAI(src)

/obj/machinery/power/apc/New()
	..()

	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area

	tdir = dir		// to fix Vars bug
	dir = SOUTH

	pixel_x = (tdir & 3)? 0 : (tdir == 4 ? 24 : -24)
	pixel_y = (tdir & 3)? (tdir ==1 ? 24 : -24) : 0

	// starts with power cell installed - cell(location,percent,maxcharge)
	if(cell_type)	src.cell = new/obj/item/weapon/cell(src,start_charge,cell_type)

	var/area/A = src.loc.loc

	if(isarea(A))
		src.area = A

	updateicon()

	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.dir = tdir
	terminal.master = src

	spawn(5)
		src.update()

/obj/machinery/power/apc/proc/surge(var/amount)
	if(amount < 10) return
	if(cell && amount < 0.01*cell.charge) return
	var/obj/effects/sparks/O = new /obj/effects/sparks(src.loc)
	O.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn(0) O.Life()
	set_broken()

/obj/machinery/power/apc/examine()
	set src in oview(1)
	if(stat & BROKEN) return
	if(!usr || !usr.is_active()) return
	usr << "A control terminal for the area electrical systems."
	if(opened)	usr << "The cover is open and the power cell is [ cell ? "installed" : "missing"]."
	else		usr << "The cover is closed."

// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/proc/updateicon()
	if(opened)
		icon_state = "[ cell ? "apc2" : "apc1" ]"		// if opened, show cell if it's inserted
		src.overlays = null								// also delete all overlays
		return

	icon_state = "apc0"
	// if closed, update overlays for channel status
	src.overlays = null
	overlays += image('power.dmi', "apcox-[locked]")	// 0=blue 1=red
	overlays += image('power.dmi', "apco3-[charging]") // 0=red, 1=yellow/black 2=green

	if(operating)
		overlays += image('power.dmi', "apco0-[equipment]")	// 0=red, 1=green, 2=blue
		overlays += image('power.dmi', "apco1-[lighting]")
		overlays += image('power.dmi', "apco2-[environ]")

//attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/machinery/power/apc/attackby(obj/item/weapon/W, mob/carbon/user)

	if(stat & BROKEN) return
	if(istype(user, /mob/silicon/ai))
		return src.interact(user)

	if(istype(W, /obj/item/weapon/screwdriver))	// screwdriver means open or close the cover
		if(opened)
			opened = 0
			updateicon()
		else
			if(coverlocked)
				user << "The cover is locked and cannot be opened."
			else
				opened = 1
				updateicon()

	else if(istype(W, /obj/item/weapon/cell) && opened)	// trying to put a cell inside
		if(cell)
			user << "There is a power cell already installed."
		else
			user.drop_item()
			W.loc = src
			cell = W
			user << "You insert the power cell."
			chargecount = 0

		updateicon()
	else if(istype(W, /obj/item/weapon/card/id))			// trying to unlock the interface with an ID card

		if(opened)
			user << "You must close the cover to swipe an ID card."
		else
			if(src.allowed(usr))
				locked = !locked
				user << "You [ locked ? "lock" : "unlock"] the APC interface."
				updateicon()
			else
				user << "\red Access denied."

	else if(istype(W, /obj/item/weapon/card/emag))		// trying to unlock with an emag card

		if(opened)
			user << "You must close the cover to swipe an ID card."
		else
			flick("apc-spark", src)
			sleep(6)
			if(prob(50))
				locked = !locked
				user << "You [ locked ? "lock" : "unlock"] the APC interface."
				updateicon()
			else
				user << "You fail to [ locked ? "unlock" : "lock"] the APC interface."
	else if(istype(W, /obj/item/weapon/wirecutters))
		if (opened)
			if (src.aidisabled)
				user << "You have reconnected the AI control wire in the APC interface."
				src.aidisabled = 0
			else
				user << "You have cut the AI control wire in the APC interface."
				src.aidisabled = 1
		else
			user << "You must open the cover first."

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/interact(mob/carbon/user)
	add_fingerprint(user)
	if(stat & BROKEN) return
	if(!opened || istype(user,/mob/silicon/ai))	return src.interaction(user)
	if(!cell) return
	user << "The power cell pops free of its casing"
	cell.loc = src.loc
	cell.updateicon()
	charging = 0
	src.cell = null
	src.updateicon()

/obj/machinery/power/apc/proc/interaction(mob/user)

	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/silicon/ai))
			user.machine = null
			ss13_browse(user, null, "window=apc")
			return
		else if (istype(user, /mob/silicon/ai) && src.aidisabled)
			user << "AI control for this APC interface has been disabled."
			ss13_browse(user, null, "window=apc")
			return

	user.machine = src
	var/t = "<TT><B>Area Power Controller</B> ([area.name])<HR>"

	if(locked && (!istype(user, /mob/silicon/ai)))
		t += "<I>(Swipe ID card to unlock inteface.)</I><BR>"
		t += "Main breaker : <B>[operating ? "On" : "Off"]</B><BR>"
		t += "External power : <B>[ main_status ? (main_status ==2 ? "<FONT COLOR=#004000>Good</FONT>" : "<FONT COLOR=#D09000>Low</FONT>") : "<FONT COLOR=#F00000>None</FONT>"]</B><BR>"
		t += "Power cell: <B>[cell ? "[round(cell.percent())]%" : "<FONT COLOR=red>Not connected.</FONT>"]</B>"
		if(cell)
			t += " ([charging ? ( charging == 1 ? "Charging" : "Fully charged" ) : "Not charging"])<BR>"
			t += "Cell charger: [!chargemode ? "Off" : (chargemode==1 ? "Auto" : "Manual: [chargecount]")]"

		t += "<BR><HR>Power channels<BR><PRE>"

		var/list/L = list ("Off","Off (Auto)", "On", "On (Auto)")

		t += "Equipment:    [add_lspace(lastused_equip, 6)] W : <B>[L[equipment+1]]</B><BR>"
		t += "Lighting:     [add_lspace(lastused_light, 6)] W : <B>[L[lighting+1]]</B><BR>"
		t += "Environmental:[add_lspace(lastused_environ, 6)] W : <B>[L[environ+1]]</B><BR>"

		t += "<BR>Total load: [lastused_light + lastused_equip + lastused_environ] W</PRE>"
		t += "<HR>Cover lock: <B>[coverlocked ? "Engaged" : "Disengaged"]</B>"

	else
		if (!istype(user, /mob/silicon/ai))
			t += "<I>(Swipe ID card to lock interface.)</I><BR>"
		t += "Main breaker: [operating ? "<B>On</B> <A href='?src=\ref[src];breaker=1'>Off</A>" : "<A href='?src=\ref[src];breaker=1'>On</A> <B>Off</B>" ]<BR>"
		t += "External power : <B>[ main_status ? (main_status ==2 ? "<FONT COLOR=#004000>Good</FONT>" : "<FONT COLOR=#D09000>Low</FONT>") : "<FONT COLOR=#F00000>None</FONT>"]</B><BR>"
		if(cell)
			t += "Power cell: <B>[round(cell.percent())]%</B>"
			t += " ([charging ? ( charging == 1 ? "Charging" : "Fully charged" ) : "Not charging"])<BR>"
			t += "Cell charger: "
			switch(chargemode)
				if(0) t += "<A href='?src=\ref[src];chargemode=1'>Off</A>"
				if(1) t += "<A href='?src=\ref[src];chargemode=2'>Auto</A>"
				if(2) t += "<A href='?src=\ref[src];chargemode=0'>Manual</A>: [rate_control(src,"recharge",chargecount,5,20)]"

		else
			t += "Power cell: <B><FONT COLOR=red>Not connected.</FONT></B>"

		t += "<BR><HR>Power channels<PRE>"


		t += "<BR>Equipment:    [add_lspace(lastused_equip, 6)] W : "
		switch(equipment)
			if(0)	t += "<B>Off</B> <A href='?src=\ref[src];eqp=2'>On</A> <A href='?src=\ref[src];eqp=3'>Auto</A>"
			if(1)	t += "<A href='?src=\ref[src];eqp=1'>Off</A> <A href='?src=\ref[src];eqp=2'>On</A> <B>Auto (Off)</B>"
			if(2)	t += "<A href='?src=\ref[src];eqp=1'>Off</A> <B>On</B> <A href='?src=\ref[src];eqp=3'>Auto</A>"
			if(3)	t += "<A href='?src=\ref[src];eqp=1'>Off</A> <A href='?src=\ref[src];eqp=2'>On</A> <B>Auto (On)</B>"

		t += "<BR>Lighting:     [add_lspace(lastused_light, 6)] W : "
		switch(lighting)
			if(0)	t += "<B>Off</B> <A href='?src=\ref[src];lgt=2'>On</A> <A href='?src=\ref[src];lgt=3'>Auto</A>"
			if(1)	t += "<A href='?src=\ref[src];lgt=1'>Off</A> <A href='?src=\ref[src];lgt=2'>On</A> <B>Auto (Off)</B>"
			if(2)	t += "<A href='?src=\ref[src];lgt=1'>Off</A> <B>On</B> <A href='?src=\ref[src];lgt=3'>Auto</A>"
			if(3)	t += "<A href='?src=\ref[src];lgt=1'>Off</A> <A href='?src=\ref[src];lgt=2'>On</A> <B>Auto (On)</B>"

		t += "<BR>Environmental:[add_lspace(lastused_environ, 6)] W : "
		switch(environ)
			if(0)	t += "<B>Off</B> <A href='?src=\ref[src];env=2'>On</A> <A href='?src=\ref[src];env=3'>Auto</A>"
			if(1)	t += "<A href='?src=\ref[src];env=1'>Off</A> <A href='?src=\ref[src];env=2'>On</A> <B>Auto (Off)</B>"
			if(2)	t += "<A href='?src=\ref[src];env=1'>Off</A> <B>On</B> <A href='?src=\ref[src];env=3'>Auto</A>"
			if(3)	t += "<A href='?src=\ref[src];env=1'>Off</A> <A href='?src=\ref[src];env=2'>On</A> <B>Auto (On)</B>"

		t += "<BR>Total load: [lastused_light + lastused_equip + lastused_environ] W</PRE>"
		t += "<HR>Cover lock: [coverlocked ? "<B><A href='?src=\ref[src];lock=1'>Engaged</A></B>" : "<B><A href='?src=\ref[src];lock=1'>Disengaged</A></B>"]"

	t += "<BR><A href='?src=\ref[src];close=1'>Close</A></TT>"
	ss13_browse(user, t, "window=apc")
	return

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(operating)
		area.power_light = (lighting > 1)
		area.power_equip = (equipment > 1)
		area.power_environ = (environ > 1)
	else
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0

	area.power_change()

/obj/machinery/power/apc/Topic(href, href_list)
	..()
	if(href_list["close"])
		ss13_browse(usr,null,"window=apc")
		usr.machine = null
		return

	if(stat & BROKEN)
		return 0
	if(!usr.can_use_hands())
		return 0
	if(!usr.check_intelligence())
		return 0

	if(!usr.contents.Find(src))
		if(!istype(usr, /mob/silicon/ai))
			if(!(istype(src.loc,/turf) || get_dist(src,usr)<=1))
				ss13_browse(usr, null, "window=apc")
				return 0

	usr.machine = src
	if(href_list["lock"]) coverlocked = !coverlocked
	else if(href_list["breaker"])
		operating = !operating
		src.update()
		updateicon()

	else if(href_list["cmode"])
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
			updateicon()

	else if(href_list["eqp"])
		var/val = text2num(href_list["eqp"])
		equipment = (val==1 ? 0 : val)
		updateicon()
		update()

	else if(href_list["lgt"])
		var/val = text2num(href_list["lgt"])
		lighting = (val==1 ? 0 : val)
		updateicon()
		update()
	else if(href_list["env"])
		var/val = text2num(href_list["env"])
		environ = (val==1 ? 0 :val)
		updateicon()
		update()
	else if(href_list["chargemode"]) chargemode = text2num(href_list["chargemode"])
	else if(href_list["recharge"])
		chargecount = dd_range(0,1000,chargecount+text2num(href_list["recharge"]))

	src.updateUsrDialog()

/obj/machinery/power/apc/surplus()
	return (!terminal ? 0 : terminal.surplus())

/obj/machinery/power/apc/add_load(var/amount)
	if(terminal && terminal.powernet)
		terminal.powernet.newload += amount

/obj/machinery/power/apc/avail()
	return (!terminal ? 0 : terminal.avail())

/obj/machinery/power/apc/process()
	if(stat & BROKEN)				return
	if(!area.requires_power)		return

	// off=0, off auto=1, on=2, on auto=3
	if(equipment > 1)	use_power(src.equip_consumption, EQUIP)
	if(lighting > 1)	use_power(src.light_consumption, LIGHT)
	if(environ > 1)		use_power(src.environ_consumption, ENVIRON)

	area.calc_lighting()

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())		main_status = 0
	else if(excess < 0)		main_status = 1
	else					main_status = 2

	var/perapc = 0
	if(terminal && terminal.powernet)
		perapc = terminal.powernet.perapc

	if(cell)	// draw power from cell as before
		var/cellused = cell.discharge(CELLRATE*lastused_total)
		if(excess > 0 || perapc > lastused_total)	// if power excess, or enough anyway, recharge the cell
			if(chargemode == 1)	cell.recharge(min(cell.maxcharge-cell.charge,cellused))
			if(chargemode == 2) cell.recharge(min(excess,chargecount))
			add_load(cellused/CELLRATE)		// add the load used to recharge the cell

		else		// no excess, and not enough per-apc
			if((cell.charge/CELLRATE+perapc) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?
				cell.recharge(CELLRATE * perapc)					// recharge with what we can
				add_load(perapc)									// so draw what we can from the grid
				charging = 0

			else	// not enough power available to run the last tick!
				charging = 0
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)

		// set channels depending on how much charge we have left

		if(cell.charge <= 0)					// zero charge, turn all off
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			area.poweralert(0, src)
		else if(cell.percent() < 15)			// <15%, turn off lighting & equipment
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			area.poweralert(0, src)
		else if(cell.percent() < 30)			// <30%, turn off equipment
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			area.poweralert(0, src)
		else									// otherwise all can be on
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			if(cell.percent() > 75)
				area.poweralert(1, src)

		// now trickle-charge the cell

		if(chargemode && charging == 1)
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is perapc share, capped to cell capacity, or % per second constant (Whichever is smallest)
				var/ch = min(perapc, (cell.maxcharge - cell.charge), (cell.maxcharge*CHARGELEVEL))
				cell.recharge(ch)
				add_load(ch)
			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so

		if(cell.percent() >= 100)	charging = 2

		switch(chargemode)
			if(0)	//	off
				charging = 0
				chargecount = 0
			if(1)	//	auto
				if(!charging)
					if(excess > cell.maxcharge*CHARGELEVEL)	chargecount++
					else									chargecount = 0
					if(chargecount == 10)
						chargecount = 0
						charging = 1
			if(2)	//	manual
				if(chargecount) charging = 1
				chargecount = min(excess,chargecount)

	else // no cell, switch everything off

		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		area.poweralert(0, src)

	// update icon & area power if anything changed

	if(last_lt != lighting || last_eq != equipment || last_en != environ || last_ch != charging)
		updateicon()
		update()

	src.updateDialog()

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff

/proc/autoset(var/val, var/on)

	if(on==0)
		if(val==2)			// if on, return off
			return 0
		else if(val==3)		// if auto-on, return auto-off
			return 1

	else if(on==1)
		if(val==1)			// if auto-off, return auto-on
			return 3

	else if(on==2)
		if(val==3)			// if auto-on, return auto-off
			return 1

	return val

// damage and destruction acts

/obj/machinery/power/apc/meteorhit(var/obj/O as obj)

	set_broken()
	return

/obj/machinery/power/apc/ex_act(severity)
	switch(severity)
		if(1)	del(src)
		if(2)	if(!prob(50)) return
		if(3)	if(!prob(25)) return
	set_broken()

/obj/machinery/power/apc/blob_act()
	if(prob(50)) set_broken()

/obj/machinery/power/apc/proc/set_broken()
	stat |= BROKEN
	icon_state = "apc-b"
	overlays = null

	operating = 0
	update()