/obj/item/weapon/limb
	name = "limb"
	icon = 'humansevered.dmi'
	s_istate = "bio_orange"
	var/icon/skin
	var/fingerprint
/obj/item/weapon/limb/r_arm
	name = "right arm"
	icon_state = "r_arm"
	force = 11
	w_class = 4
/obj/item/weapon/limb/l_arm
	name = "left arm"
	icon_state = "l_arm"
	force = 11
	w_class = 4
/obj/item/weapon/limb/r_arm_stump
	name = "right arm stump"
	desc = "It's missing the hand"
	icon_state = "r_arm_stump"
	force = 7
/obj/item/weapon/limb/l_arm_stump
	name = "left arm stump"
	desc = "It's missing the hand"
	icon_state = "l_arm_stump"
	force = 7
/obj/item/weapon/limb/r_hand
	name = "right hand"
	icon_state = "r_hand"
	force = 3
	w_class = 2
/obj/item/weapon/limb/l_hand
	name = "left hand"
	icon_state = "l_hand"
	force = 3
	w_class = 2
/obj/item/weapon/limb/r_leg
	name = "right leg"
	icon_state = "r_leg"
	force = 11
	w_class = 4
/obj/item/weapon/limb/l_leg
	name = "left leg"
	icon_state = "l_leg"
	force = 11
	w_class = 4
/obj/item/weapon/limb/r_leg_stump
	name = "right leg stump"
	desc = "It's missing the foot"
	icon_state = "r_leg_stump"
	force = 7
/obj/item/weapon/limb/l_leg_stump
	name = "left leg stump"
	desc = "It's missing the foot"
	icon_state = "l_leg_stump"
	force = 7
/obj/item/weapon/limb/r_foot
	name = "right foot"
	icon_state = "r_foot"
	force = 3
	w_class = 2
/obj/item/weapon/limb/l_foot
	name = "left foot"
	icon_state = "l_foot"
	force = 3
	w_class = 2
/obj/item/weapon/limb/head
	name = "head"
	icon_state = "head"
	force = 7
	var/icon/face

/obj/item/weapon/limb/proc/haircolor_rgb(color)
	if(color == "grey")
		return rgb(200,200,200)
	else if(color == "black")
		return rgb(255,255,255)
	else if(color == "brown")
		return rgb(150, 70, 20)
	else if(color == "blond")
		return rgb(220, 210, 190)
	else if(color == "white")
		return rgb(255, 255, 255)
	else
		return rgb(255, 255, 255)

/obj/item/weapon/limb/proc/setup_limb(mob/carbon/M as mob)
	M.show_viewers("\red <B>[M]'s [name] has been severed!</B>")
	name = addtext("severed ",name)
	if (findtext(name,"hand") || (findtext(name,"arm") && !findtext(name,"stump")))
		src.fingerprint = M.get_fingerprint()
	var/icon/skin = new /icon( 'humansevered.dmi', icon_state )
	if (M.skin_color == "dark")
		skin.Blend(rgb(100,100,100), ICON_MULTIPLY)
	else if(M.skin_color == "medium")
		skin.Blend(rgb(200,200,200), ICON_MULTIPLY)
	if (icon_state == "head")
		var/icon/face = new /icon('mob.dmi', "[M.hair_style]2")
		face.Blend(haircolor_rgb(M.hair_color), ICON_ADD)
		skin.Blend(face, 3)
		src.name = "[M.body_name]'s severed head"
	skin.Blend(new /icon('humansevered.dmi', text("[]_blood",icon_state)),3)	// Blooood
	src.icon = skin
