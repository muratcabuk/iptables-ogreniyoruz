#!/bin/bash
lxc delete sunucu1 sunucu2 sunucu3 sunucufirewall
lxc network delete bridge172
lxc network delete bridge192
lxc profile delete myprofile


