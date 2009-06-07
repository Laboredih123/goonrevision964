/turf
	icon = 'turfs.dmi'
	var/datum/substance/gas/gas		=	new /datum/substance/gas
	var/datum/substance/gas/phase1	=	new /datum/substance/gas	//	old
	var/datum/substance/gas/phase2	=	new /datum/substance/gas	//	tmp

	//backwards compatability
	var/oxygen=O2STANDARD
	var/n2=N2STANDARD
	var/poison=0
	var/co2 = 0
	var/temp=T20C

	var/intact = 0
	var/firelevel = null
	var/checkfire = 1.0
	var/atmoalt	= null
	var/updatecell = 1
	level = 1.0

	//optimizations
	var/DiffuseAir[]
	var/ConductHeat[]
	var/equilibrium = 0

/turf/space
	name = "space"
	icon_state = "space"
	var/previousArea = null
	updatecell = 1.0
	checkfire = 0

/turf/station
	name = "station"
	intact = 1

/turf/station/command
	name = "command"

/turf/station/command/floor
	name = "floor"
	icon = 'icons.dmi'
	icon_state = "Floor3"
	updatecell = 1

/turf/station/command/floor/other
	icon_state = "Floor"

/turf/station/command/wall
	name = "wall"
	icon = 'wall.dmi'
	icon_state = "CCWall"
	opacity = 1
	density = 1
	updatecell = 0.0

/turf/station/command/wall/other
	icon_state = "r_wall"

/turf/station/engine
	name = "engine"
	icon = 'engine.dmi'

/turf/station/engine/floor
	name = "floor"
	icon_state = "floor"
	updatecell = 1

/turf/station/floor
	name = "floor"
	icon = 'icons.dmi'
	icon_state = "Floor"
	var/health = 150.0
	var/burnt = null
	updatecell = 1

/turf/station/floor/grid
	icon = 'weap_sat.dmi'
	icon_state = "grid"

/turf/station/r_wall
	name = "r wall"
	icon = 'wall.dmi'
	icon_state = "r_wall"
	var/previousArea = null
	opacity = 1
	density = 1
	var/state = 2
	var/d_state = 0
	updatecell = 0

/turf/station/wall
	name = "wall"
	icon = 'wall.dmi'
	var/previousArea = null
	opacity = 1
	density = 1
	var/state = 2
	updatecell = 0
