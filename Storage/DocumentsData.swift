//
//  Networking.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 26/06/2020.
//

import Foundation
import Alamofire

class AntarFilters: ObservableObject {
    var company: Company = Company.any
    var itemPerPage: Int = 20
    var status: AGAnalysisStatus? = nil
    var sortDirection : AGDocumentSortingDirection = .descending
    var sortProperty : AGDocumentSortingOption = .createdAt
    var specificFilters : String? = nil
    
    func isEmpty() -> Bool {
        if company == Company.any && status == nil && sortProperty != .createdAt && sortDirection != .descending {
            return true
        }
        
        return false
    }
    
    static let companies: [Company] = Company.allCases
}

final class AppData: ObservableObject {
    @Published var loadedDocuments:[AGDocument] = mockAntarResponseDocuments()!
    @Published var mockDocument:AGDocument = mockLoadReceipt()!
    @Published var mockMode = true
    @Published var filters: AntarFilters = AntarFilters()
    @Published var isLoading = false
    
    func setFilters(_ filters: AntarFilters){
        self.filters = filters
        self.loadDocumentsFromNetwork()
    }
    
    func loadDocumentsFromNetwork() {
        isLoading = true
        NetworkManager.loadAllDocuments(filters) { [self] documents in
            print(documents.count)
            self.loadedDocuments = documents
            isLoading = false
        }
    }
}

class NetworkManager {
    
    static func loadAllDocuments(_ filters: AntarFilters, _ completion: @escaping (_ documents: [AGDocument]) -> (Void)) {
        
        authenticate { hydraAuth  in
            if let authObject = hydraAuth {
                gatherDocuments(authObject, filters: filters) { documentPage in
                    completion(documentPage.documents)
                }
            }else {
                print("could not auth")
            }
        }
    }
    
    static func gatherDocuments(_ authentication: HydraAuth, filters: AntarFilters, _ completion: @escaping (_ documents: AGDocumentPage) -> (Void)) {
        var apiHost = URL(string: "https://receipt.agkit.io/v2/")!
        apiHost.appendPathComponent("documents")
        
        var headers: HTTPHeaders = [
            "Authorization" : "\(authentication.tokenType) \(authentication.accessToken)",
            "format" : "short",
            
        ]
        
        if(filters.company != Company.any){
            headers.add(name: "company-uid", value: filters.company.rawValue)
        }
        
        
        
        var urlParameters : Parameters = [
            "per_page" : filters.itemPerPage,
            "sort" : filters.sortProperty,
            "sort_direction" : filters.sortDirection.rawValue,
        ]
        
        if let customFilters = filters.specificFilters {
            urlParameters["filters"] = customFilters
        }
        
        AF.request(apiHost,
                   parameters: urlParameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: headers
        ).responseData { response in
            debugPrint(response.request?.url?.absoluteString)
            switch response.result {
            case .success:
                //debugPrint(response.result)
                if let data = response.data {
                    do {
                        //print("Received Data: \(String(describing: response.data?.count))")
                        let decodedResponse = try JSONDecoder().decode(AGDocumentPage.self, from: data)
                        completion(decodedResponse)
                    } catch let error as NSError {
                        print(error)
                        assertionFailure(error.description)
                    }
                }
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }

    static func authenticate(_ completion: @escaping (_ auth: HydraAuth?) -> (Void)) -> Void {
        var authHost = URL(string: "https://security.agkit.io/")!
        let clientId = secretClientId
        let clientSecret = secretClientSecret
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters = [
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "grant_type" : "client_credentials"
        ]
        
        authHost.appendPathComponent("oauth2")
        authHost.appendPathComponent("token")
        
        
        AF.request(authHost, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseData { response in
            switch response.result {
            case .success:
                do {
                    if let data = response.data {
                        let decodedResponse:HydraAuth = try JSONDecoder().decode(HydraAuth.self, from: data)
                        completion(decodedResponse)
                    }
                } catch let error as NSError {
                    print(error)
                    assertionFailure(error.debugDescription)
                }
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }

}


func mockAntarResponseDocuments() -> [AGDocument]? {
    if let dataToDecode = FileReader.getContent(ofFileName: "AntarResponseDocumentsMock", withExtension: "json") {
        do {
            let documentPageData = try JSONDecoder().decode(AGDocumentPage.self, from: dataToDecode)
            return documentPageData.documents
        }catch let error as NSError {
            print(error.description)
            return nil
        }
    }
    return nil
}

func mockLoadReceipt() -> AGDocument? {
    if let dataToDecode = FileReader.getContent(ofFileName: "ReceiptMock", withExtension: "json") {
        do {
            let receiptList = try JSONDecoder().decode(AGDocument.self, from: dataToDecode)
            return receiptList
        }catch let error as NSError {
            print(error.description)
            return nil
        }
    }
    return nil
}


class FileReader {
    
    static func getContent(ofFileName fileName:String, withExtension type: String = "json") -> Data? {
        let bundle = Bundle.main
        
        guard let pathOfFile = bundle.path(forResource: fileName, ofType: type) else {
            print("[FILE][ERROR] Cannot find file for path : \(fileName).\(type)")
            return nil
        }
        
        guard let contentString = try? String(contentsOfFile: pathOfFile, encoding: String.Encoding.utf8) else {
            print("[FILE][ERROR] Cannot read file : \(fileName).\(type)")
            return nil
        }
        
        guard let dataFromFile = contentString.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            print("[FILE][ERROR] Cannot decode file : \(fileName).\(type)")
            return nil
        }
        
        return dataFromFile
        
    }
}
