/datum/canonical_locus
	var/is_junk = 1
	var/default_allele = null
	var/datum/gene/associated_gene = null
	var/list/alleles = list(TOTAL_NUM_ALLELES)

	New()
		if(!default_allele)
			default_allele = pick_allele()