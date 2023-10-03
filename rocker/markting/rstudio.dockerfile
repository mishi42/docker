FROM  rocker/ml-verse

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

#causal inf yasui
RUN install2.r --error --skipmissing --skipinstalled broom MatchIt WeightIt cobalt Matching haven Ecdat CausalImpact rdd
#causal inf takahashi          
RUN install2.r --error --skipmissing --skipinstalled normtest sandwhich lmtest AER rdrobust rddensity ivpack Amelia
#datamining toyoda 
RUN install2.r --error --skipmissing --skipinstalled nlme nnet neural mvpart som kohonen arules deal e1071 kernlab RMeCab partykit
#marketing Chris 
RUN install2.r --error --skipmissing --skipinstalled \
      lavaan semPlot corrplot coefplot multcomp car psych zoo beanplot rworldmap RColorBrewer gplots lattics binom BayesFactor MCMCpack nFactors \
      GPArotation vcdExtra lme4 semTools semPLS cluster mclust poLCA randomForest arulesViz mlogit ChoiceModelR AlgDesign clickstream superheat \
      expm iptools rgeolocate TraMineR vcd bayesm BoomMix biganalytics biglm ClickClust forecast mnlogit OpenMx arulesSequences caret clue flexmix \
      mclust mlbench foreign gdata Matrix odbc RODBC randomForestExplainer 

#marketing wirawan
RUN install2.r --error --skipmissing --skipinstalled stargazer lmtest mlogit flexmix sampleSelection pscl \
                                            survival MASS conjoint lavaan bayesm invgamma rstanarm bayestestR openxlsx RMeCab

# bayes baba
RUN install2.r --error --skipmissing --skipinstalled rstan ggfortify bayesplot brms
# predictive analysis iwasawa
RUN install2.r --error --skipmissing --skipinstalled pdp glmnetUtils mgcv ranger CASdatasets ROCR aglm
# bayesian net
RUN install2.r --error --skipmissing --skipinstalled bnlearn rbmn lattice Rgraphviz gRain igraph corpcor penalized rstan deal catnet pcalg abn nlme 

#NC
#RUN install2.r --error --skipmissing --skipinstalled tidync ncdf4 RNetCDF

#uryu
#RUN R -q -e 'remotes::install_github("uribo/kuniezu")'
RUN R -q -e 'remotes::install_github("uribo/zipangu")'
RUN R -q -e 'devtools::install_github("uribo/jpndistrict")'
#RUN R -q -e 'devtools::install_github("uribo/lab.note")'
#RUN R -q -e 'install.packages("jmastats", repos = c(uribo = "https://uribo.r-universe.dev", getOption("repos")))'

#for writing papers
RUN install2.r --error --skipmissing --skipinstalled rmarkdown knitr DT flexdashboard htmlwidgets bookdown tableone knitr sessioninfo shiny shinydashboard plotly

# iryo
RUN install2.r --error --skipmissing --skipinstalled \
           gtsummary ggcorrplot ggdag meta netmeta survminer Meth nanir visdat Rtsne ggtree ggtreeExtra pROC

#business economics
RUN install2.r --error --skipmissing --skipinstalled fixest summarytools kableExtra sjmisc tictoc optimx modelsummary \
                                                    doParallel doRNG evd skimr numDeriv plot3D
RUN R -q -e "remotes::install_github('rapporter/pander')"

#personal
RUN install2.r --error --skipmissing --skipinstalled \
          xts readxl openxlsx ComplexHeatmap ranger glmnet rBaysianOptimization gridExtra \
          xgboost lightgbm progress stringi excel.link XLConnect mlrMBO bigrquery janitor DBI tidymodels crosstable recommenderlab

#open science
RUN install2.r --error --skipmissing --skipinstalled rvest XML httr estatapi RSelenium

#catdap2ext\\
RUN install2.r --error --skipmissing --skipinstalled catdap && \
    curl -OL "https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip" && \
    R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'


