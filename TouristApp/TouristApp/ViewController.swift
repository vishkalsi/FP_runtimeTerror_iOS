import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var createButton: UIButton!
    
    static var placesHandler = PlacesHandler()
    
    //static var places:[Places] = []
    static var place:[Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visited Places"
        
//        ViewController.places.append(Places(id: 1, name: "Taj Mahal"))
//        ViewController.places.append(Places(id: 2, name: "Effil Tower"))
//        ViewController.places.append(Places(id: 3, name: "Statue of liberty"))
//        ViewController.places.append(Places(id: 4, name: "Great wall of china"))
        ViewController.place.append(Place(id: 1, name: "Taj Mahal", images: ["taj_1","taj_2","taj_3"], video: "taj", latitude: 27.173891,longitude: 78.042068, uiImages: [], videoUrl: NSURL()))
        ViewController.place.append(Place(id: 2, name: "Effil Tower", images: ["effil_1","effil_2","effil_3"], video: "effil", latitude: 48.858093,longitude: 2.294694, uiImages: [], videoUrl: NSURL()))
        ViewController.place.append(Place(id: 3, name: "Statue of liberty", images: ["sol_1","sol_2","sol_3"], video: "sol", latitude: 40.689247,longitude: -74.044502, uiImages: [], videoUrl: NSURL()))
        ViewController.place.append(Place(id: 4, name: "Great wall of china", images: ["wall_1","wall_2","wall_3"], video: "wall",latitude: 40.431908,longitude: 116.570374, uiImages: [], videoUrl: NSURL()))
        ViewController.placesHandler.placeList = ViewController.place
        
        tableView.delegate = ViewController.placesHandler
        tableView.dataSource = ViewController.placesHandler
        
        ViewController.placesHandler.onNameClick = { place in
            self.viewPlacesController(currentPlace: place)
        }
        
        createButton.setImage(UIImage(named: "create"), for: .normal)
        
        
    }
    
    func viewPlacesController(currentPlace:Place){
        
//        var cPlace = Place(id: 0, name: "", images: [], video: "", latitude: 0,longitude: 0, uiImages: [], videoUrl: NSURL())
//
//        for i in 0..<ViewController.place.count{
//            if ViewController.place[i].id == currentPlace.id{
//                cPlace = ViewController.place[i]
//            }
//        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewPlacesViewController = storyboard.instantiateViewController(withIdentifier: "ViewPlacesSID") as! ViewPlaceViewController
        viewPlacesViewController.place = currentPlace
    
        self.navigationController?.pushViewController(viewPlacesViewController, animated: true)
    }
    
    func createViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createViewController = storyboard.instantiateViewController(withIdentifier: "createSID") as! CreateViewController
        self.navigationController?.pushViewController(createViewController, animated: true)
    }
    
    
    @IBAction func createAction(_ sender: UIButton) {
        createViewController()
    }
    
}

