/mob/var/const
	HAIR_COLOR_BROWN = "brown"
	HAIR_COLOR_BLACK = "black"
	HAIR_COLOR_WHITE = "white"
	HAIR_COLOR_GREY = "grey"
	HAIR_COLOR_BLOND = "blond"

/mob/proc/get_hair_colors()
	return list(
		HAIR_COLOR_BROWN,
		HAIR_COLOR_BLACK,
		HAIR_COLOR_WHITE,
		HAIR_COLOR_GREY,
		HAIR_COLOR_BLOND
	)

/mob/prespawn/proc/choose_hair_color()
	src.char_hair_color = input("Select a hair color", "Character Generation", src.char_hair_color) in get_hair_colors()