package simu5g.emulation.car.test;

module SrcPolicy
{
    parameters:
        // @class(SrcPolicy);
        string wlanIface = default("wlan[0]");
        string cellIface = default("cellularNic");
        string netA = default("192.168.100.0/24");  // → wlan[0]
        string netB = default("10.0.100.0/24");     // → cellularNic
        string interfaceTableModule = default("^.interfaceTable");
    gates:
        input  in;   // recebe IPv4Datagram vindo da eth[0]
        output out;  // segue para a pilha IPv4
}
