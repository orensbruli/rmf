set -e
apt update -y
apt install curl git wget -y


## Add ROS2 repo
if ! grep -q "http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" /etc/apt/sources.list.d/ros2-latest.list; then
  curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2-latest.list > /dev/null
else
  echo "ros2 repository already configured"
fi

## Add gazebo repo
if ! grep -q "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" /etc/apt/sources.list.d/gazebo-stable.list; then
  sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
  wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
else
  echo "gazebo repository already configured"
fi

# Install build tools
apt update && apt upgrade -y
apt install \
    python3-pip cmake python3-colcon-common-extensions -y

# download cyclonedds and use clang for humble
if [ "$ROS_DISTRO" = "humble" ]; then \
        apt install ros-humble-rmw-cyclonedds-cpp -y && \
        apt install clang lldb lld -y && \
        update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100;
fi