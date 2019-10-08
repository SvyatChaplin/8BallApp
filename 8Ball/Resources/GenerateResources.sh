#!/bin/sh

RSROOT=$SRCROOT/8Ball/Resources

"$PODS_ROOT/SwiftGen/bin/swiftgen" \
xcassets -t swift3 "$RSROOT/Assets.xcassets" \
--output "$RSROOT/Assets.swift"

"$PODS_ROOT/SwiftGen/bin/swiftgen" \
strings -t structured-swift4 "$RSROOT/Localizable.strings" \
--output "$RSROOT/L10n.swift"

"$PODS_ROOT/SwiftGen/bin/swiftgen" \
colors -t swift4 "$RSROOT/Colors.json" \
--output "$RSROOT/Colors.swift"

"$PODS_ROOT/SwiftGen/bin/swiftgen" \
fonts -t swift4 "$RSROOT/Fonts" \
--output "$RSROOT/Fonts.swift"
