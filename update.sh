#!/bin/bash
git push
ssh prj@howto.lxd 'cd project; git pull; composer install'