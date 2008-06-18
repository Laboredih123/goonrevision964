/mob/var/const
	HAIR_COLOR_BROWN = 1
	HAIR_COLOR_BLACK = 2
	HAIR_COLOR_WHITE = 3
	HAIR_COLOR_GREY = 4
	HAIR_COLOR_BLOND = 5

/mob/proc/get_hair_colors()
	return list(
		HAIR_BROWN = "brown",
		HAIR_BLACK = "black",
		HAIR_WHITE = "white",
		HAIR_GREY = "grey",
		HAIR_BLOND = "blond"
	)

/mob/prespawn/proc/choose_hair_color()
	var/colors = get_hair_colors()
	var/descs = list()
	for(var/color in get_hair_colors())
		descs += colors[color]
	src.char_hair_color = input("Select a hair color", "Character Generation", colors[src.hair_color]) in colors