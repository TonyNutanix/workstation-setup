# Workstation Setup
This script sets up the environment to run all the atomic_scripts.

## Prequisites
This script assumes it is being run on a freshly installed Rocky 9 system

## Setup/Install
1. Clone the repo to the Rocky Linux system
2. Edit .env to set related variable
3. Run "sudo bash ./setup.bash"


## NOTES
TH 05212025: At this moment these scripts are designed to work against a single Prism Central which may have 1 or more clusters attached.  
Clone this repo once for each Prism Central in order to keep the environments seperated and for ease of use.