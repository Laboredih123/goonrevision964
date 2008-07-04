/datum/game_mode/monkey
	name = "monkey"
	config_tag = "monkey"

/datum/game_mode/monkey/announce()
	world << "<B>The current game mode is - Monkey!</B>"
	world << "<B>Some of your crew members have been infected by a mutageous virus!</B>"
	world << "<B>Escape on the shuttle but the humans have precedence!</B>"

/datum/game_mode/monkey/post_setup()
	spawn (50)
		var/list/mobs = list()
		for (var/mob/carbon/M in world)
			if (M.client)
				mobs += M
		var/list/monkeyed = list()
		if (mobs.len >= 3)
			var/amount = round((mobs.len - 1) / 3) + 1
			amount = min(4, amount)
			while (amount > 0)
				var/mob/carbon/M = pick(mobs)
				mobs -= M
				monkeyed += M
				amount--
		//find the "infectious" and "monkey appearance" loci
		for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
			for(var/j = 1; j <= NUM_LOCI; j++)
				var/datum/canonical_locus/L = canonical_dna.data[i][j]
				if(!L.associated_gene)
					break
				if(istype(L.associated_gene, /datum/gene/appearance))
					for(var/allele in L.alleles)
						if(L.alleles[allele] != APPEARANCE_MONKEY)
							break
						for(var/mob/carbon/M in monkeyed)
							M.dna.data[i][j] = allele
				if(istype(L.associated_gene, /datum/gene/infectious))
					for(var/allele in L.alleles)
						if(L.alleles[allele] != INFECTIOUS)
							break
						for(var/mob/carbon/M in monkeyed)
							M.dna.data[i][j] = allele
	spawn (0)
		ticker.extend_process()

/datum/game_mode/monkey/check_win()
	var/area/A = locate(/area/shuttle)
	var/monkeywin = 1
	for(var/mob/carbon/M in world)
		if (!M.is_dead)
			var/T = M.loc
			if (istype(T, /turf))
				if ((T in A))
					monkeywin = 0
	if (monkeywin)
		monkeywin = 0
		for(var/mob/carbon/M in world)
			if (!M.is_dead && M.appearance == APPEARANCE_MONKEY)
				var/T = M.loc
				if (istype(T, /turf))
					if ((T in A))
						monkeywin = 1
	if (monkeywin)
		world << "<FONT size = 3><B>The monkeys have won!</B></FONT>"
		for(var/mob/carbon/M in world)
			if (M.client && M.appearance == APPEARANCE_MONKEY)
				world << text("<B>[] was a monkey.</B>", M.key)
	else
		world << "<FONT size = 3><B>The Research Staff has stopped the monkey invasion!</B></FONT>"
		for(var/mob/carbon/M in world)
			if (M.client && M.appearance == APPEARANCE_HUMAN)
				world << text("<B>[] was [].</B>", M.key, M)
	return 1