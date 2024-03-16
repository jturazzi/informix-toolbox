#!/bin/bash
# Informix Toolbox - https://github.com/jturazzi/informix-toolbox
# Jérémy TURAZZI - jeremy@trz.fr

CYAN="\e[36m"
GREEN="\e[32m"
MAGENTA="\e[35m"
RED="\e[31m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
TOTAL_STEPS=7

# Variables
informix_version=informix-4.50.FC10
informix_url=https://localhost/ibm.csdk.4.50.FC10.LNX.zip

function step_message() {
    local step_number=$1
    local step_description=$2
    local status=$3

    if [[ "$status" == "success" ]]; then
        echo -e "${YELLOW}- [${step_number}/${TOTAL_STEPS}]${ENDCOLOR} ${step_description} [${GREEN}✓${ENDCOLOR}]"
    elif [[ "$status" == "failure" ]]; then
        echo -e "${YELLOW}- [${step_number}/${TOTAL_STEPS}]${ENDCOLOR} ${step_description} [${RED}✗${ENDCOLOR}]"
    else
        echo -e "${YELLOW}- [${step_number}/${TOTAL_STEPS}]${ENDCOLOR} ${step_description}"
    fi
}

function download_informix_sdk() {
    step_message 1 "Downloading Informix SDK" "failure"
    wget -qP /tmp/$informix_version $informix_url
    step_message 1 "Downloading Informix SDK" "failure"
}

function copy_and_extract_installation_folder() {
    step_message 2 "Copying and extracting temporary installation folder" "failure"
    cd /tmp/$informix_version/
    sudo unzip *.zip
    sudo chmod +x /tmp/$informix_version/installclientsdk
    step_message 2 "Copying and extracting temporary installation folder" "success"
}

function install_missing_libraries() {
    step_message 3 "Installing missing libraries" "failure"
    sudo apt install libncurses5-dev libncursesw5-dev libncurses5:amd64 -y
    step_message 3 "Installing missing libraries" "success"
}

function install_informix_sdk() {
    step_message 4 "Installing SDK $informix_version" "failure"
    sudo /tmp/$informix_version/installclientsdk -DUSER_INSTALL_DIR="/opt/IBM/$informix_version"
    step_message 4 "Installing SDK $informix_version" "success"
}

function create_symbolic_link() {
    step_message 5 "Creating symbolic link" "failure"
    sudo ln -s /opt/IBM/$informix_version /opt/IBM/informix
    step_message 5 "Creating symbolic link" "success"
}

function remove_temporary_installation_folder() {
    step_message 6 "Removing temporary installation folder" "failure"
    sudo rm -rv /tmp/$informix_version
    step_message 6 "Removing temporary installation folder" "success"
}

function configure_informix_sdk() {
    step_message 7 "Configuring Informix SDK" "failure"
    sudo tee /etc/ld.so.conf.d/informix.conf >> /dev/null <<EOT 
/opt/IBM/informix/lib
/opt/IBM/informix/lib/esql
/opt/IBM/informix/lib/cli
EOT
    sudo ldconfig

    step_message 7 "Configuring Informix SDK" "success"
}

function run_function_based_on_argument() {
    if [ -n "$1" ] && declare -f "$1" > /dev/null; then
        echo "Executing function: $1"
        "$1"
    else
        echo "Unknown function: $1"
        exit 1
    fi
}

function main() {
    if [ $# -eq 1 ]; then
        run_function_based_on_argument "$1"
        exit 0
    fi

    echo -e "${CYAN}[Start of script $0]${ENDCOLOR}"

    download_informix_sdk

    copy_and_extract_installation_folder

    install_missing_libraries

    install_informix_sdk

    create_symbolic_link

    remove_temporary_installation_folder

    configure_informix_sdk

    echo -e "${CYAN}[End of script $0]${ENDCOLOR}"
}

main "$@"
