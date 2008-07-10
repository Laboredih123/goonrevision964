/mob/carbon/proc/update_body()
	if(src.appearance == APPEARANCE_HUMAN)
		del(src.stand_icon)
		del(src.lying_icon)
		src.stand_icon = new /icon( 'human.dmi', "blank" )
		src.lying_icon = new /icon( 'human.dmi', "blank" )
		for(var/t in src.organs) // update/show only those organs that are currently attached
			src.stand_icon.Blend(new /icon( 'human.dmi', text("[]", t) ), 3)
			src.lying_icon.Blend(new /icon( 'human.dmi', text("[]2", t) ), 3)
		if (src.skin_color == SKIN_COLOR_DARK)
			src.stand_icon.Blend(rgb(100,100,100), ICON_MULTIPLY)
			src.lying_icon.Blend(rgb(100,100,100), ICON_MULTIPLY)
		else if (src.skin_color == SKIN_COLOR_MEDIUM)
			src.stand_icon.Blend(rgb(200,200,200), ICON_MULTIPLY)
			src.lying_icon.Blend(rgb(200,200,200), ICON_MULTIPLY)
		src.stand_icon.Blend(new /icon( 'human.dmi', "diaper" ), ICON_OVERLAY)
		src.lying_icon.Blend(new /icon( 'human.dmi', "diaper2" ), ICON_OVERLAY)
		if (src.gender == "female")
			src.stand_icon.Blend(new /icon( 'human.dmi', "f_add" ), ICON_OVERLAY)
			src.lying_icon.Blend(new /icon( 'human.dmi', "f_add2" ), ICON_OVERLAY)
	else if(src.appearance == APPEARANCE_MONKEY)
		src.stand_icon = new /icon('monkey.dmi', "monkey1")
		src.lying_icon = new /icon('monkey.dmi', "monkey0")
	else
		src.stand_icon = new /icon('quivering_mass.dmi')
		src.lying_icon = new /icon('quivering_mass.dmi')

	if(src.lying)
		src.icon = src.lying_icon
	else
		src.icon = src.stand_icon

	src.update_name()
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
