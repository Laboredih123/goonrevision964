/datum/dna
	var/const/NUM_CHROMOSOMES = 23
	var/const/NUM_LOCI = 10
	var/list/data[NUM_CHROMOSOMES][NUM_LOCI]

/datum/dna/proc/mutate()
	for(var/list/chromosome in data)
		for(var/i = 1; i <= chromosome.len; i++)
			//1% chance of mutating any given locus
			if(prob(1))
				chromosome[i] = pick_allele()



// canonical DNA - effectively a singleton, with data on all the loci and their associated genes
// one instance of this is created when the world is, no more are after that
// that instance is at /var/datum/dna/canonical/canonical_dna
/datum/dna/canonical/New()
	//make the loci
	for(var/i = 0; i < NUM_CHROMOSOMES; i++)
		for(var/j = 0; j < NUM_LOCI; j++)
			data[i][j] = new /datum/canonical_locus()

	//assign genes to them
	var/genes = typesof(/datum/gene)
	for(var/datum/gene/G in genes)
		G.associate_with_loci(src)

/datum/dna/canonical/proc/get_random_junk_locus()
	while(1)
		var/canonical_locus/L = get_random_locus()
		if(L.is_junk)
			return L

/datum/dna/canonical/proc/get_random_locus()
	var/chromosome = pick(src.data)
	return pick(chromosome)