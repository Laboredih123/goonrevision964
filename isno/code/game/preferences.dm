/datum/preferences
	var/name = ""
	var/gender = MALE
	var/datum/job/job1 = null
	var/datum/job/job2 = null
	var/datum/job/job3 = null
	var/skin_color = SKIN_COLOR_LIGHT
	var/hair_color = HAIR_COLOR_BROWN
	var/hair_style = HAIR_STYLE_SHORT
	var/last_version //md5 of changelog, to keep track of the most recent version of ss13 they've seen
	var/be_syndicate = "No"
	var/savefile_loc = null

/datum/preferences/proc/load()
	if(!fexists(src.savefile_loc))
		return 0
	var/savefile/F = new /savefile(src.savefile_loc, -1)
	F["name"] >> src.name
	F["gender"] >> src.gender
	var/j1type
	var/j2type
	var/j3type
	F["job1"] >> j1type
	F["job2"] >> j3type
	F["job3"] >> j3type
	if(j1type)
		src.job1 = get_job_instance_by_type(j1type)
	if(j2type)
		src.job2 = get_job_instance_by_type(j2type)
	if(j3type)
		src.job3 = get_job_instance_by_type(j3type)
	F["hair_color"] >> src.hair_color
	F["hair_style"] >> src.hair_style
	F["skin_color"] >> src.skin_color
	F["be_syndicate"] >> src.be_syndicate
	F["last_version"] >> src.last_version
	return 1

/datum/preferences/proc/save()
	var/savefile/F = new /savefile(src.savefile_loc, -1)
	F["name"] << src.name
	F["gender"] << src.gender
	F["job1"] << (src.job1 ? src.job1.type : null)
	F["job2"] << (src.job2 ? src.job2.type : null)
	F["job3"] << (src.job3 ? src.job3.type : null)
	F["hair_color"] << src.hair_color
	F["hair_style"] << src.hair_style
	F["skin_color"] << src.skin_color
	F["be_syndicate"] << src.be_syndicate
	F["last_version"] << md5(changes)

/datum/preferences/proc/setup(var/client/M)
	if(!M)
		return
	if(!length(trim(src.name)))
		src.name = M.key
	if(!(src.gender in list(MALE, FEMALE)))
		src.gender = MALE
	if(!(src.skin_color in get_skin_colors()))
		src.skin_color = SKIN_COLOR_LIGHT
	if(!(src.hair_color in get_hair_colors()))
		src.hair_color = HAIR_COLOR_BROWN
	if(!(src.hair_style in get_hair_styles()))
		src.hair_style = HAIR_STYLE_SHORT
	if(!(src.be_syndicate in list("Yes", "No")))
		src.be_syndicate = "No"
	if(!(src.job1))
		src.job1 = null
		src.job2 = null
		src.job3 = null

	var/dat = "<html><body>"
	var/vars = list(
		"gender" = src.gender,
		"skin_color" = src.skin_color,
		"hair_color" = src.hair_color,
		"hair_style" = src.hair_style,
		"prefer_syndicate" = src.be_syndicate
	)

	dat += "<B>Name: </B> <A href=\"byond://?src=\ref[src];name=input\"><B>[capitalize(src.name)]</A></B> (<A href=\"byond://?src=\ref[src];name=random\">&reg;</A>)<BR>"

	for(var/x in vars)
		dat += "<b>[capitalize(dd_replacetext(x,"_"," "))]: </b>"
		dat += "<a href=\"byond://?src=\ref[src];[x]=input\"><b>[capitalize(vars[x])]</b></a><br>"
	dat += "<hr>"

	dat += "<b>Job Choices</b>:<br>"
	dat += "First Choice: <a href=\"byond://?src=\ref[src];job=1\">[src.job1 ? "<b>[src.job1.name]</b>" : "No Preference"]</a><br>"
	if (src.job1)
		dat += "Second Choice: <a href=\"byond://?src=\ref[src];job=2\">[src.job2 ? "<b>[src.job2]</b>" : "No Preference"]</a><br>"
		if(src.job2)
			dat += "Third Choice: <a href=\"byond://?src=\ref[src];job=3\">[src.job3 ? "<b>[src.job3]</b>" : "No Preference"]</a><br>"
	dat += "<hr>"
	dat += "<br><a href='byond://?src=\ref[src];reset=1'>Reset</a>"
	dat += "<h2><a href='byond://?src=\ref[src];ready=1'>Ready</a></h2>"
	dat += "</body></html>"
	ss13_browse(M, dat, "window=mob_jobs;size=300x600;can_close=[!M.mob || !istype(M.mob,/mob/prespawn)]")

