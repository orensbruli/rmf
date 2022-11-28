set -e
# use of "|| true" to avoid failing in case of already installed rosdep
rosdep init || true

# Sometimes it fails getting some of the urls, but we should continue
rosdep update --rosdistro $ROS_DISTRO || true

python3 -m pip install flask-socketio fastapi uvicorn datamodel_code_generator

mkdir -p /tmp/rmf_ws/src
cd /tmp/rmf_ws
wget https://raw.githubusercontent.com/open-rmf/rmf/main/rmf.repos
vcs import src < rmf.repos

cd /tmp/rmf_ws
# Some dependencies are expected to not be available
rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO \
    --skip-keys roscpp  \
    --skip-keys actionlib \
    --skip-keys rviz \
    --skip-keys catkin \
    --skip-keys move_base \
    --skip-keys amcl \
    --skip-keys turtlebot3_navigation \
    --skip-keys turtlebot3_bringup \
    --skip-keys move_base_msgs \
    --skip-keys dwa_local_planner \
    --skip-keys map_server \
    --skip-keys iginition \
    -yr || true

colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml || true
colcon mixin update default || true

