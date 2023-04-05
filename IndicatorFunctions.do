* This file contains the commands for generating indicator functions for the turbulent and tranquil VIX regimes, as well as the recession and expansion phases of the US business cycle.

* Initial commands: declare monthly time series
 generate t=tm(1997m3)+_n-1
 format t %tm
 tsset t, monthly

* VIX indicator function (vixif): 1 = turbulent volatility regime and 0 = tranquil volatility regime in the US stock market. The classification is based on the practitioner's rule that values exceeding 20 are high volatility periods underlying the S&P 500 index (see, e.g., Mahadeo, S.M.R., Heinlein, R. and Legrenzi, G.D., 2022. Contagion testing in frontier markets under alternative stressful S&P 500 market scenarios. The North American Journal of Economics and Finance, 60, p.101629.). 
gen vixif=1
replace vixif=0 if vix<=20

*Business cycle indicator function (bcif): 1 = recession phases and 0 = expansion phase in the US business cycle. The dating of recessions is determined by the National Bureau of Economic Research (NBER) (see https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions). 
gen bcif=0
replace bcif=1 if t >= tm(2001m3) & t <= tm(2001m11)
replace bcif=1 if t >= tm(2007m12) & t <= tm(2009m6)
replace bcif=1 if t >= tm(2020m2) & t <= tm(2020m4)
