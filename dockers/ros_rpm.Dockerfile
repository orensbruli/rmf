## Almalinux base image with ros2 installed
ARG ROS_DISTRO="humble"

# To build an image based on almalinux 8 with ros installed:
# docker build -f ros_rpm.Dockerfile -t ros_rpm .

FROM almalinux/8-base as ros_rpm
ARG ROS_DISTRO
SHELL ["bash", "-c"]
COPY scripts/rpm/rpm_install_ros2.sh scripts/rpm/rpm_install_ros2.sh
RUN bash -x scripts/rpm/rpm_install_ros2.sh


