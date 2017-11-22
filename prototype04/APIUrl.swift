
import Foundation

class APIUrl{
    
    static let baseUrl = "http://52.163.126.71:80/test/"
    
    enum requestUrl:String {
        case requestMessageUserList = "requestMessageUserList.php"
        case updateLocation = "updateLocation.php"
    }
    
}

