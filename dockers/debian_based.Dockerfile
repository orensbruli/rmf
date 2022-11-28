ARG BASE_REGISTRY="docker.io"
ARG ROS_DISTRO="humble"
ARG RMF_IMAGE="debian_bin"


# SOURCE BASED IMAGES
#####################

## Image with the needed build tools installed
FROM $BASE_REGISTRY/ros:$ROS_DISTRO as debian_source_base
ARG NETRC
SHELL ["bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY debian_install_build_tools.sh debian_install_build_tools.sh
RUN bash debian_install_build_tools.sh

## Image with the specific rmf rosdep dependences installed
FROM debian_source_base as debian_source_rosdep
COPY debian_install_src_deps.sh debian_install_src_deps.sh
RUN bash debian_install_src_deps.sh

## Image with RMF built from sources
FROM debian_source_rosdep as debian_source_built
WORKDIR /tmp/rmf_ws
RUN export CXX=clang++ && export CC=clang && . /opt/ros/$ROS_DISTRO/setup.bash && cd /tmp/rmf_ws && colcon build --mixin lld release --merge-install --install-base /opt/rmf --packages-up-to rmf_traffic rmf_traffic_ros2 rmf_task rmf_battery rmf_utils rmf_fleet_adapter rmf_fleet_adapter_python rmf_task_ros2 rmf_traffic_ros2 rmf_websocket rmf_fleet_adapter_python rmf_fleet_msgs
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

# BIN/PACKAGE BASED IMAGE
#########################

## Image with RMF installed from packages
FROM $BASE_REGISTRY/ros:$ROS_DISTRO as debian_bin
COPY debian_install_packages.sh debian_install_packages.sh
RUN bash debian_install_packages.sh


## Final image to invoke the built of any of the others
FROM ${RMF_IMAGE} AS final
ARG RMF_IMAGE
RUN echo "Built ${RMF_IMAGE}"


