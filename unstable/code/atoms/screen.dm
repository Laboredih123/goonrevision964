/obj/screen/attack_hand(mob/user as mob, using)
	return user.db_click(src.name, using)

/obj/screen/attack_paw(mob/user as mob, using)
	return user.db_click(src.name, using)


/obj/screen/New(owner, name = null, dir = null, screen_loc = null, layer = null, icon_state = null, mouse_not_opaque = 0)
	..(owner)
	if(name)
		src.name = name
	if(dir)
		src.dir = dir
	if(screen_loc)
		src.screen_loc = screen_loc
	if(layer)
		src.layer = layer
	if(icon_state)
		src.icon_state = icon_state
	if(mouse_not_opaque)
		src.mouse_opacity = 0