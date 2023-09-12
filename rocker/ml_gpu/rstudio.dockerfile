FROM  rocker/ml-verse
#FROM  rocker/cuda

# https://zenn.dev/nononoexe/articles/recommendations-for-spatial-analysis-with-r
# 日本語ロケールの設定
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# 日本語フォントのインストール 
RUN apt-get update && apt-get install -y \
  fonts-ipaexfont \
  fonts-noto-cjk 
#uryu
RUN install2.r --error --skipmissing --skipinstalled remotes extrafont devtools

#japanese font  
RUN R -q -e 'extrafont::font_import(prompt = FALSE)'

#COPY ./install_rlib.sh /work/
#RUN /work/install_rlib.sh


RUN install2.r --error --skipmissing --skipinstalled \
           remotes extrafont devtools
RUN R -q -e 'remotes::install_gitlab("uribo/jmastats")'


#spark
#RUN R -q -e 'devtools::install_github("rstudio/sparklyr")'
#RUN R -q -e 'sparklyr::spark_install("3.3.1")'
#RUN R -q -e 'sparklyr::spark_install()'
#RUN R -q -e 'devtools::install_github("rstudio/sparkxgb")'
#RUN install2.r --error --skipmissing --skipinstalled \
#           apache.sedona arrow sparklyr.nested corrr dbplot sparkextension sparktf tfdatasets variantspark geospark

#causal inf yasui
#RUN R -q -e 'devtools::install_github("itamarcaspi/experimentdatar")'

RUN install2.r --error --skipmissing --skipinstalled \
      broom MatchIt WeightIt cobalt Matching haven Ecdat CausalImpact rdd

#causal inf takahashi          
RUN install2.r --error --skipmissing --skipinstalled \
      normtest sandwhich lmtest AER rdrobust rddensity ivpack Amelia

#datamining toyoda 
RUN install2.r --error --skipmissing --skipinstalled \
      nlme nnet neural mvpart som kohonen arules deal e1071 kernlab RMeCab

#marketing Chris 
RUN install2.r --error --skipmissing --skipinstalled \
      lavaan semPlot corrplot coefplot multcomp car psych zoo beanplot rworldmap RColorBrewer gplots lattics binom BayesFactor MCMCpack nFactors \
      GPArotation vcdExtra lme4 semTools semPLS cluster mclust poLCA randomForest arulesViz mlogit ChoiceModelR AlgDesign clickstream superheat \
      expm iptools rgeolocate TraMineR vcd bayesm BoomMix biganalytics biglm ClickClust forecast mnlogit OpenMx arulesSequences caret clue flexmix \
      mclust mlbench foreign gdata Matrix odbc RODBC randomForestExplainer 


# bayes baba
RUN install2.r --error --skipmissing --skipinstalled \
      rstan ggfortify bayesplot brms

# geocomputation Robin
RUN install2.r --error --skipmissing --skipinstalled \
      sf raster leaflet spData sp reticulate tabularaster geoverse spatial sgeostat splancs akima geoR spdep \
      maptools rgdal gstat geosphere rgdal rgeos ggmap mapview tmap rasterVis tidtcensus tigris hddtools rnaturalearth osmdata \
      ows4R shiny grid mapdeck tidygraph plotly cartogram geogrid geofacet cartography ggspatial parallelMap mlr stplaner osmdata igraph \
      revgeo vegan RQGIS

RUN R -q -e 'devtools::install_github("Nowosad/spDataLarge")'
RUN R -q -e 'devtools::install_github("tylermorganwall/rayshader")'
RUN R -q -e 'devtools::install_github("oscarperpinan/rasterVis")'

# predictive analysis iwasawa
RUN install2.r --error --skipmissing --skipinstalled \
    pdp glmnetUtils mgcv ranger CASdatasets ROCR aglm

#NC
#RUN install2.r --error --skipmissing --skipinstalled \
#           tidync ncdf4 RNetCDF

#uryu
RUN install2.r --error --skipmissing --skipinstalled \
           jpmesh zipangu
RUN R -q -e 'remotes::install_gitlab("uribo/jmastats")'
RUN R -q -e 'remotes::install_github("uribo/kuniezu")'
RUN R -q -e 'devtools::install_github("uribo/jpndistrict")'
RUN R -q -e 'devtools::install_github("uribo/lab.note")'

#for writing papers
RUN install2.r --error --skipmissing --skipinstalled \
          rmarkdown knitr DT flexdashboard htmlwidgets bookdown tableone knitr rmarkdown sessioninfo

# iryo
RUN install2.r --error --skipmissing --skipinstalled \
           gtsummary ggcorrplot ggdag meta netmeta survminer Meth nanir visdat Rtsne ggtree ggtreeExtra

#tidy series
RUN install2.r --error --skipmissing --skipinstalled \
           tidytext tidymodels tidyposterior spatialsample discrim bayesian bayesmodels DBI tidygeocoder tidyverse
RUN R -q -e 'devtools::install_github("xrobin/pROC")'

#personal
RUN install2.r --error --skipmissing --skipinstalled \
          xts readxl openxlsx rstanarm modelsummary ComplexHeatmap ranger glmnet rBaysianOptimization gridExtra  \
           RODBC xgboost lightgbm skimr progress stringi excel.link XLConnect dataPreparation mlrMBO ggplot2


#catdap2ext
#install2.r --error --skipmissing --skipinstalled \
#           catdap 
#curl -OL "https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip"
#R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'





