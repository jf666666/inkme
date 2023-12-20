//
//  Bundle+.swift
//  CommonKit
//
//  Created by royal on 26/12/2022.
//

import Foundation

public extension Bundle {
	/// Short version string, `CFBundleShortVersionString` in `Info.plist`.
	var buildVersion: String {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
	}

	/// Version string, `CFBundleVersion` in `Info.plist`.
	var buildNumber: String {
		Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
	}

	/// Main bundle identifier, `MainBundleIdentifier` in `Info.plist`
	var mainBundleIdentifier: String? {
		Bundle.main.infoDictionary?["MainBundleIdentifier"] as? String
	}

	/// App identifier prefix, `AppIdentifierPrefix` in `Info.plist`
	var appIdentifierPrefix: String? {
		Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String
	}

	/// Group identifier, including `AppIdentifierPrefix`.
	var groupIdentifier: String? {
		"\(appIdentifierPrefix ?? "")group.\(mainBundleIdentifier ?? bundleIdentifier ?? "")"
	}
}
