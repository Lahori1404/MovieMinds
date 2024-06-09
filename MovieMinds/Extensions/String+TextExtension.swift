//
//  String+LocalizableExtension.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 08/06/24.
//

import Foundation
import SwiftUI

extension String {
    
    public func localized() -> String {
        return localized(tableName: nil, bundle: Bundle.main)
    }

    func localized(tableName: String?, bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? Bundle.main
        return bundle.localizedString(forKey: self, value: nil, table: tableName)
    }

    func localizedFormat(arguments: CVarArg...) -> String {
        return String(format: localized(),
                      arguments: arguments)
    }
}

extension Text {
    init(markdown: String) {
        do {
            let attrString = try AttributedString(markdown: markdown)
            self = Text(attrString)
        } catch {
            assertionFailure("Unable to parse markdown:\(markdown) - Error:\(error)")
            self = Text("ERROR: Invalid markdown")
        }
    }
}
