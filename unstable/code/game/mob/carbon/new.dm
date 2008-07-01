/mob/carbon/New(loc, name)
	..(loc, name)
	if(!src.loc)
		var/area/A = locate(/area/arrival/start)
		var/list/L = list(  )
		for(var/turf/T in A)
			if(T.isempty() )
				L += T
		var/turf/Trand = pick(L)
		src.loc = Trand

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

	src.body_name = name

	src.dna = new /datum/dna(src)
	src.dna.apply(src)
	src.dna.register(src)