import Foundation

  /// Method for making signed (w/access token) requests to the API
    /// - Parameters:
    ///   - withEndpoint: the part after v1; ie /users
    ///   - completionHandler: The JSON Data is released here
    ///   - oauthToken: The token used to sign the request, stored in the keychain
    ///   - oauthTokenSecret: The token secret used to sign the request, stored in the keychain
    static func staticGeneralRequest(withEndpoint endpoint: String, oauthToken: String, oauthTokenSecret: String, httpMethod:String = "GET", completionHandler: @escaping (Data) ->Void){
        //the  oauthToken and tokenSecret are fetchable from the keychain
        var semaphore = DispatchSemaphore (value: 0)
        
        let oauthTimestamp = Int(NSDate().timeIntervalSince1970)
        let oauthNonce: String = NSUUID().uuidString
        
        var request = URLRequest(url: URL(string: someURL)!,timeoutInterval: Double.infinity)
    	buildRequest(&request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
//          print(String(data: data, encoding: .utf8)!)
          completionHandler(data)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    