// HOW TO ADD A NEW ACCESS LEVEL
// 1. Add it to the end of the list right below this. (Give it a number that isn't already taken.)
// 2. Add it to get_all_accesses() at the end.
// 3. Add a description of it to get_access_desc().
// 4. If you want people other than the captain to be able to access it, add it to get_access for the
// jobs you want to be able to access it.
//
// That's it! Now you can make doors on your map require that permission. Don't worry about things like
// making it show up in the ID computer - it will automatically. This is the only file you have to edit apart from
// the individual job files.

/var/const
	access_security = 1
	access_brig = 2
	access_security_lockers = 3
	access_forensics_lockers= 4
	access_security_records = 5
	access_medical_supplies = 6
	access_medical_records = 7
	access_morgue = 8
	access_tox = 9
	access_tox_storage = 10
	access_genetics = 11
	access_engine = 12
	access_eject_engine = 13
	access_maint_tunnels = 14
	access_external_airlocks = 15
	access_emergency_storage = 16
	access_apcs = 17
	access_change_ids = 18
	access_ai_upload = 19
	access_teleporter = 20
	access_eva = 21
	access_heads = 22
	access_captain = 23
	access_all_personal_lockers = 24
	access_chaplain_office = 25
	access_tech_storage = 26
	access_atmospherics = 27

/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/New()
	var/reset_req_access = 0
	if(!src.req_access_txt) return ..()
	var/req_access_str = params2list(req_access_txt)
	for(var/x in req_access_str)
		var/y = text2num(x)
		if(!y) continue
		if(!reset_req_access)
			req_access = list()
			reset_req_access = 1
		req_access += y
	..()

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	if(src.check_access(null))		return 1	//	it doesn't require any access at all
	if(istype(M, /mob/silicon/ai))	return 1	//	AI can do whatever it wants
	if(istype(M, /mob/carbon))
		if(src.check_access(M:id))			return 1	//	wearin an ID with access
		if(src.check_access(M:equipped()))	return 1	//	holding a card with access
	return 0

/obj/proc/check_access(obj/item/weapon/card/id/I)
	if(!src.req_access) return 1				//	no requirements
	if(!istype(src.req_access, /list)) return 1	//	something's very wrong

	var/list/L = src.req_access
	if(!L.len) return 1	//	no requirements
	if(!I || !istype(I, /obj/item/weapon/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in src.req_access)
		if(!(req in I.access)) return 0 //doesn't have this access
	return 1

/proc/get_all_accesses()
	return list(access_security, access_brig, access_security_lockers, access_forensics_lockers,
	            access_security_records, access_medical_supplies, access_medical_records, access_morgue, access_tox,
	            access_tox_storage, access_genetics, access_engine, access_eject_engine, access_maint_tunnels,
	            access_external_airlocks, access_emergency_storage, access_apcs, access_change_ids, access_ai_upload,
	            access_teleporter, access_eva, access_heads, access_captain, access_all_personal_lockers,
	            access_chaplain_office, access_tech_storage, access_atmospherics)

/proc/get_access_desc(A)
	switch(A)
		if(access_security)				return "access security"
		if(access_brig)					return "access the brig"
		if(access_security_lockers)		return "open security lockers"
		if(access_forensics_lockers)	return "open forensics lockers"
		if(access_security_records)		return "access security records"
		if(access_medical_supplies)		return "access medical supplies"
		if(access_medical_records)		return "access medical records"
		if(access_morgue)				return "access the morgue"
		if(access_tox)					return "access toxins"
		if(access_tox_storage)			return "access toxins storage"
		if(access_genetics)				return "access genetics"
		if(access_engine)				return "access the engine"
		if(access_eject_engine)			return "eject the engine"
		if(access_maint_tunnels)		return "access maintenance tunnels"
		if(access_external_airlocks)	return "open external airlocks"
		if(access_emergency_storage)	return "access emergency storage"
		if(access_apcs)					return "access APCs"
		if(access_change_ids)			return "change ID cards"
		if(access_ai_upload)			return "access the AI upload"
		if(access_teleporter)			return "access the teleporter"
		if(access_eva)					return "access EVA storage"
		if(access_heads)				return "access the heads' quarters"
		if(access_captain)				return "access the captain's quarters"
		if(access_all_personal_lockers)	return "open all personal lockers"
		if(access_chaplain_office)		return "access chaplain's office"
		if(access_tech_storage)			return "access technical storage"
		if(access_atmospherics)			return "access atmospherics"
	return "invalid access"

/proc/get_target_desc(mob/target) //return a useful string describing the target
	var/targetjob = null
	for(var/datum/data/record/R in data_core.general)
		if(R.fields["name"] == target.spawn_name)
			targetjob = R.fields["job"]
	return "[target.name] the [targetjob]"

/proc/get_mobs_with_job(datum/job/job)
	var/list/mobs = list()
	for(var/mob/M in world)
		if(istype(M.spawn_job, job))
			mobs += M
	return mobs
