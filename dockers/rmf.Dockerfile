ARG BASE_REGISTRY="docker.io"
ARG ROS_DISTRO="humble"
ARG PACK="deb"
ARG RMF_IMAGE="debian_bin"
# $BASE_REGISTRY/ros:$ROS_DISTRO or ros_rpm
ARG BASE_IMAGE=$BASE_REGISTRY/ros:$ROS_DISTRO

## Almalinux base image with ros2 installed
FROM almalinux/8-base as ros_rpm
ARG ROS_DISTRO
SHELL ["bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY scripts/rpm/rpm_install_ros2.sh scripts/rpm/rpm_install_ros2.sh
RUN bash -x scripts/rpm/rpm_install_ros2.sh

# SOURCE BASED IMAGES
#####################

## Image with the needed build tools installed
FROM $BASE_IMAGE as source_base
ARG NETRC
ARG ROS_DISTRO
SHELL ["bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY scripts scripts
RUN bash -x scripts/install_build_tools.sh

## Image with the specific rmf rosdep dependencies installed
FROM source_base as source_rosdep
ARG ROS_DISTRO
RUN bash -x scripts/install_src_deps.sh

## Image with RMF built from sources
FROM source_rosdep as source_built
ARG ROS_DISTRO
ARG PACK
WORKDIR /tmp/rmf_ws
RUN export CXX=clang++ && export CC=clang && . /opt/ros/$ROS_DISTRO/setup.bash && cd /tmp/rmf_ws/ && colcon build --mixin lld release --merge-install --install-base /opt/rmf --packages-up-to rmf_traffic rmf_traffic_ros2 rmf_task rmf_battery rmf_utils rmf_fleet_adapter rmf_fleet_adapter_python rmf_task_ros2 rmf_traffic_ros2 rmf_websocket rmf_fleet_adapter_python rmf_fleet_msgs
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

# BIN/PACKAGE BASED IMAGE
#########################

## Image with RMF installed from packages
FROM $BASE_REGISTRY/ros:$ROS_DISTRO as bin
ARG ROS_DISTRO
ARG PACK
COPY $PACK_install_packages.sh $PACK_install_packages.sh
RUN bash $PACK_install_packages.sh


## Final image to invoke the built of any of the others
FROM ${RMF_IMAGE} AS final
ARG ROS_DISTRO
ARG PACK
ARG RMF_IMAGE
RUN echo "Built ${RMF_IMAGE}"


