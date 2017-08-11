//Preliminary Result-looking at 2000-2015//

* This do-file analyzes the data from "/Users/nathaniellai/Desktop/MAE/DepVar2-Final.dta" (BG) for the period 2000-2015

clear all
set more off 
cd "/Users/nathaniellai/Desktop/MAE"
capture log close
use "/Users/nathaniellai/Desktop/MAE/DepVar2-Final.dta",clear

merge m:1 countrycode using "/Users/nathaniellai/Desktop/Countrycodecheck/Fracionalization1-touse.dta", force
drop if _merge==2
drop _merge

merge m:1 countrycode using "/Users/nathaniellai/Desktop/Countrycodecheck/Frac2015.dta", force
drop if _merge==2
drop _merge

tab year if dum70s == 1 
* 91 obs
tab year if dum80s == 1 
* 96 obs
tab year if dum90s == 1 
* 97 obs
tab year if dum00s == 1 
* 148 obs 
tab year if dum20s == 1 
* 151 obs

//Generating 0515bk dataset// 
drop if year < 2004 
drop if year > 2010 

//Generating Dummies for Eurozone countries//
 graph matrix chgdp5 extshk mginiall mdemoc 

gen dumeuro = 0 
replace dumeuro = 1 if countrycode == "AUT" 
replace dumeuro = 1 if countrycode == "BEL" 
replace dumeuro = 1 if countrycode == "CYP" 
replace dumeuro = 1 if countrycode == "EST"
replace dumeuro = 1 if countrycode == "FIN" 
replace dumeuro = 1 if countrycode == "FRA" 
replace dumeuro = 1 if countrycode == "DEU"
replace dumeuro = 1 if countrycode == "GRC"
replace dumeuro = 1 if countrycode == "IRL" 
replace dumeuro = 1 if countrycode == "ITA" 
replace dumeuro = 1 if countrycode == "LUX" 
replace dumeuro = 1 if countrycode == "MLT"
replace dumeuro = 1 if countrycode == "NLD" 
replace dumeuro = 1 if countrycode == "PRT" 
replace dumeuro = 1 if countrycode == "SVK" 
replace dumeuro = 1 if countrycode == "SVN"
replace dumeuro = 1 if countrycode == "ESP"

save "/Users/nathaniellai/Desktop/0515bk.dta", replace
 
use "/Users/nathaniellai/Desktop/0515bk.dta", clear
set more off

sum

twoway (scatter chgdp4 gdpprior5, sort mlabel(countrycode))
twoway (scatter chgdp5 gdpprior5, sort mlabel(countrycode))
twoway (scatter chgdp6 gdpprior5, sort mlabel(countrycode))
twoway (scatter chgdp7 gdpprior5, sort mlabel(countrycode))
twoway (scatter chgdp8 gdpprior5, sort mlabel(countrycode))

twoway (scatter gdppost4 gdpprior5, sort mlabel(countrycode))
twoway (scatter gdppost5 gdpprior5, sort mlabel(countrycode))
twoway (scatter gdppost6 gdpprior5, sort mlabel(countrycode))
twoway (scatter gdppost7 gdpprior5, sort mlabel(countrycode))
twoway (scatter gdppost8 gdpprior5, sort mlabel(countrycode))

foreach var of varlist chgdp5 csh_idiffp mginiall nocivitotb4 mdemoc mpolity2 extshk mrol mrq mccup{
sum `var' if dumlatina == 1
sum `var' if dumasia == 1
sum `var' if dumindr == 1
sum `var' if dumeasteup == 1
sum `var' if dumafrica == 1
sum `var' if dummideast == 1
}

correlate csh_idiffp mginiall ethnic nocivitotb4 extshk mdemoc mpolity2 mrol mrq mccup


*************//Regressions//*****************
//After dropping duplicated observations, this section runs regression in Rodrik's fashion//

use "/Users/nathaniellai/Desktop/0515bk.dta", clear
* gen interest4 = du3_l1usrategr + nodu3_l1usrategr
eststo clear

