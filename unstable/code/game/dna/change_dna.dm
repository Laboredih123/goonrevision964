/mob/carbon/proc/change_dna(datum/dna/D)
	src.dna = D
	src.update_body()
	src.update_face()

/mob/carbon/proc/update_body()
	if(src.appearance == APPEARANCE_HUMAN)
		del(src.stand_icon)
		del(src.lying_icon)
		src.stand_icon = new /icon( 'human.dmi', "[src.gender]")
		src.lying_icon = new /icon( 'human.dmi', "[src.gender]-d")
		if (src.skin_color == SKIN_COLOR_DARK)
			src.stand_icon.Blend(rgb(50,50,50), 0)
			src.lying_icon.Blend(rgb(50,50,50), 0)
		else if (src.skin_color == SKIN_COLOR_MEDIUM)
			src.stand_icon.Blend(rgb(100,100,100), 0)
			src.lying_icon.Blend(rgb(100,100,100), 0)
		else if(src.skin_color == SKIN_COLOR_LIGHT)
			src.stand_icon.Blend(rgb(150,150,150), 0)
			src.lying_icon.Blend(rgb(150,150,150), 0)
		src.stand_icon.Blend(new /icon( 'human.dmi', "diaper" ), 3)
		src.lying_icon.Blend(new /icon( 'human.dmi', "diaper2" ), 3)
		if (src.gender == "female")
			src.stand_icon.Blend(new /icon( 'human.dmi', "f_add" ), 3)
			src.lying_icon.Blend(new /icon( 'human.dmi', "f_add2" ), 3)
	else
		src.stand_icon = new /icon('monkey.dmi', "monkey1")
		src.lying_icon = new /icon('monkey.dmi', "monkey0")

	if(src.lying)
		src.icon = src.lying_icon
	else
		src.icon = src.stand_icon
	return

/mob/carbon/proc/hair_color_rgb(color)
	if(color == HAIR_COLOR_GREY)
		return rgb(200,200,200)
	else if(color == HAIR_COLOR_BLACK)
		return rgb(255,255,255)
	else if(color == HAIR_COLOR_BROWN)
		return rgb(150, 70, 20)
	else if(color == HAIR_COLOR_BLOND)
		return rgb(220, 210, 190)
	else if(color == HAIR_COLOR_WHITE)
		return rgb(255, 255, 255)
	else
		return rgb(255, 255, 255)

/mob/carbon/proc/update_face()
	if(src.appearance == APPEARANCE_HUMAN)
		del(src.face)
		del(src.face2)
		src.face = new/icon("icon" = 'mob.dmi', "icon_state" = src.hair_style)
		src.face2 = new/icon("icon" = 'mob.dmi', "icon_state" = "[src.hair_style]2")
		face.Blend(hair_color_rgb(src.hair_color), ICON_ADD)
		face2.Blend(hair_color_rgb(src.hair_color), ICON_ADD)
		src.stand_icon.Blend(face, ICON_OVERLAY)
		src.lying_icon.Blend(face2, ICON_OVERLAY)