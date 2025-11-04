package simu5g.emulation.car.test;

import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.IRoutingTable;
import inet.networklayer.contract.INetworkLayer;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.node.inet.Router;

module CarNode extends Router
{
    submodules:
        srcPolicy: SrcPolicy {
            parameters:
                wlanIface = "wlan[0]";
                cellIface = "cellularNic";
                netA = "192.168.100.0/24";   // vai para wlan[0]
                netB = "10.0.100.0/24";      // vai para cellularNic
        }
    connections allowunconnected:
        // NIC eth[0] → policy → pilha IPv4 (networkLayer)
        eth[0].upperLayerOut --> srcPolicy.in;
        srcPolicy.out        --> nl.in++;

        // caminho de volta (IPv4 → eth[0]) permanece normal
        nl.out++ --> eth[0].upperLayerIn;
}
