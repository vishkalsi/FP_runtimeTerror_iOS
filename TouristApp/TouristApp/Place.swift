import Foundation
import CoreLocation
import UIKit

struct Place{
    
    var id:Int?
    var name:String?
    var images:[String]?
    var uiImages:[UIImage]?
    var video:String?
    var videoUrl:NSURL?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    init(id:Int,name:String,images:[String],video:String,latitude:CLLocationDegrees,longitude:CLLocationDegrees,uiImages:[UIImage],videoUrl:NSURL){
        self.id = id
        self.name = name
        self.images = images
        self.video = video
        self.latitude = latitude
        self.longitude = longitude
        self.uiImages = uiImages
        self.videoUrl = videoUrl
    }
    
    
}
