/mob/prespawn
	var
		char_name = ""
		char_gender = MALE
		char_job1 = "No Preference"
		char_job2 = "No Preference"
		char_job3 = "No Preference"
		char_skin_color = SKIN_COLOR_LIGHT
		char_hair_color = HAIR_COLOR_BROWN
		char_hair_style = HAIR_STYLE_SHORT
		char_last_version //md5 of changelog, to keep track of the most recent version of ss13 they've seen
		char_be_syndicate = "No"
		ready = 0
		savefile_loc = null
		const/SAVEFILE_EXTENSION = "sav"
	opacity = 0
	density = 0
	icon = null
	icon_state = null

/mob/prespawn/New()
	world << "new prespawn"
	..()
	src.verbs -= /mob/verb/add_memory
	src.verbs -= /mob/verb/cancel_camera
	src.verbs -= /mob/verb/memory
	src.verbs -= /mob/verb/observe
	src.verbs -= /mob/verb/respawn

	return

mob/prespawn/proc/savefile_load()
	world << src.savefile_loc
	if (fexists(src.savefile_loc))
		var/savefile/F = new /savefile(src.savefile_loc, -1)
		F["name"] >> src.char_name
		F["gender"] >> src.char_gender
		F["job1"] >> src.char_job1
		F["job2"] >> src.char_job2
		F["job3"] >> src.char_job3
		F["hair_color"] >> src.char_hair_color
		F["hair_style"] >> src.char_hair_style
		F["skin_color"] >> src.char_skin_color
		F["be_syndicate"] >> src.char_be_syndicate
		F["last_version"] >> src.char_last_version
		return 1
	else
		world << "no file"
		return 0

/mob/prespawn/proc/savefile_write()
	var/savefile/F = new /savefile(src.savefile_loc, -1)
	F["name"] << src.char_name
	F["gender"] << src.char_gender
	F["job1"] << src.char_job1
	F["job2"] << src.char_job2
	F["job3"] << src.char_job3
	F["hair_color"] << src.char_hair_color
	F["hair_style"] << src.char_hair_style
	F["skin_color"] << src.char_skin_color
	F["be_syndicate"] << src.char_be_syndicate
	F["last_version"] << md5(changes)

/mob/prespawn/Topic(href, href_list)
	if(src != usr)
		return ..()
	if(href_list["ready"])
		for (var/mob/carbon/H in world)
			if (cmptext(H.spawn_name, src.char_name))
				usr << "You are using a name that is very similar to a currently used name, please choose another one using Character Setup."
				return
		src.ready = 1
		savefile_write()
		src << browse(null, "window=mob_occupations")
		if (ticker)
			var/list/L = assistant_occupations
			var/job
			if (L.Find(src.char_job1))
				job = src.char_job1
			else if (L.Find(src.char_job2))
				job = src.char_job2
			else if (L.Find(src.char_job3))
				job = src.char_job3
			else
				job = pick(L)
			var/joined_late = 1
			src.Assign_Rank(job, joined_late)

		return ..()
	if(href_list["name"])
		src.char_name = input("What is your character's name?", "Character Generation", src.char_name) as text
	else if(href_list["gender"])
		src.char_gender = input("Select a gender", "Character Generation", src.char_gender) in list(MALE, FEMALE)
	else if(href_list["skin_color"])
		src.choose_skin_color()
	else if(href_list["hair_color"])
		src.choose_hair_color()
	else if(href_list["hair_style"])
		src.choose_hair_style()
	else if(href_list["job"])
		src.choose_job(text2num(href_list["job"]))

	else if(href_list["reset"])
		var/loaded = src.savefile_load()
		if(!loaded)
			src.char_name = initial(src.char_name)
			src.char_gender = initial(src.char_gender)
			src.char_job1 = initial(src.char_job1)
			src.char_job2 = initial(src.char_job2)
			src.char_job3 = initial(src.char_job3)
			src.char_hair_color = initial(src.char_hair_color)
			src.char_hair_style = initial(src.char_hair_style)
			src.char_skin_color = initial(src.char_skin_color)
	else if(href_list["prefer_syndicate"])
		src.char_be_syndicate = input("Would you like to be eligible for playing as Syndicate?", "Character Generation", src.char_be_syndicate) in list("Yes", "No")
	else
		return ..()
	spawn()
		char_setup()

/mob/prespawn/verb/char_setup()
	if(!src.char_name)
		if(src.client)
			src.char_name = src.client.key
		else
			src.char_name = "Cool Person"
	if(!(src.char_gender in list(MALE, FEMALE)))
		src.char_gender = MALE
	if(!(src.char_skin_color in get_skin_colors()))
		src.char_skin_color = SKIN_COLOR_LIGHT
	if(!(src.char_hair_color in get_hair_colors()))
		src.char_hair_color = HAIR_COLOR_BROWN
	if(!(src.char_hair_style in get_hair_styles()))
		src.char_hair_style = HAIR_STYLE_SHORT
	if(!(src.char_be_syndicate in list("Yes", "No")))
		src.char_be_syndicate = "No"
	if(!(src.char_job1))
		src.char_job1 = "No Preference"
		src.char_job2 = "No Preference"
		src.char_job3 = "No Preference"

	var/dat = "<html><body>"
	var/vars = list(
		"name" = src.char_name,
		"gender" = src.char_gender,
		"skin_color" = src.char_skin_color,
		"hair_color" = src.char_hair_color,
		"hair_style" = src.char_hair_style,
		"prefer_syndicate" = src.char_be_syndicate
	)
	for(var/x in vars)
		dat += "<b>[capitalize(dd_replacetext(x,"_"," "))]: </b>"
		dat += "<a href=\"byond://?src=\ref[src];[x]=input\"><b>[capitalize(vars[x])]</b></a><br>"
//	dat += text("Prefer Syndicate: <a href=\"byond://?src=\ref[];char_be_syndicate=[]\"><b>[]</b></a><br>", src, src.char_be_syndicate, src.char_be_syndicate)
	dat += "<hr>"

	dat += "<b>Occupation Choices</b>:<br>"
	dat += "First Choice: <a href=\"byond://?src=\ref[src];job=1\">[src.char_job1 == "No Preference" ? "No Preference" : "<b>[src.char_job1]</b>"]</a><br>"
	if (src.char_job1 != "No Preference")
		dat += "Second Choice: <a href=\"byond://?src=\ref[src];job=2\">[src.char_job2 == "No Preference" ? "No Preference" : "<b>[src.char_job2]</b>"]</a><br>"
		if (src.char_job2 != "No Preference")
			dat += "Third Choice: <a href=\"byond://?src=\ref[src];job=3\">[src.char_job3 == "No Preference" ? "No Preference" : "<b>[src.char_job2]</b>"]</a><br>"
	dat += "<hr>"
	dat += "<br><a href='byond://?src=\ref[src];reset=1'>Reset</a>"
	dat += "<h2><a href='byond://?src=\ref[src];ready=1'>Ready</a></h2>"
	dat += "</body></html>"
	src << browse(dat, "window=mob_occupations;size=300x600;can_close=0")
	return
