/datum/canonical_locus
	var/default_allele = null
	var/datum/gene/associated_gene = null
	var/list/alleles = list(TOTAL_NUM_ALLELES)
	var/is_junk = 1

	New()
		if(!default_allele)
			default_allele = pick_allele()