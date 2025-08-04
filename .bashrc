#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export TERM=kitty

export PATH="$HOME/go/bin:$PATH"

# export ANDROID_HOME="$HOME/Android/Sdk"
# export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
# export ANDROID_NDK_ROOT="$HOME/Android/Sdk/ndk/29.0.13599879" # Replace with the actual version
# export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
# export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

# export QT_DIR="/opt/Qt/6.9.1"
# export QT_HOST_ROOT="$QT_DIR/gcc_64"
# export QT_ANDROID_ROOT="$QT_DIR/android_arm64_v8a"
# export PATH="$PATH:$QT_DIR/gcc_64/bin"
