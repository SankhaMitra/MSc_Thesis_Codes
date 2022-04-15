**** The following are the codes for replication of the results of my M.Sc. thesis ****
**** The results are preliminary, not to be cited and shared ****
**** Codes are not be shared or posted in public domain ****
**** Thank you ****

cd "D:\Semester4_Courses\HSP620\Results_Replication_Stata" 
***You can write the path of your working directory here***
*** We import the dataset used in Master's Thesis (ongoing)**** 
use PanelData_1991to2019_Varsinpercent 
*** Our dataset spans over 29 years (1991-2019) ***
*** Our dataset takes into account 17 major Indian states ***
*** We undertake a panel data analysis ****
xtset statecode Year
*** Models 1-4 ****
eststo model1: qui reg schools_established Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year#i.statecode, vce(cluster statecode)

*** eststo command runs the model and stores the estimates, qui ensures the regression is run quietly, ie, all the outputs are not written down instantaneously; ## are used for interaction terms and to ensure that the terms that are interacted are also included as separate explanatory variables; i.statecode and i.Year are for state and time fixed effects, c.Year#i.statecode is for state-specific time trends; vce(cluster statecode) is specified to report robust standard errors clustered at state-level     
   
eststo model2: qui reg sc_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year#i.statecode, vce(cluster statecode)

eststo model3: qui reg st_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year#i.statecode, vce(cluster statecode)

eststo model4: qui reg tot_min_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year#i.statecode, vce(cluster statecode)
         
