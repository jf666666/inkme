//
//  String.swift
//  Ikachan
//
//  Created by Sketch on 2021/2/3.
//

import Intents

extension String {
  var localizedString: String {
    NSLocalizedString(self, comment: "")
  }

  var stageName: String {
    let bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj")
    let englishBundle = Bundle(path: bundlePath!)
    return NSLocalizedString(self, bundle: englishBundle!, comment: "")
  }

  var specialWeaponName: String {
    let bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj")
    let englishBundle = Bundle(path: bundlePath!)
    return NSLocalizedString(self, bundle: englishBundle!, comment: "")
  }

  var localizedIntentsString: String {
    let languageCode = INPreferences.siriLanguageCode()

    guard let path = Bundle.main.path(forResource: escapeLanguageCode(languageCode: languageCode), ofType: "lproj") else {
      return self
    }
    let bundle = Bundle(path: path)

    return bundle?.localizedString(forKey: self, value: nil, table: nil) ?? self
  }

  var asDate:Date{
    utcToDate(date: self) ?? Date()
  }


}

extension String {
  // Base64 编码
  func base64Encoded() -> String {
    return self.data(using: .utf8)?.base64EncodedString() ?? "nil"
  }

  // Base64 解码
  func base64Decoded() -> String {
    guard let data = Data(base64Encoded: self) else { return "nil" }
    return String(data: data, encoding: .utf8) ?? "nil"
  }
}


extension Array where Element == String {
  func concate(delimiter: String) -> String {
    var result = ""

    for s in self {
      if !result.isEmpty {
        result = result + delimiter
      }

      result = result + s
    }

    return result
  }
}

/// HACK: Escapes language code to supported language.
private func escapeLanguageCode(languageCode: String) -> String {
  if languageCode.starts(with: "en") {
    return "en"
  } else if languageCode.starts(with: "ja") {
    return "ja"
  } else if languageCode.starts(with: "zh") {
    return "zh-Hans"
  } else {
    return "en"
  }
}

extension String {
  func base64UrlEncoded() -> String {
    return self.replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }
}

extension String{
  var userKey:String?{
    let pattern = "(VsHistoryDetail-u-|CoopHistoryDetail-u-)([^:]+)"
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }

    let nsRange = NSRange(self.startIndex..<self.endIndex, in: self)
    let matches = regex.matches(in: self, range: nsRange)

    guard let match = matches.first,
          let range = Range(match.range(at: 2), in: self) else {
      return nil
    }

    return String(self[range])
  }
}

extension String{
  var base64Index:Int{
    Int(self.base64Decoded().split(separator: "-")[1]) ?? 0
  }
}

extension String {
  var imageHash: String {
    let path = self.components(separatedBy: "?")[0]
    let split = path.components(separatedBy: "/")
    return split.last?.components(separatedBy: "_")[0] ?? ""
  }
}


extension String {
  /// Returns `String` with debug information, useful for logging.
  /// - Parameters:
  ///   - _function: Function name
  ///   - _fileID: File ID
  ///   - _line: Line of the statement
  /// - Returns: `String`
  static func _debugInfo(_function: StaticString = #function, _fileID: StaticString = #fileID, _line: Int = #line) -> Self {
#if DEBUG
    "\(_function) \(_fileID):\(_line)"
#else
    "\(_function)"
#endif
  }
}
