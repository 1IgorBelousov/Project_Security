import Foundation
import CoreLocation

// fake server
fileprivate let TARGET_URL: URL = URL(string: "http://sberbank.ru")!

class HttpRequestHelper
{
    /// Sends location data to remote server.
    static func SendLocationData(location: CLLocation?)
    {
        var request = URLRequest(url: TARGET_URL)
        request.httpMethod = "POST"
        request.httpBody = Data(base64Encoded: "\(String(describing: location?.coordinate.latitude))-\(String(describing: location?.coordinate.longitude))")
        
        // send request
        URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            NSLog("Location data sent")
        }).resume()
    }
    
    /// Sends SOS signal to remote server.
    static func SendSos()
    {
        var request = URLRequest(url: TARGET_URL)
        request.httpMethod = "POST"
        request.httpBody = Data(base64Encoded: "SOS")
        
        // send request
        URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            NSLog("Location data sent")
        }).resume()
    }
}
