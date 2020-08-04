FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y python3.6-dev python3-pip

RUN python3.6 -m pip install pip --upgrade

RUN apt-get install -y cmake libeigen3-dev libboost-all-dev git

#RUN cd home && git clone https://github.com/MIT-SPARK/TEASER-plusplus.git && \
#    cd TEASER-plusplus && mkdir build && cd build && cmake .. && make  && make install \
#    && cd python && pip install .

# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/* 
