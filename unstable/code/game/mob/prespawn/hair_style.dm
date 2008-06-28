/var/const
	HAIR_STYLE_SHORT = "short"
	HAIR_STYLE_LONG = "long"
	HAIR_STYLE_CUT = "cut"
	HAIR_STYLE_BALD = "bald"

/proc/get_hair_styles()
	return list(
		HAIR_STYLE_SHORT,
		HAIR_STYLE_LONG,
		HAIR_STYLE_CUT,
		HAIR_STYLE_BALD
	)

/mob/prespawn/proc/choose_hair_style()
	src.char_hair_style = input("Select a hair style", "Character Generation", src.char_hair_style) in get_hair_styles()