/obj/item/weapon/paper/poster
	icon = 'poster.dmi'
	icon_state = "poster"
	name = "Poster"

	New()
		..()
		src.pixel_x = 0
		src.pixel_y = 0
		info = pick_rev_saying()

	interact(mob/carbon/user)
		if(!istype(user, /mob/carbon))
			return ..()
		src.anchored = 0
		src.pixel_x = 0
		src.pixel_y = 0
		return ..()

	attack_self()
		return

	attackby(obj/item/weapon/P, mob/user)
		if (istype(P, /obj/item/weapon/pen))
			return // TODO: allow vandalizing posters
		..()

	burn(fi_amount)
		spawn()
			var/t = src.icon_state
			src.icon_state = "burning"
			flick("[t]", src)
			spawn( 14 )
				del(src)

	proc/place(turf/station/wall/W)
		var/dir = get_dir(src, W)
		var/dx = 0
		var/dy = 0
		if(dir & NORTH)
			dy = 1
		else if(dir & SOUTH)
			dy = -1
		if(dir & EAST)
			dx = 1
		else if(dir & WEST)
			dx = -1

		src.pixel_x = dx * 32
		src.pixel_y = dy * 32
		src.loc = get_turf(loc)
		src.anchored = 1