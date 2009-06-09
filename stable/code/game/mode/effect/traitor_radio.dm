/datum/effect/traitor_radio/New(mob/human/M)
//	spawn (100)
	if(!M || !istype(M, /mob/human))
		return
	// generate list of radio freqs
	var/freq = 144.1
	var/list/freqlist = list()
	while (freq <= 148.9)
		if (freq < 145.1 || freq > 145.9)
			freqlist += freq
		freq += 0.2
		if (round(freq * 10, 1) % 2 == 0)
			freq += 0.1
	freq = freqlist[rand(1, freqlist.len)]
	// find a radio! toolbox(es), backpack, belt, headset
	var/loc = ""
	var/obj/item/weapon/radio/R = null
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
	if (!R && M.w_uniform && istype(M.belt, /obj/item/weapon/radio))
		R = M.belt
		loc = "on your belt"
	if (!R && istype(M.w_radio, /obj/item/weapon/radio))
		R = M.w_radio
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
		M << "The Syndicate have cunningly disguised a Syndicate Uplink as your [R.name] [loc]. Simply dial the frequency [freq] to unlock it's hidden features."
		M.store_memory("<B>Radio Freq:</B> [freq] ([R.name] [loc]).", 0)
	return