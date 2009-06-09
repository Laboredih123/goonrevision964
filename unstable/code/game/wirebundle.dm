// Generic Wire Bundle
//
// Intended for airlocks, atmos panels, and the like. (things with lots of wires to cut)
// Supports up to 32 wires, using a selection of Crayola colors from 1949 (plus flesh, which kurper really wanted to add)

var/const/MAX_WIRES = 32

/datum/assembly/wirebundle
	var/list/wirecolors = list("Gold" = 1, "Blue" = 2, "Orange" = 3, "Violet" = 4, "Magenta" = 5, "Melon" = 6, "Flesh" = 7, "Maize" = 8, "Turquoise" = 9, "Periwinkle" = 10, "Brown" = 11, "Silver" = 12, "Plum" = 13, "Sepia" = 14, "Black" = 15, "Orchid" = 16, "Red" = 17, "Peach" = 18, "Salmon" = 19, "Goldenrod" = 20, "Apricot" = 21, "Tan" = 22, "White" = 23, "Lavender" = 24, "Copper" = 25, "Pink" = 26, "Aquamarine" = 27, "Yellow" = 28, "Green" = 29, "Maroon" = 30, "Mahogany" = 31, "Gray" = 32)

	var/numwires          = 0 // number of wires we have

	var/list/wirestatus   = list(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1) // 1 if cut

	var/list/wirenumtoidx = list(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) // 32 elements
	var/list/wireidxtonum = list(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

	var/obj/machinery/door/airlock/master        = null

	var/list/triggers[MAX_WIRES]

// initialize a new wirebundle
/datum/assembly/wirebundle/New(numwires = MAX_WIRES)
	if(numwires == 0)
		// attempting to clone...
		return
	// randomize the order
	for (var/i = 1, i <= MAX_WIRES, i++)
		var/valid = 0
		while(!valid)
			var/colorIndex = rand(1, MAX_WIRES)
			if(wirenumtoidx[colorIndex]==0)
				valid = 1
				wirenumtoidx[colorIndex] = i
				wireidxtonum[i] = colorIndex
	src.setwires(numwires)

/datum/assembly/wirebundle/proc/debug()
	// debugme

	world.log << variable(null, "wirestatus", wirestatus)
	world.log << variable(null, "wirenumtoidx", wirenumtoidx)
	world.log << variable(null, "wireidxtonum", wireidxtonum)

	// /debugme

// makes a copy of the wirebundle
/datum/assembly/wirebundle/proc/clone()
	var/datum/assembly/wirebundle/W = new(0)
	W.numwires = src.numwires
	W.wirestatus = src.wirestatus.Copy()
	W.wirenumtoidx = src.wirenumtoidx
	W.wireidxtonum = src.wireidxtonum

	return W

// set the maximum wires in this bundle (so we don't return too many)
// also initializes the wirestatus variable
/datum/assembly/wirebundle/proc/setwires(var/num_wires as num)
	src.numwires = num_wires
	for(var/i = 1; i <= numwires; i++)
		wirestatus[i] = 0

// cut and mend, accepts text, returns idx
/datum/assembly/wirebundle/proc/cut(var/wirenum as num)
	var/idx = src.wirenumtoidx[wirenum]
	wirestatus[idx] = 1
	return idx

/datum/assembly/wirebundle/proc/mend(var/wirenum as num)
	var/idx = src.wirenumtoidx[wirenum]
	wirestatus[idx] = 0
	return idx

// returns assoc list of wires and their cut status
/datum/assembly/wirebundle/proc/getwires()
	var/list/L = list()
	for(var/i = 1; i <= MAX_WIRES; i++)
		if(wirenumtoidx[i] <= src.numwires)
			L[src.wirecolors[i]] = i
	return L

/datum/assembly/wirebundle/proc/wirenumberiscut(var/wirenum as num)
	return src.wireidxiscut(src.wirenumtoidx[wirenum])

/datum/assembly/wirebundle/proc/wirecoloriscut(var/wirecolor as text)
	return src.wireidxiscut(wirecolortoidx(wirecolor))

/datum/assembly/wirebundle/proc/wireidxiscut(var/wireidx as num)
	return wirestatus[wireidx]

/datum/assembly/wirebundle/proc/wireidxtocolor(var/wireidx as num)
	return src.wirecolors[src.wireidxtonum[wireidx]]

/datum/assembly/wirebundle/proc/wirecolortoidx(var/wirecolor as text)
	return wirenumtoidx[wirecolors[wirecolor]]

/datum/assembly/wirebundle/proc/wirenumtoidx(var/wirenum as num)
	return wirenumtoidx[wirenum]

/datum/assembly/wirebundle/proc/attach_trigger(var/wirenum as num, var/obj/item/weapon/multitool/trigger)
	var/idx = src.wirenumtoidx(wirenum)
	// if(src.triggers[wirenum] || idx > src.numwires || !(trigger.flags & SENDSRSIGNAL) || src.wireidxiscut(idx)) return 0
	if(src.triggers[idx])
		return "There's already a trigger attached to this wire."
	if(idx > src.numwires)
		return "You tried to attach a trigger to a non existant wire!"
	if(!(trigger.flags & SENDSRSIGNAL))
		return "You try to attach the object, but you can't quite figure out what's going to pulse the wire... (try using a signaller or timer)"
	if(src.wireidxiscut(idx))
		return "You can't attach to a cut wire!"
	if(istype(trigger, /obj/item/weapon/radio/signaller))
		var/obj/item/weapon/radio/signaller/S = trigger
		if(!S.is_attachable)
			return "The radio can't be attached!"

	src.triggers[idx] = trigger

	var/mob/carbon/M = usr
	M.drop_item()

	trigger.assmaster = src
	trigger.loc = src

	return "You attach the trigger to the wire."

/datum/assembly/wirebundle/proc/detach_trigger(var/wirenum as num)
	if(!src.wirenumhastrigger(wirenum))
		return "There's no trigger on that wire to detach!"
	var/obj/item/weapon/multitool/trigger = triggers[wirenumtoidx(wirenum)]

	trigger.assmaster = null
	trigger.loc = usr.loc

	triggers[wirenumtoidx(wirenum)] = null

	return "You detach the trigger."

/datum/assembly/wirebundle/proc/wirenumhastrigger(var/wirenum as num)
	var/obj/item/weapon/trigger = triggers[wirenumtoidx(wirenum)]
	if(istype(trigger, /obj/item/weapon))
		return 1
	return 0

/datum/assembly/wirebundle/r_signal(n, source)
	for(var/i = 1; i <= src.numwires; i++)
		if(src.triggers[i] == source)
			spawn(0)
				master.r_signal(wireidxtonum[i])
				return
			break

/datum/assembly/proc/r_signal()
	return
