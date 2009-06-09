/mob/ai/var/last_lockdown = null

/mob/ai/proc/lockdown()
	set name = "Lockdown"
	set category = "AI Commands"

	if(src.stat == 2)
		src <<"You cannot initiate lockdown because you are dead!"
		return

	if(src.last_lockdown + 100 > ss13time())
		src << "You locked down too recently! Wait a few seconds first."
		return

	src.last_lockdown = ss13time()

	begin_lockdown(src)

	src.verbs += /mob/ai/proc/disablelockdown

/mob/ai/proc/disablelockdown()
	set name = "Disable Lockdown"
	set category = "AI Commands"

	if(src.stat == 2)
		src <<"You cannot disable lockdown because you are dead!"
		return

	end_lockdown(src)

	src << "\red Disable lockdown command disabled until lockdown engaged again!"

	while(/mob/ai/proc/disablelockdown in src.verbs)
		src.verbs -= /mob/ai/proc/disablelockdown