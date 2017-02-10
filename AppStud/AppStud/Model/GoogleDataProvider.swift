//
//  GoogleDataProvider.swift
//  Feed Me
//
/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Foundation
import CoreLocation
//import SwiftyJSON

class GoogleDataProvider {
  var photoCache = [String:UIImage]()
  var placesTask: URLSessionDataTask?
  var session: URLSession {
    return URLSession.shared
  }
    
    static let sharedInstance: GoogleDataProvider = {
        let instance = GoogleDataProvider()
        // setup code
        return instance
    }()
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping (([GooglePlace]) -> Void)) -> ()
    {
        var urlString:String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=2000&types=bar&key=AIzaSyBvcp25k9w_k8sSL5rsA-py9y1Ks0qgRjE"
        //urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
//        if (placesTask?.taskIdentifier)! > 0 && placesTask?.state == .running {
//            placesTask?.cancel()
//        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        placesTask = session.dataTask(with: NSURL(string: urlString)! as URL) {data, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            if let aData = data {
                //let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                do {
                    if let json = try JSONSerialization.jsonObject(with: aData, options:.mutableContainers) as? Any {
                        print(json)
                        if let jsonDictionary = json as? Dictionary<String, Any> {
                            if let jsonArray = jsonDictionary["results"] as? [Any] {
                                for rawPlace in jsonArray {
                                    let googlePlace : GooglePlace = GooglePlace()
                                    if let result = rawPlace as? Dictionary<String, Any> {
                                        if let iconURL = result["icon"] {
                                            let iconURLString : String = iconURL as! String
                                            print(iconURLString)
                                            //3
                                            let downloadedPhoto = try UIImage(data: NSData(contentsOf: URL(string : iconURLString)!) as Data)
                                            googlePlace.photo = downloadedPhoto
                                        }
                                        if let nameURL = result["name"] {
                                            let nameURLString : String = nameURL as! String
                                            print(nameURLString)
                                            //4
                                            googlePlace.name = nameURLString
                                        }
                                        
                                        if let geometry = result["geometry"] {
                                            if let jsonGeometry = geometry as? Dictionary<String, Any> {
                                                if let location = jsonGeometry["location"] {
                                                    if let jsonLocation = location as? Dictionary<String, Any> {
                                                        var coordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D()
                                                        if let latObj = jsonLocation["lat"] {
                                                            let lattitude : Double = latObj as! Double
                                                            print(lattitude)
                                                            //1
                                                            coordinate?.latitude = lattitude
                                                        }
                                                        if let lngObj = jsonLocation["lng"] {
                                                            let longitude : Double = lngObj as! Double
                                                            print(longitude)
                                                            //2
                                                            coordinate?.longitude = longitude
                                                        }
                                                        googlePlace.coordinate = coordinate
                                                    }
                                                }
                                            }
                                        }
                                    }
                                 
                                    placesArray.append(googlePlace)
                                }
                                //print(placesArray)
                            }
                            
                        }
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
                //print(json)
                
//                let json = JSON(data:aData, options:NSJSONReadingOptions.MutableContainers, error:nil)
//                if let results = json["results"] {
                    
//                    for rawPlace in results {
//                        let place = GooglePlace(dictionary: rawPlace, acceptedTypes: types)
//                        placesArray.append(place)
//                        if let reference = place.photoReference {
//                            self.fetchPhotoFromReference(reference) { image in
//                                place.photo = image
//                            }
//                        }
//                    }
//                }
            }
            DispatchQueue.main.async {
                completion(placesArray)
            }
        }
        placesTask?.resume()
    }
  
//  func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: (([GooglePlace]) -> Void)) -> ()
//  {
//    var urlString = "http://localhost:10000/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
//    let typesString = types.count > 0 ? types.joinWithSeparator("|") : "food"
//    urlString += "&types=\(typesString)"
//    urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//    
//    if let task = placesTask where task.taskIdentifier > 0 && task.state == .Running {
//      task.cancel()
//    }
//    
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//    placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
//      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//      var placesArray = [GooglePlace]()
//      if let aData = data {
//        let json = JSON(data:aData, options:NSJSONReadingOptions.MutableContainers, error:nil)
//        if let results = json["results"].arrayObject as? [[String : AnyObject]] {
//          for rawPlace in results {
//            let place = GooglePlace(dictionary: rawPlace, acceptedTypes: types)
//            placesArray.append(place)
//            if let reference = place.photoReference {
//              self.fetchPhotoFromReference(reference) { image in
//                place.photo = image
//              }
//            }
//          }
//        }
//      }
//      dispatch_async(dispatch_get_main_queue()) {
//        completion(placesArray)
//      }
//    }
//    placesTask?.resume()
//  }
  
  
//  func fetchPhotoFromReference(reference: String, completion: ((UIImage?) -> Void)) -> () {
//    if let photo = photoCache[reference] as UIImage? {
//      completion(photo)
//    } else {
//      let urlString = "http://localhost:10000/maps/api/place/photo?maxwidth=200&photoreference=\(reference)"
//      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//      session.downloadTaskWithURL(NSURL(string: urlString)!) {url, response, error in
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//        if let url = url {
//          let downloadedPhoto = UIImage(data: NSData(contentsOfURL: url)!)
//          self.photoCache[reference] = downloadedPhoto
//          dispatch_async(dispatch_get_main_queue()) {
//            completion(downloadedPhoto)
//          }
//        }
//        else {
//          dispatch_async(dispatch_get_main_queue()) {
//            completion(nil)
//          }
//        }
//        }.resume()
//    }
//  }
}
