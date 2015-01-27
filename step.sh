#!/bin/bash

#Go to the project folder
eval cd "$BITRISE_SOURCE_DIR"

#Check if provided path exists
if [ ! -f "$BITRISE_SOURCE_DIR/$CRASHLYTICS_PATH" ]; then
    export CRASHLYTICS_PATH=`find . | grep -i crashlytics.framework/submit`
fi

echo "Using $CRASHLYTICS_PATH"

eval "$CRASHLYTICS_PATH $CRASHLYTICS_API_KEY $CRASHLYTICS_BUILD_SECRET -ipaPath \"$BITRISE_IPA_PATH\" -emails $CRASHLYTICS_EMAILS -groupAliases $CRASHLYTICS_GROUP_ALIASES -notifications $CRASHLYTICS_NOTIFICATIONS"

exit $?