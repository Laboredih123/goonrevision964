var/const/
	ALLELE_A = 1
	ALLELE_C = 2
	ALLELE_G = 3
	ALLELE_T = 4

	ATTR_JUNK = 1
	ATTR_FIREPROOF = 2


/var/datum/dna/canonical/canonical_dna = new()

/proc/rand_allele()
	return rand(ALLELE_A, ALLELE_C, ALLELE_G, ALLELE_T)

/datum/dna
	var/list/data[NUM_CHROMOSOMES][NUM_LOCI]
	var/const/NUM_CHROMOSOMES = 23
	var/const/NUM_LOCI = 10

	New()
		for(var/i = 0; i < NUM_CHROMOSOMES; i++)
			for(var/j = 0; j < NUM_LOCI; j++)
				data[i][j] = ALLELE_A

/datum/dna/canonical
	New()
		for(var/i = 0; i < NUM_CHROMOSOMES; i++)
			for(var/j = 0; j < NUM_LOCI; j++)
				data[i][j] = new /datum/canonical_allele()

/datum/canonical_allele
	var/attribute = ATTR_JUNK //what attribute this is required for
	var/req_val = rand_allele() //what value this must be set to in order to have that attribute
	//req_val is meaningless if attribute == ATTR_JUNK
	var/default_val = req_val //what an unaltered /mob/carbon spawns with as the value for this allele

	/*
	effectively, everyone starts out with every ability and then they're taken away based on which
	alleles don't have value == req_val

	this makes it very simple to have attributes that require multiple alleles to be set - just have
	multiple alleles with attribute == [whatever]

	unfortunately, it makes it hard to have multiple alleles that all provide the same attribute
	but that's not really a necessary thing to have
	*/