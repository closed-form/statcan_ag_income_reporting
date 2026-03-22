#### Import Packages ####

present_packages<-as.data.frame(installed.packages())$Package

weird_packages<-c("vctrs",
                  "xfun")

needed_weird_packages<-setdiff(weird_packages,
                               present_packages)

if(length(needed_weird_packages)>0){
  for(i in 1:length(needed_weird_packages)){
    install.packages(needed_weird_packages[i],
                     dependencies = TRUE)
  }
  rm(i)
}

required_packages<-c("tidyverse",
                     "devtools",
                     "tinytex",
                     "kableExtra",
                     "lubridate",
                     "stringr",
                     "remotes",
                     "scales",
                     "ggcorrplot")

needed_packages<-setdiff(required_packages,
                         present_packages)

if(length(needed_packages)>0){
  for(i in 1:length(needed_packages)){
    install.packages(needed_packages[i],
                     dependencies = TRUE)
  }
  rm(i)
}

if(sum(as.numeric(present_packages=="qs"))==0){
  remotes::install_version("qs", version = "0.27.3")
}

if(sum(as.numeric(present_packages=="cansim"))==0){
  install.packages("cansim")
}

library(tidyverse)
library(devtools)
library(tinytex)
library(kableExtra)
library(lubridate)
library(stringr)
library(scales)
library(cansim)
library(ggcorrplot)

rm(present_packages,
   weird_packages,
   needed_weird_packages,
   required_packages,
   needed_packages)

#### Import Data ####

atdp<-get_cansim(cansimTableNumber = "32-10-0136-01",
                 language = "english") %>%
  filter(!is.na(VALUE))

estimate_types<-c("Total estimate",
                  "Average per farm")

vars<-atdp %>%
  filter(GEO=="Canada",
         `Farm type`=="All farm types",
         `Revenue class`=="All revenue classes",
         `Estimate type` %in% estimate_types) %>%
  select(Estimates) %>%
  distinct()

vars<-as.vector(unlist(vars))

selected_vars<-select.list(
  choices = vars,
  title = paste0("Select vars to summarize. ",
                 "Ctrl+click to multi-select"),
  multiple = TRUE,
  graphics = TRUE)

selected_type<-select.list(
  choices = estimate_types,
  title = "Select ONE estimate type.",
  multiple = FALSE,
  graphics = TRUE)

selected_prov<-select.list(
  choices = unique(as.character(atdp$GEO)),
  title = "Select ONE province.",
  multiple = FALSE,
  graphics = TRUE)

complexities<-c("Simple (Summary, Graphs)",
                "Expanded (Simple + Linear Fit)",
                "Complex (Expanded + Correlation)")

selected_complexity<-select.list(
  choices = complexities,
  title = "Select level of complexity.",
  multiple = FALSE,
  graphics = TRUE)

selected_atdp<-atdp %>%
  filter(Estimates %in% selected_vars,
         GEO==selected_prov,
         `Estimate type`==selected_type,
         `Farm type`=="All farm types",
         `Revenue class`=="All revenue classes")

rm(estimate_types,
   vars,
   complexities)

save(selected_atdp,
     selected_vars,
     selected_prov,
     selected_type,
     selected_complexity,
     file = paste0(getwd(),
                   "/atdp_reporting/",
                   "atdp_data.RData"))

rm(selected_atdp,
   selected_vars,
   selected_prov,
   selected_type,
   selected_complexity,
   atdp)

#### Render Markdown Doc ####

rmarkdown::render(
  input = paste0(getwd(),
                 "/atdp_reporting/atdp_report.Rmd"),
  output_format = "pdf_document",
  output_file = paste0(getwd(),
                       "/atdp_report_",
                       Sys.getenv('USERNAME'),"_",
                       format(Sys.time(),
                              '%Y-%m-%d_%H-%M-%S'),
                       ".pdf"))
