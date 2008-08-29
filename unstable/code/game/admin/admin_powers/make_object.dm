/datum/admin_power/make_object
	panel_type = PANEL_TYPE_GAME

	New(adminlevel)
		if(adminlevel == ADMIN_MOD)
			del(src)

	Topic(href, href_list)
		if(href_list["display"])
			return DisplayMenu(usr)

		if(!href_list["ObjectList"]) return

		var/atom/loc = usr.loc
		var/object = href_list["ObjectList"]
		var/list/offset = dd_text2list(href_list["offset"],",")
		var/number = dd_range(1,500,text2num(href_list["number"]))
		var/X = ((offset.len>0)?text2num(offset[1]) : 0)
		var/Y = ((offset.len>1)?text2num(offset[2]) : 0)
		var/Z = ((offset.len>2)?text2num(offset[3]) : 0)

		for(var/i = 1 to number)
			switch(href_list["otype"])
				if("absolute")	new object(locate(0+X,0+Y,0+Z))
				if("relative")	if(loc) new object(locate(loc.x+X,loc.y+Y,loc.z+Z))
				else			return
		if(number == 1) world.log_admin("[usr.key] spawned an [object]")
		else			world.log_admin("[usr.key] spawned [number] of [object]")
		ss13_browse(usr, null, "window=admin_object_spawn")

	proc/DisplayMenu(var/mob/user)
		var/txt = {"<HTML><HEAD><TITLE>Spawn Object</TITLE></HEAD><BODY>
					<FORM NAME="Spawner" ACTION="?src=\ref[src]" METHOD="GET">
					Type  <INPUT TYPE="text" NAME="SearchBar" VALUE="/obj/" onKeyUp="updateSearch()" style="width:350px"><BR>
					Offset: <INPUT TYPE="text" NAME="offset" VALUE="x,y,z" style="width:250px">
					A <INPUT TYPE="radio" NAME="otype" VALUE="absolute">
					R <INPUT TYPE="radio" NAME="otype" VALUE="relative" checked="checked"><BR>
					Number: <INPUT TYPE="text" NAME="number"  VALUE="1" style="width:330px"><BR><BR>
					<SELECT NAME="ObjectList" id="ObjectList" size="20" multiple style="width:400px"></SELECT><BR>
					<INPUT TYPE="hidden" name="src" value="\ref[src]">
					<INPUT TYPE="submit" value="spawn">
					</FORM>

					<SCRIPT LANGUAGE="JavaScript">
						var OldSearch = "/obj/";
						var ObjectList = document.Spawner.ObjectList;
						var ObjectTypes = "[dd_list2text(typesof(/obj),";")]"
						var ObjectArray = ObjectTypes.split(";");
						populateList();

						function populateList()
						{
							var myElem
							ObjectList.options.length = 0;
							for(myElem in ObjectArray)
							{
								var oOption = document.createElement("OPTION");
								oOption.value = ObjectArray\[myElem\];
								oOption.text = ObjectArray\[myElem\];
								ObjectList.options.add(oOption);
							}
						}
						function updateSearch()
						{
							if(OldSearch == document.Spawner.SearchBar.value) return
							OldSearch = document.Spawner.SearchBar.value;
							ObjectArray = new Array();

							var TestElem;
							var TmpArray = ObjectTypes.split(";");
							for(TestElem in TmpArray)
							{
								if(OldSearch != TmpArray\[TestElem\].substring(0,OldSearch.length)) continue;
								ObjectArray.push(TmpArray\[TestElem\]);
							}
							populateList();
						}
					</SCRIPT></BODY></HTML>"}
		ss13_browse(user, txt, "window=admin_object_spawn;size=425x475")

	get_desc()
		return "<a href='?src=\ref[src];display=1'>Make object</a>"
