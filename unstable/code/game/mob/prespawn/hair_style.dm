/mob/prespawn/proc/choose_hair_style()
	src.char_hair_style = input("Select a hair style", "Character Generation", src.char_hair_style) in get_hair_styles()