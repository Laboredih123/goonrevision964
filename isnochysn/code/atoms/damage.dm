/datum/damage
	var/brute = 0
	var/burn = 0
	var/toxin = 0
	var/electric = 0
	var/suffocation = 0

/datum/damage/New(brute, burn, toxin, electric, suffocation)
	src.brute = brute
	src.burn = burn
	src.toxin = toxin
	src.electric = electric
	src.suffocation = suffocation

/datum/damage/proc/add(datum/damage/dam)
	src.brute += dam.brute
	src.burn += dam.burn
	src.toxin += dam.toxin
	src.electric += dam.electric
	src.suffocation += dam.suffocation

/datum/damage/proc/subtract(datum/damage/dam)
	//returns anything left over from the subtraction, doesn't just throw away overflow
	if(dam.brute > src.damage.brute)
		dam.brute -= src.damage.brute
		src.damage.brute = 0
	else
		src.damage.brute -= dam.brute
		dam.brute = 0

	if(dam.burn > src.damage.burn)
		dam.burn -= src.damage.burn
		src.damage.burn = 0
	else
		src.damage.burn -= dam.burn
		dam.burn = 0

	if(dam.toxin > src.damage.toxin)
		dam.toxin -= src.damage.toxin
		src.damage.toxin = 0
	else
		src.damage.toxin -= dam.toxin
		dam.toxin = 0

	if(dam.electric > src.damage.electric)
		dam.electric -= src.damage.electric
		src.damage.electric = 0
	else
		src.damage.electric -= dam.electric
		dam.electric = 0

	if(dam.suffocation > src.damage.suffocation)
		dam.suffocation -= src.damage.suffocation
		src.damage.suffocation = 0
	else
		src.damage.suffocation -= dam.suffocation
		dam.suffocation = 0

	return dam

/datum/damage/proc/total()
	return src.brute + src.burn + src.toxin + src.electric + src.suffocation