/proc/shuffle(var/list/shufflelist)
	if (!shufflelist)
		return

	var/list/old_list = shufflelist.Copy()
	var/list/new_list = list()

	while(old_list.len)
		var/item = old_list[rand(1, old_list.len)]
		new_list += item
		old_list -= item

	return new_list

/proc/uniquelist(var/list/L)
	var/list/K = list()
	for(var/item in L)
		if (!(item in K))
			K += item
	return K

/proc/sanitize(var/t)
	var/index = findtext(t, "\n")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\n")

	index = findtext(t, "\t")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\t")

	return t

/proc/add_zero(t, u)
	while (length(t) < u)
		t = "0[t]"
	return t

/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	return t

/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	return t

/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

/proc/trim_right(text)
	for (var/i = length(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)

	return ""

/proc/trim(text)
	return trim_left(trim_right(text))

/proc/capitalize(var/t as text)
	return uppertext(copytext(t, 1, 2)) + copytext(t, 2)

/proc/findname(msg)
	for(var/mob/M in world)
		if (M.spawn_name == msg)
			return 1
	return 0

/proc/sortList(var/list/L)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return mergeLists(sortList(L.Copy(0,middle)), sortList(L.Copy(middle))) //second parameter null = to end of list

/proc/sortNames(var/list/L)
	var/list/Q = new()
	for(var/atom/x in L)
		Q[x.name] = x
	return sortList(Q)

/proc/mergeLists(var/list/L, var/list/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R[Ri++]
		else
			result += L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))



/proc/dd_file2list(file_path, separator)

	var/file
	if (separator == null)
		separator = "\n"
	if (isfile(file_path))
		file = file_path
	else
		file = file( file_path )
	return dd_text2list(file2text(file), separator)
	return

/proc/dd_replacetext(text, search_string, replacement_string)

	var/textList = dd_text2list(text, search_string)
	return dd_list2text(textList, replacement_string)
	return

/proc/dd_replaceText(text, search_string, replacement_string)

	var/textList = dd_text2List(text, search_string)
	return dd_list2text(textList, replacement_string)
	return

/proc/dd_hasprefix(text, prefix)

	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)
	return

/proc/dd_hasPrefix(text, prefix)

	var/start = 1
	var/end = length(prefix) + 1
	return findText(text, prefix, start, end)
	return

/proc/dd_hassuffix(text, suffix)

	var/start = length(text) - length(suffix)
	if (start)
		return findtext(text, suffix, start, null)
	return

/proc/dd_hasSuffix(text, suffix)

	var/start = length(text) - length(suffix)
	if (start)
		return findText(text, suffix, start, null)
	return

/proc/dd_text2list(text, separator)

	var/textlength = length(text)
	var/separatorlength = length(separator)
	var/textList = new /list(  )
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtext(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		textList += text("[]", buggyText)
		searchPosition = findPosition + separatorlength
		if (findPosition == 0)
			return textList
		else
			if (searchPosition > textlength)
				textList += ""
				return textList
	return

/proc/dd_text2List(text, separator)

	var/textlength = length(text)
	var/separatorlength = length(separator)
	var/textList = new /list(  )
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findText(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		textList += text("[]", buggyText)
		searchPosition = findPosition + separatorlength
		if (findPosition == 0)
			return textList
		else
			if (searchPosition > textlength)
				textList += ""
				return textList
	return

/proc/dd_list2text(var/list/the_list, separator)

	var/total = the_list.len
	if (total == 0)
		return
	var/newText = text("[]", the_list[1])
	var/count = 2
	while(count <= total)
		if (separator)
			newText += separator
		newText += text("[]", the_list[count])
		count++
	return newText
	return

/proc/dd_centertext(message, length)

	var/new_message = message
	var/size = length(message)
	if (size == length)
		return new_message
	if (size > length)
		return copytext(new_message, 1, length + 1)
	var/delta = length - size
	if (delta == 1)
		return new_message + " "
	if (delta % 2)
		new_message = " " + new_message
		delta--
	delta = delta / 2
	var/spaces = ""
	var/count = null
	count = 1
	while(count <= delta)
		spaces += " "
		count++
	return spaces + new_message + spaces
	return

/proc/dd_limittext(message, length)

	var/size = length(message)
	if (size <= length)
		return message
	else
		return copytext(message, 1, length + 1)
	return
