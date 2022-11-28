ARG BASE_REGISTRY="docker.io"
ARG ROS_DISTRO="humble"
ARG RMF_IMAGE="rpm_bin"


# SOURCE BASED IMAGES
#####################

## Image with the needed build tools installed
FROM almalinux/8-base as ros_rpm
ARG ROS_DISTRO
SHELL ["bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY scripts/rpm/rpm_install_ros2.sh scripts/rpm/rpm_install_ros2.sh
RUN bash -x scripts/rpm/rpm_install_ros2.sh


## Image with the needed build tools installed
FROM ros_rpm as rpm_source_base
ARG ROS_DISTRO
SHELL ["bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
COPY scripts scripts
RUN bash -x scripts/install_build_tools.sh

## Image with the specific rmf rosdep dependences installed
FROM rpm_source_base as rpm_source_rosdep
ARG ROS_DISTRO
COPY scripts scripts
RUN bash -x scripts/install_src_deps.sh

## Image with RMF built from sources
FROM rpm_source_rosdep as rpm_source_built
ARG ROS_DISTRO
WORKDIR /tmp/rmf_ws
RUN source /opt/ros/$ROS_DISTRO/setup.bash && CXX=clang++ && CC=clang && colcon build --mixin release lld
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
#
# # BIN/PACKAGE BASED IMAGE
# #########################
#
# ## Image with RMF installed from packages
# FROM $BASE_REGISTRY/ros:$ROS_DISTRO as rpm_bin
# COPY rpm_install_packages.sh rpm_install_packages.sh
# RUN bash rpm_install_packages.sh
#
#
# ## Final image to invoke the built of any of the others
# FROM ${RMF_IMAGE} AS final
# ARG RMF_IMAGE
# RUN echo "Built ${RMF_IMAGE}"

