/mob/carbon/var/weight = 1250000
/mob/carbon/var/base_weight = 1250000

/mob/carbon/update_grabs()
	src.pixel_y = 0
	src.pixel_x = 0
	src.weight = src.baseweight
	if (istype(src.l_hand, /obj/item/weapon/grab))
		src.weight += src.l_hand:affecting.base_weight
	if (istype(src.r_hand, /obj/item/weapon/grab))
		src.weight += src.r_hand:affecting.base_weight
	if (locate(/obj/item/weapon/grab, src.grabbed_by))
		var/a_grabs = 0
		for(var/obj/item/weapon/grab/G in src.grabbed_by)
			G.process()
			if (G)
				if (G.state > 1) //aggressive or neck
					src.weight += G.assailant.base_weight
					if ((G.state > 2 && src.loc == G.assailant.loc)) //neck
						src.density = 0
						src.lying = 0
						switch(G.assailant.dir)
							if(NORTH)
								src.pixel_y = 8
							if(SOUTH)
								src.pixel_y = -8.0
							if(EAST)
								src.pixel_x = 8
							if(WEST)
								src.pixel_x = -8.0

/mob/carbon/proc/get_members_of_grab_chain()
	. = list(src)
	for(var/obj/item/weapon/grab/hand in list(src.l_hand, src.r_hand))
		. = uniquelist(. + hand.affecting.get_members_of_grab_chain())