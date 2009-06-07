var/changes = {"<font color='blue'><b>Recent changes (apart from bugfixes etc)</b></font><br>
<p>Source, minus the good sprites, available at
<a href="http://svn.slurm.us/public/spacestation13/branches/kurper/unstable">
http://svn.slurm.us/public/spacestation13/branches/kurper/unstable</a>. If you want the good sprites, ask here or
on irc.synirc.net in #goonstation.</p>
<hr>

<p><b>Sunday, June 7. 2009</b></p>
<ul>
<li><b>781</b> - Added Supernorn's kickass new icons.</li>
</ul>

<p><b>Saturday, June 6. 2009</b></p>
<ul>
<li><b>780</b> - Removed blindfold, along with a bunch of other things that aren't used any more because they're
terrible features.</li>
</ul>

<p><b>Friday, June 5. 2009</b></p>
<ul>
<li><b>775</b> - Your HUD is now cleared when you die (although issues arising from switching mobs may still
exist). You now are told the mode and who any traitors are when you die.</li>
</ul>

<p><b>Wednesday, June 3. 2009</b></p>
<ul>
<li><b>772</b> - In multitraitor, instead of n traitors having n shared, ordinary objectives, they now each have a
separate individual objective and one group objective. Group objective types are "abduct someone," "frame someone
(by getting their fingerprints on something)," "steal a bunch of plasma canisters," and "escape alone apart from
other traitors."</li>
<li><b>770</b> - If a traitor, multitraitor, or spy vs spy round goes on for more than an hour, Central Command may
now find out that there are traitors on board and send death commandoes to liquidate the station. Don't fret,
though - you can always try to hijack their shuttle before the battleships arrive.</li>
</ul>

<p><b>Tuesday, June 2. 2009</b></p>
<ul>
<li><b>767</b> - Added death commando deathmatch mode.
</ul>

<p><b>Monday, June 1. 2009</b></p>
<ul>
<li><b>761</b> - Observers can no longer wander off the edge of the map into nothingness. Added "JumpToZ" verb for
observers, in case they want to observe different z-levels.</li>
<li><b>760</b> - Added false rwalls.</li>
<li><b>749</b> - Clickable "abort vote" link added to vote notification for admins.</li>
</ul>

<p><b>Sunday, May 31. 2009</b></p>
<ul>
<li><b>748</b> - Clickable "vote" link added to vote notification.</li>
<li><b>747</b> - Added "disable lockdown" feature to comm computers.</li>
<li><b>742</b> - Multitraitor.</li>
<li><b>741</b> - Folded assistant, atmos tech, and engineer jobs into "technician" job, with more access and
responsibilities. Made engine start at the start of the round without any human intervention.</li>
</ul>

<p><b>Saturday, May 30. 2009</b></p>
<ul>
<li><b>739</b> - You can finally drag a backpack onto you to view its contents while it's on the ground. Total
characters needed to make this change: 4.</li>
<li><b>736</b> - Since it fills the same purpose as the camera jammer, traitor can no longer spawn a syndicate
ID card.</li>
<li><b>735</b> - Redid job system to use /datum/job instead of strings. Adding new jobs should now be easier,
among other nice things.</li>
</ul>

<p><b>Friday, May 29. 2009</b></p>
<ul>
<li><b>734</b> - Added adminwho verb.</li>
<li><b>730</b> - Added "manage bans" admin power. Added bans for a certain number of rounds, to go with permanent
and time bans.</li>
<li><b>728</b> - Replaced existing ban system with better one, which allows non-permanent bans and various other
useful features.</li>
<li><b>727</b> - Improved communications computer formatting.</li>
<li><b>726</b> - Added "make traitor" admin power.</li>
</ul>

<p><b>Thursday, May 28. 2009</b></p>
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

<p><b>Wednesday, May 27. 2009</b></p>
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
"}