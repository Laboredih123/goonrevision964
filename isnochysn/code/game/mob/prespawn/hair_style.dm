/mob/var/const
	HAIR_STYLE_SHORT = 1
	HAIR_STYLE_LONG = 2
	HAIR_STYLE_CUT = 3
	HAIR_STYLE_BALD = 4

/mob/proc/get_hair_styles()
	return list(
		HAIR_STYLE_SHORT = "short",
		HAIR_STYLE_LONG = "long",
		HAIR_STYLE_CUT = "cut",
		HAIR_BALD = "bald"
	)

/mob/prespawn/proc/choose_hair_style()
	var/styles = get_hair_styles()
	var/descs = list()
	for(var/style in get_hair_styles())
		descs += styles[style]
	var/curr_style
	src.char_hair_style = input("Select a hair style", "Character Generation", styles[src.hair_style]) in styles