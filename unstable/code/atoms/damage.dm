/datum/damage
	var/brute = 0
	var/burn = 0
	var/toxin = 0
	var/electric = 0
	var/suffocation = 0
	var/total = 0

/datum/damage/New(brute, burn, toxin, electric, suffocation)
	src.brute = brute
	src.burn = burn
	src.toxin = toxin
	src.electric = electric
	src.suffocation = suffocation
	total()

/datum/damage/proc/add(datum/damage/dam)
	src.brute += max(dam.brute, 0)
	src.burn += max(dam.burn, 0)
	src.toxin += max(dam.toxin, 0)
	src.electric += max(dam.electric, 0)
	src.suffocation += max(dam.suffocation, 0)
	total()

/datum/damage/proc/subtract(datum/damage/dam)
	//returns anything left over from the subtraction, doesn't just throw away overflow
	if(dam.brute > src.brute)
		dam.brute -= src.brute
		src.brute = 0
	else
		src.brute -= dam.brute
		dam.brute = 0

	if(dam.burn > src.burn)
		dam.burn -= src.burn
		src.burn = 0
	else
		src.burn -= dam.burn
		dam.burn = 0

	if(dam.toxin > src.toxin)
		dam.toxin -= src.toxin
		src.toxin = 0
	else
		src.toxin -= dam.toxin
		dam.toxin = 0

	if(dam.electric > src.electric)
		dam.electric -= src.electric
		src.electric = 0
	else
		src.electric -= dam.electric
		dam.electric = 0

	if(dam.suffocation > src.suffocation)
		dam.suffocation -= src.suffocation
		src.suffocation = 0
	else
		src.suffocation -= dam.suffocation
		dam.suffocation = 0
	total()
	return dam

/datum/damage/proc/total()
	total = src.brute + src.burn + src.toxin + src.electric + src.suffocation