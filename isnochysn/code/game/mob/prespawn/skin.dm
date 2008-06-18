/mob/prespawn/var/const
	SKIN_DARK = 1
	SKIN_MEDIUM = 2
	SKIN_LIGHT = 3

/mob/get_skins()
	return list(
		SKIN_DARK = "dark",
		SKIN_MEDIUM = "medium",
		SKIN_LIGHT = "light"
	)


/mob/prespawn/proc/choose_skin()
	var/skins = get_hair_skins()
	var/descs = list()
	for(var/skin in get_skins())
		descs += skins[skin]
	src.char_skin = input("Select a skin tone", "Character Generation", skins[src.char_skin]) in skins