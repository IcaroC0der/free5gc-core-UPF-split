#!/usr/bin/env bash

LOG_PATH="./log/"
LOG_NAME="free5gc.log"
TODAY=$(date +"%Y%m%d_%H%M%S")
PCAP_MODE=0

PID_LIST=()
echo $$ > run.pid

sudo -v # cache credentials
if [ $? == 1 ] # check if credentials were successfully cached
then
    echo "[ERRO] Without root permission, you cannot run free5GC"
    exit 1
fi

if [ $# -ne 0 ]; then
    while [ $# -gt 0 ]; do
        case $1 in
            -p)
                shift
                case $1 in
                    -*)
                        continue ;;
                    *)
                        if [ "$1" != "" ];
                        then
                            LOG_PATH=$1
                        fi
                esac ;;
            -cp)
                PCAP_MODE=$((${PCAP_MODE} | 0x01))
                ;;
            -dp)
                PCAP_MODE=$((${PCAP_MODE} | 0x02))
                ;;
        esac
        shift
    done
fi

function terminate()
{
    rm run.pid
    echo "Receive SIGINT, terminating..."
    
    echo Terminate PID_LIST = ${PID_LIST[@]}
    wait ${PID_LIST[@]}
    echo The free5GC UPF terminated successfully!
    exit 0
}

trap terminate SIGINT

LOG_PATH=${LOG_PATH%/}"/"${TODAY}"/"
echo "log path: $LOG_PATH"

if [ ! -d ${LOG_PATH} ]; then
    mkdir -p ${LOG_PATH}
fi

if [ $PCAP_MODE -ne 0 ]; then
    PCAP=${LOG_PATH}free5gc.pcap
    case $PCAP_MODE in
        1)  # -cp
            sudo tcpdump -i any 'tcp port 8000 || udp port 8805' -w ${PCAP} &
            ;;
        2)  # -dp
            sudo tcpdump -i any 'udp port 2152' -w ${PCAP} &
            ;;
        3)  # include -cp -dp
            sudo tcpdump -i any 'tcp port 8000 || udp port 8805 || udp port 2152' -w ${PCAP} &
            ;;
    esac

    SUDO_TCPDUMP_PID=$!
    sleep 0.1
    TCPDUMP_PID=$(pgrep -P $SUDO_TCPDUMP_PID)
    PID_LIST+=($SUDO_TCPDUMP_PID $TCPDUMP_PID)
fi

# --- Bloco Principal: Iniciar a UPF ---
sudo -E ./bin/upf -c ./config/upfcfg.yaml -l ${LOG_PATH}${LOG_NAME} &
SUDO_UPF_PID=$!
sleep 0.1
UPF_PID=$(pgrep -P $SUDO_UPF_PID)
PID_LIST+=($SUDO_UPF_PID $UPF_PID)
# -------------------------------------

echo "UPF started."
echo "Press [Ctrl+C] to terminate."

wait ${PID_LIST}
exit 0