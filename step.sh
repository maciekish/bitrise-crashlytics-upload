#!/bin/bash

cmd="\"$CRASHLYTICS_PATH\" $CRASHLYTICS_API_KEY $CRASHLYTICS_BUILD_SECRET -ipaPath \"$BITRISE_IPA_PATH\" -emails $CRASHLYTICS_EMAILS -groupAliases $CRASHLYTICS_GROUP_ALIASES -notifications $CRASHLYTICS_NOTIFICATIONS"

eval "$cmd"

exit $?