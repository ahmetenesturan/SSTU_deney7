#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Thu Dec 15 01:38:19 +03 2022
# SW Build 3671981 on Fri Oct 14 04:59:54 MDT 2022
#
# IP Build 3669848 on Fri Oct 14 08:30:02 MDT 2022
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim MULTB_tb_behav -key {Behavioral:sim_1:Functional:MULTB_tb} -tclbatch MULTB_tb.tcl -log simulate.log"
xsim MULTB_tb_behav -key {Behavioral:sim_1:Functional:MULTB_tb} -tclbatch MULTB_tb.tcl -log simulate.log

