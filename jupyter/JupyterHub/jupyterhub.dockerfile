#FROM  gcr.io/kaggle-images/python:latest
FROM jupyterhub/jupyterhub

RUN mkdir /work
RUN mkdir /work/dev
WORKDIR /work/dev

# タイムゾーンの設定・AWSCLIのダウンロード
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y tzdata pass zip unzip vim jq curl && \
    #apt-get -y install libpq-dev python-dev && \
    apt-get -y install libpq-dev && \
    apt update -y && \
    apt upgrade -y && \
    apt install -y git make xz-utils file sudo gdal-bin python3-rtree libspatialindex-dev

ENV TZ=Asia/Tokyo

#RUN conda install -c conda-forge mamba
#RUN pip install --ignore-installed mamba
#RUN mamba install -c conda-forge jupyterhub

# JupyterLab関連のパッケージ（いくつかの拡張機能を含む）
#&&  pip install -r /srv/requirements.txt
#COPY ./requirements.txt /srv/requirements.txt
#RUN apt-get -y install libpq-dev python-dev && \
RUN pip install -U pip

# big query
RUN pip install --ignore-installed black && \
    pip install --ignore-installed requests && \
    pip install --ignore-installed beautifulsoup4 && \
    pip install --ignore-installed msoffcrypto-tool && \
    pip install --ignore-installed jpholiday && \
    pip install --ignore-installed sweetviz && \
    pip install --ignore-installed google-cloud-bigquery

# data pre
RUN pip install --ignore-installed numpy && \
    pip install --ignore-installed pandas && \
    pip install --ignore-installed 'polars[all]' && \
    pip install --ignore-installed ipython-sql && \
    pip install --ignore-installed datashader && \
    pip install --ignore-installed fastparquet && \
    pip install --ignore-installed missingno
    
# machine learning
RUN pip install --ignore-installed scikit-learn && \
    pip install --ignore-installed dtreeviz && \
    pip install --ignore-installed pycaret && \
    pip install --ignore-installed mlxtend && \
    pip install --ignore-installed scipy && \
    pip install --ignore-installed statsmodels
    #pip install --ignore-installed torch-scatter && \
    #pip install --ignore-installed torch-sparse && \

#bayes
#RUN pip install --ignore-installed arviz && \
#    pip install --ignore-installed pymc3 && \
#    pip install --ignore-installed pyro-ppl && \
#    pip install --ignore-installed numpyro

# visualization 
RUN pip install --ignore-installed japanize-matplotlib && \
    pip install --ignore-installed pygwalker && \
    pip install --ignore-installed plotly-express && \
    pip install --ignore-installed --upgrade plotly && \
    pip install --ignore-installed matplotlib-scalebar && \
    pip install --ignore-installed seaborn && \
    pip install --ignore-installed dash

# geocoding apply patch

# optimization

# text
RUN pip install --ignore-installed fugashi && \
    pip install --ignore-installed fugashi[unidic] && \
    pip install --ignore-installed ipadic && \
    pip install --ignore-installed sudachipy && \
    pip install --ignore-installed sudachidict_core  && \
    pip install --ignore-installed neologdn  && \
    pip install --ignore-installed Janome  && \
    pip install --ignore-installed tomotopy && \
    pip install --ignore-installed pyLDAvis && \
    pip install --ignore-installed scattertext && \
    pip install --ignore-installed ginza && \
    pip install --ignore-installed nlpaug && \
    pip install --ignore-installed nlpaug nltk
    
#macab
RUN python -c "import nltk; nltk.download('omw-1.4');"
RUN apt update -y && apt upgrade -y && \
    apt install -y mecab libmecab-dev mecab-ipadic && \
    apt install -y mecab-ipadic-utf8 && \
    apt install -y libc6-dev build-essential && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    pip install mecab-python3 && \
    pip install unidic-lite


#Jupyterlab extensions
RUN pip install --ignore-installed jupyter_contrib_nbextensions && \
    pip install --ignore-installed jupyterlab_widgets && \
    pip install --ignore-installed ipywidgets && \
    pip install --ignore-installed import-ipynb && \
    pip install --ignore-installed notebook && \
    pip install --ignore-installed lckr-jupyterlab-variableinspector && \
    pip install --ignore-installed jupyterlab-nvdashboard && \
    pip install --ignore-installed jupyterlab-tensorboard-pro && \
    pip install --ignore-installed jupyterlab_sql && \
    pip install --ignore-installed jupyterlab-execute-tim && \
    pip install --ignore-installed flake8

RUN jupyter labextension install jupyterlab-plotly && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install plotlywidget && \
    jupyter labextension install jupyterlab-spreadsheet && \
    jupyter labextension install @jupyterlab/hub-extension  
    

#RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable codefolding/main

# conf & jupyterhub
WORKDIR /work
COPY jupyter_notebook_config.py /work/jupyter_notebook_config.py
RUN cat jupyter_notebook_config.py >> /opt/jupyter/.jupyter/jupyter_notebook_config.py

#RUN apt-get clean && \
#    pip freeze > requirements.txt && \
#    jupyter lab build
