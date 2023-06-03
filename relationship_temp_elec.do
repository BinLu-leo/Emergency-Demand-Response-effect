* version 15.0

capture clear  // (Clear the data in the memory) capture means to clear the memory if there is data, if not, the clear command will be ignored
clear matrix


global path "/Users/lubin/Desktop/My Library/EmergencyDemandResponse/revise"
cd "$path"

************************************************************************************
*** Supplementary Table 3 - Relationship between temperature and electricity use ***
************************************************************************************

use "relationship_temp_elec_onpeak.dta", clear

gen lnelec_mean = log(elec_mean)
global control_weather_mean "pressure_hpa_mean wind_direction_2mean_angle_mean wind_speed_2mean_mean relative_humidity_mean visibility_mean wind_level_mean"

gen lnelec_peak = log(elec_peak)
global control_weather_peak "pressure_hpa_peak wind_direction_2mean_angle_peak wind_speed_2mean_peak relative_humidity_peak visibility_peak wind_level_peak"

xtset user_id time

* Column 1-3 - All time: Total/Urban/Rural *
* Controls yes
* Individual FE yes
* Robust clustered SEs

xtreg elec_mean temperature_mean $control_weather_mean, fe r
est store tableS3c1

xtreg elec_mean temperature_mean $control_weather_mean if urban==1, fe r
est store tableS3c2

xtreg elec_mean temperature_mean $control_weather_mean if urban==0, fe r
est store tableS3c3

* Column 4-6 - On-peak time: Total/Urban/Rural *
* Controls yes
* Individual FE yes
* Robust clustered SEs

xtreg elec_peak temperature_peak $control_weather_peak, fe r
est store tableS3c4

xtreg elec_peak temperature_peak $control_weather_peak if urban==1, fe r
est store tableS3c5

xtreg elec_peak temperature_peak $control_weather_peak if urban==0, fe r
est store tableS3c6

