/turf/station/floor/shuttle
	icon = 'shuttle.dmi'
	icon_state = "floor"

/turf/station/r_wall/shuttle
	icon = 'shuttle.dmi'
	icon_state = "wall"

	attackby(obj/item/weapon/W as obj, mob/carbon/user as mob)
		if(!istype(W, /obj/item/weapon/paper/poster))
			// people can't destroy shuttle rwalls, that would only end in tears
			return
		return ..()