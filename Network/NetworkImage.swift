import Foundation
import SwiftUI

// TODO: Route to get list of companies

public func buildUrlRequestWithBasicAuth(username: String, password: String, url: URL) -> URLRequest {
    let loginString = "\(username):\(password)"
    let loginData = loginString.data(using: .utf8)!
    let base64LoginString = loginData.base64EncodedString()
    
    var request = URLRequest(url: url)
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    return request
}

//https://receipt.agkit.io/v2/documents/8001464f-89bb-4cec-adff-560374cf6f29/show
//https://img.agkit.io/fill/300/400/sm/0/
func buildImgProxyUrl(withImageUrl image: URL, width: Int, height: Int) -> URL? {
    if let imageUrlString = image.absoluteString.data(using: .utf8) {
        print(image.absoluteString)
        if var imgProxyURL = URL(string: "https://img.agkit.io") {
            imgProxyURL.appendPathComponent("fill")
            imgProxyURL.appendPathComponent(String(width))
            imgProxyURL.appendPathComponent(String(height))
            //Gravity
            imgProxyURL.appendPathComponent("no")
            //Force resize
            imgProxyURL.appendPathComponent("0")
            //Image URL
            imgProxyURL.appendPathComponent(imageUrlString.base64EncodedString())
            //print(imgProxyURL.absoluteString)
            return imgProxyURL
        }
        return nil
    }
    return nil
    
}

final class Loader: ObservableObject {
    
    var task: URLSessionDataTask!
    @Published var loaded:Bool = false
    @Published var data: Data? = nil
    @Published var error: Error? = nil
    
    init(urlRequest: URLRequest){
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            
            DispatchQueue.main.async {
                self.data = data
            }
            
            if(self.data != nil) {
                DispatchQueue.main.async {
                    self.loaded = true
                }
            }
            
            if error != nil {
                self.error = error
                print(self.error.debugDescription)
            }
        })
        task.resume()
    }
    
    init(_ url: URL) {
        task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            DispatchQueue.main.async {
                self.data = data
            }
        })
        task.resume()
    }
    deinit {
        task.cancel()
    }
}

let placeholder = UIImage(systemName: "photo")!

public struct AsyncImage: View {
    public init(url: URL) {
        self.imageLoader = Loader(url)
    }
    
    public init(urlRequest: URLRequest){
        self.imageLoader = Loader(urlRequest: urlRequest)
    }
    
    @ObservedObject private var imageLoader: Loader
    
    var image: UIImage? {
        return imageLoader.data.flatMap(UIImage.init)
    }
    public var body: some View {
            Image(uiImage: image ?? placeholder)
        if imageLoader.error != nil {
            Image(systemName: "xmark.octagon.fill")
                .foregroundColor(.red)
        }
    }
}
