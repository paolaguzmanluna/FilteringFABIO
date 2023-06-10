# FilteringFABIO

In this repository the code to narrow FABIO down to the European dairy farm context and commodity of interest (i.e., cow raw milk) is provided. 
To do so, the code is divided in two parts:

Part 1 was done in R as the original code of FABIO was built there. The code was extracted directly from FABIO's author (https://github.com/martinbruckner/fabio_v1.git)
At this point, FABIO covers the production of 130 agriculture and food products over 191 countries from 1986 to 2013. This code defines the geographical and temporal boundaries.
So, only the production of the commodity of interest amongts European countries (EU + UK) in the most recent year of the databased (i.e., 2013) was selected. 
As a result, a file called "resultsMatlab.csv" is obtained. This file is then used in Part 2.

