#!/bin/sh

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

DEFAULT_JVM_OPTS="-Xmx64m -Xms64m"

PRG="$0"
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

# Download the official Gradle 8.4 wrapper JAR when it is missing.
# This keeps builds working even when the binary wrapper JAR is omitted from the ZIP.
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"
if [ ! -s "$WRAPPER_JAR" ]; then
  WRAPPER_URL="https://services.gradle.org/distributions/gradle-8.4-wrapper.jar"
  WRAPPER_SHA256="0336f591bc0ec9aa0c9988929b93ecc916b3c1d52aed202c7381db144aa0ef15"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 -o "$WRAPPER_JAR" "$WRAPPER_URL" || exit 1
  elif command -v wget >/dev/null 2>&1; then
    wget -q --tries=3 -O "$WRAPPER_JAR" "$WRAPPER_URL" || exit 1
  else
    echo "ERROR: curl or wget is required to download Gradle Wrapper." >&2
    exit 1
  fi
  if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL_SHA256="$(sha256sum "$WRAPPER_JAR" | awk '{print $1}')"
    if [ "$ACTUAL_SHA256" != "$WRAPPER_SHA256" ]; then
      echo "ERROR: Gradle Wrapper checksum mismatch." >&2
      rm -f "$WRAPPER_JAR"
      exit 1
    fi
  fi
fi

CLASSPATH="$WRAPPER_JAR"

JAVACMD='java'
if [ -n "$JAVA_HOME" ] ; then
    JAVACMD="$JAVA_HOME/bin/java"
fi

exec "$JAVACMD" $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS \
    "-Dorg.gradle.appname=$APP_BASE_NAME" \
    -classpath "$CLASSPATH" \
    org.gradle.wrapper.GradleWrapperMain \
    "$@"
