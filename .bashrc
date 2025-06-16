#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$HOME/go/bin:$PATH"

export PATH="/usr/lib/qt6/bin:$PATH"

export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_NDK_ROOT="$HOME/Android/Sdk/ndk/29.0.13599879" # Replace with the actual version
export JAVA_HOME="/usr/lib/jvm/default-java"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
export QT_ANDROID_ROOT="$HOME/Qt/6.6.0/android_arm64_v8a"
export QT_HOST_PATH="/usr/lib/qt6"
