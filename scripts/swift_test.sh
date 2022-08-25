#!/bin/bash

#====================#
# Defaults
#====================#

# Our default platform is macOS.
# TODO: Detect macOS or Linux and switch accordingly?
platform=macOS

# Set our output directory. If none is set, use the DEPLOY_DIRECTORY environment variable by default.
output=$DEPLOY_DIRECTORY

# Define the architecture our operating system is running on.
arch=$(uname -m)

#====================#
# Get Arguments
#====================#

# This method isn't foolproof, as it relies on options being explicitly passed via alternating option/value order.
# source: https://www.brianchildress.co/named-parameters-in-bash/
while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
    fi
    shift
done

#====================#
# Functions
#====================#

swift_test() {
    # Before we do anything, clean the build artifacts.
    swift package clean

    command="swift test -c debug"

    # If code coverage is enabled, add it to the command.
    if [ -n "$codecov" ]; then
        command+=" --enable-code-coverage"
    fi

    # If we're running on Linux, add the --enable-test-discovery flag.
    # This is only required in Swift versions before 5.5, but adding it is safe.
    if [ $platform == "Linux" ]; then
        command+=" --enable-test-discovery"
    fi

    # If we're not running on the macOS or Linux platforms, we need to pass an SDK into the command.
    if [[ $platform != "macOS" || $platform != "Linux" ]]; then
        if [[ $arch != "arm64" && $arch != "x86_64" ]]; then
            echo "ERROR: Invalid architecture '${arch}'!"
            exit 0
        fi

        case $platform in
        iOS)
            command+=" -Xswiftc '-sdk' -Xswiftc '$(xcrun --sdk iphonesimulator --show-sdk-path)' -Xswiftc '-target' -Xswiftc '${arch}-apple-ios16.0-simulator'"
            ;;
        tvOS)
            command+=" -Xswiftc '-sdk' -Xswiftc '$(xcrun --sdk appletvsimulator --show-sdk-path)' -Xswiftc '-target' -Xswiftc '${arch}-apple-tvos16.0-simulator'"
            ;;
        watchOS)
            command+=" -Xswiftc '-sdk' -Xswiftc '$(xcrun --sdk watchsimulator --show-sdk-path)' -Xswiftc '-target' -Xswiftc '${arch}-apple-watchos9.0-simulator'"
            ;;
        esac
    fi

    # Print the command for debugging before we run it.
    echo "============================================================"
    echo "Running command:"
    echo "$ $command"
    echo "============================================================"

    # Run our command.
    eval "$command"

    # If code coverage is enabled and our output directory is set, copy the coverage results into the output directory.
    if [[ -n "$codecov" && -n "$output" ]]; then
        # Copy code coverage results into the output directory.
        cp $(swift test --show-codecov-path) "${output}/codecov.json"
    fi

    echo "============================================================"
}

# TODO: Add ability to collect code coverage / xctestresult and pass in output directory.
xcodebuild_test() {
    # TODO: We need to be able to detect the Module (if only single product) or Module-Package (if multiple products), pass as --scheme.
    command="xcodebuild clean test -scheme MyModule"

    # Add our destination to the xcodebuild command.
    # To get valid destinations, run "xcodebuild -showdestinations -scheme <package_name>"
    case $platform in
    iOS)
        # The iPhone 12 Pro supports Xcode 12+
        command+=" -destination 'platform=iOS Simulator,name=iPhone 12 Pro'"
        ;;
    macOS)
        command+=" -destination 'platform=OS X,arch=${arch}'"
        ;;
    tvOS)
        xcodebuild -showdestinations -scheme MyModule
        # command+=" -destination 'platform=tvOS Simulator,name=Apple TV 4K (at 1080p) (2nd generation)'"
        ;;
    watchOS)
        xcodebuild -showdestinations -scheme MyModule
        # command+=" -destination 'platform=watchOS Simulator,name=Apple Watch Series 7 - 45mm'"
        ;;
    Linux)
        echo "ERROR: Linux cannot run xcodebuild!"
        exit 0
        ;;
    esac

    # Print the command for debugging before we run it.
    echo "============================================================"
    echo "Running command:"
    echo "$ $command"
    echo "============================================================"

    # Run our command.
    eval "$command"
}

validate_operating_system() {
    operating_system=$(uname)
    expected_operating_system

    case $platform in
    Linux)
        expected_operating_system="Linux"
        ;;
    *)
        expected_operating_system="Darwin"
        ;;
    esac

    if [ $operating_system != $expected_operating_system ]; then
        echo "ERROR: Invalid operating system for platform '$platform'! Expected '$expected_operating_system', evaluated '$operating_system'."
        exit 0
    fi
}

#====================#
# Main
#====================#

# Validate our operating system before we do anything else.
# For example, a build intended for Linux should not run on Darwin,
# and a build intended for tvOS should not run on Linux.
validate_operating_system

# Create the output directory if it does not already exist.
mkdir -p $output

# Next, process the test function for the given platform.
case $platform in
iOS)
    xcodebuild_test
    ;;
macOS)
    # TODO: Should these be split out to separate build results?
    swift_test
    # xcodebuild_test
    ;;
tvOS)
    xcodebuild_test
    ;;
watchOS)
    xcodebuild_test
    ;;
Linux)
    swift_test
    ;;
*)
    echo "ERROR: The --platform option is required!"
    exit 0
    ;;
esac
