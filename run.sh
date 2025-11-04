#!/bin/bash
# make sure you run '. setenv' in the Simu5G root directory before running this script

# Verifica se o usuário passou o nome da configuração
if [ -z "$1" ]; then
  echo "Uso: $0 <nome_da_configuracao>"
  echo "Exemplo: $0 FCFS-5G || FCFS-WIFI || FCFS-MULTI"
  exit 1
fi

CONFIG=$1   # recebe o primeiro parâmetro

opp_run -m -r 0 -u Cmdenv -c "$CONFIG" -n ..:../../simulations:../../src:../../../inet/examples:../../../inet/showcases:../../../inet/src:../../../inet/tests/validation:../../../inet/tests/networks:../../../inet/tutorials:../../../veins/examples/veins:../../../veins/src/veins:../../../veins_inet/src/veins_inet:../../../veins_inet/examples/veins_inet \
--image-path=../../images:../../../inet/images:../../../veins/images:../../../veins_inet/images -l ../../src/simu5g -l ../../../inet/src/INET -l ../../../veins/src/veins -l ../../../veins_inet/src/veins_inet omnetpp.ini
