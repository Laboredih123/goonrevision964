/mob/carbon/proc/change_dna(/datum/dna/D)
	src.dna = D


/mob/carbon/proc/update_body()

	//src.stand_icon = null
	del(src.stand_icon)
	//src.lying_icon = null
	del(src.lying_icon)
	src.stand_icon = new /icon( 'human.dmi', "blank" )
	src.lying_icon = new /icon( 'human.dmi', "blank" )
	for(var/t in list( "chest", "head", "l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot" ))
		src.stand_icon.Blend(new /icon( 'human.dmi', text("[]", t) ), 3)
		src.lying_icon.Blend(new /icon( 'human.dmi', text("[]2", t) ), 3)
		//Foreach goto(95)
	if (src.s_tone >= 0)
		src.stand_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), 0)
		src.lying_icon.Blend(rgb(src.s_tone, src.s_tone, src.s_tone), 0)
	else
		src.stand_icon.Blend(rgb( -src.s_tone,  -src.s_tone,  -src.s_tone), 1)
		src.lying_icon.Blend(rgb( -src.s_tone,  -src.s_tone,  -src.s_tone), 1)
	src.stand_icon.Blend(new /icon( 'human.dmi', "diaper" ), 3)
	src.lying_icon.Blend(new /icon( 'human.dmi', "diaper2" ), 3)
	if (src.gender == "female")
		src.stand_icon.Blend(new /icon( 'human.dmi', "f_add" ), 3)
		src.lying_icon.Blend(new /icon( 'human.dmi', "f_add2" ), 3)


	return

/mob/human/proc/update_face()

	//src.face = null
	del(src.face)
	//src.face2 = null
	del(src.face2)
	var/icon/I = new/icon("icon" = 'mob.dmi', "icon_state" = "eyes")
	var/icon/I2 = new/icon("icon" = 'mob.dmi', "icon_state" = "eyes2")
	var/icon/F = new/icon("icon" = 'mob.dmi', "icon_state" = text("[]", src.h_style_r))
	var/icon/F2 = new/icon("icon" = 'mob.dmi', "icon_state" = text("[]2", src.h_style_r))
	F.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), 0)
	F2.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), 0)
	I.Blend(rgb(src.r_eyes, src.g_eyes, src.b_eyes), 0)
	I2.Blend(rgb(src.r_eyes, src.g_eyes, src.b_eyes), 0)
	I.Blend(F, 3)
	I2.Blend(F2, 3)
	F = new/icon("icon" = 'human.dmi', "icon_state" = "mouth")
	F2 = new/icon("icon" = 'human.dmi', "icon_state" = "mouth2")
	I.Blend(F, 3)
	I2.Blend(F2, 3)
	//F = null
	del(F)
	//F2 = null
	del(F2)
	src.face = new /image(  )
	src.face2 = new /image(  )
	src.face.icon = I
	src.face2.icon = I2
	//I = null
	del(I)
	//I2 = null
	del(I2)
	return