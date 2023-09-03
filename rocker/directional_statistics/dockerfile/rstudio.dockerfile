#FROM  rocker/geospatial
FROM  rocker/ml-verse:4.3.0
USER root

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
RUN apt-get update && \
    apt-get install -y \
    fonts-ipaexfont fonts-noto-cjk \
    libpng-dev libjpeg-dev libfreetype6-dev libglu1-mesa-dev libgl1-mesa-dev pandoc zlib1g-dev libicu-dev libgdal-dev gdal-bin libgeos-dev libproj-dev \
    libboost-filesystem-dev mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8 texlive-xetex texlive-latex-base sudo

#japanese font
RUN install2.r --error --skipmissing --skipinstalled extrafont remotes
RUN R -q -e 'extrafont::font_import(prompt = FALSE)'
#RUN R -q -e 'install.packages("devtool")'
RUN R -q -e 'install.packages("devtools")'

RUN mkdir /work && \
    mkdir /work/env/

#ADD ./shell/ .
#compose fileからのディレクトリの位置。フォルダはコピーされない
COPY ./dockerfile/shell/ /work/env/

WORKDIR /work/env/
# direct_stat
RUN sudo ./ins_app_dir.sh
# Bayes
RUN sudo ./ins_bayes.sh
#torch
RUN sudo ./ins_torch.sh
#geo science
RUN sudo ./ins_geo_sp.sh
#for writing papers
RUN sudo ./ins_doc.sh
#for writing papers
RUN sudo ./ins_tidy_gg.sh
#spark
RUN ./ins_spark.sh
# marketing
RUN ./ins_marke.sh

#GPU
RUN install2.r --error --skipmissing --skipinstalled drat OpenCL
RUN R -q -e 'drat::addRepo("daqana"); install.packages("RcppArrayFire")'

# data cleaning
RUN install2.r --error --skipmissing --skipinstalled validate errorlocate simputation Amelia rspa lumberjack docopt dcmodify mice 
# iryo
RUN install2.r --error --skipmissing --skipinstalled gtsummary MatchIt corrplot ggcorrplot ggdag meta netmeta survminer ggfortify Meth nanir visdat Rtsne ggtree ggtreeExtra TDA
RUN R -q -e 'devtools::install_github("xrobin/pROC")'
#network
#RUN install2.r --error --skipmissing --skipinstalled \
#           igraph ggraph graphframes spNetwork sfnetworks networkD3 visNetwork circlize HiveR sna ergm ggnetwork statnet qgraph
#RUN R -q -e 'devtools::install_github("gastonstat/arcdiagram")'

#Bio
#RUN install2.r BiocManager
#RUN R -q -e 'BiocManager::install("WGCNA")'

#personal
RUN install2.r --error --skipmissing --skipinstalled \
           CausalImpact xts modelsummary ComplexHeatmap caret ranger glmnet rBaysianOptimization gridExtra RODBC odbc xgboost lightgbm skimr progress stringi excel.link XLConnect \
           FactoMineR factoextra PMCMRplus agricolae missMDA partykit rpart.plot igraph maps animation ineq lmtest tictoc patchwork tsibble zoo xts forecast naniar pacman estimatr 

#RUN R -q -e 'remotes::install_github("https://github.com/pola-rs/r-polars",ref = "long_arms64", force =TRUE)'
RUN R -q -e 'install.packages("https://github.com/pola-rs/r-polars/releases/latest/download/polars__x86_64-pc-linux-gnu.gz",repos = NULL)'


RUN mkdir /work/xgb
WORKDIR /work/xgb

#xgboost gpu
RUN wget https://s3-us-west-2.amazonaws.com/xgboost-nightly-builds/release_1.7.0/xgboost_r_gpu_linux_21d95f3d8f23873a76f8afaad0fee5fa3e00eafe.tar.gz -O xgboost_r_gpu_linux.tar.gz
RUN R CMD INSTALL ./xgboost_r_gpu_linux.tar.gz

#lightgbm gpu
#RUN git clone --recursive https://github.com/microsoft/LightGBM && \
#    cd LightGBM && \
#    Rscript build_r.R \
#    --use-gpu \
#    --opencl-library=/usr/lib/x86_64-linux-gnu/libOpenCL.so \
#    --boost-librarydir=/usr/lib/x86_64-linux-gnu


#catdap2ext
RUN mkdir /work/catdap
WORKDIR /work/catdap

RUN install2.r --error --skipmissing --skipinstalled catdap && \
    curl -OL https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip && \
    R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'

#kato pgm
RUN mkdir /work/ref_kato/
WORKDIR /work/ref_kato/

# Tractable circula densities from Fourier series. TEST
RUN curl -OL https://www.ism.ac.jp/~skato/KPJ_Datasets_and_R_code.zip && \
    unzip KPJ_Datasets_and_R_code.zip

# Robust estimation of location and concentration parameters for the von Mises-Fisher distribution. Statistical Papers, 
RUN curl -OL https://www.ism.ac.jp/~skato/R-code-robust.R
RUN mkdir /work/data/
WORKDIR /work/data/


#衛星
#RUN curl -OL https://www.gsi.go.jp/geowww/globalmap-gsi/download/data/gm-japan/gm-jpn-all_u_2_2.zip
#RUN unzip gm-jpn-all_u_2_2.zip

