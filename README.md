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

Note that not all fields are guaranteed to be available. On the user logging in for the
first time, they provide enough in the way of facebook permissions to grab everything. However
until they do that, we're only going to know them from a hackathons attendance list, meaning
only __username__ and __name__ are going to be guaranteed.

We will therefore use the :signed_up attribute to specify determine whether the user has
logged in.

##User
```ruby
class User < ActiveRecord::Base
  attr_accessible :email, :name, :username, :tags, :github_email, :signed_up

  validates :name,     :presence => true
  validates :username, :presence => true

  has_many :hackathons
  has_many :teams, :through => :hackathons

end
```

##Hackathon
```ruby
class Hackathon < ActiveRecord::Base
  attr_accessible :desc, :end, :location, :name, :scheduleItems, :start

  has_many :users
  has_many :teams
  has_many :proposals, :through => :teams
end
```

##Proposal
```ruby
class Proposal < ActiveRecord::Base
  belongs_to :team
  has_one :hackathon, :through => :team
  attr_accessible :desc, :name, :skills
end
```

##Team
```ruby
class Team < ActiveRecord::Base
  belongs_to :hackathon
  has_many :users
  attr_accessible :name
end
```
