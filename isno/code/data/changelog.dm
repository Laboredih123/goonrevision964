var/changes = {"<font color='blue'><b>Recent changes (apart from bugfixes etc)</b></font>
<hr>

<p><b>Tuesday, June 30, 2009</b></p>
<ul>
<li><b>899</b> - Constructing things like walls, racks, tables, etc, is now logged, so it's much easier to find out
who the douchebags that build 80 walls all over the station are and ban them.</li>

<p><b>Monday, June 29, 2009</b></p>
<ul>
<li><b>896</b> - CO2 and sleeping gas will now make your oxygen meter turn red.</li>
<li><b>895</b> - Added freeform AI module, thanks Pantaloons!</li>
<li><b>894</b> - Changed "escape alone" multitraitor objective to "prevent any nontraitors from escaping."</li>
</ul>

<p><b>Sunday, June 28, 2009</b></p>
<ul>
<li><b>888</b> - Added Thunderbeast's space tiles, at least for now. Doors should no longer hold fires in.</li>
<li><b>884</b> - Added "jump" verb for observers and admins.</li>
<li><b>882</b> - Replaced most rwalls with regular walls, except in the engine, plasma storage areas, and the
room storing the captain's spare ID. Electrified the grilles at the northeast of the engine, so it's not TOO
easy to release engine fire.</li>
<li><b>880</b> - Ripped out code relating to nukes, changed nuke disk to a codes disk.</li>
</ul>

<p><b>Saturday, June 27, 2009</b></p>
<ul>
<li><b>878</b> - Added "show AI laws" admin power.</li>
</ul>

<p><b>Friday, June 26, 2009</b></p>
<ul>
<li><b>872</b> - Rebalanced weapons. Many things now knock people down rather than knocking them out most of the
time, so if they have a radio that isn't being jammed they can call for help. Traitors still have plenty of ways to
prevent this, of course, so it should only really fuck over griefers.</li>
<li><b>870</b> - Brig computer now gives a list of suggested sentences.</li>
<li><b>869</b> - Removed the wardrobes and black jumpsuits that litter the station. Hopefully this will stop moron
pubbie security officers from wearing colors other than red as much.</li>
<li><b>866</b> - Posters are now a traitor item, costing 0.2 charges. Hopefully people will use them in rev mode (or
in other modes, to throw people off their trail).</li>
<li><b>861</b> - Admins now get their powers as soon as they log in, rather than having to wait a few seconds.</li>
<li><b>859</b> - Lawyer suit on the bridge.</li>
</ul>

<p><b>Thursday, June 25, 2009</b></p>
<ul>
<li><b>858</b> - Reorganized and compacted security and forensics, added courtroom.</li>
<li><b>857</b> - You can no longer set headsets to perma-transmit. Hopefully this will get new people to actually
read the MOTD and use say "; blah blah" (but probably not).</li>
<li><b>856</b> - Rwalls now do not produce any byproducts during deconstruction except at the very end. This will
hopefully make them less painful to destroy.</li>
<li><b>855</b> - Observers can now use examine (and, if they're admins, delete and variables) verb while observing
a person. AIs and cameras cannot, unfortuntely.</li>
<li><b>854</b> - Added "freeze" ability, so admins can prevent people from causing more havoc while they ask them
questions. Monkeys (and people who disconnect) now wander around and emote significantly less.</li>
</ul>

<p><b>Wednesday, June 24, 2009</b></p>
<ul>
<li><b>853</b> - Added a second monkey holding area to genetics, in case you want to go through all the monkeys and
test them for superpowers or something. Also added oxygen tank dispenser.</li>
</ul>

<p><b>Tuesday, June 23, 2009</b></p>
<ul>
<li><b>851</b> - Added handcuff remover in brig, so prisoners aren't stuck in their cuffs the whole time when
security are lazy.</li>
</ul>

<p><b>Monday, June 22, 2009</b></p>
<ul>
<li><b>848</b> - Added radio jammer traitor item, which prevents radios within 6 tiles from operating. This should
make it easier for traitors to kill people undetected without making it even easier to grief.</li>
</ul>

<p><b>Sunday, June 21, 2009</b></p>
<ul>
<li><b>845</b> - Fire now does significantly less damage. Needs further testing to be sure if it's balanced.</li>
<li><b>844</b> - Split EVA into secure (jetpacks) and regular (everything else) sections. Technicians have access to
regular EVA.</li>
<li><b>843</b> - Outer brig doors are now remote openable from inside the cell, so prisoners can get out but people
can't steal their stuff.</li>
<li><b>842</b> - Some map changes - people now start on a shuttle instead of in crew quarters, death commando
shuttle now is south of where it used to be, and security area is redesigned. Brig redone - cells are now two rooms,
with an outer room for putting the convict's gear in and an inner room for putting the convict himself in (so people
don't steal their stuff). Inner room automatically releases after 5 minutes by default. The period can be adjusted
by security at the brig computer. When they're released, an announcement is made on the station about why they were
imprisoned and how long they were imprisoned. This isn't quite complete yet, since they have no way to get out of
the outer room or free themselves from handcuffs. Both of these problems should be fixed soon.</li>
</ul>

<p><b>Saturday, June 20, 2009</b></p>
<ul>
<li><b>841</b> - Attacks and most other aggressive actions are now permanently logged. This should help stop some
griefing.</li>
</ul>

<p><b>Friday, June 19, 2009</b></p>
<ul>
<li><b>834</b> - Modified jobban system to use existing ban system, rather than a less-robust, less-featureful one.
Jobbans should now be much more difficult to evade, and can last for periods of time other than "forever."</li>
</ul>

<p><b>Thursday, June 18, 2009</b></p>
<ul>
<li><b>833</b> - Admins can now PM people by right-clicking them.</li>
<li><b>832</b> - Slight adjustment to admin system. Rather than a strict hierarchy of admins, there are now several
independent types of admin, and you can be any or all of them. The admin types are GM, Mod, Admin, Superadmin,
Developer, and Host. GMs can do game-related things like spawning items, starting the game, changing the mode, etc.
Mods, admins, and superadmins can ban people, mute people, and jobban people, for lengths of time depending on their
admin level (admins can ban for longer than mods, and superadmins longer still). Developers can view variables and
do various other debugging-related things. Hosts can do everything.</li>
</ul>

<p><b>Wednesday, June 17, 2009</b></p>
<ul>
<li><b>830</b> - You can now choose to spawn as an observer if you join midgame, rather than having to kill yourself
if you don't want to play.</li>
<li><b>829</b> - Dead folks can now hear everything anyone says. Improved emote help.
</li>
<li><b>828</b> - Engine now ejects to z-level 3 instead of 2. This means you can find it when you're lost in space,
but you can't eject and then go from the engine to the shuttles or the prespawn area.</li>
<li><b>827</b> - Prespawn blobs can now move around in the prespawn area in addition to chillaxing and having fun.
</li>
<li><b>826</b> - "Manage Bans" window now shows original ban time.</li>
<li><b>825</b> - Icons no longer default to retarded "stretch to fit" size. 32x32 is finally the default now.</li>
</ul>

<p><b>Tuesday, June 16, 2009</b></p>
<ul>
<li><b>824</b> - Emergency lockers are now locked. They can be unlocked by captains or heads, by the atmospheric
alarm in the area going off. The communications computer now has the ability to unlock and open all emergency
lockers.</li>
</ul>

<p><b>Monday, June 15, 2009</b></p>
<ul>
<li><b>823</b> - Added some more logging for admin powers. All use of admin powers should now be logged.</li>
</ul>

<p><b>Sunday, June 14, 2009</b></p>
<ul>
<li><b>822</b> - In meteor mode, meteors now come in larger waves spaced further apart. It's now 10 seconds of
meteors followed by 50 seconds of peace.</li>
<li><b>821</b> - Fixed mass driver exploit.</li>
</ul>

<p><b>Saturday, June 13, 2009</b></p>
<ul>
<li><b>819</b> - Bans should now be tougher to evade.</li>
</ul>

<p><b>Friday, June 12, 2009</b></p>
<ul>
<li><b>817</b> - Updated legal SOP document. It's now reasonably short and less unrealistic.</li>
<li><b>816</b> - Updated job responsibilities paper for the first time in at least a year. It now auto-updates.</li>
</ul>

<p><b>Thursday, June 11, 2009</b></p>
<ul>
<li><b>813</b> - Changed name from "unstable" to "isno" (short for "isnochysn").</li>
<li><b>812</b> - A random monkey in Genetics now gets a superpower each round. Hopefully, this will give them
something. to work on besides abducting people. Added "unbreathing" superpower, which does about what you'd expect.
Other current superpowers are fire immunity (not as great as it sounds unless you have air), super strength (nowhere
near as powerful as on other servers, just makes you a beast in combat), telepathy (you can hear anything anyone
says), and x-ray vision (you can see everything).</li>
<li><b>809</b> - You're now told your job's responsibilities when you spawn.</li>
<li><b>808</b> - Voting now shows you a brief description of each mode.</li>
<li><b>807</b> - Voting now works again.</li>
</ul>

<p><b>Wednesday, June 10, 2009</b></p>
<ul>
<li><b>801</b> - No more 10-second wait before you get your traitor radio. AI now gets law 0 after the "survive"
mission, rather than before.</li>
<li><b>800</b> - AI no longer gets an alert from fire alarms with no power.</li>
</ul>

<p><b>Tuesday, June 9, 2009</b></p>
<ul>
<li><b>797</b> - You now have a maximum amount of NO2 and CO2 in your system, so if you breathe in a ridiculous
amount of NO2 you'll still wake up in a few minutes (assuming you get enough O2 in the meantime).</li>
<li><b>796</b> - Pulling things now behaves as it used to - moving such that you're one square north and one square
west of the thing you're pulling will pull it to where you used to be.</li>
<li><b>791</b> - New assembly system. You can now combine any signaller (timer, prox, radio, or infrared) with any
actor (radio, igniter, igniter-tank assembly, or multitool). Look for more signallers and actors to be added in the
future. Making bombs now requires a different procedure. Here's how to make a time bomb, for instance:
<ol>
	<li>Use screwdriver on timer and igniter.</li>
	<li>Use igniter on plasma tank.</li>
	<li>Use screwdriver on igniter-tank assembly.</li>
	<li>Use welder on igniter-tank assembly.</li>
	<li>Use igniter-tank assembly on timer.</li>
	<li>Use screwdriver on timer-igniter-tank assembly.</li>
</ol>
</li>
</ul>

<p><b>Monday, June 8, 2009</b></p>
<ul>
<li><b>785</b> - Log files are now permanently kept, rather than deleted at end of round.</li>
</ul>

<p><b>Sunday, June 7. 2009</b></p>
<ul>
<li><b>783</b> - Added color-coded airlocks and floors.</li>
<li><b>782</b> - Added Supernorn's kickass new icons.</li>
</ul>

<p><b>Saturday, June 6, 2009</b></p>
<ul>
<li><b>780</b> - Removed blindfold, along with a bunch of other things that aren't used any more because they're
terrible features.</li>
</ul>

<p><b>Friday, June 5, 2009</b></p>
<ul>
<li><b>775</b> - Your HUD is now cleared when you die (although issues arising from switching mobs may still
exist). You now are told the mode and who any traitors are when you die.</li>
</ul>

<p><b>Wednesday, June 3, 2009</b></p>
<ul>
<li><b>772</b> - In multitraitor, instead of n traitors having n shared, ordinary objectives, they now each have a
separate individual objective and one group objective. Group objective types are "abduct someone," "frame someone
(by getting their fingerprints on something)," "steal a bunch of plasma canisters," and "escape alone apart from
other traitors."</li>
<li><b>770</b> - If a traitor, multitraitor, or spy vs spy round goes on for more than an hour, Central Command may
now find out that there are traitors on board and send death commandoes to liquidate the station. Don't fret,
though - you can always try to hijack their shuttle before the battleships arrive.</li>
</ul>

<p><b>Tuesday, June 2, 2009</b></p>
<ul>
<li><b>767</b> - Added death commando deathmatch mode.
</ul>

<p><b>Monday, June 1, 2009</b></p>
<ul>
<li><b>761</b> - Observers can no longer wander off the edge of the map into nothingness. Added "JumpToZ" verb for
observers, in case they want to observe different z-levels.</li>
<li><b>760</b> - Added false rwalls.</li>
<li><b>749</b> - Clickable "abort vote" link added to vote notification for admins.</li>
</ul>

<p><b>Sunday, May 31, 2009</b></p>
<ul>
<li><b>748</b> - Clickable "vote" link added to vote notification.</li>
<li><b>747</b> - Added "disable lockdown" feature to comm computers.</li>
<li><b>742</b> - Multitraitor.</li>
<li><b>741</b> - Folded assistant, atmos tech, and engineer jobs into "technician" job, with more access and
responsibilities. Made engine start at the start of the round without any human intervention.</li>
</ul>

<p><b>Saturday, May 30, 2009</b></p>
<ul>
<li><b>739</b> - You can finally drag a backpack onto you to view its contents while it's on the ground. Total
characters needed to make this change: 4.</li>
<li><b>736</b> - Since it fills the same purpose as the camera jammer, traitor can no longer spawn a syndicate
ID card.</li>
<li><b>735</b> - Redid job system to use /datum/job instead of strings. Adding new jobs should now be easier,
among other nice things.</li>
</ul>

<p><b>Friday, May 29, 2009</b></p>
<ul>
<li><b>734</b> - Added adminwho verb.</li>
<li><b>730</b> - Added "manage bans" admin power. Added bans for a certain number of rounds, to go with permanent
and time bans.</li>
<li><b>728</b> - Replaced existing ban system with better one, which allows non-permanent bans and various other
useful features.</li>
<li><b>727</b> - Improved communications computer formatting.</li>
<li><b>726</b> - Added "make traitor" admin power.</li>
</ul>

<p><b>Thursday, May 28, 2009</b></p>
<ul>
<li><b>725</b> - Added nuclear disk pinpointer item and made traitors able to spawn it with traitor radio for
one crystal. It'll be nice in spy vs spy mode.</li>
<li><b>724</b> - Added several new traitor items. Traitors now get 3 telecrystals, and items cost variable amounts.
<li><b>723</b> - Added area for prespawns to chillax instead of just a black screen.
<li><b>721</b> - Made "Change Mode" power and votes not restart the round, they just set what the mode will be next
round..</li>
<li><b>720</b> - Added Spy vs Spy mode, in which two teams of three spies each both try to steal the nuke disk and
the crew tries to stop both of them.</li>
</ul>

<p><b>Wednesday, May 27, 2009</b></p>
<ul>
<li><b>719</b> - Bomb rebalancing. Blast radius is now proportional to sqrt(temp), rather than temp. Bombs above
500C are now less powerful, while bombs below 500C are more powerful. 500C bombs are the same strength as
before.</li>
<li><b>718</b> - Added voice changer traitor item. Allowed traitor radio item to spawn in your hand.</li>
<li><b>716</b> - Fixed false wall glitches which allowed, among other things, ridiculously hot bombs.</li>
<li><b>713</b> - Random names are now gender-specific.</li>
<li><b>712</b> - Removed "resist" button and functionality.</li>
<li><b>709</b> - New arrivals should be announced by the AI now.</li>
<li><b>708</b> - AI can click people's names to track them.</li>
<li><b>707</b> - Admins are now notified when the traitor dies.</li>
<li><b>706</b> - Latecomers can now take any job that's available, and get full equipment.</li>
<li><b>704</b> - Made shuttle distance announced to the world periodically. Removed status panel.</li>
<li><b>703</b> - Made internals HUD icon indicate amount of air left.</li>
<li><b>702</b> - Improved chat color support.</li>
<li><b>701</b> - Added job ban system.</li>
<li><b>697</b> - Added separate, explicit "escape" mission in traitor mode - allows for future missions that do not
require you to escape.</li>
<li><b>692</b> - Modes can now have minimum numbers of players, so if there are only 3 people on the server
Revolution mode will never be selected.</li>
<li><b>689</b> - Added "boot" and "mute" admin powers.</li>
</ul>

<p><b>May 2008 - Janury 2009</b><p>
<ul>
<li>You can do character setup even after you've spawned.</li>
<li>Posters for revolutionary mode!</li>
<li>Revolutionaries convert people with convert verb, rather than flashes.</li>
<li>Removed earmuffs and ear slot.</li>
<li>Removed speeds other than "running" and speed selector.</li>
<li>Made intent bar and "more inventory" bar always out.</li>
<li>Removed speeds other than "running."</li>
<li>New genetics system added.</li>
<li>600 commits worth of bugfixes and minor or behind-the-scenes improvements.</li>
</ul>

<hr>
<p>Source, minus the good sprites, available at
<a href="http://svn.slurm.us/public/spacestation13/branches/kurper/isno">
http://svn.slurm.us/public/spacestation13/branches/kurper/isno</a>. You'll want to use
<a href='http://tortoisesvn.tigris.org/'>tortoisesvn</a> to get it. If you want the good sprites, ask here or
on irc.synirc.net in #goonstation and you might be allowed to have them. If you want to contribute, come to
#goonstation on irc.synirc.net.</p>

"}