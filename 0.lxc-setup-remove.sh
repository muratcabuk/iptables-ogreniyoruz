#!/bin/bash
lxc delete c2 client11 client31 firewall
lxc network delete bridge172
lxc network delete bridge192
lxc profile delete myprofile


