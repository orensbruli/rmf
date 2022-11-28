set -e
dnf install 'dnf-command(config-manager)' epel-release -y
dnf config-manager --set-enabled powertools
dnf install curl -y
curl --output /etc/yum.repos.d/ros2.repo http://packages.ros.org/ros2/rhel/ros2.repo
dnf makecache -y
dnf update -y
dnf install ros-$ROS_DISTRO-ros-base -y