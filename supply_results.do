* version 15.0

capture clear  // (Clear the data in the memory) capture means to clear the memory if there is data, if not, the clear command will be ignored
clear matrix

global path "/Users/lubin/Desktop/My Library/EmergencyDemandResponse"
cd "$path"

*******************************************************************************************************************************
*** Supplementary Table 7 - Estimations examining the effects of the EDR on electricity use in areas with temperature rises ***
*******************************************************************************************************************************
use "EDR_effect.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

gen att_postedr = att*postedr
xtset user_id postedr

* Column 1 - EDR Difference-in-difference-in-difference TempDiff *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_tempdiff=att*postedr*tempdiff
gen att_tempdiff=att*tempdiff
gen postedr_tempdiff=postedr*tempdiff

xtreg elec att_postedr_tempdiff att_tempdiff postedr_tempdiff att_postedr att postedr tempdiff $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables7c1

* Column 3 - EDR Difference-in-difference-in-difference TempDiff Urban *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_tempdiff att_tempdiff postedr_tempdiff att_postedr att postedr tempdiff $control_feature $control_weather if urban == 1 , fe i(group) robust cluster(group)
est store tables7c3

* Column 4 - EDR Difference-in-difference-in-difference TempDiff Rural *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_tempdiff att_tempdiff postedr_tempdiff att_postedr att postedr tempdiff $control_feature $control_weather if urban == 0 , fe i(group) robust cluster(group)
est store tables7c4

* Column 5 - EDR Difference-in-difference-in-difference TempDiff Children *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_tempdiff att_tempdiff postedr_tempdiff att_postedr att postedr tempdiff $control_feature $control_weather if children == 1, fe i(group) robust cluster(group)
est store tables7c5

* Column 6 - EDR Difference-in-difference-in-difference TempDiff Elderly *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_tempdiff att_tempdiff postedr_tempdiff att_postedr att postedr tempdiff $control_feature $control_weather if elderly ==1, fe i(group) robust cluster(group)
est store tables7c6

* Column 2 - EDR spillover effect Difference-in-difference-in-difference TempDiff *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postmessage = att*postmessage
xtset user_id postmessage

gen att_postmessage_tempdiff=att*postmessage*tempdiff
gen postmessage_tempdiff=postmessage*tempdiff

xtreg elec att_postmessage_tempdiff att_tempdiff postmessage_tempdiff att_postmessage att postmessage tempdiff $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables7c2

