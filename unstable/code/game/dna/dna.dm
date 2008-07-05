var/const/NUM_CHROMOSOMES = 23
var/const/NUM_LOCI = 10

/datum/dna/var/list/data[NUM_CHROMOSOMES][NUM_LOCI]

/datum/dna/New(mob/carbon/M)
	if(M)
		for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
			for(var/j = 1; j <= NUM_LOCI; j++)
				var/datum/canonical_locus/L = canonical_dna.data[i][j]
				if(L.associated_gene)
					var/datum/gene/G = L.associated_gene
					src.data[i][j] = G.choose_allele(M, L)
				if(L.is_junk && prob(5)) //everyone gets a few random mutations
					src.data[i][j] = pick_allele()
	else
		for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
			for(var/j = 1; j <= NUM_LOCI; j++)
				src.data[i][j] = pick_allele()

/datum/dna/proc/mutate()
	//75% chance of no mutation at all
	if(!prob(75))
		return
	for(var/list/chromosome in src.data)
		for(var/i = 1; i <= chromosome.len; i++)
			//1% chance of mutating any given locus
			if(prob(1))
				chromosome[i] = pick_allele()

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
					L.alleles[src.data[i][j]] = G.default
			else
				var/x = src.data[i][j]
				genes[G] = L.alleles[x] //the attribute associated with the allele this guy has
	for(var/datum/gene/G in genes)
		G.pre_apply(M)
	for(var/datum/gene/G in genes)
		G.apply(M, genes[G])
	var/name = src.check_registered()
	if(name)
		M.body_name = name
		M.voice = name
	else
		M.body_name = "Unknown"
		M.voice = "Unknown"
	M.update_body()
	M.update_face()

/datum/dna/proc/copy()
	var/datum/dna/copy = new()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			copy.data[i][j] = src.data[i][j]
	return copy


/var/list/registered_dna = list()

/datum/dna/proc/hash()
	var/s = ""
	for(var/list/chromosome in src.data)
		for(var/allele in chromosome)
			s += allele
	return md5(s)

/datum/dna/proc/register(mob/carbon/M)
	//registers this DNA as belonging to this mob, so if someone else gets it later they get this name, etc
	registered_dna[src.hash()] = M.spawn_name


/datum/dna/proc/check_registered()
	var/hash = src.hash()
	if(hash in registered_dna)
		return registered_dna[hash]
	else
		return null

// canonical DNA - effectively a singleton, with data on all the loci and their associated genes
// one instance of this is created when the world is, no more are after that
// that instance is at /var/datum/dna/canonical/canonical_dna
/datum/dna/canonical/New()
	//make the loci
	var/datum/gene/junk = new()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			src.data[i][j] = new /datum/canonical_locus()
			junk.associate_with_locus(src.data[i][j])

	//assign genes to them
	var/genetypes = typesof(/datum/gene)
	genetypes -= /datum/gene //get rid of junk one
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
