#!/usr/bin/bash

echo "  _    _                              _                                            ";
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
echo "                                                                                ";
echo "                                                                                   ";
echo "V1.0";
echo "";
echo "";
echo "";
echo "";
echo -e "Enter the Connection String for The iotHub";
read connectionString

echo "starting installing tools";

echo "*- installing IoT Edge";

wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

echo "________________________________________________________________________________"
echo "________________________________________________________________________________"
echo "________________________________________________________________________________"

echo "*- installing container engine"
sudo apt-get update
sudo apt-get -y install moby-engine

sudo systemctl restart docker

echo "sleep for 1 minute, waiting for docker to restart"

duration=60

while [ "$duration" -gt 0 ]; do
  echo -ne "$duration\033[0K\r"  # \033[0K clears the line  sleep 1
  sleep 1
  ((duration--))
done

echo "________________________________________________________________________________"
echo "________________________________________________________________________________"
echo "________________________________________________________________________________"


echo "*- installing IoT Edge runtime"

sudo apt-get -y install aziot-edge

echo "________________________________________________________________________________"
echo "________________________________________________________________________________"
echo "________________________________________________________________________________"

sudo iotedge config mp --connection-string $connectionString

sudo iotedge config apply

echo "Setup done!"

echo " __ __   ____  __ __    ___      _____  __ __  ____       __ ";
echo "|  |  | /    ||  |  |  /  _]    |     ||  |  ||    \     |  |";
echo "|  |  ||  o  ||  |  | /  [_     |   __||  |  ||  _  |    |  |";
echo "|  _  ||     ||  |  ||    _]    |  |_  |  |  ||  |  |    |__|";
echo "|  |  ||  _  ||  :  ||   [_     |   _] |  :  ||  |  |     __ ";
echo "|  |  ||  |  | \   / |     |    |  |   |     ||  |  |    |  |";
echo "|__|__||__|__|  \_/  |_____|    |__|    \__,_||__|__|    |__|";
echo "                                                             ";