outreg2 [tables7c1 tables7c2 tables7c3 tables7c4 tables7c5 tables7c6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

***************************************************************************************************************************
*** Supplementary Table 8 - Estimations examining the effects of the EDR on electricity use with increasing temperature ***
***************************************************************************************************************************

*temperature_20
gen att_postedr_temperature_20=att*postedr*temperature_20
gen att_temperature_20=att*temperature_20
gen postedr_temperature_20=postedr*temperature_20

gen att_postmessage_temperature_20=att*postmessage*temperature_20
gen postmessage_temperature_20=postmessage*temperature_20

xtreg elec att_postedr_temperature_20 att_temperature_20 postedr_temperature_20 att_postedr att postedr temperature_20 $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables8c1
xtreg elec att_postmessage_temperature_20 att_temperature_20 postmessage_temperature_20 att_postmessage att postmessage temperature_20 $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables8c2
xtreg elec att_postedr_temperature_20 att_temperature_20 postedr_temperature_20 att_postedr att postedr temperature_20 $control_feature $control_weather if urban == 1 , fe i(group) robust cluster(group)
est store tables8c3
xtreg elec att_postedr_temperature_20 att_temperature_20 postedr_temperature_20 att_postedr att postedr temperature_20 $control_feature $control_weather if urban == 0 , fe i(group) robust cluster(group)
est store tables8c4
xtreg elec att_postedr_temperature_20 att_temperature_20 postedr_temperature_20 att_postedr att postedr temperature_20 $control_feature $control_weather if children == 1, fe i(group) robust cluster(group)
est store tables8c5
xtreg elec att_postedr_temperature_20 att_temperature_20 postedr_temperature_20 att_postedr att postedr temperature_20 $control_feature $control_weather if elderly ==1, fe i(group) robust cluster(group)
est store tables8c6

outreg2 [tables8c1 tables8c2 tables8c3 tables8c4 tables8c5 tables8c6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

**************************************************************************************************************************************
*** Supplementary Table 10 - Estimations examining the effects of the EDR assignment selection on the logarithm of electricity use ***
**************************************************************************************************************************************
global path "/Users/lubin/Desktop/My Library/EmergencyDemandResponse"
cd "$path"

use "EDR_effect.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr
gen lnelec = log(elec)

xtset user_id postedr

* Column 1 - Main effect: EDR effect *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg lnelec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store table10c1

* Column 3 - Heterogeneous effect: Urban *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban

xtreg lnelec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store table10c3

* Column 4 - Heterogeneous effect: Children *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children
xtreg lnelec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe i(group) robust cluster(group)
est store table10c4

* Column 5 - Heterogeneous effect: Elderly *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly
xtreg lnelec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store table10c5

* Column 2 - Main effect: EDR spillover effect *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_postmessage=att*postmessage
xtset user_id postmessage
xtreg lnelec att_postmessage att postmessage $control_feature $control_weather , fe i(group) robust cluster(group)
est store table10c2

outreg2 [table10c1 table10c2 table10c3 table10c4 table10c5] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

*********************************************************************************************************************************
*** Supplementary Table 11 - Estimations examining the effects of the EDR rebate coverage on the logarithm of electricity use ***
*********************************************************************************************************************************

*columns (1)-(4)
*IV - compare A to C
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

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

gen att_postedr = att*postedr
gen iv_postedr = iv*postedr

gen lnelec = log(elec)
xtset user_id postedr

xtivreg lnelec postedr $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store tables11c1

* Heterogeneous effect: Urban *
gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban
xtivreg lnelec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store tables11c2

* Heterogeneous effect: Children *
gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children
xtivreg lnelec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store tables11c3

* Heterogeneous effect: Elderly *
gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly
xtivreg lnelec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store tables11c4

outreg2 [tables11c1 tables11c2 tables11c3 tables11c4] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

*columns (5)-(8)
*A vs C
use "All_subsampleC.dta", clear
append using "All_subsampleA.dta"

gen lnelec = log(elec)

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr
xtset user_id postedr

xtreg lnelec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables11c5

* Heterogeneous effect: Urban *
gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban
xtreg lnelec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables11c6

* Heterogeneous effect: Children *
gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children
xtreg lnelec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables11c7

* Heterogeneous effect: Elderly *
gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly
xtreg lnelec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables11c8

outreg2 [tables11c5 tables11c6 tables11c7 tables11c8] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

********************************************************************************************************************************************************
*** Supplementary Table 12 - Estimations examining the effects of the EDR rebate coverage on electricity use (within heterogeneous group regression) ***
********************************************************************************************************************************************************

*columns (1)-(4)
*IV - compare A to C
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

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

gen att_postedr = att*postedr
gen iv_postedr = iv*postedr

xtset user_id postedr

xtivreg elec postedr $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust) first
est store tables12c1

xtivreg elec postedr $control_feature $control_weather (att_postedr = iv_postedr) if urban == 1,fe vce(robust) first
est store tables12c2

xtivreg elec postedr $control_feature $control_weather (att_postedr = iv_postedr) if children == 1,fe vce(robust) first
est store tables12c3

xtivreg elec postedr $control_feature $control_weather (att_postedr = iv_postedr) if elderly == 1,fe vce(robust) first
est store tables12c4

outreg2 [tables12c1 tables12c2 tables12c3 tables12c4] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

*columns (5)-(8)
*A vs C
use "All_subsampleC.dta", clear
append using "All_subsampleA.dta"

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr

xtset user_id postedr

xtreg elec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables12c5

xtreg elec att_postedr att postedr $control_feature $control_weather if urban == 1, fe i(group) robust cluster(group)
est store tables12c6

xtreg elec att_postedr att postedr $control_feature $control_weather if children == 1, fe i(group) robust cluster(group)
est store tables12c7

xtreg elec att_postedr att postedr $control_feature $control_weather if elderly == 1, fe i(group) robust cluster(group)
est store tables12c8

outreg2 [tables12c5 tables12c6 tables12c7 tables12c8] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

***********************************************************************************************************************************************************************
*** Supplementary Table 13 - Estimations examining the effects of the EDR assignment selection (comparison of results before and after the DTW-based matching method) ***
***********************************************************************************************************************************************************************

use "EDR_effect.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr
xtset user_id postedr

* Column 1 - Main effect: EDR effect *
* Controls no
* Group no
* Robust clustered SEs

xtreg elec att_postedr att postedr, fe robust
est store tables13c1

* Column 2 - Main effect: EDR effect *
* Controls yes
* Group no
* Robust clustered SEs

xtreg elec att_postedr att postedr $control_feature $control_weather , fe robust
est store tables13c2

* Column 3 - EDR spillover effect *
* Controls no
* Group no
* Robust clustered SEs

gen att_postmessage=att*postmessage
xtset user_id postmessage

xtreg elec att_postmessage att postmessage, fe robust
est store tables13c3

* Column 4 - EDR spillover effect *
* Controls yes
* Group no
* Robust clustered SEs

xtreg elec att_postmessage att postmessage $control_feature $control_weather , fe robust
est store tables13c4

* Column 5 - Main effect: EDR effect *
* Controls no
* Group yes
* Robust clustered SEs

xtreg elec att_postedr att postedr, fe i(group) robust cluster(group)
est store tables13c5

* Column 6 - Main effect: EDR effect *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables13c6

* Column 7 - EDR spillover effect *
* Controls no
* Group yes
* Robust clustered SEs

xtreg elec att_postmessage att postmessage, fe i(group) robust cluster(group)
est store tables13c7

* Column 8 - EDR spillover effect *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postmessage att postmessage $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables13c8

outreg2 [tables13c1 tables13c2 tables13c3 tables13c4 tables13c5 tables13c6 tables13c7 tables13c8] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

***********************************************************************************************************************************************************************
*** Supplementary Table 14 - Estimations examining the effects of the EDR assignment selection among heterogeneous groups (comparison of results before and after the DTW-based matching method) ***
***********************************************************************************************************************************************************************

use "EDR_effect.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr
xtset user_id postedr

* Column 1 - Heterogeneous effect: Urban *
* Controls yes
* Group no
* Robust clustered SEs

gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban

xtreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe robust
est store tables14c1

* Column 2 - Heterogeneous effect: Children *
* Controls yes
* Group no
* Robust clustered SEs

gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children

xtset user_id postedr
xtreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe robust
est store tables14c2

* Column 3 - Heterogeneous effect: Elderly *
* Controls yes
* Group no
* Robust clustered SEs

gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly

xtset user_id postedr
xtreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe robust
est store tables14c3

* Column 4 - Heterogeneous effect: Urban *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables14c4

* Column 5 - Heterogeneous effect: Children *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables14c5

* Column 6 - Heterogeneous effect: Elderly *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables14c6

outreg2 [tables14c1 tables14c2 tables14c3 tables14c4 tables14c5 tables14c6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

***********************************************************************************************************************************************************************
*** Supplementary Table 15 - Estimations examining the effects of the EDR rebate coverage among heterogeneous groups (comparison of results before and after the DTW-based matching method) ***
***********************************************************************************************************************************************************************

use "All_subsampleC.dta", clear
append using "All_subsampleA.dta"

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr=att*postedr

xtset user_id postedr

* Column 1 - EDR rebate coverage: Total *
* Controls yes
* Group no
* Robust clustered SEs

xtreg elec att_postedr att postedr $control_feature $control_weather , fe robust
est store tables15c1

* Column 2 - EDR rebate coverage: urban *
* Controls yes
* Group no
* Robust clustered SEs

gen att_postedr_urban=att*postedr*urban
gen att_urban=att*urban
gen postedr_urban=postedr*urban

xtreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe robust
est store tables15c2

* Column 3 - EDR rebate coverage: children *
* Controls yes
* Group no
* Robust clustered SEs

gen att_postedr_children=att*postedr*children
gen att_children=att*children
gen postedr_children=postedr*children

xtreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe robust
est store tables15c3

* Column 4 - EDR rebate coverage: elderly *
* Controls yes
* Group no
* Robust clustered SEs

gen att_postedr_elderly=att*postedr*elderly
gen att_elderly=att*elderly
gen postedr_elderly=postedr*elderly

xtreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe robust
est store tables15c4

* Column 5 - EDR rebate coverage: Total *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr att postedr $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables15c5

* Column 6 - EDR rebate coverage: urban *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_urban att_urban postedr_urban att_postedr att postedr urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables15c6

* Column 7 - EDR rebate coverage: children *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_children att_children postedr_children att_postedr att postedr children $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables15c7

* Column 8 - EDR rebate coverage: elderly *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_postedr_elderly att_elderly postedr_elderly att_postedr att postedr elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables15c8

outreg2 [tables15c1 tables15c2 tables15c3 tables15c4 tables15c5 tables15c6 tables15c7 tables15c8] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

************************************
*** Heckman two-step method test ***
************************************

********************************************************************
*** Supplementary Table 16 - Heckman two-step method test result ***
********************************************************************

use "Robust_heckman.dta",clear 

global control_weather " wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa"
global control_feature " m_ave city d_level "
global control_heckman " Area Person_cnt Ene_industry Income Electric_car Region D_leval Aircon_cnt Lapp_cnt M_ave"

xtset user_id postedr 
gen att_postedr = att*postedr

*ols
reg elec att_postedr  $control_weather  $control_feature 
est store OLS

*heckmle
heckman elec att_postedr  $control_weather $control_feature, select(att= Act_enth $control_heckman $control_feature ) 
est store HeckMLE

*heck2sls
heckman elec att_postedr  $control_weather $control_feature, select(att= Act_enth $control_heckman $control_feature ) twostep
est store Heck2SLS

*2sls
probit att Act_enth $control_heckman
est store First

predict y_hat,xb
gen pdf=normalden(y_hat)
gen cdf=normal(y_hat)
gen imr1=pdf/cdf // att=1
gen imr2=(-pdf)/(1-cdf) // att=0
gen imr=imr1
replace imr=imr2 if att==0

reg elec att_postedr $control_weather $control_feature imr 
est store Second

local m "OLS HeckMLE Heck2SLS First Second"

esttab `m' using "Robust_heckman_result.rtf", mtitle(`m') nogap compress pr2 ar2 replace b(%9.4f) se(4) star(* 0.10 ** 0.05 *** 0.01)

********************
*** Placebo test ***
********************

**********************************************************************************************************************************
*** Supplementary Table 17 - Estimations examining the effect of EDR assignment selection (intent-to-treat test, placebo test) ***
**********************************************************************************************************************************

use "placebo_EDR_effect.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

gen att_post = att*post
xtset user_id post

* Column 1 - Main effect: EDR effect *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_post att post $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables17c1

* Column 2 - Main effect: EDR spillover effect *
* Controls yes
* Group yes
* Robust clustered SEs

xtreg elec att_post att post $control_feature $control_weather if sample_ == 2 | sample_ ==3, fe i(group) robust cluster(group)
est store tables17c2

* Column 3 - Heterogeneous effect: Urban *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_post_urban=att*post*urban
gen att_urban=att*urban
gen post_urban=post*urban

xtreg elec att_post_urban att_urban post_urban att_post att post urban $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables17c3

* Column 4 - Heterogeneous effect: Children *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_post_children=att*post*children
gen att_children=att*children
gen post_children=post*children
xtreg elec att_post_children att_children post_children att_post att post children $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables17c4

* Column 5 - Heterogeneous effect: Elderly *
* Controls yes
* Group yes
* Robust clustered SEs

gen att_post_elderly=att*post*elderly
gen att_elderly=att*elderly
gen post_elderly=post*elderly
xtreg elec att_post_elderly att_elderly post_elderly att_post att post elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables17c5

outreg2 [tables17c1 tables17c2 tables17c3 tables17c4 tables17c5] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

*******************************************************************************************************************************************************
*** Supplementary Table 18 - Estimations examining the effects of EDR rebate coverage (IV two-stage approach and DTW matching method, placebo test) ***
*******************************************************************************************************************************************************

* Column 1-4 EDR rebate coverage (IV two-stage) *
*A vs C
use "placebo_EDR_effect.dta", clear

gen iv=att
replace iv = 1 if sample_ == 1
replace iv = 1 if sample_ == 2
replace iv = 0 if sample_ == 3
label variable iv "AB1,C0"

replace att = 1 if sample_ == 1
replace att = 0 if sample_ == 2
replace att = 0 if sample_ == 3
label variable att "A1,BC0"

gen att_post = att*post
gen iv_post = iv*post
global control_weather "wind_direction_2mean_angle relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

xtset user_id post

* Total *
xtivreg elec post $control_feature $control_weather (att_post = iv_post),fe vce(robust) first
est store tables18c1

* Heterogeneous effect: Urban *
gen att_post_urban=att*post*urban
gen att_urban=att*urban
gen post_urban=post*urban
xtivreg elec att_post_urban att_urban post_urban att_post att post urban $control_feature $control_weather (att_post = iv_post),fe vce(robust) first
est store tables18c2

gen att_post_children=att*post*children
gen att_children=att*children
gen post_children=post*children
xtivreg elec att_post_children att_children post_children att_post att post children $control_feature $control_weather (att_post = iv_post),fe vce(robust) first
est store tables18c3

gen att_post_elderly=att*post*elderly
gen att_elderly=att*elderly
gen post_elderly=post*elderly
xtivreg elec att_post_elderly att_elderly post_elderly att_post att post elderly $control_feature $control_weather (att_post = iv_post),fe vce(robust) first
est store tables18c4

outreg2 [tables18c1 tables18c2 tables18c3 tables18c4] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

* Column 5-8 EDR rebate coverage (DTW-matching) *
*A vs C

use "placebo_EDR_effect.dta", clear
replace att = 1 if sample_ == 1
replace att = 0 if sample_ == 3

gen att_post=att*post
global control_weather "wind_direction_2mean_angle relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"

xtset user_id post

* Total *
xtreg elec att_post att post $control_feature $control_weather if sample_ == 1 | sample_ ==3, fe i(group) robust cluster(group)
est store tables18c5

* Heterogeneous effect: Urban *
gen att_post_urban=att*post*urban
gen att_urban=att*urban
gen post_urban=post*urban
xtreg elec att_post_urban att_urban post_urban att_post att post urban $control_feature $control_weather if sample_ == 1 | sample_ ==3, fe i(group) robust cluster(group)
est store tables18c6

* Heterogeneous effect: Children *
gen att_post_children=att*post*children
gen att_children=att*children
gen post_children=post*children
xtreg elec att_post_children att_children post_children att_post att post children $control_feature $control_weather if sample_ == 1 | sample_ ==3, fe i(group) robust cluster(group)
est store tables18c7

* Heterogeneous effect: Elderly *
gen att_post_elderly=att*post*elderly
gen att_elderly=att*elderly
gen post_elderly=post*elderly
xtreg elec att_post_elderly att_elderly post_elderly att_post att post elderly $control_feature $control_weather , fe i(group) robust cluster(group)
est store tables18c8

outreg2 [tables18c5 tables18c6 tables18c7 tables18c8] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

****************************************************************
*** Supplementary Table 21 - Regression model with MP and AP ***
****************************************************************

global path "/Users/lubin/Desktop/My Library/EmergencyDemandResponse"
cd "$path"

use "All_subsampleABC_price.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr = att*postedr

*FE model
reghdfe elec att_postedr att postedr mp201907 ap201907 $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store tables21c1

* IV *
gen iv=att
replace iv = 1 if sample_ == 1
replace iv = 1 if sample_ == 2
replace iv = 0 if sample_ == 3
label variable iv "AB1,C0"

replace att = 1 if sample_ == 1
replace att = 0 if sample_ == 2
replace att = 0 if sample_ == 3
label variable att "A1,BC0"

gen iv_postedr = iv*postedr
xtset user_id postedr

xtivreg elec postedr mp201907 ap201907 $control_feature $control_weather (att_postedr = iv_postedr),fe vce(robust)
est store tables21c2

outreg2 [tables21c1 tables21c2] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

***********************************************************************************************************
*** Supplementary Table 22 - Heterogeneous treatment effect analysis across different electricity price ***
***********************************************************************************************************

use "All_subsampleABC_price.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr = att*postedr

*DDD FE model
gen att_postedr_mp201907 = att_postedr*mp201907
gen att_mp201907 = att*mp201907
gen postedr_mp201907 = postedr*mp201907
reghdfe elec att_postedr_mp201907 att_postedr att_mp201907 postedr_mp201907 att postedr mp201907 $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store r1

gen att_postedr_ap201907 = att_postedr*ap201907
gen att_ap201907 = att*ap201907
gen postedr_ap201907 = postedr*ap201907
reghdfe elec att_postedr_ap201907 att_postedr att_ap201907 postedr_ap201907 att postedr ap201907 $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store r2

gen att_postedr_mp2019half = att_postedr*mp2019half
gen att_mp2019half = att*mp2019half
gen postedr_mp2019half = postedr*mp2019half
reghdfe elec att_postedr_mp2019half att_postedr att_mp2019half postedr_mp2019half att postedr mp2019half $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store r3

gen att_postedr_ap2019half = att_postedr*ap2019half
gen att_ap2019half = att*ap2019half
gen postedr_ap2019half = postedr*ap2019half
reghdfe elec att_postedr_ap2019half att_postedr att_ap2019half postedr_ap2019half att postedr ap2019half $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store r4

gen att_postedr_mp_year = att_postedr*mp_year
gen att_mp_year = att*mp_year
gen postedr_mp_year = postedr*mp_year
reghdfe elec att_postedr_mp_year att_postedr att_mp_year postedr_mp_year att postedr mp_year $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store r5

gen att_postedr_ap_year = att_postedr*ap_year
gen att_ap_year = att*ap_year
gen postedr_ap_year = postedr*ap_year
reghdfe elec att_postedr_ap_year att_postedr att_ap_year postedr_ap_year att postedr mp_year $control_feature $control_weather, absorb(user_id postedr) vce(cluster user_id)
est store r6

outreg2 [r1 r2 r3 r4 r5 r6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

******************************************************************************************************
*** Supplementary Table 23 - Group regression analysis across different electricity marginal price ***
******************************************************************************************************

use "All_subsampleABC_price.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature_20"
global control_feature "m_ave city d_level"
gen att_postedr = att*postedr

*FE model
reghdfe elec att_postedr att postedr $control_feature $control_weather if mp201907 < .61, absorb(user_id postedr) vce(cluster user_id)
est store r1

drop if mp201907 < .61
reghdfe elec att_postedr att postedr $control_feature $control_weather if mp201907 < .7, absorb(user_id postedr) vce(cluster user_id)
est store r2

drop if mp201907 < .7
reghdfe elec att_postedr att postedr $control_feature $control_weather if mp201907 < 1, absorb(user_id postedr) vce(cluster user_id)
est store r3

* IV *
gen iv=att
replace iv = 1 if sample_ == 1
replace iv = 1 if sample_ == 2
replace iv = 0 if sample_ == 3
label variable iv "AB1,C0"

replace att = 1 if sample_ == 1
replace att = 0 if sample_ == 2
replace att = 0 if sample_ == 3
label variable att "A1,BC0"

gen iv_postedr = iv*postedr
xtset user_id postedr

xtivreg elec postedr mp201907 ap201907 $control_feature $control_weather (att_postedr = iv_postedr) if mp201907 < .61, fe vce(robust)
est store r4

drop if mp201907 < .61
xtivreg elec postedr mp201907 ap201907 $control_feature $control_weather (att_postedr = iv_postedr) if mp201907 < .7, fe vce(robust)
est store r5

drop if mp201907 < .7
xtivreg elec postedr mp201907 ap201907 $control_feature $control_weather (att_postedr = iv_postedr) if mp201907 < 1, fe vce(robust)
est store r6

outreg2 [r1 r2 r3 r4 r5 r6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

******************************************************************************************************************************************
*** Supplementary Table 24 - EDR rebate coverage on the subsample of survey respondents who reported self-owned and tenant information ***
******************************************************************************************************************************************

global path "/Users/lubin/Desktop/My Library/EmergencyDemandResponse"
cd "$path"

use "renteriv.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature"
global control_feature "m_ave city d_level"

gen EDR_post = EDR * post

*FE model
reghdfe elec EDR_post EDR post $control_feature $control_weather , absorb(user_id post) vce(cluster user_id) 
est store r1

* IV *
gen iv=EDR
replace iv = 1 if sample_ == 1
replace iv = 1 if sample_ == 2
replace iv = 0 if sample_ == 3
label variable iv "AB1,C0"

replace EDR = 1 if sample_ == 1
replace EDR = 0 if sample_ == 2
replace EDR = 0 if sample_ == 3
label variable EDR "A1,BC0"

gen iv_post = iv*post
xtset user_id post

xtivreg elec post $control_feature $control_weather (EDR_post = iv_post) ,fe vce(robust) first
est store r2

outreg2 [r1 r2] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

*****************************************************************
*** Supplementary Table 25 - Regression results by house type ***
*****************************************************************

use "renteriv.dta", clear

global control_weather "wind_direction_2mean_angle wind_speed_2mean relative_humidity vapor_pressure_hpa temperature"
global control_feature "m_ave city d_level"

gen EDR_post = EDR * post
gen EDR_post_Htype = EDR_post * htype
gen EDR_Htype = EDR * htype
gen post_Htype = post * htype

reghdfe elec EDR_post_Htype EDR_post EDR_Htype post_Htype EDR postraw htype $control_feature $control_weather , absorb(user_id postraw) vce(cluster user_id)
est store r1

reghdfe elec EDR_post EDR postraw $control_feature $control_weather if htype==1, absorb(user_id postraw) vce(cluster user_id)
est store r2

reghdfe elec EDR_post EDR postraw $control_feature $control_weather if htype==0, absorb(user_id postraw) vce(cluster user_id)
est store r3

outreg2 [r1 r2 r3] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