//Relaxing break year assumption//
g gdppostnew = (gdppost5*5-growthbkyr1)/4 if growthbkyr1 <1 
g chgdpnew = gdppostnew - gdpprior
replace chgdpnew = chgdp4 if chgdpnew == . 

//Table 1//
global ylist chgdp5
global xlist lngdpbk gdpprior5 dumasia dumlatina dumafrica dumeasteup dumeuro csh_idiffp nodu3_l1usrategr

/*rename extshk ex
g dex = 0 
replace dex = 1 if nodb3_l1tttgr > 0
g extshk = dex*db3_l1tttgr*/

//Baseline Model//
*Model 1
eststo: reg $ylist $xlist, robust
display "adjusted R2 = " e(r2_a)
estat vif 
acprplot csh_idiffp, lowess lsopts(bwidth(1))

*Model 2 
eststo: reg $ylist $xlist mginiall, robust
display "adjusted R2 = " e(r2_a)
estat vif 
avplot mginiall, mlabel(countrycode)
acprplot mginiall, lowess lsopts(bwidth(1))
 
* Check other gini indices
reg $ylist $xlist mgini_net, robust
display "adjusted R2 = " e(r2_a)
estat vif 
avplot mgini_net, mlabel(countrycode)
acprplot mgini_net, lowess lsopts(bwidth(1))
drop if countrycode == "NAM"
drop if countrycode == "ZAF"

reg $ylist $xlist mgini_net, robust
reg $ylist $xlist mgini_netb4bk, robust
reg $ylist $xlist mgini_market, robust
reg $ylist $xlist mgini_marketb4bk, robust
reg $ylist $xlist mginiallb4bk, robust
reg $ylist $xlist mginiallafbk, robust
reg $ylist $xlist mginiwb, robust
reg $ylist $xlist mginiwbb4bk, robust
reg $ylist $xlist mginiwbafbk, robust
reg $ylist $xlist mehgini, robust
reg $ylist $xlist mabsred, robust
reg $ylist $xlist mrelred, robust
reg $ylist $xlist mabsredb4bk, robust
reg $ylist $xlist mrelredb4bk, robust

reg chgdp5 lngdpbk mgini_net extshk gdpprior5 dumasia dumafrica dumlatina dummideast dumeasteup, r 

reg $ylist $xlist , robust

*Model 3 
eststo: reg $ylist $xlist elf, robust
display "adjusted R2 = " e(r2_a)
estat vif 
avplot elf, mlabel(countrycode)
acprplot elf, lowess lsopts(bwidth(1))

 reg $ylist $xlist ethnic,robust
display "adjusted R2 = " e(r2_a)
estat vif 
avplot ethnic, mlabel(countrycode)
acprplot ethnic, lowess lsopts(bwidth(1))

*Model 4 
eststo: reg $ylist $xlist ethnic mpolity2,robust
display "adjusted R2 = " e(r2_a)
estat vif 
avplot ethnic, mlabel(countrycode)
acprplot ethnic, lowess lsopts(bwidth(1))
avplot mpolity2, mlabel(countrycode)
acprplot mpolity2, lowess lsopts(bwidth(1))

*Model 5 
eststo: reg $ylist $xlist nocivitotb4 mprcl7215 , robust
display "adjusted R2 = " e(r2_a)
estat vif
avplot nocivitotb4, mlabel(countrycode)
acprplot nocivitotb4, lowess lsopts(bwidth(1))
avplot mprcl7215, mlabel(countrycode)
acprplot mprcl7215, lowess lsopts(bwidth(1))

esttab using Table1app, se ar2 compress obslast nogaps nodepvars label replace booktabs ///
   alignment(D{.}{.}{-1})       ///
   title (\\ \emph{Dependent Varable: Five-year average growth differential at specific break years}\\) 
  
