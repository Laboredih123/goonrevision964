/datum/canonical_locus
	var/is_junk = 1
	var/default_allele = get_rand_allele()
	var/datum/gene/associated_gene = null
	var/list/alleles = list(TOTAL_NUM_ALLELES)