/var/const/NON_REV = 0
/var/const/REV_FOLLOWER = 1
/var/const/REV_LEADER = 2

/mob/var/rev_status = NON_REV

/datum/game_mode/revolution
	name = "revolution"
	config_tag = "revolution"
	var/const/NUM_REVS = 3
	min_players = 3 + NUM_REVS
	var/list/revs = null
	var/list/heads = null
	var/rev1
	var/rev2
	var/rev3
	var/head1
	var/head2
	var/head3

/datum/game_mode/revolution/announce()
	world << "<B>The current game mode is - Revolution!</B>"
	world << "<B>Some crewmembers are attempting to start a revolution!<BR>\nRevolutionaries - Kill the Captain, HoP, and HoR. Convert other crewmembers (excluding the Captain, HoP, HoR, and security officers) to your cause by flashing them. Protect your leaders.<BR>\nPersonnel - Protect the Captain, HoP, and HoR. Kill the leaders of the revolution, and brainwash the other revolutionaries (by beating them in the head).</B>"
/datum/game_mode/revolution/pre_setup()
	var/retries
	while(1)	//try for two minutes
		var/curNum = 0
		for(var/mob/M in world)
			if(M.client && M.start)
				curNum ++
		if(curNum < min_players)
			world << "<b>Minimum amount of players required for revolution not met, waiting 10 seconds...(Retry [retries])</b>"
			retries ++
			sleep(100) //10 seconds
		else
			break

/datum/game_mode/revolution/post_setup()
	for(var/x=0; x<3; x++)
		pick_killer()
		ticker.killer << "\blue You are a member of the revolutionaries' leadership!"
	if(get_mobs_with_rank("Captain"))
		head1 = get_mobs_with_rank("Captain")[1]
		heads += head1
	if(get_mobs_with_rank("Head of Personnel"))
		head2 = get_mobs_with_rank("Head of Personnel")[1]
		heads += head2
	if(get_mobs_with_rank("Head of Research"))
		head3 = get_mobs_with_rank("Head of Research")[1]
		heads += head3
	spawn (0)
		ticker.extend_process()

/datum/game_mode/revolution/proc/get_synd_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && istype(M, /mob/human))
			if(M.be_syndicate && M.start)
				if(M.rev_status == NON_REV)
					mobs += M
	if(mobs.len < 1)
		mobs = get_mob_list()
	return mobs

/datum/game_mode/revolution/proc/get_mob_list()	//override the default to include rev_status check
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && M.start)
			if(M.rev_status == NON_REV)
				mobs += M
	return mobs

/datum/game_mode/revolution/proc/pick_killer()
	var/mob/human/killer = pick(get_synd_list())
	ticker.killer = killer
	revs += killer
	spawn(100)
		new /datum/effect/traitor_radio(killer)
		// convert verb allows overt conversion
		new /datum/effect/convert(killer)
		killer.rev_status = REV_LEADER
		for(var/mob/N in revs)
			show_rev(killer, N) // give people a rev flag on themselves too
		if (killer.r_store)
			killer.equip_if_possible(new /obj/item/weapon/flash(killer), killer.slot_l_store)
		if (killer.l_store)
			killer.equip_if_possible(new /obj/item/weapon/flash(killer), killer.slot_r_store)
	return

/datum/game_mode/revolution/proc/check_death(var/mob/M as mob)
	if (!M)	return 1
	if (M.stat == 2)	return 1
	return 0

/datum/game_mode/revolution/check_win()
	if (check_death(head1) && check_death(head2) && check_death(head3))
		world << "<FONT size = 3><B>Revolutionary Victory</B></FONT>"
		world << "<B>The Captain, Head of Personnel, and Head of Research have been killed!</B> The Revolution is victorious!"
		return 1
	if (check_death(rev1) && check_death(rev2) && check_death(rev3))
		world << "<FONT size = 3><B>The Research Staff has stopped the revolution!</B></FONT>"
		world << "<B>The leaders of the revolution have been killed!</B>"
		return 1
	return 0