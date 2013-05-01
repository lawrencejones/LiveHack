LiveHack
========
LiveHack aims to simplify the hackathon process, and add excitement to the
event! We aim to implement a system to allow matching up of project ideas to
the developers that have the skills to see it through, preventing the awkward
(for those who don't come with team/idea) time wasting circles that most hackathons host.

Features
========
Below are the aims for this project. I'll keep them up-to-date as I add or
otherwise change the current build.

 - Facebook sign in
 - Collate all your subscribed hackathons
 - Automatically manage users by adding an attendee list from the Facebook event
 - Create interface with which you can customize your own skill tags and user details
 - Pair project proposals with the developers

Database UML
============
For anyone wanting a quick overview of how the data is structured.
Initially your user details are picked off facebook, and you can start by creating
an Hackathon from a Facebook event (or creating one if it doesn't yet exist).
The users for each Hackathon are taken from the attendee list in the Facebook event.

Bolded fields indicate that this data is guaranteed to exist. Other fields will be 
filled once the user logs in him/herself.

###User
 - **username:string**
 - **name:string**
 - email:string
 - skills:string
 - preferences:string

###Hackathon
 - **facebook_link:string**
 - **name:string**
 - **description:string**
 - **start:datetime**
 - **end:datetime**
 
