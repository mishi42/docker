#FROM nvidia/cuda:11.7.0-base-ubuntu22.04
FROM nvidia/cuda:12.2.0-base-ubuntu20.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /work && \ 
    mkdir /work/dev && \
    mkdir /work/env

RUN apt-get update && \
    apt-get install -y python3-pip sudo wget git vim curl libgl1-mesa-dev
RUN ln -s /usr/bin/python3.10 /usr/bin/python
RUN pip install --upgrade pip

#torch
RUN pip install torch torchvision torchaudio torch_tb_profiler && \
    pip install pytorch-lightning torchinfo torchensemble pyro-ppl albumentations pytorchvideo catalyst pytorchltr && \
    pip install torch-scatter torch-sparse torch-geometric gym

#
RUN pip install tensorboard tensorflow onnxruntime-gpu skl2onnx

#XAI
RUN pip install shap lime eli5 skater pydotplus graphviz skope-rules interpret-core xgboost catboost lightgbm witwidget alibi

#personal
RUN pip install scipy statsmodels polars optuna missingno pyarrow imbalanced-learn mlxtend boto3 s3fs xlrd xlwt \ 
                msoffcrypto-tool openpyxl seaborn google-cloud-bigquery beautifulsoup4 selenium

#bayes
RUN pip install numpyro[cuda] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

#causal
RUN pip install pgmpy lingam munkres cdt && \
    #semopy causalml \
    pip install obp causalnex 

#image
RUN apt-get -y install tesseract-ocr tesseract-ocr-jpn libtesseract-dev libleptonica-dev tesseract-ocr-script-jpan tesseract-ocr-script-jpan-vert && \
    pip install pdf2image open3d timm yolov5 pyocr opencv-python pillow PyPDF

#transformer
RUN mkdir /work/dev/model/
WORKDIR /work/dev/model/
RUN pip install 'transformers[torch]' fugashi unidic-lite 
#RUN python3 -c \
#    "from transformers import BertJapaneseTokenizer; \
#    tokenizer = BertJapaneseTokenizer.from_pretrained('cl-tohoku/bert-base-japanese-v2'); \
#    dir_name = 'bert_base_japanese_v2'; \
#    tokenizer.save_pretrained(dir_name) "

#NLP
#RUN ./ins_nlp.sh
#WORKDIR /work/dev/
RUN apt-get -y install mecab libmecab-dev file mecab-ipadic-utf8 fontconfig fonts-ipaexfont
RUN pip install --upgrade pip
RUN pip install python-dotenv gensim ginza japanize_matplotlib matplotlib \
                networkx numpy oseti pandas pymlask pyvis requests_oauthlib sklearn spacy tqdm wordcloud \
                allennlp allennlp-models nlpaug

RUN pip install pyLDAvis scattertext ja-ginza mojimoji nlplot texthero \
                ja-ginza-electra janome imgaug preprocessing numba stop-words textblob pyshp \
                fugashi fugashi[unidic] sudachipy sudachidict_core mecab-python3 Janome unidic ipywidgets \
                bertopic 
            #ipadicneologdn 
            #cabocha-python 
RUN python3 -m unidic download
RUN python3 -c "import nltk; nltk.download('omw-1.4')"
#RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && cd ./mecab-unidic-neologd && ./bin/install-mecab-unidic-neologd -n yes yes | mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n -a
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    echo yes | ./bin/install-mecab-ipadic-neologd -n


#GIS
RUN pip install geopandas pyrosm shapely pysal geojson contextily mplleaflet osmnx pygeos fiona sentinelsat

# geocoding apply patch
RUN git clone https://github.com/hottolink/pydams.git \
    && wget http://newspat.csis.u-tokyo.ac.jp/download/dams-4.3.4.tgz \
    && tar -xzvf dams-4.3.4.tgz \
    && patch -d ./dams-4.3.4 -p1 < ./pydams/patch/dams-4.3.4.diff

#jupyter lab
RUN apt-get install -y graphviz graphviz-dev && \
    pip install datashader plotly dash && \
    pip install jupyterlab lckr-jupyterlab-variableinspector jupyterlab_nvdashboard jupyterlab_execute_time flake8 jupyterlab-git

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get -y install nodejs

RUN jupyter lab build --minimize=False

WORKDIR /work
#CMD ["/bin/bash"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]
