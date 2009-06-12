/mob/carbon/proc/give_random_superpower()
	var/list/genes = list()
	for(var/i = 1; i <= NUM_CHROMOSOMES; i++)
		for(var/j = 1; j <= NUM_LOCI; j++)
			var/datum/canonical_locus/L = canonical_dna.data[i][j]
			var/datum/gene/G = L.associated_gene
			if(G.is_superpower)
				for(var/allele in L.alleles)
					if(L.alleles[allele] in G.attributes)
						genes[G] = list(i, j, allele)
	var/datum/gene/G = pick(genes)
	var/list/L = genes[G]
	var/i = L[1]
	var/j = L[2]
	var/allele = L[3]
	src.dna.data[i][j] = allele
	src.dna.apply(src)
	world << "GENE IS [G.type] MOB IS [src.name]"