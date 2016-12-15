# check postfix mailq

##  Overview
This script is for nagios monitoring.  
check_mailq, nagios plugin, is too heavey response when mail queue increase.  
so I wrote Lightweight nagios plugin for postfix.  

## Notice
This script is wrote by bash.  
This script is wrote for postfix.  
This script need sudo for nrpe excute.  

## Installation guide
set anywhere, and add eXcute permition for nrpe

    # chmod +x ./check_postfix_mailq.sh

permit nrpe to sudo find.

    # cat << EOF > /etc/sudoers.d/nrpe
    Defaults:nrpe !requiretty
    nrpe ALL=(ALL) NOPASSWD: `which find`
    EOF

set nrpe configuration.
example:

    ## warn at 100 mail queue, critical at 300 mail queue
    command[check_postfix_mailq]=/usr/lib64/nagios/plugins/check_postfix_mailq.sh 100 300

and resstart nrpe.
