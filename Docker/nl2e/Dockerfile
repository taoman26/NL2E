FROM ubuntu:20.04
ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y x11-apps \
      language-pack-ja-base \
      language-pack-ja \
      fonts-noto-cjk \
      fonts-noto-color-emoji \
      supervisor \
      gosu \
      default-jre default-jdk \
      libcurl4-openssl-dev libssl-dev \
      libfontconfig1-dev \
      libnode-dev libmagick++-dev libharfbuzz-dev libfribidi-dev \
      mecab mecab-ipadic-utf8 \
      make \
      cpanminus \
      fonts-ipafont-gothic             \
      libmysqlclient-dev default-mysql-client \
      libalgorithm-naivebayes-perl     \
      libclass-accessor-lite-perl      \
      libcryptx-perl                   \
      libdbd-csv-perl                  \
      libdbd-mysql-perl                \
      libdbi-perl                      \
      libexcel-writer-xlsx-perl        \
      libextutils-config-perl          \
      libextutils-helpers-perl         \
      libextutils-installpaths-perl    \
      libfile-bom-perl                 \
      libgraphics-colorutils-perl      \
      libgsl-dev                       \
      libgmp-dev libmpfr-dev           \
      libjcode-perl                    \
      liblingua-sentence-perl          \
      libmodule-build-tiny-perl        \
      libnet-telnet-perl               \
      libproc-background-perl          \
      libspreadsheet-parseexcel-perl   \
      libstatistics-distributions-perl \
      libstatistics-lite-perl          \
      libtest-requires-perl            \
      libtext-diff-perl                \
      libunicode-escape-perl           \
      libxml-twig-perl                 \
      libxml2-dev                      \
      libyaml-perl                     \
      perl-tk                          \
      r-base-core                      \
      r-cran-ade4                      \
      r-cran-amap                      \
      r-cran-cairo                     \
      r-cran-cluster                   \
      r-cran-codetools                 \
      r-cran-colorspace                \
      r-cran-dichromat                 \
      r-cran-foreign                   \
      r-cran-ggdendro                  \
      r-cran-ggsci                     \
      r-cran-gtable                    \
      r-cran-igraph                    \
      r-cran-kernsmooth                \
      r-cran-lattice                   \
      r-cran-maptools                  \
      r-cran-mass                      \
      r-cran-matrix                    \
      r-cran-mgcv                      \
      r-cran-munsell                   \
      r-cran-nlme                      \
      r-cran-nnet                      \
      r-cran-permute                   \
      r-cran-pheatmap                  \
      r-cran-plyr                      \
      r-cran-proto                     \
      r-cran-rcolorbrewer              \
      r-cran-rcpp                      \
      r-cran-reshape2                  \
      r-cran-rgl                       \
      r-cran-rpart                     \
      r-cran-scales                    \
      r-cran-scatterplot3d             \
      r-cran-slam                      \
      r-cran-sp                        \
      r-cran-spatial                   \
      r-cran-stringr                   \
      r-cran-survival                  \
      r-cran-tm                        \
      r-cran-vegan                     \
      r-cran-wordcloud                 \
      vim-nox \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*
RUN update-locale LANG=ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

COPY mecabrc /etc/mecabrc
RUN cpanm Lingua::JA::Regular::Unicode Statistics::ChisqIndep File::Copy::Recursive
RUN Rscript -e 'install.packages(c("som", "topicmodels"))'
# R 3.6 では最新の CRAN から ggnetwork の依存 (statnet.common 等) を入れられないため、当時のスナップショットを使う
RUN Rscript -e 'install.packages(c("ggnetwork", "smacof", "networkD3", "devEMF", "RSVGTipsDevice", "ldatuning"), repos = "https://packagemanager.posit.co/cran/2020-06-01")'

RUN cpanm DOY/Spreadsheet-ParseXLSX-0.17.tar.gz
RUN Rscript -e 'install.packages("http://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_2.2.1.tar.gz", repos=NULL, type="source")'

# install.packages は失敗してもビルドが止まらないため、読み込めるか確認する
RUN Rscript -e 'for (p in c("ggnetwork", "smacof", "networkD3", "devEMF", "RSVGTipsDevice", "ldatuning", "som", "topicmodels", "ggplot2")) library(p, character.only = TRUE)'

# Ubuntu 20.04 同梱の Perl/Tk 804.033 は XIM の確定文字列を取得できず、日本語入力が反映されない。
# 804.036 に入れ替える（ビルドに必要な -dev パッケージも導入する）
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libx11-dev libxft-dev libpng-dev libjpeg-dev zlib1g-dev libfreetype6-dev libfontconfig1-dev \
    && cpanm --notest SREZIC/Tk-804.036.tar.gz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
