FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y python3.6-dev python3-pip

RUN python3.6 -m pip install pip --upgrade

RUN apt-get install -y cmake libeigen3-dev libboost-all-dev git wget

# For PCL
RUN apt-get install -y libflann-dev libvtk6-dev

RUN python3.6 -m pip install numpy \
                             scikit-learn \
                             open3d==0.9.0.0

RUN update-alternatives --set python /usr/bin/python3.6

# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/* 
