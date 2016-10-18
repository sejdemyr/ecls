
# Processing Data from the Early Childhood Longitudinal Study (ECLS) #

Many people have asked for the education data from ECLS used in [this
tutorial on propensity score
matching](http://stanford.edu/~ejdemyr/r-tutorials-archive/tutorial8.html). This
repository produces a dataset (ecls.csv) that is similar to the
data used in the tutorial.

The reason for not making the data directly available is that each
user has to agree to ECLS's Terms of Use. Once you have done that and
downloaded the data, you'll be able to recreate the dataset using the
script 'ecls-clean.R'. For detailed instructions, please see below.

## Detailed Instructions ##

1. Clone or download this repository and place it somewhere on your computer.
2. Go to the [download page for
ECLS](http://www.researchconnections.org/childcare/studies/4075?q=c5r2mtsc&type=Data+Sets).
3. Under Dataset(s), click on 'SPSS', read and accept the Terms of
Use, and the download should begin.
4. Unzip the downloaded zip file. In it, there's a file called
'04075-0001-Data.por'. Place this file directly in the folder
'data-raw' from your copy of this repository (downloaded in step 1).
5. Open 'R/ecls-clean.R' in R. Then:
   * Set your working directory to the folder you downloaded and
     unzipped in step 1 (e.g., `setwd('~/Desktop/ecls-master')`.
   * Make sure you have all the packages loaded in the beginning of
     this script. If not, you can install them using
     `install.packages(c('Hmisc', 'dplyr', 'stringr'))`.
   * Execute the remainder of the script. Note that reading the data
       into R may take a little while.

That's it! The final dataset should now be in 'data-processed' alongside a codebook.
