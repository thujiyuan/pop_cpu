
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name pop_cpu -dir "F:/thujiyuan/pop_cpu/planAhead_run_2" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/thujiyuan/pop_cpu/pop_cpu.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/thujiyuan/pop_cpu} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "pop_cpu.ucf" [current_fileset -constrset]
add_files [list {pop_cpu.ucf}] -fileset [get_property constrset [current_run]]
link_design
