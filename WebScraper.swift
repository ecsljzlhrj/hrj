//
//  WebScraper.swift
//  a p p
//
//  Created by Mac on 2025/3/31.
//
// WebScraper.swift
import Foundation

enum ParsingError: Error {
    case invalidTitle
    case invalidAuthor
    case invalidCoverURL
    case unexpectedHTMLStructure
    case emptyHTML
    case invalidISBN
}

struct WebScraper {
    static func parseBookInfo(from html: String) throws -> (title: String, author: String, coverURL: URL?) {
        let title = try parseTitle(from: html)
        let author = try parseAuthor(from: html)
        let coverURL = try parseCoverURL(from: html)
        return (title, author, coverURL)
    }
    
    // 标题解析
    private static func parseTitle(from html: String) throws -> String {
        guard let titleStart = html.range(of: "<title>"),
              let titleEnd = html.range(of: "</title>", range: titleStart.upperBound..<html.endIndex)
        else {
            throw ParsingError.invalidTitle
        }
        
        let rawTitle = String(html[titleStart.upperBound..<titleEnd.lowerBound])
            .replacingOccurrences(of: "豆瓣读书", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !rawTitle.isEmpty else {
            throw ParsingError.invalidTitle
        }
        
        return rawTitle
    }
    
    // 作者解析
    private static func parseAuthor(from html: String) throws -> String {
        let pattern = #"<span class="pl">\s*作者\s*</span>[\s\S]*?<a.*?>(.*?)</a>"#
        guard let author = try html.firstCaptureGroup(of: pattern) else {
            throw ParsingError.invalidAuthor
        }
        return author
    }
    
    private static func parseCoverURL(from html: String) throws -> URL? {
        let pattern = #"<img src="(.*?)"\s+title="点击看大图""#
        guard let urlString = try html.firstCaptureGroup(of: pattern) else {
            throw ParsingError.invalidCoverURL
        }
        return URL(string: urlString)
    }
}

extension String {
    func firstCaptureGroup(of pattern: String) throws -> String? {
        let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        guard let match = regex.firstMatch(in: self, range: NSRange(location: 0, length: utf16.count)) else {
            return nil
        }
        return NSString(string: self).substring(with: match.range(at: 1))
    }
}
