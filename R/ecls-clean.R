# ecls-clean.R --- Simon Ejdemyr (ejdemyr@gmail.com)
# An R script for processing data from the Early Childhood Longitudinal
# Study. The output is saved to 'data-processed/ecls.csv'.

# Begin by changing your working directory as necessary here
setwd('~/dropbox/ecls')

# Load required packages ('install.packages()' first if necessary)
library(Hmisc)
library(dplyr)
library(stringr)

# Read the data
dta <- spss.get('data-raw/04075-0001-Data.por',
                lowernames = TRUE,
                use.value.labels = TRUE,
                allow = '_')

# Convert factors to character
dta <- dta %>% mutate_if(is.factor, as.character)

# Filter down to catholic and public school students and create a
# dummy for catholic
dta <- dta %>%
  filter(l5cathol == 'YES' | l5public == 'YES') %>%
  mutate(catholic = if_else(l5cathol == 'YES', 1, 0))

# Create race dummies
dta <- dta %>%
  mutate(race_white = if_else(r5race == 'WHITE, NON-HISPANIC', 1, 0),
         race_black = if_else(r5race == 'BLACK OR AFRICAN AMERICAN, NON-HISPANIC', 1, 0),
         race_hispanic = if_else(r5race %in% c('HISPANIC, RACE SPECIFIED', 'HISPANIC, RACE NOT SPECIFIED'), 1, 0),
         race_asian = if_else(r5race == 'ASIAN', 1, 0))

# Set scores of 0 or below on occupational prestige scores, number of
# places lived, and mother's/father's age to NA
dta <- dta %>%
  mutate_at(vars(w3momscr, w3dadscr, p5numpla, p5hmage, p5hdage),
            funs(ifelse(. <= 0, NA, .)))

# Recode poverty and food stamp nominal variables to dummies
dta <- dta %>%
  mutate(w3povrty = if_else(w3povrty == 'BELOW POVERTY THRESHOLD', 1, 0),
         p5fstamp = if_else(p5fstamp == 'YES', 1, if_else(p5fstamp == 'NO', 0, as.double(NA))))

# Create dummies for high school or below (grouping 'some college' as above)
hs_cats <- c('8TH GRADE OR BELOW', '9TH - 12TH GRADE', 'HIGH SCHOOL DIPLOMA/EQUIVALENT',
             'VOC/TECH PROGRAM')
dta <- dta %>%
  mutate_at(vars(w3daded, w3momed),
            funs('hsb' = if_else(. %in% hs_cats, 1,
                          if_else(. == 'NOT APPLICABLE', as.double(NA), 0))))

# Recode income categories to numeric. Income categories are set at
# their midvalue. 5000 or less is set to 5000; 200,001 or more is set
# to 200,001.
dta <- dta %>%
  mutate(w3inccat = if_else(w3inccat == '$5,000 OR LESS', '$5,000 TO $5,000',
                            if_else(w3inccat == '$200,001 OR MORE', '$200,001 TO $200,001', w3inccat)))

convert_income <- function(s) {                              # function for converting income
  split_mat <- str_split_fixed(s, " TO ", n = 2)
  split_mat <- gsub('\\$|,', '', split_mat)
  (as.numeric(split_mat[, 1]) + as.numeric(split_mat[, 2])) / 2
}

test <- unique(dta$w3inccat)                                 # test function
data.frame(test, convert_income(test))

dta <- dta %>% mutate(w3income = convert_income(w3inccat))   # finally, convert income

# Clean math t score and create a standardized score
dta <- dta %>%
  mutate(c5r2mtsc = if_else(c5r2mtsc <= 0, as.double(NA), as.numeric(c5r2mtsc)),
         c5r2mtsc_std = (c5r2mtsc - mean(c5r2mtsc, na.rm = T)) / sd(c5r2mtsc, na.rm = T))

# Remove observations with missing math score
dta <- dta %>% filter(!c5r2mtsc %in% NA)

# Select and rename variables as necessary
dta <- dta %>%
  dplyr::select(childid,
                catholic,
                race = r5race,
                race_white,
                race_black,
                race_hispanic,
                race_asian,
                p5numpla,
                p5hmage,
                p5hdage,
                w3daded,
                w3momed,
                w3daded_hsb,
                w3momed_hsb,
                w3momscr,
                w3dadscr,
                w3inccat,
                w3income,
                w3povrty,
                p5fstamp,
                c5r2mtsc,
                c5r2mtsc_std)

write.csv(dta, 'data-processed/ecls.csv', row.names = FALSE)
