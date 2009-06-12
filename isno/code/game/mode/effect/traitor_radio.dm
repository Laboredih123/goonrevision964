// TODO: Make this work properly when their first radio selected already is a syndicate uplink. It should either
//make it another syndicate uplink or try another radio, not overwrite the existing uplink as this does now.

/datum/effect/traitor_radio/New(mob/carbon/human/M)
	if(!M || !istype(M, /mob/carbon/human))
		return
	// generate list of radio freqs
	var/list/freqlist = list()
	for(var/f = 1441, f <= 1489, f += 2)
		if (f < 1451 || f > 1459)
			freqlist += f
	var/freq = pick(freqlist)
	// find a radio! toolbox(es), backpack, belt, headset
	var/loc = ""
	var/obj/item/weapon/radio/R = null
	if (!R && istype(M.l_hand, /obj/item/weapon/radio))
		R = M.l_hand
		loc = "in your left hand"
	if (!R && istype(M.r_hand, /obj/item/weapon/radio))
		R = M.r_hand
		loc = "in your right hand"
	if (!R && istype(M.l_hand, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = M.l_hand
		var/list/L = S.return_inv()
		for (var/obj/item/weapon/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your left hand"
			break
	if (!R && istype(M.r_hand, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = M.r_hand
		var/list/L = S.return_inv()
		for (var/obj/item/weapon/radio/foo in L)
			R = foo
			loc = "in the [S.name] in your right hand"
			break
	if (!R && istype(M.back, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = M.back
		var/list/L = S.return_inv()
		for (var/obj/item/weapon/radio/foo in L)
			R = foo
			loc = "in the [S.name] on your back"
			break
	if (!R && M.jumpsuit && istype(M.belt, /obj/item/weapon/radio))
		R = M.belt
		loc = "on your belt"
	if (!R && istype(M.headset, /obj/item/weapon/radio))
		R = M.headset
		loc = "on your head"

	if (!R)
		M << "Unfortunately, the Syndicate wasn't able to get you a radio."
	else
		var/obj/item/weapon/syndicate_uplink/T = new /obj/item/weapon/syndicate_uplink(R)
		R.traitorradio = T
		R.traitorfreq = freq
		T.name = R.name
		T.icon_state = R.icon_state
		T.origradio = R
		var/display_freq = round(freq/10, 0.1)
		M << "The Syndicate have cunningly disguised a Syndicate Uplink as your [R.name] [loc]. Simply dial the frequency [display_freq] to unlock its hidden features."
		M.store_memory("<B>Radio Freq:</B> [display_freq] ([R.name] [loc]).", 0)