/datum/preferences/Topic(href, href_list)
	if(href_list["name"])
		switch(href_list["name"])
			if("input")		src.name = capitalize(scrub_input("What is your character's name?", "Character Generation", src.name))
			if("random")
				var/first_name
				if(src.gender == MALE)
					first_name = pick(first_names_male)
				else
					first_name = pick(first_names_female)
				src.name = strip_html(capitalize(first_name) + " " + capitalize(pick(last_names)))
	else if(href_list["gender"])
		if(src.gender == MALE)
			src.gender = FEMALE
		else
			src.gender = MALE
	else if(href_list["skin_color"])
		src.choose_skin_color()
	else if(href_list["hair_color"])
		src.choose_hair_color()
	else if(href_list["hair_style"])
		src.choose_hair_style()
	else if(href_list["job"])
		src.choose_job(text2num(href_list["job"]))
	else if(href_list["reset"])
		var/loaded = src.load()
		if(!loaded)
			src = new()
	else if(href_list["prefer_syndicate"])
		if(src.be_syndicate == "No") src.be_syndicate = "Yes"
		else src.be_syndicate = "No"
	else if(href_list["ready"])
		if(!istype(usr,/mob/prespawn))
			ss13_browse(usr, null, "window=mob_jobs")
			return save()

		var/mob/prespawn/new_player = usr

		if(!new_player.client.authenticated)
			usr << "You are not authorized to enter the game. If you are not a member of the Something Awful forums, you aren't allowed to play on this server. If you are, visit http://byond.lljk.net and register your username."
			return
		if(!enter_allowed)
			usr << "\blue There is an administrative lock on entering the game!"
			return
		for (var/mob/carbon/H in world)
			if (cmptext(H.spawn_name, src.name))
				usr << "You are using a name that is very similar to a currently used name, please choose another one using Character Setup."
				return
		for (var/mob/prespawn/P in world)
			if (cmptext(P.name, src.name) && P != usr)
				usr << "You are using a name that is very similar to a currently used name, please choose another one using Character Setup."
				return
		save()
		ss13_browse(usr, null, "window=mob_jobs")
		if(new_player.ready)
			return //	they clicked ready before

		new_player.ready = 1
		world.log_game("[usr.key] entered as [usr.name]")

		if (game_started)
			config.current_mode.give_newcomer_job(new_player)
		return
	spawn()
		src.setup(usr.client)

//----------------------------------------------------------------------------

/var/const
	SKIN_COLOR_DARK = "dark"
	SKIN_COLOR_LIGHT = "light"
	SKIN_COLOR_MEDIUM = "medium"

/proc/get_skin_colors()
	return list(
		SKIN_COLOR_DARK,
		SKIN_COLOR_MEDIUM,
		SKIN_COLOR_LIGHT
	)


/datum/preferences/proc/choose_skin_color()
	src.skin_color = input("Select a skin color", "Character Generation", src.skin_color) in get_skin_colors()

//----------------------------------------------------------------------------

/var/const
	HAIR_COLOR_BROWN = "brown"
	HAIR_COLOR_BLACK = "black"
	HAIR_COLOR_WHITE = "white"
// removing blond hair due to reduction in # of alleles
//	HAIR_COLOR_BLOND = "blond"
	HAIR_COLOR_GREY  = "grey"

/proc/get_hair_colors()
	return list(
		HAIR_COLOR_BROWN,
		HAIR_COLOR_BLACK,
		HAIR_COLOR_WHITE,
		HAIR_COLOR_GREY,
// removing blond hair due to reduction in # of alleles
//		HAIR_COLOR_BLOND
	)

/datum/preferences/proc/choose_hair_color()
	src.hair_color = input("Select a hair color", "Character Generation", src.hair_color) in get_hair_colors()
//----------------------------------------------------------------------------

/var/const
	HAIR_STYLE_SHORT = "short"
	HAIR_STYLE_LONG = "long"
	HAIR_STYLE_BALD = "bald"
	HAIR_STYLE_CUT = "cut"

/proc/get_hair_styles()
	return list(
		HAIR_STYLE_SHORT,
		HAIR_STYLE_LONG,
		HAIR_STYLE_CUT,
		HAIR_STYLE_BALD
	)

/datum/preferences/proc/choose_hair_style()
	src.hair_style = input("Select a hair style", "Character Generation", src.hair_style) in get_hair_styles()

//----------------------------------------------------------------------------

//TODO: make all this use a list instead of 3 variables

/datum/preferences/proc/choose_job(job_num)
	var/list/L = list()
	for(var/datum/job/j in get_all_job_instances())
		if(allowed_to_do_job(usr, j) && j.max > 0) // make sure its not a /datum/job
			L[j.name] = j
	L["No Preference"] = null
	var/curr_job = "No Preference"
	if(job_num == 1 && src.job1)
		curr_job = src.job1.name
	if(job_num == 2 && src.job2)
		curr_job = src.job2.name
	if(job_num == 3 && src.job3)
		curr_job = src.job3.name

	var/job = input("Select a job", "Character Generation", curr_job) in L
	switch(job_num)
		if(1)	src.job1 = L[job]
		if(2)	src.job2 = L[job]
		if(3)	src.job3 = L[job]
