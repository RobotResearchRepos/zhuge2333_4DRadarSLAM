FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# Source code dependencies
RUN git clone https://github.com/koide3/ndt_omp.git \
 && cd ndt_omp && mkdir build && cd build \
 && cmake .. && make install && cd .. && rm -fr ndt_omp
 
# Code repository

RUN mkdir -p /catkin_ws/src/

RUN git clone --recurse-submodules \
      https://github.com/RobotResearchRepos/zhuge2333_4DRadarSLAM \
      /catkin_ws/src/4DRadarSLAM

RUN git clone --recurse-submodules \
      https://github.com/zhuge2333/fast_apdgicp \
      /catkin_ws/src/fast_apdgicp

RUN git clone --recurse-submodules \
      https://github.com/zhuge2333/barometer_bmp388 \
      /catkin_ws/src/barometer_bmp388

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make
 
 
