/datum/gene/hair_color
	var/const
		BROWN = "brown"
		BLACK = "black"
		WHITE = "white"
		GREY = "grey"
		BLOND = "blond"
	attributes = list(
		BROWN,
		BLACK,
		WHITE,
		GREY,
		BLOND
	)
	default = GREY

/datum/gene/hair_style/update_mob(mob/carbon/M, attribute)
	. = ..()
	if(!.) return