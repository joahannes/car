//
//                  Simu5G
//
// Authors: Giovanni Nardini, Giovanni Stea, Antonio Virdis (University of Pisa)
//
// This file is part of a software released under the license included in file
// "license.pdf". Please read LICENSE and README files before using it.
// The above files and the present reference are part of the software itself,
// and cannot be removed from it.
//

package simu5g.emulation.car;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.ethernet.Eth10G;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;

import simu5g.world.radio.LteChannelControl;
import simu5g.common.carrierAggregation.CarrierAggregation;
import simu5g.nodes.Upf;
import simu5g.common.binder.Binder;
import simu5g.nodes.NR.gNodeB;
//import simu5g.nodes.NR.NRUe;
import simu5g.nodes.ExtCell;

//car
import simu5g.emulation.car.nodes.NRCar;
import simu5g.emulation.car.nodes.CarWithWifi;
import org.car2x.veins.subprojects.veins_inet.VeinsInetManager;

// wifi car
import inet.node.ethernet.EthernetSwitch;
import inet.node.ethernet.Eth100M;
import inet.node.wireless.AccessPoint;

import inet.physicallayer.wireless.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;

// ExtClientServerExample
//
// One real UE receives data from a real server
// 
network CarClientServerExample
{
    parameters:
        int numExtCells = default(0);
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        string algorithm = default("TESTE");
        @display("i=block/network2;bgb=732,483;bgi=background/pisa");

    submodules:

        routingRecorder: RoutingTableRecorder {
            @display("p=51,426;is=s");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=136,426");
        }

        //# Veins manager module
        veinsManager: VeinsInetManager {
            @display("p=262,426;is=s");
        }

        // joahannes
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=446,425");
        }

        ap: AccessPoint {
            parameters:
                @display("p=154,42;r=,,#707070");
        }

        channelControl: LteChannelControl {
            @display("p=530,436;is=s");
        }
        binder: Binder {
            @display("p=203,426;is=s");
        }
        carrierAggregation: CarrierAggregation {
            @display("p=346,426;is=s");
        }
        router: Router {
            @display("p=494,105;i=device/smallrouter");
        }
        upf: Upf {
            @display("p=270,138");
        }
        gnb: gNodeB {
            @display("p=51,172;is=vl");
        }
        extCell[numExtCells]: ExtCell {
            @display("p=51,172;is=vl");
        }
        //# submodule vector to store all cars - will be filled dynamically during simulations
        car[0]: CarWithWifi;
        
    connections allowunconnected:

        router.pppg++ <--> Eth10G <--> upf.filterGate;
        upf.pppg++ <--> Eth10G <--> gnb.ppp;

        ap.ethg++ <--> Eth10G <--> router.ethg[1];
}
