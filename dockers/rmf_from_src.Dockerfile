ARG BASE_REGISTRY="docker.io"
ARG ROS_DISTRO="humble"
ARG RMF_IMAGE="source_built"
# $BASE_REGISTRY/ros:$ROS_DISTRO or ros_rpm
ARG BASE_IMAGE=$BASE_REGISTRY/ros:$ROS_DISTRO

# This is a multistage dockerfile.
# Multiple images are built and used and ones depends on the others.
# The current states created in this Dockerfile are
# base_build_tools: ros2 image with build tools installed (like gcc python3-pip cmake python3-colcon-common-extensions... )
# source_rosdep: Source code downloaded to tmp directory and dependencies installed with rosdep
# source_built: Source already built and ready to be used. Source code still also available in /tmp/ folder.


# To get an image of Ubuntu with ros2 and rmf built from sources
# docker build -f rmf_from_src.Dockerfile -t rmf_from_source .

# To get an image of Almalinux with ros2 and rmf built from sources
# docker build -f rmf_from_src.Dockerfile -t rmf_from_source --build-arg BASE_IMAGE=ros_rpm .

# It's possible to get intermediate images as a result of the built just setting
# the $RMF_IMAGE argument to the name of the desired image
# For example, if we want an image with the source code downloaded and dependencies installed (rosde):
# docker build -f rmf_from_src.Dockerfile -t rmf_from_source --build-arg RMF_IMAGE=source_rosdep .

# SOURCE BASED IMAGES
#####################

## Image with the needed build tools installed
FROM $BASE_IMAGE as base_build_tools
ARG NETRC
ARG ROS_DISTRO
SHELL ["bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY scripts scripts
RUN bash -x scripts/install_build_tools.sh

## Image with the specific rmf rosdep dependencies installed
FROM base_build_tools as source_rosdep
ARG ROS_DISTRO
RUN bash -x scripts/install_src_deps.sh

## Image with RMF built from sources
FROM source_rosdep as source_built
ARG ROS_DISTRO
WORKDIR /tmp/rmf_ws
RUN export CXX=clang++ && export CC=clang && . /opt/ros/$ROS_DISTRO/setup.bash && cd /tmp/rmf_ws/ && colcon build --mixin lld release --merge-install --install-base /opt/rmf --packages-up-to rmf_traffic rmf_traffic_ros2 rmf_task rmf_battery rmf_utils rmf_fleet_adapter rmf_fleet_adapter_python rmf_task_ros2 rmf_traffic_ros2 rmf_websocket rmf_fleet_adapter_python rmf_fleet_msgs
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]


## Final image to invoke the built of any of the others
FROM ${RMF_IMAGE} AS final
ARG ROS_DISTRO
ARG RMF_IMAGE
RUN echo "Built ${RMF_IMAGE}"

