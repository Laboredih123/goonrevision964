/mob/prespawn/var/const
	SKIN_DARK = "dark"
	SKIN_MEDIUM = "medium"
	SKIN_LIGHT = "light"

/mob/get_skins()
	return list(
		SKIN_DARK,
		SKIN_MEDIUM,
		SKIN_LIGHT
	)


/mob/prespawn/proc/choose_skin()
	src.char_skin = input("Select a skin tone", "Character Generation", src.char_skin) in get_skins()