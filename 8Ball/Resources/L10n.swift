// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// https://8ball.delegator.com/magic/JSON/question
  internal static let urlString = L10n.tr("Localizable", "urlString")
  /// Ask your qestion and shake your IPhone to see the answer
  internal static let wellcomeText = L10n.tr("Localizable", "wellcomeText")

  internal enum Button {
    /// Ok
    internal static let ok = L10n.tr("Localizable", "button.ok")
  }

  internal enum ConnectionError {
    /// Please turn off your internet connection to use default answers.
    internal static let message = L10n.tr("Localizable", "connectionError.message")
    /// Error
    internal static let title = L10n.tr("Localizable", "connectionError.title")
  }

  internal enum EmptyArrayWarning {
    /// Please add your answers at the setting screen!
    internal static let message = L10n.tr("Localizable", "emptyArrayWarning.message")
    /// Ooops
    internal static let title = L10n.tr("Localizable", "emptyArrayWarning.title")
  }

  internal enum EmptyTFAlert {
    /// Please enter a little bit longer answer 😉
    internal static let message = L10n.tr("Localizable", "emptyTFAlert.message")
    /// Empty answer
    internal static let title = L10n.tr("Localizable", "emptyTFAlert.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