esttab model1 model2 model3 model4 using Results_Replication_PolRes_Stata.rtf, se keep(SC_res ST_res SC_curr_share ST_curr_share c.ST_res#c.ST_curr_share c.SC_res#c.SC_curr_share)

***** Esttab finally presents the results of the 4 regression models in a nice table format, results are exported as a word doc (.rtf extension) **********

******* Please change the name of the regression output file that you are exporting from "Results_Replication_PolRes_Stata.rtf" to something else, it would give error if a file by that name already exists in your directory ****   

***** Please refer to .rmd or .html file for replication of the same using using R****** 

******* We now create margin plots to visualize marginal effects of reservation shares for Scheduled Castes and Scheduled Tribes as functions of their corresponding population shares***

**** We have these plots since we introduced interactions between SC(ST) reservation shares and SC(ST) population shares. Marginal effects of SC(ST) reservation shares are therefore linear functions of SC(ST) population shares, and vice-versa****

use PanelData_1991to2019_Varsinpercent, clear
*****Panel Data Analysis*****

xtset statecode Year


gen Year2 = Year 


label var ST_res "ST Reservation Share"
label var ST_curr_share "ST Current Population Shares"
label var SC_res "SC Reservation Share"
label var SC_curr_share "SC Current Population Shares"

******Year2 is created to get rid of the error marginsplot faces if c.Year and i.Year are both included********

********** ST Reservation Margins Plot ***********
qui reg schools_established Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

   
margins, dydx(ST_res) at(ST_curr_share = (0.00(4.00)40.00))
marginsplot, title("States") name("margins_plot_outcome1", replace) plotregion(fcolor(white)) graphregion(fcolor(white))


qui reg sc_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

margins, dydx(ST_res) at(ST_curr_share = (0.00(4.00)40.00))
marginsplot, title("High SC-Population Share Districts") name("margins_plot_outcome2", replace) plotregion(fcolor(white)) graphregion(fcolor(white))


qui reg st_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

margins, dydx(ST_res) at(ST_curr_share = (0.00(4.00)40.00))
marginsplot, title("High ST-Population Share Districts") name("margins_plot_outcome3", replace) plotregion(fcolor(white)) graphregion(fcolor(white))


qui reg tot_min_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

margins, dydx(ST_res) at(ST_curr_share = (0.00(4.00)40.00))
marginsplot, title("High SC/ST-Population Share Districts") name("margins_plot_outcome4", replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph combine margins_plot_outcome1 margins_plot_outcome2 margins_plot_outcome3 margins_plot_outcome4, name("margins_plots_combined", replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph export "ST_Margins_plots_replication.png", replace

**** We repeat this for SC Reservation ***********

******************** SC Reservation Margins Plot ********************
use PanelData_1991to2019_Varsinpercent, clear
*****Panel Data Analysis*****

xtset statecode Year


gen Year2 = Year 


label var ST_res "ST Reservation Share"
label var ST_curr_share "ST Current Population Shares"
label var SC_res "SC Reservation Share"
label var SC_curr_share "SC Current Population Shares"

******Year2 is created to get rid of the error marginsplot faces if c.Year and i.Year are both included********

qui reg schools_established Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)
   
margins, dydx(SC_res) at(SC_curr_share = (0.00(4.00)40.00))
marginsplot, title("States") name("sc_margins_plot_outcome1", replace) plotregion(fcolor(white)) graphregion(fcolor(white))


qui reg sc_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

margins, dydx(SC_res) at(SC_curr_share = (0.00(4.00)40.00))
marginsplot, title("High SC-Population Share Districts") name("sc_margins_plot_outcome2", replace) plotregion(fcolor(white)) graphregion(fcolor(white))


qui reg st_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

margins, dydx(SC_res) at(SC_curr_share = (0.00(4.00)40.00))
marginsplot, title("High ST-Population Share Districts") name("sc_margins_plot_outcome3", replace) plotregion(fcolor(white)) graphregion(fcolor(white))


qui reg tot_min_schools Elec_Yrs_ECI female_win_prop sc_census_share st_census_share Population_Density_SqKm c.ST_res##c.ST_curr_share c.SC_res##c.SC_curr_share i.statecode i.Year c.Year2#i.statecode, vce(cluster statecode)

margins, dydx(SC_res) at(SC_curr_share = (0.00(4.00)40.00))
marginsplot, title("High SC/ST-Population Share Districts") name("sc_margins_plot_outcome4", replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph combine sc_margins_plot_outcome1 sc_margins_plot_outcome2 sc_margins_plot_outcome3 sc_margins_plot_outcome4, name("sc_margins_plots_combined", replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph export "SC_Margins_plots_replication.png", replace

*********** Now we make some maps for SC-Population shares and ST-Population Shares*******
*********** We make them for the years 1991 and 2019 ************************

use PanelData_1991to2019_Varsinpercent, clear

shp2dta using India_State_Boundary, database(Indstatedb) coordinates(Indstatecoord) genid(id)

use Indstatedb, clear
******** 1991 ************************ 
gen stcode_1991 = 1 if id == 17 | id == 16
replace stcode_1991 = 2 if id == 35 | id == 6
replace stcode_1991 = 3 if id == 4 
replace stcode_1991 = 4 if id == 23
replace stcode_1991 = 5 if id == 5
replace stcode_1991 = 6 if id == 7
replace stcode_1991 = 7 if id == 8 
replace stcode_1991 = 8 if id == 11
replace stcode_1991 = 9 if id == 10 | id == 15
replace stcode_1991 = 10 if id == 12
replace stcode_1991 = 11 if id == 21 
replace stcode_1991 = 12 if id == 22
replace stcode_1991 = 13 if id == 14
replace stcode_1991 = 14 if id == 32
replace stcode_1991 = 15 if id == 25 | id == 24
replace stcode_1991 = 16 if id == 34
replace stcode_1991 = 17 if id == 27
replace stcode_1991 = 18 if id == 1| id == 3 | id == 9 | id == 13 | id == 19 | id == 20 | id == 26 | id == 28| id == 29 | id == 30 | id == 31 | id == 33 | id == 36 | id == 37 | id == 2

save trans_1991, replace
*********** A dataset with 1991 data for the variables considered and states considered has been prepared, and along with that we add the states not included in our study but part of India. The file is named Data1991_maps_with_extrastatesanduts  ******************** 
use Data1991_maps_with_extrastatesanduts, clear 
gen stcode_1991 = statecode

merge m:m stcode_1991 using trans_1991

drop if _merge != 3
 
format(ST_curr_share) %12.2f

spmap ST_curr_share using Indstatecoord, id(id) fcolor(Blues) plotregion(fcolor(white)) graphregion(fcolor(white))

graph export "ST_Population_Share_Map_1991_replication_stata.png", replace 

format(SC_curr_share) %12.2f

spmap SC_curr_share using Indstatecoord, id(id) fcolor(Greens) plotregion(fcolor(white)) graphregion(fcolor(white))


graph export "SC_Population_Share_Map_1991_replication_stata.png", replace 

**** We repeat the exercise for 2019 maps; the statecodes would change a bit here, since in 1991, we considered Jharkhand, Chhattisgarh, Uttarakhand and Telangana to be parts of Bihar, Madhya Pradesh, Uttar Pradesh and Andhra Pradesh. In 2019, they are separate states and not included in our study ****   
 
use Indstatedb, clear
**** Statecodes change in 2019 due to formation of new states *************
gen stcode_2019 = 1 if id == 17 
replace stcode_2019 = 2 if id == 35 
replace stcode_2019 = 3 if id == 4 
replace stcode_2019 = 4 if id == 23
replace stcode_2019 = 5 if id == 5
replace stcode_2019 = 6 if id == 7
replace stcode_2019 = 7 if id == 8 
replace stcode_2019 = 8 if id == 11
replace stcode_2019 = 9 if id == 10 
replace stcode_2019 = 10 if id == 12
replace stcode_2019 = 11 if id == 21 
replace stcode_2019 = 12 if id == 22
replace stcode_2019 = 13 if id == 14
replace stcode_2019 = 14 if id == 32
replace stcode_2019 = 15 if id == 25 
replace stcode_2019 = 16 if id == 34
replace stcode_2019 = 17 if id == 27
replace stcode_2019 = 18 if id == 1| id == 3 | id == 9 | id == 13 | id == 19 | id == 20 | id == 26 | id == 28| id == 29 | id == 30 | id == 31 | id == 33 | id == 36 | id == 37 | id == 2 | id == 6 | id == 15 | id == 24 | id == 16

save trans_2019, replace

*********** A dataset with 2019 data for the variables considered and states considered has been prepared, and along with that we add the states not included in our study but part of India. The file is named Data2001_maps_with_extrastatesanduts  ******************** 
use Data2019_maps_withextrastatesanduts, clear 
gen stcode_2019 = statecode

merge m:m stcode_2019 using trans_2019

drop if _merge != 3

format(ST_curr_share) %12.2f

spmap ST_curr_share using Indstatecoord, id(id) fcolor(Blues) plotregion(fcolor(white)) graphregion(fcolor(white))

graph export "ST_Population_Share_Map_2019_replication_stata.png", replace 

format(SC_curr_share) %12.2f

spmap SC_curr_share using Indstatecoord, id(id) fcolor(Greens) plotregion(fcolor(white)) graphregion(fcolor(white))


graph export "SC_Population_Share_Map_2019_replication_stata.png", replace 

***** We now replicate the figures 1 and 2 in the study ******    

import delimited "Reservation_Vars_graph_stata.csv", clear 

**** This .csv dataset was created using R *********
**** This gives average SC and ST reservation shares across the states for the years between 1991 to 2019 **** 


label var screser_meants "SC-Reservation"
label var streser_meants "ST-Reservation"

twoway line screser_meants streser_meants years, lpattern(dash solid) ytitle("Reservation Shares in per cent") plotregion(fcolor(white)) graphregion(fcolor(white)) name("reservation_shares_graph")


graph export "Reservation_Shares_replication_stata.png", replace


**** The following .csv dataset was created using R ****
**** They give average number of schools established across states/ across high SC or ST population share districts of all the states, for every year (Details given in the thesis) ****  

import delimited "Outcomes_graph_stata.csv", clear

label var outcome1_meants "Average Number of Schools Established in State"
label var outcome2_meants "Average Number of Schools Established in High SC-Population Share Districts"
label var outcome3_meants "Average Number of Schools Established in High ST-Population Share Districts"
label var outcome4_meants "Average Number of Schools Established in High SC/ST-Population Share Districts"
    
graph twoway line outcome1_meants years, ytitle("State") name("graph_outcome1", replace) plotregion(fcolor(white)) graphregion(fcolor(white))
 
graph twoway line outcome2_meants years, ytitle("High SC-Population Share") name("graph_outcome2", replace) plotregion(fcolor(white)) graphregion(fcolor(white))
 
graph twoway line outcome3_meants years, ytitle("High ST-Population Share") name("graph_outcome3", replace) plotregion(fcolor(white)) graphregion(fcolor(white))
 
graph twoway line outcome4_meants years, ytitle("High SC/ST-Population Share") name("graph_outcome4", replace) plotregion(fcolor(white)) graphregion(fcolor(white))
 
graph combine graph_outcome1 graph_outcome2 graph_outcome3 graph_outcome4, name("graph_outcomes", replace) plotregion(fcolor(white)) graphregion(fcolor(white))

graph export "Outcomes_Panel_replication_stata.png"

**** Thank You ************
 
