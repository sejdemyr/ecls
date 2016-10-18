
# ecls: Processing Data from the Early Childhood Longitudinal Study #

This repository reproduces the dataset used
in [this tutorial on propensity score matching](http://stanford.edu/~ejdemyr/r-tutorials-archive/tutorial8.html).

The data come from the Early Childhood Longitudinal Study (ECLS) and
cannot be made available directly due to ECLS's Terms of Use. However,
once you have accepted the Terms of Use, you'll be able to quickly
create an easy-to-analyze dataset (which will end up in
'data-processed/ecls.csv').

For detailed instructions on how to do this, please see below. For
information on the variables included in the final dataset, please see
the codebook ('data-processed/ecls-codebook.txt').


## Instructions ##

1. Clone or download this repository and place it somewhere on your computer.
2. Go to the [download page for
ECLS](http://www.researchconnections.org/childcare/studies/4075?q=c5r2mtsc&type=Data+Sets).
3. Under Dataset(s), click on 'SPSS', read and accept the Terms of
Use, and the download should begin.
4. Unzip the downloaded zip file. In it, there's a file called
'04075-0001-Data.por'. Place this file directly in the folder
'data-raw' from your copy of this repository (downloaded in step 1).
5. Open 'R/ecls-clean.R'.
   * Set your working directory to the folder you downloaded and
     unzipped in step 1 (e.g., `setwd('~/Desktop/ecls-master')`.
   * Make sure you have installed all the packages loaded in the beginning of
     this script. If not, you can install them using
     `install.packages(c('Hmisc', 'dplyr', 'stringr'))`.
   * Execute the remainder of the script. Note that reading the data
       into R may take a little while.

That's it! The final dataset is called 'ecls.csv' and should now be in
'data-processed'.