outreg2 [tableS3c1 tableS3c2 tableS3c3 tableS3c4 tableS3c5 tableS3c6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace

*************************************************************************************************
*** Supplementary Table 4 - Relationship between temperature and logarithm of electricity use ***
*************************************************************************************************

* Column 1-3 - All time: Total/Urban/Rural *
* Controls yes
* Individual FE yes
* Robust clustered SEs

xtreg lnelec_mean temperature_mean $control_weather_mean, fe r
est store tableS4c1

xtreg lnelec_mean temperature_mean $control_weather_mean if urban==1, fe r
est store tableS4c2

xtreg lnelec_mean temperature_mean $control_weather_mean if urban==0, fe r
est store tableS4c3

* Column 4-6 - On-peak time: Total/Urban/Rural *
* Controls yes
* Individual FE yes
* Robust clustered SEs

xtreg lnelec_peak temperature_peak $control_weather_peak, fe r
est store tableS4c4

xtreg lnelec_peak temperature_peak $control_weather_peak if urban==1, fe r
est store tableS4c5

xtreg lnelec_peak temperature_peak $control_weather_peak if urban==0, fe r
est store tableS4c6

outreg2 [tableS4c1 tableS4c2 tableS4c3 tableS4c4 tableS4c5 tableS4c6] using auditorreturn1, e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace
*coefplot tableS4c1 tableS4c2 tableS4c3 tableS4c4 tableS4c5 tableS4c6, drop(_cons pressure_hpa_mean wind_direction_2mean_angle_mean wind_speed_2mean_mean relative_humidity_mean visibility_mean wind_level_mean pressure_hpa_peak wind_direction_2mean_angle_peak wind_speed_2mean_peak relative_humidity_peak visibility_peak wind_level_peak) ciopts(recast(rcap)) vertical

********************************************************************************************
*** Supplementary Table 5 - Relationship between temperature and electricity use by hour ***
********************************************************************************************

use "relationship_temp_elec_byhour.dta", clear

gen lnelec = log(elec)
global control_weather "pressure_hpa wind_direction_2mean_angle wind_speed_2mean relative_humidity visibility wind_level"

xtset user_id time

* Controls yes
* Individual FE yes
* Robust clustered SEs

xtreg elec temperature $control_weather if hour==1, fe r
est store hour1
xtreg elec temperature $control_weather if hour==2, fe r
est store hour2
xtreg elec temperature $control_weather if hour==3, fe r
est store hour3
xtreg elec temperature $control_weather if hour==4, fe r
est store hour4
xtreg elec temperature $control_weather if hour==5, fe r
est store hour5
xtreg elec temperature $control_weather if hour==6, fe r
est store hour6
xtreg elec temperature $control_weather if hour==7, fe r
est store hour7
xtreg elec temperature $control_weather if hour==8, fe r
est store hour8
xtreg elec temperature $control_weather if hour==9, fe r
est store hour9
xtreg elec temperature $control_weather if hour==10, fe r
est store hour10
xtreg elec temperature $control_weather if hour==11, fe r
est store hour11
xtreg elec temperature $control_weather if hour==12, fe r
est store hour12
xtreg elec temperature $control_weather if hour==13, fe r
est store hour13
xtreg elec temperature $control_weather if hour==14, fe r
est store hour14
xtreg elec temperature $control_weather if hour==15, fe r
est store hour15
xtreg elec temperature $control_weather if hour==16, fe r
est store hour16
xtreg elec temperature $control_weather if hour==17, fe r
est store hour17
xtreg elec temperature $control_weather if hour==18, fe r
est store hour18
xtreg elec temperature $control_weather if hour==19, fe r
est store hour19
xtreg elec temperature $control_weather if hour==20, fe r
est store hour20
xtreg elec temperature $control_weather if hour==21, fe r
est store hour21
xtreg elec temperature $control_weather if hour==22, fe r
est store hour22
xtreg elec temperature $control_weather if hour==23, fe r
est store hour23
xtreg elec temperature $control_weather if hour==24, fe r
est store hour24

outreg2 [hour1 hour2 hour3 hour4 hour5 hour6 hour7 hour8 hour9 hour10 hour11 hour12 hour13 hour14 hour15 hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23 hour24] using auditorreturn1,e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace
*coefplot hour1 hour2 hour3 hour4 hour5 hour6 hour7 hour8 hour9 hour10 hour11 hour12 hour13 hour14 hour15 hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23 hour24, drop(_cons weekend pressure_hpa wind_direction_2mean_angle wind_speed_2mean relative_humidity visibility wind_level) ciopts(recast(rcap)) vertical

*************************************************************************************************************
*** Supplementary Table 6 - Relationship between temperature and the logarithm of electricity use by hour ***
*************************************************************************************************************

* Controls yes
* Individual FE yes
* Robust clustered SEs

xtreg lnelec temperature $control_weather if hour==1, fe r
est store hourl1
xtreg lnelec temperature $control_weather if hour==2, fe r
est store hourl2
xtreg lnelec temperature $control_weather if hour==3, fe r
est store hourl3
xtreg lnelec temperature $control_weather if hour==4, fe r
est store hourl4
xtreg lnelec temperature $control_weather if hour==5, fe r
est store hourl5
xtreg lnelec temperature $control_weather if hour==6, fe r
est store hourl6
xtreg lnelec temperature $control_weather if hour==7, fe r
est store hourl7
xtreg lnelec temperature $control_weather if hour==8, fe r
est store hourl8
xtreg lnelec temperature $control_weather if hour==9, fe r
est store hourl9
xtreg lnelec temperature $control_weather if hour==10, fe r
est store hourl10
xtreg lnelec temperature $control_weather if hour==11, fe r
est store hourl11
xtreg lnelec temperature $control_weather if hour==12, fe r
est store hourl12
xtreg lnelec temperature $control_weather if hour==13, fe r
est store hourl13
xtreg lnelec temperature $control_weather if hour==14, fe r
est store hourl14
xtreg lnelec temperature $control_weather if hour==15, fe r
est store hourl15
xtreg lnelec temperature $control_weather if hour==16, fe r
est store hourl16
xtreg lnelec temperature $control_weather if hour==17, fe r
est store hourl17
xtreg lnelec temperature $control_weather if hour==18, fe r
est store hourl18
xtreg lnelec temperature $control_weather if hour==19, fe r
est store hourl19
xtreg lnelec temperature $control_weather if hour==20, fe r
est store hourl20
xtreg lnelec temperature $control_weather if hour==21, fe r
est store hourl21
xtreg lnelec temperature $control_weather if hour==22, fe r
est store hourl22
xtreg lnelec temperature $control_weather if hour==23, fe r
est store hourl23
xtreg lnelec temperature $control_weather if hour==24, fe r
est store hourl24

outreg2 [hourl1 hourl2 hourl3 hourl4 hourl5 hourl6 hourl7 hourl8 hourl9 hourl10 hourl11 hourl12 hourl13 hourl14 hourl15 hourl16 hourl17 hourl18 hourl19 hourl20 hourl21 hourl22 hourl23 hourl24] using auditorreturn1,e(r2_b,F) bdec(4) sdec(4) rdec(4) excel replace
*coefplot hourl1 hourl2 hourl3 hourl4 hourl5 hourl6 hourl7 hourl8 hourl9 hourl10 hourl11 hourl12 hourl13 hourl14 hourl15 hourl16 hourl17 hourl18 hourl19 hourl20 hourl21 hourl22 hourl23 hourl24, drop(_cons weekend pressure_hpa wind_direction_2mean_angle wind_speed_2mean relative_humidity visibility wind_level) ciopts(recast(rcap)) vertical

