FROM nvidia/cuda:10.2-base-ubuntu18.04

ENV TZ=Europe/Vienna
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install neccessary tools
RUN apt-get update
RUN apt-get install -y \
  bash \
  software-properties-common \ 
  ca-certificates \
  wget \
  xvfb
RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main"
RUN apt-get update
RUN apt-get install -y \ 
  build-essential \
  g++ \
#  python-dev \
  autotools-dev \
  libicu-dev \
  libbz2-dev \
  zip \
  libboost-all-dev \
  libomp-dev

# Python
RUN apt-get install -y python3.6-dev python3-pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install \
  numpy \
  scikit-learn \
  open3d==0.9.0.0
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
    update-alternatives --set python /usr/bin/python3.6

RUN apt-get install -y  \
  mc \
  lynx \
  libqhull* \
  pkg-config \
  libxmu-dev \
  libxi-dev \
  --no-install-recommends --fix-missing

RUN apt-get install -y  \
  mesa-common-dev \
  cmake  \
  git  \
  mercurial \
  freeglut3-dev \
  libflann-dev \
  --no-install-recommends --fix-missing

RUN apt-get autoremove

# Install Eigen
RUN apt-get install -y libeigen3-dev

# Install VTK
RUN cd /opt && git clone https://gitlab.kitware.com/vtk/vtk.git VTK 
RUN cd /opt/VTK && git checkout tags/v8.0.0
RUN cd /opt/VTK && mkdir build
RUN cd /opt/VTK/build && cmake -DCMAKE_BUILD_TYPE:STRING=Release -D VTK_RENDERING_BACKEND=OpenGL ..
RUN cd /opt/VTK/build && make -j 32 && make install
