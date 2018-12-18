#!/bin/bash

./gradlew ${1:-installDevMinSdkDevKernelDebug} --stacktrace && adb shell am start -n com.bacon.expokitfastlane/host.exp.exponent.MainActivity
