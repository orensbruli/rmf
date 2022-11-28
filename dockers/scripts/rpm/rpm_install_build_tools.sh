set -e
dnf update -y
dnf install curl git wget -y

# Install build tools
dnf update && dnf upgrade -y
dnf install \
    gcc python3-pip cmake python3-colcon-common-extensions python3-vcstool -y

# download cyclonedds and use clang for humble
if [ "$ROS_DISTRO" = "humble" ]; then \
        dnf install ros-humble-rmw-cyclonedds-cpp -y && \
        dnf install clang lldb lld -y && \
        update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100;
fi