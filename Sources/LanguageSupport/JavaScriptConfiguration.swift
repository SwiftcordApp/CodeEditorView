//
//  JavaScriptConfiguration.swift
//  
//
//  Created by Vincent on 16/6/26.
//

import Foundation
import RegexBuilder


private let javaScriptReservedIdentifiers =
  ["arguments", "as", "async", "await", "break", "case", "catch", "class", "const",
   "continue", "debugger", "default", "delete", "do", "else", "enum", "eval", "export",
   "extends", "false", "finally", "for", "from", "function", "get", "if", "implements",
   "import", "in", "Infinity", "instanceof", "interface", "let", "NaN", "new", "null",
   "of", "package", "private", "protected", "public", "return", "set", "static", "super",
   "switch", "this", "throw", "true", "try", "typeof", "undefined", "var", "void", "while",
   "with", "yield"]

extension LanguageConfiguration {

  /// Language configuration for JavaScript.
  ///
  public static func javaScript(_ languageService: LanguageService? = nil) -> LanguageConfiguration {
    let numberRegex: Regex<Substring> = Regex {
      optNegation
      ChoiceOf {
        Regex { /0[bB]/; binaryLit; Optionally("n") }
        Regex { /0[oO]/; octalLit; Optionally("n") }
        Regex { /0[xX]/; hexalLit; Optionally("n") }
        Regex { decimalLit; "."; decimalLit; Optionally { exponentLit } }
        Regex { "."; decimalLit; Optionally { exponentLit } }
        Regex { decimalLit; exponentLit }
        Regex { decimalLit; Optionally("n") }
      }
    }
    let stringRegex: Regex<Substring> = Regex {
      ChoiceOf {
        /"(?:\\.|[^"\\\n\r])*"/
        /`(?:\\.|[^`\\\n\r])*`/
      }
    }
    let identifierHeadCharacters = CharacterClass("a"..."z", "A"..."Z", .anyOf("_$"))
    let identifierCharacters     = CharacterClass(identifierHeadCharacters, "0"..."9")
    let identifierRegex: Regex<Substring> = Regex {
      identifierHeadCharacters
      ZeroOrMore {
        identifierCharacters
      }
    }
    let operatorRegex: Regex<Substring> = Regex {
      OneOrMore {
        CharacterClass(.anyOf("+-*/%=&|!<>^~?:."))
      }
    }
    return LanguageConfiguration(name: "JavaScript",
                                 supportsSquareBrackets: true,
                                 supportsCurlyBrackets: true,
                                 stringRegex: stringRegex,
                                 characterRegex: /'(?:\\.|[^'\\\n\r])*'/,
                                 numberRegex: numberRegex,
                                 singleLineComment: "//",
                                 nestedComment: (open: "/*", close: "*/"),
                                 identifierRegex: identifierRegex,
                                 operatorRegex: operatorRegex,
                                 reservedIdentifiers: javaScriptReservedIdentifiers,
                                 reservedOperators: [],
                                 languageService: languageService)
  }
}
