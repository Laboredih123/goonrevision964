/datum/gene
	var/const/JUNK = 0

	var/attributes = list(JUNK)
	var/num_alleles = 1

	//the default value of this gene for a standard /mob/carbon
	var/default = JUNK

	//if fill_with is null, make the attributes be evenly divided among the alleles
	//if it's not, give each of the attributes one allele and give the rest to fill_with
	var/fill_with = null

/datum/gene/proc/update_mob(mob/carbon/M, attribute) //grants attribute number "attribute" to M
	if(!istype(M, /mob/carbon))
		return 0
	return 1

/datum/gene/proc/associate_with_loci(/datum/dna/canonical/D)
	for(var/i = 0; i < src.num_alleles; i++)
		var/canonical_locus/locus = D.get_random_junk_locus()
		locus.is_junk = 0
		locus.associated_gene = src

		if(fill_with)
			//fill with the fill_with value
			for(var/allele in get_all_alleles())
				locus.alleles[allele] = fill_with

			//add in 1 copy each of the rest
			var/used = list()
			for(var/attr in attributes)
				var/allele = pick(get_all_alleles_except(used))
				locus.alleles[allele] = attr
				used += allele
		else //
			//fill the list with the things in attributes, one by one
			var/unused = get_all_alleles()
			var/attr_index = 1
			while(unused.len)
				var/allele = pick(unused)
				unused -= allele
				locus.alleles[allele] = attributes[attr_index]
				attr_index++
				if(attr_index > attributes.len)
					attr_index = 1
