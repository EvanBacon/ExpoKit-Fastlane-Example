#!/bin/bash

./gradlew ${1:-installDevMinSdkDevKernelDebug} --stacktrace && adb shell am start -n com.evanbacon.expokitfastlane/host.exp.exponent.MainActivity
