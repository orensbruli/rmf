ARG BASE_REGISTRY="docker.io"
ARG ROS_DISTRO="humble"
ARG PACK="deb"
# $BASE_REGISTRY/ros:$ROS_DISTRO or ros_rpm
ARG BASE_IMAGE=$BASE_REGISTRY/ros:$ROS_DISTRO

# BIN/PACKAGE BASED IMAGE
#########################

## Image with RMF installed from packages
FROM $BASE_IMAGE as final
ARG ROS_DISTRO
ARG PACK
COPY scripts scripts
RUN bash scripts/${PACK}/${PACK}_install_packages.sh

# To build an image with RMF installed from DEB packages in ros:humble (ubuntu)
# docker build -f rmf_from_packages.Dockerfile -t deb_bin  .

# To build an image with RMF installed from RPM packages in Almalinux (ros2_rpm)
# If it fails to find ros_rpm image, please look into ros_rpm.Dockerfile
# docker build -f rmf_from_packages.Dockerfile -t rpm_bin --build-arg PACK="rpm" --build-arg BASE_IMAGE='ros_rpm' .

