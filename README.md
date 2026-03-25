# Purpose
This project exists to let R users create reports based on data in Statistics Canada's ATDP CANSIM catalogue.

It consists of a main repository with an R Project file (for RStudio users to easily access and navigate the repo and pull changes from git), and (currently) one subfolder. The subfolders are based on discrete tables from CANSIM.

# Dependencies

The user must have the ***pdflatex*** package installed on their computer for the Rmd file to be knitted successfully. To ensure they have the package, they can do the following:

## Recommended Approach

**Download and install mixtex at https://miktex.org/download**

## Alternative Approach

Run the following commands in an R script or in your console:

```
install.packages("tinytex")
tinytex::install_tinytex()
```

**NOTE**: This approach does not work on some corporately managed machines

# Usage

Each subfolder has its own usage guide.

## ATDP Reporting

Within the atdp_reporting subfolder there are two files:

* atdp_report.Rmd
* prep_and_knit_atdp_report.R

The user only needs to **open prep_and_knit_atdp_report.R**, then do the following:

1.  Hit Control+A
2.  Hit Control+Enter
3.  Make selections in the popup menus when prompted
4.  Access the output within `statcan_ag_income_reporting/atdp_reporting`

The output will have the following naming convention: **atdp_report\_[USERNAME]\_[YYYY]-[MM]-[DD]\_[hh]-[mm]-[ss].pdf**
