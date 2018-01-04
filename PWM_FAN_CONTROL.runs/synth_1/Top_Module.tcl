# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35ticpg236-1L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.cache/wt [current_project]
set_property parent.project_path C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/imports/new/PWM_Counter.v
  C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/imports/new/lcd_module.v
  C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/new/Top_Module.v
}
read_ip -quiet C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xdc]
set_property is_locked true [get_files C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/constrs_1/imports/constraints/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/Student/Desktop/PWM_FAN_CONTROL/PWM_FAN_CONTROL.srcs/constrs_1/imports/constraints/Basys3_Master.xdc]


synth_design -top Top_Module -part xc7a35ticpg236-1L


write_checkpoint -force -noxdef Top_Module.dcp

catch { report_utilization -file Top_Module_utilization_synth.rpt -pb Top_Module_utilization_synth.pb }