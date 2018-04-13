Setting up a scaled XP
=========================

* Install XP1
* Install an additional CD server
    * Install cd without SQL
* Enable scalability of all instances
* Set up a session state provider for private and shared session state
    * https://github.com/MicrosoftArchive/redis/releases
    * port 6379

* Show redis:
   redis-cli
   keys *