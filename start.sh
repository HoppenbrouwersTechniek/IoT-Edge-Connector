#!/usr/bin/bash
 
version="3.2"
 
banner() {
    echo "";
    echo " | |  | |                            | |                                           ";
    echo " | |__| | ___  _ __  _ __   ___ _ __ | |__  _ __ ___  _   ___      _____ _ __ ___  ";
    echo " |  __  |/ _ \| '_ \| '_ \ / _ \ '_ \| '_ \| '__/ _ \| | | \ \ /\ / / _ \ '__/ __| ";
    echo " | |  | | (_) | |_) | |_) |  __/ | | | |_) | | | (_) | |_| |\ V  V /  __/ |  \__ \ ";
    echo " |_|  |_|\___/| .__/| .__/ \___|_| |_|_.__/|_|  \___/ \__,_| \_/\_/ \___|_|  |___/ ";
    echo "              | |   | |                                                            ";
    echo "  _       _   |_|___|_|                           _               _              _ ";
    echo " (_)     | |    / ____|                          | |             | |            | |";
    echo "  _  ___ | |_  | |     ___  _ __  _ __   ___  ___| |_ ___  _ __  | |_ ___   ___ | |";
    echo " | |/ _ \| __| | |    / _ \| '_ \| '_ \ / _ \/ __| __/ _ \| '__| | __/ _ \ / _ \| |";
    echo " | | (_) | |_  | |___| (_) | | | | | | |  __/ (__| || (_) | |    | || (_) | (_) | |";
    echo " |_|\___/ \__|  \_____\___/|_| |_|_| |_|\___|\___|\__\___/|_|     \__\___/ \___/|_|";
    echo -e "\n";
    echo "V${version}";
}
 
sucessBanner() {
    echo "Setup done!"
    echo " __ __   ____  __ __    ___      _____  __ __  ____       __ ";
    echo "|  |  | /    ||  |  |  /  _]    |     ||  |  ||    \     |  |";
    echo "|  |  ||  o  ||  |  | /  [_     |   __||  |  ||  _  |    |  |";
    echo "|  _  ||     ||  |  ||    _]    |  |_  |  |  ||  |  |    |__|";
    echo "|  |  ||  _  ||  :  ||   [_     |   _] |  :  ||  |  |     __ ";
    echo "|  |  ||  |  | \   / |     |    |  |   |     ||  |  |    |  |";
    echo "|__|__||__|__|  \_/  |_____|    |__|    \__,_||__|__|    |__|";
    echo "                                                             ";
}
 
checkInstalled() {
    if ! which "$1" &> /dev/null ; then
        echo -e "\033[37;41;1;4m$1 not available, installation failed!\033[0m"
        exit 1
    else
        echo -e "\033[37;42m$1 is available.\033[0m"
    fi
}
 
if ! lsb_release --id | grep Ubuntu &> /dev/null; then
    echo "This script is intended for Ubuntu, not $(lsb_release --id --short)!"
    exit 2
fi
 
banner
 
checkInstalled curl

echo -e "Enter the Connection String for Azure IoT-Hub:"
connectionString=$(sed 1q)
if [[ -z "$connectionString" ]]; then
    echo "The connection string may not be empty, try again."
    exit 1
elif ! echo "$connectionString" | grep "DeviceId=" &> /dev/null; then
    echo "The connection is missing the device identifier, try again."
    exit 1
fi
 
echo -e "\033[30;47;1m(1/3) Installing IoT Edge...\033[0m";
 
ubuntu_version=$(lsb_release --release --short)
package_sources_url="https://packages.microsoft.com/config/ubuntu/${ubuntu_version}/packages-microsoft-prod.deb"
echo "Downloading package from '$package_sources_url'"
curl -ssl "$package_sources_url" -o packages-microsoft-prod.deb
if [[ ! -f "./packages-microsoft-prod.deb" ]]; then
    echo "Failed to get package sources from '$package_sources_url'."
    exit 3
fi
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
 
echo -e "\033[30;47;1m(2/3) Installing container engine...\033[0m"
sudo apt update
sudo apt -y install moby-engine
checkInstalled docker
 
duration=0
echo "Starting Docker"
sudo systemctl restart docker
while ! systemctl is-active --quiet docker;
do
  echo -ne "Awaiting Docker (${duration}s)...\033[0K\r"
  sleep 1
  ((duration++))
done
echo "Docker is active"
 
echo -e "\033[30;47;1m(3/3) Installing IoT Edge runtime...\033[0m"
 
sudo apt -y install aziot-edge
checkInstalled iotedge
 
sudo iotedge config mp --connection-string "$connectionString"
sudo iotedge config apply

sudo iotedge check && sucessBanner
