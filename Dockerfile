FROM baikangwang/tensorflow_gpu:tfonly_py2
MAINTAINER dighexode <dighexode@163.com>

# referenced from <https://hub.docker.com/r/kevin8093/tf_opencv_contrib/>

RUN apt update && \
    # Dependencies
    apt install -y --no-install-recommends \
	build-essential cmake \
    libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev \
    liblapacke-dev checkinstall && \
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*
#
# OpenCV 3.3
#
# Get source from github
# git clone https://github.com/opencv/opencv.git /usr/local/src/opencv && \
RUN apt update && \
    cd / && \
    wget https://github.com/opencv/opencv/archive/3.3.0.tar.gz -O opencv-3.3.0.tar.gz && \
    tar -xvf opencv-3.3.0.tar.gz && \
    mv opencv-3.3.0 /usr/local/src/opencv && \
    # Compile
    cd /usr/local/src/opencv && mkdir build && cd build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_TESTS=OFF \
          -D BUILD_opencv_gpu=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D WITH_IPP=OFF \
          -D WITH_CUDA=OFF \
          -D PYTHON_DEFAULT_EXECUTABLE=$(which python2) \
          .. && \
    make -j"$(nproc)" && \
    make install && \
    #
    # Cleanup
    #
    rm /opencv-3.3.0.tar.gz && \
    cd /usr/local/src/opencv && rm -r build && \
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

    CMD ["/bin/bash"]