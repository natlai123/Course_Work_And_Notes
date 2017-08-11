

*************// Panel Regressions//*****************

clear all
set more off 
cd "/Users/nathaniellai/Desktop/MAE"
capture log close
use "/Users/nathaniellai/Desktop/MAE/DepVar2-Final.dta", clear
capture log close
log using "Panel-Regression", text replace

set more off
foreach var of varlist chgdp5 csh_idiffp mginiall mehgini mginiwb nocivitotb4 mdemoc mpolity2 extshk mdebtgdpb4bk mkofglob{
sum `var' if dumlatina == 1
sum `var' if dumasia == 1
sum `var' if dumindr == 1
sum `var' if dumeasteup == 1
sum `var' if dumafrica == 1
sum `var' if dummideast == 1
*sum `var' if dumeuro == 1
}
set more off
foreach var of varlist du3_l1usrategr db3_l1tttgr nobcsysb4 noccsysb4 nosdcsysb4 nocivilwarb4 nodu3_l1usrategr nodb3_l1tttgrnobcsysb4 noccsysb4 nocivitotb4{
tab `var' if dumlatina == 1
tab `var' if dumasia == 1
tab `var' if dumindr == 1
tab `var' if dumeasteup == 1
tab `var' if dumafrica == 1
tab `var' if dummideast == 1
}

correlate mdemoc mpolity2 extshk mdebtgdpb4bk mkofglob meconglob mpolitglob msocglob
correlate mginiallb4bk mehginib4bk mginiwbb4bk mgini_marketb4bk mgini_marketafbk mgini_netb4bk mgini_netafbk mginiallafbk mehginiafbk mginiwbafbk
correlate mrelredb4bk mrelredafbk mabsredb4bk mabsredafbk relreddiff absreddiff

correlate mdemocb4bk mdemocafbk 

*Social Conflict Regressions 

nob4externaldebtcrisis

* mlmfdebtlb4bk nob4extdebtc dum70s dum80s dum90s dum00s


quietly xtreg chgdp5 $xlist, fe 
estimates store fixed 

quietly xtreg chgdp5 $xlist, re 
estimates store random

hausman fixed random

*mdebtgdpb4bk mrealrateb4bk mboardmb4bk

//Panel FE//
set more off
eststo clear
eststo: xtreg $ylist $xlist, fe robust

eststo: xtreg $ylist $xlist mgini_market, fe r
eststo: xtreg $ylist $xlist mgini_marketb4bk,fe r
 
eststo: xtreg $ylist $xlist mgini_net, fe r
eststo: xtreg $ylist $xlist mgini_netb4bk,fe r
 
eststo: xtreg $ylist $xlist mgini_market mdebtgdpb4bk, fe r
eststo: xtreg $ylist $xlist mgini_marketb4bk mdebtgdpb4bk,fe r

eststo: xtreg $ylist $xlist mgini_net mdebtgdpb4bk, fe r
eststo: xtreg $ylist $xlist mgini_netb4bk mdebtgdpb4bk, fe r
 
 
// Cluster Robust Std Error is used  (keep if dumsys== 1 gives 394 obs)// 

//Checking gini_net the closest pvalue to being significant is 0.065// 
 
eststo: xtreg $ylist $xlist mgini_net , fe robust
eststo: xtreg $ylist $xlist mgini_netb4bk,fe robust
 
eststo: xtreg $ylist $xlist mgini_net mlmfdebtlb4bk, fe robust
eststo: xtreg $ylist $xlist mgini_netb4bk mlmfdebtlb4bk,fe robust

eststo: xtreg $ylist $xlist mgini_net mlmfdebtlb4bk nodb3_l1tttgr, fe robust
eststo: xtreg $ylist $xlist mgini_netb4bk mlmfdebtlb4bk nodb3_l1tttgr , fe robust
 
eststo: xtreg $ylist $xlist mgini_net mdebtgdpb4bk , fe r
eststo: xtreg $ylist $xlist mgini_netb4bk mdebtgdpb4bk , fe r
 

*Institutions of Conflict Management Regressions 
global ylist chgdp5
global xlist lngdpbk gdpprior oilcrises nordicbc mexcrises asiacrises greatrecess nodb3_l1tttgr nocivilwarb4 nobcsysb4 nob4sdcsysdur
//Panel FE//
set more off
eststo clear

eststo: xtreg $ylist dum90s dum00s $xlist mgini_market,fe robust
outreg2 using myreg.xls, replace ctitle(1)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_marketb4bk,fe robust
outreg2 using myreg.xls, append ctitle(2)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_market mprcl7215,fe robust
outreg2 using myreg.xls, append ctitle(3)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_marketb4bk mprcl7215,fe robust
outreg2 using myreg.xls, append ctitle(4)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_market mprcl7215 relreddiff  ,fe robust
outreg2 using myreg.xls, append ctitle(5)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_marketb4bk mprcl7215 relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(6)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_market mprcl7215 relreddiff mlmfdebtlb4bk ,fe robust
outreg2 using myreg.xls, append ctitle(7)
eststo: xtreg $ylist dum90s dum00s $xlist mgini_marketb4bk mprcl7215 relreddiff mlmfdebtlb4bk,fe robust
outreg2 using myreg.xls, append ctitle(8)

esttab using Table8.tex, se r2 compress obslast nogaps nodepvars label replace booktabs ///
   alignment(D{.}{.}{-1})       ///
   title (\\ Dependent Variable: \emph{Six-year average growth differential at specific break years}\\) 
eststo clear

//Using mdemoc//

set more off
eststo clear
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_market,fe robust
outreg2 using myreg.xls, replace ctitle(1)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_marketb4bk,fe robust
outreg2 using myreg.xls, append ctitle(2)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_market mdemoc,fe robust
outreg2 using myreg.xls, append ctitle(3)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_marketb4bk mdemoc,fe robust
outreg2 using myreg.xls, append ctitle(4)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_market mdemoc absreddiff,fe robust
outreg2 using myreg.xls, append ctitle(5)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_marketb4bk mdemoc absreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(6)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_market mdemoc absreddiff mlmfdebtlb4bk,fe robust
outreg2 using myreg.xls, append ctitle(7)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_marketb4bk mdemoc absreddiff mlmfdebtlb4bk ,fe robust
outreg2 using myreg.xls, append ctitle(8)

*Extending chgdp5 up to chgdp8 does not change the robustness of relreddiff 
esttab using Table9.tex, se r2 compress obslast nogaps nodepvars label replace booktabs ///
   alignment(D{.}{.}{-1})       ///
   title (\\ Dependent Variable: \emph{Six-year average growth differential at specific break years}\\) 
eststo clear


**************************************************************************************
set more off
eststo clear

global xlist dum90s dum00s lngdpbk gdpprior nordicbc mexcrises asiacrises nob4sdcsysdur nob4bcsysdur nocivilwarb4 mlmfdebtlb4bk

eststo: xtreg chgdp4 $xlist  mgini_market mdemoc relreddiff  ,fe robust
outreg2 using myreg.xls, replace ctitle(1)
eststo: xtreg chgdp4 $xlist mgini_marketb4bk mdemoc relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(2)
eststo: xtreg chgdp5 $xlist mgini_market mdemoc relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(3)
eststo: xtreg chgdp5 $xlist mgini_marketb4bk mdemoc relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(4)
eststo: xtreg chgdp6 $xlist mgini_market mdemoc relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(5)
eststo: xtreg chgdp6 $xlist mgini_marketb4bk mdemoc relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(6)

 
esttab using Table12.tex, se r2 compress obslast nogaps nodepvars label replace booktabs ///
   alignment(D{.}{.}{-1})       ///
   title (\\ Dependent Variable: \emph{Six-year average growth differential at specific break years}\\) 
eststo clear

log close
************************************************************************************************************


g conflict4 = mgini_net*(10-mdemocb4bk)
g conflict5 = mgini_market*(10-mdemocb4bk)

g conflict6 = mgini_netb4bk*(10-mdemocb4bk)
g conflict7 = mgini_marketb4bk*(10-mdemocb4bk)


 nob4sdcsysdur nob4bcsysdur
global ylist chgdp5
global xlist lngdpbk gdpprior nordicbc mexcrises asiacrises nob4sdcsysdur nob4bcsysdur nocivilwarb4
 

set more off
eststo clear
eststo: xtreg $ylist  dum90s dum00s $xlist conflict6 ,fe robust
outreg2 using myreg.xls, replace ctitle(1)
eststo: xtreg $ylist  dum90s dum00s $xlist conflict7,fe robust
outreg2 using myreg.xls, append ctitle(2)
eststo: xtreg $ylist  dum90s dum00s $xlist conflict6 relreddiff,fe robust
outreg2 using myreg.xls, append ctitle(3)
eststo: xtreg $ylist  dum90s dum00s $xlist conflict7 relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(4)
eststo: xtreg $ylist  dum90s dum00s $xlist conflict6 relreddiff mlmfdebtlb4bk ,fe robust
outreg2 using myreg.xls, append ctitle(5)
eststo: xtreg $ylist  dum90s dum00s $xlist conflict7 relreddiff mlmfdebtlb4bk ,fe robust
outreg2 using myreg.xls, append ctitle(6)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mdemoc absreddiff mlmfdebtlb4bk,fe robust
outreg2 using myreg.xls, append ctitle(7)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mdemoc absreddiff mlmfdebtlb4bk ,fe robust
outreg2 using myreg.xls, append ctitle(8)
*Extending chgdp5 up to chgdp8 does not ch


set more off
eststo clear
global ylist chgdp4
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net, fe robust
outreg2 using myreg.xls, replace ctitle(1)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk,fe robust
outreg2 using myreg.xls, append ctitle(2)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215,fe robust
outreg2 using myreg.xls, append ctitle(3)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mprcl7215,fe robust
outreg2 using myreg.xls, append ctitle(4)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215 relreddiff,fe robust
outreg2 using myreg.xls, append ctitle(5)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mprcl7215 relreddiff ,fe robust
outreg2 using myreg.xls, append ctitle(6)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215 relreddiff mlmfdebtlb4bk,fe robust
outreg2 using myreg.xls, append ctitle(7)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mprcl7215 relreddiff mlmfdebtlb4bk ,fe robust
outreg2 using myreg.xls, append ctitle(8)



set more off
eststo clear
global ylist chgdp5
global xlist lngdpbk gdpprior nordicbc mexcrises asiacrises nob4sdcsysdur nobcsysb4 nocivilwarb4 csh_idiffp

eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net, re robust
outreg2 using myreg.xls, replace ctitle(1)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk,re robust
outreg2 using myreg.xls, append ctitle(2)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215,re robust
outreg2 using myreg.xls, append ctitle(3)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mprcl7215,re robust
outreg2 using myreg.xls, append ctitle(4)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215 relreddiff,re robust
outreg2 using myreg.xls, append ctitle(5)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mprcl7215 relreddiff ,re robust
outreg2 using myreg.xls, append ctitle(6)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215 relreddiff mlmfdebtlb4bk,re robust
outreg2 using myreg.xls, append ctitle(7)
eststo: xtreg $ylist  dum90s dum00s $xlist mgini_netb4bk mprcl7215 relreddiff mlmfdebtlb4bk ,re robust
outreg2 using myreg.xls, append ctitle(8)


quietly xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215 relreddiff, fe 
estimates store fixed 

quietly xtreg $ylist  dum90s dum00s $xlist mgini_net mprcl7215 relreddiff,re
estimates store random

hausman fixed random










