//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package simu5g.emulation.car.nodes;

import inet.applications.contract.IApp;
import inet.mobility.contract.IMobility;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.IRoutingTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.transportlayer.tcp.Tcp;
import inet.transportlayer.udp.Udp;
import inet.common.MessageDispatcher;

import simu5g.emulation.car.nodes.Ue;
import simu5g.emulation.car.nodes.NRUe;

import org.car2x.veins.base.modules.*;


import simu5g.emulation.car.nodes.NRUe;          // ou Ue, se for o seu base

import inet.linklayer.ieee80211.Ieee80211Interface;
import inet.linklayer.contract.IWirelessInterface;

import inet.queueing.filter.PacketFilter;
import inet.linklayer.ieee8021q.Ieee8021qTagEpdHeaderInserter;
import inet.linklayer.ieee8021q.PcpClassifier;
import inet.common.misc.ThruputMeteringChannel;

//import simu5g.emulation.car.SrcBasedRedirector;

import inet.node.inet.StandardHost;

module CarWithWifi extends NRUe
{
    parameters:
        // habilita vetor de wlan
        int numWlanInterfaces = default(1);
        
        ipv4.forwarding = true;

        //# Mobility
        mobility.typename = default("VeinsInetMobility");

        //# Network Layer specs
        *.routingTableModule = default(absPath(".ipv4.routingTable"));

        ipv4.configurator.typename = "HostAutoConfigurator";
        ipv4.configurator.interfaces = "cellular lo0 wlan0";

        @display("i=vehicle/car");

    submodules:
        // NIC Wi-Fi (pode ser vetor: wlan[0], wlan[1], …)
        wlan[numWlanInterfaces]: <default("Ieee80211Interface")> like IWirelessInterface {
            parameters:
                // Modo ad-hoc “tipo VeinsInetCar”
                //                mgmt.typename = "Ieee80211MgmtAdhoc";
                // se quiser controlar a potência, taxa, etc., configure o rádio:
                // radio.transmitter.power = 20 mW;
                @display("p=224.094,598.026");
        }
        
    connections allowunconnected:
        
        for i=0..numWlanInterfaces-1 {
            wlan[i].upperLayerOut --> nl.in++;
            wlan[i].upperLayerIn <-- nl.out++;
        }
}
