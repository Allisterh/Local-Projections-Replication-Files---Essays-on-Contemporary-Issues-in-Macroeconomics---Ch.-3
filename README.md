# Blampied-and-Mahadeo-2023-

This file explains the procedure to estimate the smooth local projections (SLP) in the terms Barnichon and Brownlees (2019).
Acknowledgements: The codes were retrieved from the supplementary material of Barnichon and Brownlees (2019) and adapted to the needs of the present paper. 
In particular, Mainfile.m, locproj.m locproj_cv, locproj.conf were retrieved from Barnichon and Brownlees (2019) supplementary material.
Instead, lagmaker and LP were retrieved from the Barcelona Summer School 2021 course material (Time Series Course) and a special mention goes to Lucca Gambetti and Nicolò Maffei-Faccioli. 


In order to replicate the main results of the paper, please note:



Panel A, B, C and D: 

In MainFile: 

1) Select load 'Dataset - Level - 1997-2019.mat'.

2) Select the variables corresponding to the log level specification.

3) Select the dependent variables one at a time. Remember you can choose:

a) MPU
b) SMU

4) Select the corresponding shock one at a time:

5) Select controls. Remember to include the linear trend (TT) in this specification and to check the autocorrelation function of the shock to include its lags (lags already created).

6) Run the code and get the IRFs and the 10% confidence interval one at a time.


Panel E and F:

In MainFile: 

1) Select load 'Dataset - Diff - 1997-2019.mat'.

2) Select the variables corresponding to the first difference of logs specification.

3) Select the dependent variables one at a time. Remember you can choose:

a) MPU
b) SMU

4) Select the corresponding shock one at a time.

5) Select controls. Remember to check the autocorrelation function of the shock to include its lags (lags already created).

6) Run the code and get the IRFs and the 10% confidence interval one at a time.



-----------------------------------------------------------------------------------------------------------------------------

In order to estimate the monetary shock using the approach of Bjorland and Leitemo (2009), please note:


1) An Excel datafile called "ConsolidatedDataSheets" is included in the repository. This has 6 sheets. 

	a) The first 3 sheets are the steps to produce the B&L (2009) SVAR model (more details are within the files). The 4th sheet, titled "SVAR structural residuals", are the shocks from the EViews estimated model.

	b) In the 5th sheet, which is called "Indicator Function", the indicator functions to be used for each of the two LP equations are found. 

	c) The last sheet is the LP ready dataset.

2) An Eviews workfile which documents the estimation of the B&L (2009) SVAR model is also included in the repository. Please note that the data for the commodity index are retrieved from the Bloomberg Terminal, so this is the reason that in order to estimate the SVAR model it would be possible to share this series upon request, if the requestor holds the corresponding licence.

3) Finally, it is also possible to find a Stata do file and dataset.

	a) The do file contains the commands written to define the indicator functions used in the two testable equations to define periods of economic turmoil (which we proxy with recessions) and financial turmoil (which we proxy with high volatility VIX regimes).



