#!/bin/bash

#Log the date, time, and version when the script was last executed

date >> /tmp/script.log
cat /proc/version >> /tmp/script.log
