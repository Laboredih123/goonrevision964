/datum/canonical_locus
	var/default_allele = null
	var/datum/gene/associated_gene = null
	var/list/alleles = list()
	var/is_junk = 1

	New()
		if(!src.default_allele)
			src.default_allele = pick_allele()