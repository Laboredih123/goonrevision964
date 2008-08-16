/mob/silicon/ai/proc/getLaw(var/index)
	if (src.laws.len < index+1)
		src << text("Error: Invalid law index [] for getLaw. Writing out list of laws for debug purposes.", index)
		showLaws(0)
	else
		return src.laws[index+1]

/mob/silicon/ai/proc/show_laws()
	set category = "AI Commands"
	set name = "Show Laws"
	src.showLaws(0)

/mob/silicon/ai/proc/showLaws(var/toAll=0)
	var/showTo = src
	if (toAll)
		showTo = world
	else
		src << "<b>Obey these laws:</b>"

	var/lawIndex = 0
	for (var/index=1, index<=src.laws.len, index++)
		var/law = src.laws[index]
		if (length(law)>0)
			if (index==2 && lawIndex==0)
				lawIndex = 1
			showTo << text("[]. []", lawIndex, law)
			lawIndex += 1

/mob/silicon/ai/proc/addLaw(var/number, var/law)
	while (src.laws.len < number+1)
		src.laws += ""
	src.laws[number+1] = law