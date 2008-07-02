/var/const
	SKIN_COLOR_DARK = "dark"
	SKIN_COLOR_MEDIUM = "medium"
	SKIN_COLOR_LIGHT = "light"

/proc/get_skin_colors()
	return list(
		SKIN_COLOR_DARK,
		SKIN_COLOR_MEDIUM,
		SKIN_COLOR_LIGHT
	)


/mob/prespawn/proc/choose_skin_color()
	src.char_skin_color = input("Select a skin color", "Character Generation", src.char_skin_color) in get_skin_colors()