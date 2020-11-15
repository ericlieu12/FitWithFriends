# FitWithFriends
<a href= https://fitwithfriends.flycricket.io/> App Store Link! </a> <br>
<b> What is it? </b> <br>
This is an app where you get to compete against your friends for the most steps in a day! Create your account and add your friends! <br>
<b> How does it work </b>
Users can create an account and add their friends! <br>
<b> Features </b>
<ol>
<li> Everyday competitions for step counting! </li>
<li> Friend Requests and Friends List </li>
<li> Blocking system for abusive users </li>
<li> Smooth user experience </li>
<li> Modern UI Design </li>
</ol>
<b> How was it made? </b> <br>
Using xCode and Swift and Google Firebase. To read in steps, we use the Core Motion framework provided by Apple. To store user data and information, we use Google Firebase. With Core Motion, we track the users steps whenever they load the app and publish the data into Google Firebase. <br>
<b> Google Firebase Data Structure </b> <br>
There is no hierarchical structure in the data as Google Firebase is a noSQL environment and that entitles different structuring vses a traditional SQL database. <br> There are two collections, friend requests and user documents. This allows us to establish a one to many relationship per friend pair. For example, Bob and Joe are friends. Bob and Joe is a document in friend requests (with isFriends set to true). This one document has many (2) relationships. <br>
Bob and Joe's information are stored in friend requests. Bob and Joe's information is also stored in their user documents. Some of this information may overlap. <br> This is structured this way due to the nature of Google Firebase. Each document read costs energy, logically. Each document is read completely, meaning energy is used to read the entire document, even if some information in the document is not needed. <br>
<br> If we want to pull up all of Bob's friends and their data, we would need to pull up Bob's document AND all of Bob's friend's documents AND all of the information in those documents, even if we just need only their name. So, to put together Bob's friends list, we would need ALL of that. That is a lot of bandwidth taking place. <br>
With the structure I devised earlier, to pull up all of Bob's friends, we would just need to do a query on the friend requests documents to find every friend requests with Bob's name in it. Since we also stored necessary information in these friend request documents, we no longer need to visit the user documents of Bob's friends. This saves a lot of bandwidth instead of the hierarchical structure discussed before.
<br> This saves us only one document read theoretically. BUT, for other cases, this saves us dramatic amounts of reads. Imagine if Bob does not want to be friends with Joe. Not only do you have to go to Bob's document to delete Joe off the friends list, but you also have to go to Joe's friends list and delete that off too. Remember also that Google Firebase requires us to read the entire document even if we only need to read part of it. With the structure I devised earlier, we only need to delete the friend request document. This saves us a lot of bandwidth and a lot of reads, halving the number of reads needed to delete a friend.
 <br>
 DO NOT attempt to replicate this data structure in a SQL environment. This would cause information overlap which results in unncessary space take up. This data structure only works for this application due to the nature of Google Firebase. <br>
<br> <b> Copyright </b> <br>
Noone is allowed to reproduce my code unless you have explicit written permission by me.


