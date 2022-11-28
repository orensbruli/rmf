set -e
dnf update -y

# This way it's we don't detect problems on package dependencies
# apt search -o APT::Cache::Search::Version=1  ros-$ROS_DISTRO-rmf | cut -d' ' -f1 | grep -v dbgsym | xargs apt install -y

dnf install -y \
  ros-humble-rmf-api-msgs \
  ros-humble-rmf-battery \
  ros-humble-rmf-building-map-msgs \
  ros-humble-rmf-charger-msgs \
  ros-humble-rmf-cmake-uncrustify \
  ros-humble-rmf-demos-assets \
  ros-humble-rmf-demos-dashboard-resources \
  ros-humble-rmf-dispenser-msgs \
  ros-humble-rmf-door-msgs \
  ros-humble-rmf-fleet-msgs \
  ros-humble-rmf-ingestor-msgs \
  ros-humble-rmf-lift-msgs \
  ros-humble-rmf-obstacle-msgs \
  ros-humble-rmf-scheduler-msgs \
  ros-humble-rmf-site-map-msgs \
  ros-humble-rmf-task \
  ros-humble-rmf-task-msgs \
  ros-humble-rmf-traffic \
  ros-humble-rmf-traffic-editor \
  ros-humble-rmf-traffic-editor-assets \
  ros-humble-rmf-traffic-editor-test-maps \
  ros-humble-rmf-traffic-examples \
  ros-humble-rmf-traffic-msgs \
  ros-humble-rmf-utils \
  ros-humble-rmf-visualization-building-systems \
  ros-humble-rmf-visualization-fleet-states \
  ros-humble-rmf-visualization-msgs \
  ros-humble-rmf-visualization-obstacles \
  ros-humble-rmf-workcell-msgs