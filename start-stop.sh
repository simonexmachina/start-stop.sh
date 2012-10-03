startStop() {
  name=$1; shift
  pidFile=$1; shift
  action=$1; shift
  command=$1; shift
  if [ -z "$action" ]; then
    echo "Usage: $command <start|stop|restart>"
    exit 1
  fi
  if [ -f "$pidFile" ]; then
    pid=`cat $pidFile`
  fi
  if [ "$action" == "stop" -o "$action" == "restart" ]; then
    if [ "$pid" ]; then
      kill $pid && echo "Stopped $name" && sleep 1
      if [ -f $pidFile ]; then
        rm $pidFile
      fi
    elif [ "$action" == "stop" ]; then
      echo "Failed to stop $name: no PID found in $pidFile"
    fi
    if [ $? -ne 0 -o "$action" == "stop" ]; then
      exit $?
    fi
  elif [ "$pid" ]; then
    echo "Failed to $action $name: PID file $pidFile already exists"
    echo "Run '$command <stop|restart>' to $action $name"
    exit 1
  fi
}