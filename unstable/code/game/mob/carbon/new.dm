/mob/carbon/New(loc, name, hair_color, hair_style, skin_color, gender)
	..(loc, name)
	if(!src.loc)
		var/area/A = locate(/area/arrival/start)
		var/list/L = list(  )
		for(var/turf/T in A)
			if(T.isempty() )
				L += T
		var/turf/Trand = pick(L)
		src.loc = Trand
	if(hair_color)
		src.hair_color = hair_color
	if(hair_style)
		src.hair_style = hair_style
	if(skin_color)
		src.skin_color = skin_color
	if(gender)
		src.gender = gender

	src.organs += new /datum/organ("chest")
	src.organs += new /datum/organ("diaper")
	src.organs += new /datum/organ("head")
	src.organs += new /datum/organ("l_arm")
	src.organs += new /datum/organ("r_arm")
	src.organs += new /datum/organ("l_hand")
	src.organs += new /datum/organ("r_hand")
	src.organs += new /datum/organ("l_leg")
	src.organs += new /datum/organ("r_leg")
	src.organs += new /datum/organ("l_foot")
	src.organs += new /datum/organ("r_foot")

	src.dna = new /datum/dna(src)
	src.dna.register(src)
	src.dna.apply(src)