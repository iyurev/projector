#!/bin/bash

 mkdir -p ~/.config/systemd/user
 cp projector.service ~/.config/systemd/user
 systemctl --user start projector
 systemctl --user status  projector
 systemctl --user enable projector
 #Check  the unit logs 
 #journalctl --user  -fu projector
