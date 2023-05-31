* version 15.0

capture clear  // (Clear the data in the memory) capture means to clear the memory if there is data, if not, the clear command will be ignored
clear matrix

****************************
*** Combine Sample A,B,C ***
****************************

global path "/Users/lubin/Desktop/My Library/EmergencyDemandResponse"
cd "$path"

*compare（A+B）to C
use All_subsampleA.dta, clear
append using All_subsampleB.dta
replace att=1 //intent-to-treat test
append using All_subsampleC.dta
save EDR_effect.dta, replace

use EDR_effect.dta, clear

*******************
*** Regressions ***
*******************

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr
xtset user_id postedr

*****************************************************************************************************
*** TABLE 1 - Estimations examining the effect of EDR assignment selection (intent-to-treat test) ***
*****************************************************************************************************

* Column 1 - Main effect: EDR effect *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store table1c1

* Column 3 - Heterogeneous effect: Urban *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban

xtreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store table1c3

* Column 4 - Heterogeneous effect: Children *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children
xtreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe i(group) robust cluster(group)
est store table1c4

* Column 5 - Heterogeneous effect: Elderly *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly
xtreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store table1c5

* Column 2 - Main effect: EDR spillover effect *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postmessage=att*postmessage
xtset user_id postmessage
xtreg elec att_postmessage att postmessage $control_feature $control_weather , fe i(group) robust cluster(group)
est store table1c2

outreg2 [table1c1 table1c2 table1c3 table1c4 table1c5] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

**************************************************************************************************************************
*** TABLE 2 - Estimations examining the effects of EDR rebate coverage (IV two-stage approach and DTW matching method) *** 
**************************************************************************************************************************

* Column 1-4 EDR rebate coverage (IV two-stage) *
*A vs C

use "All_subsampleA.dta", clear
append using "All_subsampleB.dta"
append using "All_subsampleC.dta"

gen iv=att
replace iv = 1 if sample_ == 1
replace iv = 1 if sample_ == 2
replace iv = 0 if sample_ == 3
label variable iv "AB1,C0"

replace att = 1 if sample_ == 1
replace att = 0 if sample_ == 2
replace att = 0 if sample_ == 3
label variable att "A1,BC0"

gen att_postedr = att*postedr
gen iv_postedr = iv*postedr
global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

xtset user_id postedr

* Total *
xtivreg elec postedr $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store table2c1

* Heterogeneous effect: Urban *
gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban
xtivreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store table2c2

gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children
xtivreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store table2c3

gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly
xtivreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store table2c4

outreg2 [table2c1 table2c2 table2c3 table2c4] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

* Column 5-8 EDR rebate coverage (DTW-matching) *
*A vs C

use "All_subsampleC.dta", clear
append using "All_subsampleA.dta"
save SampleA_C.dta, replace

gen att_postedr=att*postedr
global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

xtset user_id postedr

* Total *
xtreg elec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store table2c5

* Heterogeneous effect: Urban *
gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban
xtreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store table2c6

* Heterogeneous effect: Children *
gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children
xtreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe i(group) robust cluster(group)
est store table2c7

* Heterogeneous effect: Elderly *
gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly
xtreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store table2c8

outreg2 [table2c5 table2c6 table2c7 table2c8] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace




********************************************************************************************
*** Table 3 - Estimations examining the sustainability of the incentive-based EDR effect ***
********************************************************************************************

***************sustainability_main***************

use "EDR_sustainability_main.dta", clear

global control_weather "temperature pressure_hpa wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa visibility wind_level"
global control_feature "m_ave city d_level"

xtset user_id time

* Column 1 - Main Effect Att_cnt *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation att_cnt i.time $control_feature $control_weather , fe i(group) robust cluster (group)
est store table3c1

* Column 2 - Main Effect phase *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation i.att_cnt i.time $control_feature $control_weather , fe i(group) robust cluster (group)
est store table3c2

* Column 5 - Heterogeneous effect Rural Att_cnt *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation att_cnt i.time $control_feature $control_weather if urban == 0, fe i(group) robust cluster (group)
est store table3c5

* Column 6 - Heterogeneous effect Rural phase *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation i.att_cnt i.time $control_feature $control_weather if urban == 0, fe i(group) robust cluster (group)
est store table3c6

* Column 7 - Heterogeneous effect Urban Att_cnt *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation att_cnt i.time $control_feature $control_weather if urban == 1, fe i(group) robust cluster (group)
est store table3c7

* Column 8 - Heterogeneous effect Urban phase *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation i.att_cnt i.time $control_feature $control_weather if urban == 1, fe i(group) robust cluster (group)
est store table3c8

outreg2 [table3c1 table3c2 table3c5 table3c6 table3c7 table3c8] using auditorreturn1,se e(r2_a,F) bdec(4) sdec(4) excel replace

***************sustainability_spillover***************

use "EDR_sustainability_spillover.dta", clear

global control_weather "temperature pressure_hpa wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa visibility wind_level"
global control_feature "m_ave city d_level"

xtset user_id time

* Column 3 - Spillover Effect Message_cnt *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation message_cnt i.time $control_feature $control_weather , fe i(group) robust cluster (group)
est store table3c3

* Column4 - Spillover Effect phase *
* Controls yes
* Household_Group FE
* Time FE
* Robust clustered SEs

xtreg elec_conservation i.message_cnt i.time $control_feature $control_weather , fe i(group) robust cluster (group)
est store table3c4

outreg2 [table3c3 table3c4] using auditorreturn1,se e(r2_a,F) bdec(4) sdec(4) excel replace




reghdfe elec att_postedr att postedr $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
reghdfe elec att_postedr att postedr $control_feature $control_weather, absorb(user_id postedr) vce(cluster group)

reghdfe elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
reghdfe elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)

xtreg  $control_feature $control_weather , fe i(group) robust cluster(group)
