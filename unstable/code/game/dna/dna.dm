/var/const/NUM_CHROMOSOMES = 10
/var/const/NUM_LOCI = 5

/datum/dna/var/list/data[NUM_CHROMOSOMES][NUM_LOCI]

/datum/dna/New(mob/carbon/M)
	if(M)
		for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
			for(var/j = 1; j <= NUM_LOCI; j++)
				var/datum/canonical_locus/L = canonical_dna.data[i][j]
				if(L.associated_gene)
					var/datum/gene/G = L.associated_gene
					src.data[i][j] = G.choose_allele(M, L)
	else
		for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
			for(var/j = 1; j <= NUM_LOCI; j++)
				src.data[i][j] = pick_allele()

/datum/dna/proc/mutate()
	//75% chance of no mutation at all
	if(prob(75))
		return
	for(var/list/chromosome in src.data)
		for(var/i = 1; i <= chromosome.len; i++)
			//1% chance of mutating any given locus
			if(prob(1))
				chromosome[i] = pick_allele()

/datum/dna/proc/mutateAt(chrom, loc)
	//75% chance of no mutation at all
	if(prob(75))
		return
	//50% chance of hitting a nearby locus instead
	if(prob(50))
		chrom = chrom + rand(-2, 2)
		loc = loc + rand(-2, 2)
	//if it's something inaccessible, just don't mutate at all
	if (chrom < 1 || chrom > NUM_CHROMOSOMES)
		return
	if (loc < 1 || loc > NUM_LOCI)
		return
	src.data[chrom][loc] = pick_allele()

/datum/dna/proc/apply(mob/carbon/M)
	var/list/genes = list()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			var/datum/canonical_locus/L = canonical_dna.data[i][j]
			var/datum/gene/G = L.associated_gene
			if(genes[G])
				if(genes[G] != L.alleles[src.data[i][j]]) //reset it to default if it conflicts with the original
					//for instance, if you had one "long hair" allele and one "short hair" allele for a two-part
					//attribute, it would go to the default (bald)
					genes[G] = G.default
			else
				var/x = src.data[i][j]
				genes[G] = L.alleles[x] //the attribute associated with the allele this guy has
	for(var/datum/gene/G in genes)
		G.pre_apply(M)
	for(var/datum/gene/G in genes)
		G.apply(M, genes[G])

	if(M.appearance == APPEARANCE_QUIVERING_MASS)
		M.body_name = "Unholy quivering mass of flesh"
		M.voice = "Unholy quivering mass of flesh"
	else
		var/name = src.check_registered()
		if(name)
			M.body_name = name
			M.voice = name
		else
			M.body_name = "Unknown"
			M.voice = "Unknown"
	if(M.hud)
		M.hud.update_slots()
	M.update_body()
	M.update_face()

	//check what they can wear, drop what they can't
	var/list/L = list(
		list(M.can_wear_back, M.back, SLOT_BACK),
		list(M.can_wear_mask, M.mask, SLOT_MASK),
		list(M.can_wear_l_hand, M.l_hand, SLOT_L_HAND),
		list(M.can_wear_r_hand, M.r_hand, SLOT_R_HAND),
		list(M.can_wear_belt, M.belt, SLOT_BELT),
		list(M.can_wear_id, M.id, SLOT_ID),
		list(M.can_wear_glasses, M.glasses, SLOT_GLASSES),
		list(M.can_wear_gloves, M.gloves, SLOT_GLOVES),
		list(M.can_wear_helmet, M.helmet, SLOT_HELMET),
		list(M.can_wear_shoes, M.shoes, SLOT_SHOES),
		list(M.can_wear_suit, M.suit, SLOT_SUIT),
		list(M.can_wear_jumpsuit, M.jumpsuit, SLOT_JUMPSUIT),
		list(M.can_wear_l_store, M.l_store, SLOT_L_STORE),
		list(M.can_wear_r_store, M.r_store, SLOT_R_STORE),
		list(M.can_wear_headset, M.headset, SLOT_HEADSET)
	)
	for(var/slot in L)
		if(slot[1]) continue
		if(slot[2])	M.drop(slot[3])

/datum/dna/proc/copy()
	var/datum/dna/copy = new()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			copy.data[i][j] = src.data[i][j]
	return copy


/var/list/registered_dna = list()

/datum/dna/proc/hash()
	var/s = ""
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			var/datum/canonical_locus/L = canonical_dna.data[i][j]
			if(L.associated_gene && L.associated_gene.is_noticeable)
				s += src.data[i][j]
	return md5(s)

/datum/dna/proc/register(mob/carbon/M)
	//registers this DNA as belonging to this mob, so if someone else gets it later they get this name, etc
	var/hash = src.hash()
	registered_dna[hash] = M.spawn_name
	M.fingerprint = hex2num(copytext(hash, 1, 5)) //truncate to 5 or less digits (between 0 and 16^4)
	//doing hex2num on the whole thing introduces stupid floating point crap, so truncate the hash BEFORE hex2num

/datum/dna/proc/check_registered()
	var/hash = src.hash()
	if(hash in registered_dna)
		return registered_dna[hash]
	else
		return null

// canonical DNA - effectively a singleton, with data on all the loci and their associated genes
// one instance of this is created when the world is, no more are after that
// that instance is at /var/datum/dna/canonical/canonical_dna
/datum/dna/canonical/var/NUM_UNIQUE_GENES = 5 //number of completely random genes, unique for each person

/datum/dna/canonical/New()
	//make the loci
	var/datum/gene/junk = new()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			src.data[i][j] = new /datum/canonical_locus()
			junk.associate_with_locus(src.data[i][j])

	//assign genes to them
	var/genetypes = typesof(/datum/gene)
	for(var/i = 1; i < NUM_UNIQUE_GENES; i++) //one less than NUM_UNIQUE_GENES - typesof already adds it once
		genetypes += /datum/gene/unique
	genetypes -= /datum/gene //get rid of base type, it's junk
	var/list/genes = list()
	for(var/genetype in genetypes)
		genes += new genetype
	for(var/datum/gene/G in genes)
		G.associate_with_loci(src)

/datum/dna/canonical/proc/get_random_junk_locus()
	while(1)
		var/datum/canonical_locus/L = get_random_locus()
		if(L.is_junk)
			return L

/datum/dna/canonical/proc/get_random_locus()
	var/chromosome = pick(src.data)
	return pick(chromosome)