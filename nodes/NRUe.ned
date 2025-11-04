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


package simu5g.emulation.car.nodes;

import simu5g.emulation.car.nodes.Ue; // joahannes
import simu5g.stack.NRNicUe;

import simu5g.corenetwork.statsCollector.NRueStatsCollector;

import inet.linklayer.ieee80211.Ieee80211Interface;
import inet.networklayer.contract.INetworkLayer;
// 
// User Equipment Module
//
module NRUe extends Ue
{
    parameters:
        nicType = default("NRNicUe");

        int nrMasterId @mutable = default(0);
        int nrMacNodeId @mutable = default(0); // TODO: this is not a real parameter
        int nrMacCellId @mutable = default(0); // TODO: this is not a real parameter
		
//		int numWlanInterfaces = default(1);     // 1 Wi-Fi STA

    gates:
        input nrRadioIn @directIn;     // connection to master    

    submodules:
        //# UeStatsCollector - for MEC
//        NRueCollector: NRueStatsCollector if hasRNISupport {
//            @display("p=73.687996,445.75198;is=s");
//        }
        // Cria o(s) NIC(s) Wi-Fi
//        wlan[numWlanInterfaces]: Ieee80211Interface {
//            parameters:
//                @display("p=250,200,row");
//                // TIP: mgmt/agent/opMode/banda/canal você ajusta no .ini
//                // Ex.: *.car[*].wlan[0].mgmt.typename="Ieee80211MgmtSta"
//                //      *.car[*].wlan[0].agent.typename="Ieee80211AgentSTA"
//                //      *.car[*].wlan[0].opMode="a"
//        }
//
    connections allowunconnected:
//
        cellularNic.nrRadioIn <-- nrRadioIn;
//        
//        // Liga cada NIC Wi-Fi ao networkLayer (ifIn/ifOut)
//        for i=0..numWlanInterfaces-1 {
//            wlan[i].upperLayerOut --> nl.in++;
//            wlan[i].upperLayerIn  <-- nl.out++;
//        }
}
