#!/bin/bash

hciconfig hci0 down
hciconfig hci0 reset

service bluetooth restart
