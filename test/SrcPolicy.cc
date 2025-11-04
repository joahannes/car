#include <omnetpp.h>

#include "inet/common/ModuleAccess.h"
#include "inet/common/packet/Packet.h"
#include "inet/networklayer/common/InterfaceTable.h"
#include "inet/networklayer/common/InterfaceToken.h"
#include "inet/networklayer/ipv4/Ipv4Header_m.h"
#include "inet/linklayer/common/InterfaceTag_m.h"   // InterfaceReq

using namespace omnetpp;
using namespace inet;

class SrcPolicy : public cSimpleModule
{
private:
IInterfaceTable *ift = nullptr;
int wlanId = -1, cellId = -1;

Ipv4Address netA; int plenA = 24;
Ipv4Address netB; int plenB = 24;

static void parseCidr(const char *s, Ipv4Address& net, int& plen) {
std::string t(s);
auto k = t.find('/');
net = Ipv4Address(t.substr(0, k).c_str());
plen = (k == std::string::npos) ? 32 : atoi(t.substr(k + 1).c_str());
}

static bool inPrefix(const Ipv4Address& addr, const Ipv4Address& net, int plen) {
// compara (addr & mask) == (net & mask)
uint32_t mask = (plen == 0) ? 0u : (~uint32_t{0} << (32 - plen));
Ipv4Address m(mask);
return addr.doAnd(m).getInt() == net.doAnd(m).getInt();
}

protected:
virtual void initialize() override {
ift = getModuleFromPar<IInterfaceTable>(par("interfaceTableModule"), this);

auto *wlan = ift->findInterfaceByName(par("wlanIface"));
auto *cell = ift->findInterfaceByName(par("cellIface"));
if (!wlan || !cell)
throw cRuntimeError("SrcPolicy: interface(s) não encontrada(s): '%s' ou '%s'",
par("wlanIface").stringValue(), par("cellIface").stringValue());

wlanId = wlan->getInterfaceId();
cellId = cell->getInterfaceId();

parseCidr(par("netA"), netA, plenA);
parseCidr(par("netB"), netB, plenB);
}

virtual void handleMessage(cMessage *msg) override {
auto *pk = check_and_cast<Packet*>(msg);

// Estamos entre NIC e Ipv4: o pacote já tem o cabeçalho IPv4 na frente.
const auto& iphdr = pk->peekAtFront<Ipv4Header>();  // não consome, só "espia"
Ipv4Address s = iphdr->getSrcAddress();

int forceIf = -1;
if (inPrefix(s, netA, plenA))       forceIf = wlanId;
else if (inPrefix(s, netB, plenB))  forceIf = cellId;

if (forceIf != -1) {
// Em INET 4.x, define-se a interface de saída via tag InterfaceReq
auto req = pk->addTagIfAbsent<InterfaceReq>();
req->setInterfaceId(forceIf);   // força a saída pela NIC desejada
}

send(pk, "out");
}
};

Define_Module(SrcPolicy);
