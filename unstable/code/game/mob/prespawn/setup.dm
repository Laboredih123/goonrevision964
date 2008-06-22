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
		ready = 0
		savefile_loc
		const/SAVEFILE_EXTENSION = "sav"
	opacity = 0
	density = 0
	icon = null
	icon_state = null
	loc = null

/mob/prespawn/New()
	..()
	src.verbs -= /mob/verb/add_memory
	src.verbs -= /mob/verb/cancel_camera
	src.verbs -= /mob/verb/memory
	src.verbs -= /mob/verb/observe
	src.verbs -= /mob/verb/respawn
	src.verbs -= /mob/verb/say
	src.verbs -= /mob/verb/succumb

	src.client.eye = null

	src.savefile_loc = "savefiles/[savefile_ver]/[src.ckey].[SAVEFILE_EXTENSION]"
	src.savefile_load()

	if(!src.char_last_version || src.char_last_version != md5(changes)) //they havent seen this changelog
		src.changes()

	src.char_setup()

	return

mob/prespawn/proc/savefile_load()
	if (fexists(src.savefile_loc))
		var/savefile/F = new /savefile(src.savefile_loc)
		F["name"] >> src.char_name
		F["gender"] >> src.char_gender
		F["job1"] >> src.char_job1
		F["job2"] >> src.char_job2
		F["job3"] >> src.char_job3
		F["hair_color"] >> src.char_hair_color
		F["hair_style"] >> src.char_hair_style
		F["skin_color"] >> src.char_skin_color
		F["last_version"] >> src.char_last_version
		return 1
	else
		return 0

/mob/prespawn/proc/savefile_write()
	var/savefile/F = new /savefile(src.savefile_loc)
	F["name"] << src.char_name
	F["gender"] << src.char_gender
	F["job1"] << src.char_job1
	F["job2"] << src.char_job2
	F["job3"] << src.char_job3
	F["hair_color"] << src.char_hair_color
	F["hair_style"] << src.char_hair_style
	F["skin_color"] << src.char_skin_color
	F["last_version"] << md5(changes)

/mob/prespawn/Topic(href, href_list)
	if(src != usr)
		return ..()
	if(href_list["name"])
		src.char_name = input("What is your character's name?", "Character Generation", src.char_name) as text
	if(href_list["gender"])
		src.char_gender = input("Select a gender", "Character Generation", src.char_gender) in list(MALE, FEMALE)
	if(href_list["skin_color"])
		src.choose_skin_color()
	if(href_list["hair_color"])
		src.chooose_hair_color()
	if(href_list["hair_style"])
		src.choose_hair_style()
	if(href_list["job"])
		src.choose_job(text2num(href_list["job"]))
	if(href_list["ready"])
		src.ready = 1
		savefile_write()
	if(href_list["reset"])
		var/loaded = src.savefile_load()
		if(!loaded)
			src.char_name = initial(src.char_name)
			src.char_gender = initial(src.char_gender)
			src.char_job1 = initial(src.char_job1)
			src.char_job2 = initial(src.char_job2)
			src.char_job3 = initial(src.char_job3)
			src.char_hair_color = initial(src.char_hair_color)
			src.char_hair_style = initial(src.char_hair_style)
			src.skin = initial(src.skin)
	return ..()

/mob/prespawn/verb/char_setup()
	var/list/destructive = assistant_occupations.Copy()
	var/dat = "<html><body>"
	var/vars = list(
		"name" = src.char_name,
		"gender" = src.char_gender,
		"skin_color" = src.char_skin_color,
		"hair_color" = src.char_hair_color,
		"hair_style" = src.char_hair_style
	)
	for(var/x in vars)
		dat += "<b>[capitalize(dd_replacetext(x,"_"," "))]:</b>"
		dat += "<a href=\"byond://?src=\ref[src];[x]=input\"><b>[vars[x]]</b></a><br>"

	dat += "<hr>"

	dat += "<b>Occupation Choices</b>:<br>"
	dat += "First Choice: <a href=\"byond://?src=\ref[src];job=1\">[src.job1 == "No Preference" ? "No Preference" : "<b>[src.job1]</b>"]</a><br>"
	if (src.job1 != "No Preference")
		dat += "Second Choice: <a href=\"byond://?src=\ref[src];job=2\">[src.job2 == "No Preference" ? "No Preference" : "<b>[src.job2]</b>"]</a><br>"
		if (src.occupation2 != "No Preference")
			dat += "Third Choice: <a href=\"byond://?src=\ref[src];job=3\">[src.job3 == "No Preference" ? "No Preference" : "<b>[src.job2]</b>"]</a><br>"

	dat += "<a href='byond://?src=\ref[src];done=1'>Ready</a><br>"
	dat += "<a href='byond://?src=\ref[src];reset=1'>Reset</a><br>"
	dat += "</body></html>"
	src << browse(dat, "window=mob_occupations;size=300x600")
	return