*************************************************************************************
//Table 2// 
use "/Users/nathaniellai/Desktop/0515bk.dta", clear
set more off
global ylist chgdp5
global xlist lngdpbk gdpprior5 dumasia dumlatina dumafrica dumeasteup dumeuro csh_idiffp

/*g composite1 = ethnic*(10-mdemocb4bk)*nodu3_l1usrategr
g composite2 = mginiall*(10-mdemocb4bk)*nodu3_l1usrategr
g composite3 = nocivitotb4*(10-mdemocb4bk)*nodu3_l1usrategr
correlate ctfpdiffp mprcl7215 mrq mrol mccup nodu3_l1usrategr
egen  sd1= sd(composite1)
egen  sd2= sd(composite2)
egen  sd3= sd(composite3)*/

g ctfpdiffp = ctfpdiff*100
g conflict1 = ethnic*(10-mdemocb4bk)*nodu3_l1usrategr
g conflict2 = mginiall*(10-mdemocb4bk)*nodu3_l1usrategr
g conflict3 = nocivitotb4*(10-mdemocb4bk)*nodu3_l1usrategr
g conflict4 = mcivtotb4bk*(10-mdemocb4bk)*nodu3_l1usrategr 
/*drop if countrycode == "BHR"
drop if countrycode == "MAC"
drop if countrycode == "ATG"
drop if countrycode == "MNG"*/
*Dropping the above 4 outliers does not change the result 

eststo clear
eststo: reg $ylist $xlist conflict1, robust
display "adjusted R2 = " e(r2_a)
estat vif 
avplot conflict1, mlabel(countrycode)
acprplot conflict1, lowess lsopts(bwidth(1))
/*kdensity composite1, normal
generate lggnp=log(composite1)
label variable lggnp "log-10 of gnpcap"
kdensity lggnp, normal*/


eststo: reg $ylist $xlist conflict2, robust
display "adjusted R2 = " e(r2_a)
estat vif
avplot conflict2, mlabel(countrycode)
acprplot conflict2, lowess lsopts(bwidth(1))

eststo:reg $ylist $xlist conflict3, robust
display "adjusted R2 = " e(r2_a)
estat vif
avplot conflict3, mlabel(countrycode)
acprplot conflict3, lowess lsopts(bwidth(1))

eststo:reg $ylist $xlist conflict4, robust
display "adjusted R2 = " e(r2_a)
estat vif
avplot conflict4, mlabel(countrycode)
acprplot conflict4, lowess lsopts(bwidth(1))

eststo: reg $ylist $xlist nodu3_l1usrategr ctfpdiffp  mrol, robust
display "adjusted R2 = " e(r2_a)
avplot mrol, mlabel(countrycode)
acprplot mrol, lowess lsopts(bwidth(1))
estat vif 

eststo: reg $ylist $xlist nodu3_l1usrategr ctfpdiffp mccup, robust
display "adjusted R2 = " e(r2_a)
avplot mccup, mlabel(countrycode)
acprplot mccup, lowess lsopts(bwidth(1))
estat vif 

eststo: reg $ylist $xlist nodu3_l1usrategr ctfpdiffp mrq, robust
display "adjusted R2 = " e(r2_a)
avplot mrq, mlabel(countrycode)
acprplot mrq, lowess lsopts(bwidth(1))
estat vif 

esttab using Table2app.tex, se ar2 compress obslast nogaps nodepvars label replace booktabs ///
   alignment(D{.}{.}{-1})       ///
   title (Composite indicators and other proxies for institution) 

eststo clear

//Done//
/*esttab wholesample_1 oecd_1 nonoecd_1 using Tables_SDN.csv, ///
		replace drop(*year) order(gini_market logincome_pc ) b(3) se(4) //// 
		label depvars nobrackets star(* 0.10 ** 0.05 *** 0.01) nogaps nonotes addnotes("" "" ) //// 
		stats(N r2, labels("Observations" "R-squared") fmt(0 4)) mtitles("Whole sample" "OECD" "NonOECD") ///
		title("Table 2. Correlation between market inequality and redistribution")
***************************************************************************************





