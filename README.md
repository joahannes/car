Car Emulation example
---------------------------------

In this example the network consists of one UE connected to one gNB, one UPF, 
one router, one external (real) server and one external (real) client.

IP addresses and routing tables are set up by using mrt files (see "routing" folder).

Communication between the simulator and the host OS is realized using namespaces linked together via virtual ethernet (veth) interfaces. 
In particular, we configure the following scenario:

Packets sent needs to be smaller than the MTU of the veth interface (1500 bytes by default)
 
How to build and run the emulation 
----------------------------------

1) Make sure that the emulation feature is enabled in the INET project:

- via the IDE: right-click on the 'inet' folder in the Project Explorer -> Properties;
               select OMNeT++ -> Project Features; 
               tick the box "Network emulation support".
- via the command line: in the root INET folder, type 'opp_featuretool enable NetworkEmulationSupport'.

  Recompile INET with the command `make makefiles && make` (in the root INET folder).  


2) In order to be able to send/receive packets through sockets, set the application permissions (specify
   the path of your OMNeT installation): 

```bash
sudo setcap cap_net_raw,cap_net_admin=eip path/to/opp_run
```
```bash
sudo setcap cap_net_raw,cap_net_admin=eip path/to/opp_run_dbg
```
```bash
sudo setcap cap_net_raw,cap_net_admin=eip path/to/opp_run_release
```

3) Compile Simu5G from the command line by running (in the root Simu5G folder):

```bash
. setenv
make makefiles
make MODE=release 
```

4) Setup the environment by typing:
```bash
bash setup.sh
```
	 	
5) Run the external server for the uplink traffic:
```bash
bash apps/server.sh
```
  	
6) Run the simulation by typing:
```bash
bash run.sh
```
   
7) Run the external server for the downlink traffic:
```bash
bash apps/client.sh
```
        
8) Clean the environment by typing:
```bash
bash teardown.sh
``` 
