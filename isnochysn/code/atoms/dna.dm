/datum/dna
	var/list/loci
	var/const/num_loci = 23

	New()
		loci = list()
		for(var/i = 0; i < num_loci; i++)
			loci += new /datum/locus()

/datum/locus
	var/list/alleles
	var/const/num_alleles = 10

	New()
		alleles = list()
		for(var/i = 0; i < num_alleles; i++)
			alleles += new datum/allele()

/datum/allele