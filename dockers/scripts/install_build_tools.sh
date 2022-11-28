set -e
source $(dirname "$0")/common.sh

inst update -y
inst install curl git wget -y

# Install build tools
inst update && inst upgrade -y
inst install \
    gcc python3-pip cmake python3-colcon-common-extensions python3-vcstool python3-rosdep python3-colcon-mixin -y

# download cyclonedds and use clang for humble
if [ "$ROS_DISTRO" = "humble" ]; then \
        inst install ros-humble-rmw-cyclonedds-cpp -y && \
        inst install clang lldb lld -y && \
        update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100;
fi