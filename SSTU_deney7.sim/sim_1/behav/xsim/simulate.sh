#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Thu Dec 15 12:22:10 +03 2022
# SW Build 3671981 on Fri Oct 14 04:59:54 MDT 2022
#
# IP Build 3669848 on Fri Oct 14 08:30:02 MDT 2022
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim conv_tb_behav -key {Behavioral:sim_1:Functional:conv_tb} -tclbatch conv_tb.tcl -log simulate.log"
xsim conv_tb_behav -key {Behavioral:sim_1:Functional:conv_tb} -tclbatch conv_tb.tcl -log simulate.log

