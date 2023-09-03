install2.r --error --skipmissing --skipinstalled \
    rticles rmarkdown knitr DT flexdashboard htmlwidgets bookdown tableone knitr sessioninfo \
    tinytex latex2exp distill equatiomatic DiagrammerR xfun kable kableExtra magick \
    readxl docxtractr gapminder ftExtra reactable revealjs minidown rvest RSelenium stringr polite \
    renv targets cronR

R -q -e 'tinytex::install_tinytex(force = TRUE);tinytex::tlmgr_install("ipaex")'
R -q -e 'remotes::install_github("rstudio/pins")'
#R -q -e 'devtools::install_github("uribo/lab.note")'
