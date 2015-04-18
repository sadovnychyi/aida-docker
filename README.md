aida-docker
===========

Getting started
===============

* Download [entity repository] (13 GB) [MD5: c70e3c783543688d1e6c64ba94e3f6c2]. Unpack it somewhere on the host machine.

* Mount the entity repository and select the port to use, for example:
```
sudo docker run -d -p 8081:8080 -v /home/sadovnychyi/AIDA_entity_repository_2014-01-02v10_dmap/aida_20140102v10:/aida/dMaps sadovnychyi/aida-docker
```
Where `/home/sadovnychyi/AIDA_entity_repository_2014-01-02v10_dmap/aida_20140102v10` is the path to the entity repository on the host machine and `8081` is port to be used on host machine.

* Try to use it:
```
curl --data text="Einstein was born in Ulm." http://localhost:8081/aida/service/disambiguate
```
Note that the first run will take a lot of time as it need to cache a lot of things. (10-20 minutes in my case)
I've tried to run it on the `n1-highmem-16`	(16 CPU cores with 104GB of RAM) compute engine instance and it used 34 GB of RAM at most, the CPU usage was below 40%. Looks like the `n1-highmem-8` is the lowest instance class which will allow to run it.

For more info visit the official [AIDA repository](https://github.com/yago-naga/aida).
