set -e
apt update -y

# This way it's we don't detect problems on package dependencies
# apt search -o APT::Cache::Search::Version=1  ros-$ROS_DISTRO-rmf | cut -d' ' -f1 | grep -v dbgsym | xargs apt install -y

apt install -y \
  ros-$ROS_DISTRO-rmf-visualization \
  ros-$ROS_DISTRO-rmf-building-sim-gz-plugins \
  ros-$ROS_DISTRO-rmf-building-sim-gz-classic-plugins \
  ros-$ROS_DISTRO-rmf-robot-sim-gz-classic-plugins \
  ros-$ROS_DISTRO-rmf-robot-sim-gz-plugins