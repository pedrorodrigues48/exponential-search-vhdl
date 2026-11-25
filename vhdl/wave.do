onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Stimuli
add wave -noupdate -format Logic /exponentialsearch_tb/clk
add wave -noupdate -format Logic /exponentialsearch_tb/rst
add wave -noupdate -format Logic /exponentialsearch_tb/data_av
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/data
add wave -noupdate -divider ExponentialSearch_str
add wave -noupdate -format Literal /exponentialsearch_tb/processor_str/control_path/currentstate
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/base
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/len
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/key
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/i
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/left
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/right
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/mid
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_str/data_path/memdata
add wave -noupdate -format Logic /exponentialsearch_tb/ce1
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/address1
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/es1_data_in
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/pos1
add wave -noupdate -format Logic /exponentialsearch_tb/done1
add wave -noupdate -divider ExponentialSearch_beh
add wave -noupdate -format Literal /exponentialsearch_tb/processor_beh/currentstate
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/base
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/len
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/key
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/i
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/left
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/right
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/mid
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/processor_beh/memdata
add wave -noupdate -format Logic /exponentialsearch_tb/ce2
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/address2
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/es2_data_in
add wave -noupdate -format Literal -radix hexadecimal /exponentialsearch_tb/pos2
add wave -noupdate -format Logic /exponentialsearch_tb/done2
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {6000 ns}
