//
//  AntarModels.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 26/06/2020.
//

import Foundation

// MARK: - HydraAuth
public struct HydraAuth: Codable {
    public let accessToken: String
    public let expiresIn: Int
    public let scope, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case scope
        case tokenType = "token_type"
    }
}

internal var availableLanguages:[AnalysisLanguage] = [.french, .spanish, .italian, .automatic]

internal enum AnalysisLanguage : String {
    case french = "fr"
    case spanish = "es"
    case italian = "it"
    case automatic =  "🤔"
    
    func toLocale() -> Locale {
        switch self {
        case .french :
            return Locale(identifier: "fr_FR")
        case .spanish:
            return Locale(identifier: "es_ES")
        case .italian:
            return Locale(identifier: "it_IT")
        case .automatic:
            return Locale.current
        }
    }
    
    static func fromLocale(locale: Locale) -> AnalysisLanguage {
        guard let languageCode = locale.languageCode?.lowercased() else { return .automatic }
        guard let analysisLanguage = AnalysisLanguage(rawValue: languageCode) else { return .automatic }
        return analysisLanguage
    }
}

public struct AGDocumentPage: Codable {
    public var documents:[AGDocument]
    public var total:Int
    public var pages:Int
    public var currentPage:Int?
    public var nextPageUri: String?
    public var prevPageUri: String?
    
    enum CodingKeys: String, CodingKey {
        case documents = "results"
        case total = "totalEntities"
        case pages = "totalPages"
        case nextPageUri
        case prevPageUri
    }
}

public enum AGDocumentSortingDirection: String, CaseIterable, Identifiable {
    
    public var id : AGDocumentSortingDirection { self }
    
    case ascending = "ASC"
    case descending = "DESC"
}

public enum AGDocumentSortingOption: String, CaseIterable, Identifiable {
    public var id : AGDocumentSortingOption { self }
    
    case createdAt
    case status
}


public enum AGAnalysisStatus: String, Codable {
    case waitingForProcess = "WAITING_FOR_PROCESS"
    case processed = "PROCESSED"
    case processing = "PROCESSING"
    case notExploitable = "NOT_EXPLOITABLE"
    case error = "ERROR"
    case subscriptionIssue = "SUBSCRIPTION_ISSUE"
    case any = "" //For query purpose
    
    static public var statusReasons = [
        AGAnalysisStatus.processed : "Analysed with success",
        AGAnalysisStatus.processing : "Analysis currently running",
        AGAnalysisStatus.waitingForProcess : "Document has been received and is waiting for analysis",
        AGAnalysisStatus.notExploitable : "We cannot exploit this image",
        AGAnalysisStatus.subscriptionIssue : "Not analyzed due to subscription issue",
        AGAnalysisStatus.error : "We have encoutered an error",
        AGAnalysisStatus.any : ""
    ]
}

public enum AGDocumentFormat : String {
    case basic
    case short
    case full
}


public struct AGDocument : Codable {
    public var identifier:String
    public var name:String?
    public var status:AGAnalysisStatus = AGAnalysisStatus.waitingForProcess
    public var processReport:String
    public var documentData:AGDocumentData?
    public var imageUrl: String
    public var companyUid: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "uid"
        case status
        case name
        case processReport
        case documentData = "data"
        case imageUrl
        case companyUid
    }
}

public struct AGDocumentData: Codable {
    
    public var shop:AGShop?
    public var total:Float?
    public var barCode:String?
    public var buyDate:String?
    public var buyHour:String?
    public var currency:String?
    public var payment: [String]?
    public var articleCount:Int?
    public var items:[AGItem]?

}

public struct AGShop: Codable {
    public var city:String?
    public var sign:String?
    public var phone:String?
    public var address:String?
    public var postalCode:String?
    public var geoLocation:String?
}

public struct AGItem: Codable {
    public var mass:Float?
    public var entry: Int?
    public var price:Float?
    public var product: AGProduct?
    public var quantity: Int?
    public var unitPrice: Float?
    public var shortLabel: String?
    public var packageUnity: String?
    public var bundle: Int?
}

public struct AGProduct: Codable {
    public var category: String?
    public var categoryUid: String?
    public var brand:String?
}
