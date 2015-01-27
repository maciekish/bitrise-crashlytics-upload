#!/bin/bash

#Go to the project folder
eval cd "$BITRISE_SOURCE_DIR"

#Check if provided path exists
if [ ! -f "$BITRISE_SOURCE_DIR/$CRASHLYTICS_PATH" ]; then
    CRASHLYTICS_PATH=`find . | grep -i crashlytics.framework/submit | head -1`
fi

keychain_fn "add"
eval "$CRASHLYTICS_PATH $CRASHLYTICS_API_KEY $CRASHLYTICS_BUILD_SECRET -ipaPath \"$BITRISE_IPA_PATH\" -emails $CRASHLYTICS_EMAILS -groupAliases $CRASHLYTICS_GROUP_ALIASES -notifications $CRASHLYTICS_NOTIFICATIONS"
keychain_fn "remove"

exit $?

# ------------------------------
# --- Utils - Keychain

function keychain_fn {
  if [[ "$1" == "add" ]] ; then
	KEYCHAIN_PASSPHRASE="$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"

    # Create the keychain
    print_and_do_command_exit_on_error security -v create-keychain -p "${KEYCHAIN_PASSPHRASE}" "${BITRISE_KEYCHAIN}"

    # Import to keychain
    print_and_do_command_exit_on_error security -v import "${CERTIFICATE_PATH}" -k "${BITRISE_KEYCHAIN}" -P "${XCODE_BUILDER_CERTIFICATE_PASSPHRASE}" -A

    # Unlock keychain
    print_and_do_command_exit_on_error security -v set-keychain-settings -lut 72000 "${BITRISE_KEYCHAIN}"
    print_and_do_command_exit_on_error security -v list-keychains -s "${BITRISE_KEYCHAIN}"
    print_and_do_command_exit_on_error security -v list-keychains
    print_and_do_command_exit_on_error security -v default-keychain -s "${BITRISE_KEYCHAIN}"
    print_and_do_command_exit_on_error security -v unlock-keychain -p "${KEYCHAIN_PASSPHRASE}" "${BITRISE_KEYCHAIN}"
  elif [[ "$1" == "remove" ]] ; then
    print_and_do_command_exit_on_error security -v delete-keychain "${BITRISE_KEYCHAIN}"
  fi
}