import UIKit
import AVFoundation
import CoreLocation

class CreateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet var latTextField: UITextField!
    @IBOutlet var longTextField: UITextField!
    @IBOutlet var imageOne: UIButton!
    @IBOutlet var imageThree: UIButton!
    @IBOutlet var imageTwo: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var videoButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    let imagePickerManager = ImagePickerManager()
    let imagePickerController = UIImagePickerController()
    var videoURL: NSURL = NSURL()
    static var id = 4
    var one = UIImage()
    var two = UIImage()
    var three = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        imageOne.setImage(UIImage(named: "add_image"), for: .normal)
        imageTwo.setImage(UIImage(named: "add_image"), for: .normal)
        imageThree.setImage(UIImage(named: "add_image"), for: .normal)
        videoButton.setImage(UIImage(named: "add_image"), for: .normal)
    }
    
    @IBAction func imageOneAction(_ sender: UIButton) {
        getItemsClick(type: 1)
    }
    
    @IBAction func imageTwoAction(_ sender: UIButton) {
        getItemsClick(type: 2)
    }
    
    @IBAction func imageThreeAction(_ sender: UIButton) {
        getItemsClick(type: 3)
    }
    
    @IBAction func videoAction(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.mediaURL] as? URL {
            videoURL = url as NSURL
            print(videoURL)
            
            
            if let thumbnailImage = getThumbnailImage(forUrl: url) {
                videoButton.setImage(thumbnailImage, for: .normal)
                //imageView.image = thumbnailImage
            }
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        let title = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let lat:CLLocationDegrees = CLLocationDegrees(latTextField.text ?? "") ?? 0
        let longi:CLLocationDegrees = CLLocationDegrees(longTextField.text ?? "") ?? 0
        let imageOne = imageOne.imageView?.image
        let imageTwo = imageTwo.imageView?.image
        let imageThree = imageThree.imageView?.image
        let video = videoButton.imageView?.image
        
        if title == ""{
            dialog(message: "Add Title!")
            return
        }else if lat == 0{
            dialog(message: "Add Latitude!")
            return
        }else if longi == 0{
            dialog(message: "Add Longitude!")
            return
        }else if imageOne == UIImage(named: "add_image"){
            dialog(message: "Add Image!")
            return
        }else if imageTwo == UIImage(named: "add_image"){
            dialog(message: "Add Image!")
            return
        }else if imageThree == UIImage(named: "add_image"){
            dialog(message: "Add Image!")
            return
        }else if video == UIImage(named: "add_image"){
            dialog(message: "Add Video!")
            return
        }
        
        
        CreateViewController.id += 1
        //ViewController.place.append(Place(id: CreateViewController.id, name: title,images: [],video: "",latitude: 0,longitude: 0,uiImages: [],videoUrl: NSURL()))
        var images : [UIImage] = []
        
        images.append(one)
        images.append(two)
        images.append(three)
        
        ViewController.place.append(Place(id: CreateViewController.id, name: title, images: [], video: "", latitude: lat, longitude: longi, uiImages: images, videoUrl: videoURL))
        ViewController.placesHandler.placeList = ViewController.place
        
        ViewController.placesHandler.tableView?.reloadData()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func dialog(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getItemsClick(type:Int){
        self.imagePickerManager.pickImage(self,cameraTitle: "Camera",galleryTitle: "Gallery"){ image in
            
            if type == 1{
                self.one = image
                self.imageOne.setImage(image, for: .normal)
            }else if type == 2{
                self.two = image
                self.imageTwo.setImage(image, for: .normal)
            }else if type == 3{
                self.three = image
                self.imageThree.setImage(image, for: .normal)
            }
            
        }
        self.pickImage()
    }
    
    func pickImage() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(defaultAction)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        alertController.modalPresentationStyle = .popover
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
