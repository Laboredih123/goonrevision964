//TODO: make all this use a list instead of 3 variables

/mob/prespawn/proc/choose_job(job_num)
	var/jobs = uniquelist(occupations + assistant_occupations + "Captain")
	var/curr_job
	switch(job_num)
		if(1)
			curr_job = src.char_job_1
		if(2)
			curr_job = src.char_job_2
		if(3)
			curr_job = src.char_job_3
	var/job = input("Select a job", "Character Generation", curr_job) in jobs
	switch(job_num)
		if(1)
			src.char_job_1 = job
		if(2)
			src.char_job_2 = job
		if(3)
			src.char_job_3 = job