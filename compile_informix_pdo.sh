#!/bin/bash
# Informix Toolbox - https://github.com/jturazzi/informix-toolbox
# Jérémy TURAZZI - jeremy@trz.fr

CYAN="\e[36m"
GREEN="\e[32m"
MAGENTA="\e[35m"
RED="\e[31m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
TOTAL_STEPS=10

# Variables
informix_pdo_version=1.3.6
informix_pdo_url=https://pecl.php.net/get/PDO_INFORMIX-1.3.6.tgz

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

function install_php() {
    step_message 1 "Installing PHP $php_version" "failure"
    sudo apt install php$php_version php$php_version-cli php$php_version-fpm php$php_version-common -y
    step_message 1 "Installing PHP $php_version" "failure"
}

function install_php_extensions() {
    step_message 2 "Installing PHP extensions for PHP $php_version" "failure"
    sudo apt install php$php_version-bcmath -y
    sudo apt install php$php_version-curl -y
    sudo apt install php$php_version-dev -y
    sudo apt install php$php_version-gd -y
    sudo apt install php$php_version-gmp -y
    sudo apt install php$php_version-igbinary -y
    sudo apt install php$php_version-intl -y
    sudo apt install php$php_version-mbstring -y
    sudo apt install php$php_version-mcrypt -y
    sudo apt install php$php_version-memcached -y
    sudo apt install php$php_version-msgpack -y
    sudo apt install php$php_version-opcache -y
    sudo apt install php$php_version-readline -y
    sudo apt install php$php_version-redis -y
    sudo apt install php$php_version-soap -y
    sudo apt install php$php_version-xdebug -y
    sudo apt install php$php_version-xml -y
    sudo apt install php$php_version-zip -y
    step_message 2 "Installing PHP extensions for PHP $php_version" "success"
}

function download_informix_pdo() {
   step_message 3 "Downloading PDO Informix $informix_pdo_version" "failure"
   wget -qO /tmp/PDO_INFORMIX.tgz $informix_pdo_url
   step_message 3 "Downloading PDO Informix $informix_pdo_version" "failure"
}

function extract_informix_pdo() {
    step_message 4 "Extracting PDO Informix $informix_pdo_version" "failure"
    cd /tmp/
    sudo tar -xvf PDO_INFORMIX.tgz
    step_message 4 "Copying and extracting file $informix_pdo_version" "success"
}

function compile_informix_pdo() {
    step_message 5 "Compiling PDO Informix for PHP $php_version" "failure"
    sudo update-alternatives --set phpize /usr/bin/phpize$php_version
    cd /tmp/PDO_INFORMIX-$informix_pdo_version
    sudo phpize
    sudo ./configure --with-pdo-informix=/opt/IBM/informix --with-php-config=/usr/bin/php-config$php_version
    sudo make
    step_message 5 "Compiling PDO Informix for PHP $php_version" "success"
}

function install_informix_pdo() {
    step_message 6 "Installing PDO Informix" "failure"
    sudo make install
    step_message 6 "Installing PDO Informix" "success"
}

function remove_temporary_folder() {
    step_message 7 "Removing PDO Informix temporary files" "failure"
    sudo rm -rv /tmp/PDO_INFORMIX-$informix_pdo_version
    cd /home/houles
    step_message 7 "Removing PDO Informix temporary files" "success"
}

function configure_php_ini() {
    step_message 8 "Configuring PDO Informix in PHP $php_version configuration" "failure"
    echo "extension=pdo_informix.so" | sudo tee /etc/php/$php_version/mods-available/pdo_informix.ini
    sudo ln -s /etc/php/$php_version/mods-available/pdo_informix.ini /etc/php/$php_version/cli/conf.d/20-pdo_informix.ini
    sudo ln -s /etc/php/$php_version/mods-available/pdo_informix.ini /etc/php/$php_version/fpm/conf.d/20-pdo_informix.ini
    step_message 8 "Configuring PDO Informix in PHP $php_version configuration" "success"
}

function enable_FPM_at_startup() {
    step_message 9 "Enabling php$php_version-fpm service at startup" "failure"
    sudo systemctl enable php$php_version-fpm
    step_message 9 "Enabling php$php_version-fpm service at startup" "success"
}

function restart_FPM() {
    step_message 10 "Restarting php$php_version-fpm service" "failure"
    sudo systemctl restart php$php_version-fpm
    step_message 10 "Restarting php$php_version-fpm service" "success"
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
        echo -en "${MAGENTA}- Enter the PHP version number to install: ${ENDCOLOR}"
        read php_version
        run_function_based_on_argument "$1"
        exit 0
    fi

    echo -e "${CYAN}[Start of script]${ENDCOLOR}"

    echo -en "${MAGENTA}- Enter the PHP version number to install: ${ENDCOLOR}"
    read php_version

    install_php

    install_php_extensions

    download_informix_pdo

    extract_informix_pdo

    compile_informix_pdo

    install_informix_pdo

    remove_temporary_folder

    configure_php_ini

    enable_FPM_at_startup

    restart_FPM

    echo -e "${CYAN}[End of script]${ENDCOLOR}"
}

main "$@"