# Provides methods that used by projects

except() {
  local i=0
  local FRAMES=${#BASH_LINENO[@]}
  # FRAMES-2 skips main, the last one in arrays
  for ((i=FRAMES-2; i>=0; i--)); do
    echo '  File' \"${BASH_SOURCE[i+1]}\", line ${BASH_LINENO[i]}, in ${FUNCNAME[i+1]}
    # Grab the source code of the line
    sed -n -e "${BASH_LINENO[i]}{s/^/    /" -e 'p' -e '}' "${BASH_SOURCE[i+1]}"
  done
}

project_name()
{
  echo "$BAGGAGE_APP_NAME"
}

project_path()
{
  echo "$BAGGAGE_APP_PATH"
}

project_version()
{
  echo "$BAGGAGE_APP_VERSION"
}

project_description()
{
  echo "$BAGGAGE_APP_DESCRIPTION"
}


built?()
{
  if [ -n "$BAGGAGE_APP_BUILT" ]; then
    return 0
  else
    return 1
  fi
}

built_flag_off()
{
  export BAGGAGE_APP_BUILT=""
}

fatal()
{
  echo "FATAL - $1"
  except
  exit 1
}

load()
{
  local name="$1"
  [ -z "$name" ] && error "load argument missing"

  if built?; then
    $name
  else
    if [ -r "lib/${name}.bash" ]; then
      source "lib/${name}.bash"
    elif [ -r "bags/${name}.bag" ]; then
      source "bags/${name}.bag"
    elif [ -d "bags/${name}" ] && [ -r "bags/${name}/out/${name}.bag" ]; then
      source "bags/${name}/out/${name}.bag"
    fi
  fi
}
