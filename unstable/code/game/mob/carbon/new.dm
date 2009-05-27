/mob/carbon/New(loc, name, hair_color, hair_style, skin_color, gender, bloodtype, organs, dna, rank)
	..(loc, name)
	var/unable_to_spawn = -1
	while(!src.loc)
		var/area/A = locate(/area/arrival/start)
		var/list/L = list()
		for(var/turf/T in A)
			if(T.isempty()) L += T
		var/turf/Trand = pick(L)
		if(Trand) src.loc = Trand
		else
			++unable_to_spawn
			if(!unable_to_spawn)
				world.log_admin("[name] unable to spawn (no room)")
				usr << "Waiting for open spawn location (10s)"
				sleep(1000)
			else if(unable_to_spawn<6)
				usr << "Waiting for open spawn location (60s)"
				sleep(6000)
			else
				usr << "Unable to spawn: Disconnecting"
				if(src.client)
					del(src.client)
				del(src)

	if(hair_color)	src.hair_color = hair_color
	else			src.hair_color = pick(get_hair_colors())

	if(hair_style)	src.hair_style = hair_style
	else			src.hair_style = pick(get_hair_styles())

	if(skin_color)	src.skin_color = skin_color
	else			src.skin_color = pick(get_skin_colors())

	if(gender)		src.gender = gender

	if(bloodtype)	src.bloodtype = bloodtype
	else			src.bloodtype = get_random_blood_type()

	if(organs)		src.organs = organs
	else
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

	if(dna)			src.dna = dna
	else
		src.dna = new /datum/dna(src)
		src.dna.register(src)
		src.dna.apply(src)

	src.spawn_rank = rank
	spawn_ranks[name] = rank
