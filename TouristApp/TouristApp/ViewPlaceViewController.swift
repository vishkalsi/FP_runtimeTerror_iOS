import UIKit
import AVKit
import AVFoundation
import AVFAudio
import UIKit
import MapKit
import CoreLocation

class ViewPlaceViewController: UIViewController, UIScrollViewDelegate,CLLocationManagerDelegate, MKMapViewDelegate {
    
    var player: AVPlayer?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var sliderScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var videoView: UIView!
    @IBOutlet var playImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var scrollView: UIScrollView!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var place = Place(id: 0, name: "", images: [], video: "", latitude: 0,longitude: 0, uiImages: [], videoUrl: NSURL())
    var images : [String] = []
    var uiImages:[UIImage] = []
    var video:String = ""
    var videoUrl:NSURL = NSURL()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"
        
        nameLabel.text = place.name
        if place.uiImages!.count == 0{
            images = place.images!
        }else{
            uiImages = place.uiImages!
        }
        
        if place.video == ""{
            videoUrl = place.videoUrl!
        }else{
            video = place.video!
        }
        
        DispatchQueue.main.async {
            self.addScroll()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initBackgroundVideo()
        determineCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        createMapView()
    }
    
    func createMapView()
    {
        mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 40
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x:leftMargin,y: topMargin,width: mapWidth,height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        //mapView.center = view.center
        
        self.scrollView.addSubview(mapView)
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let userLocation:CLLocation = locations[0] as CLLocation
        let latitude = place.latitude
        let longitude = place.longitude
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude ?? 0, longitude ?? 0);
        myAnnotation.title = nameLabel.text
        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    func initBackgroundVideo() {
        //videoView.layer.zPosition = 0
        playImageView.isHidden = false
        
        var videoURL: NSURL?
        if place.video == ""{
            videoURL = videoUrl as NSURL
        }else{
            videoURL = Bundle.main.url(forResource: video, withExtension: "mp4")! as NSURL
        }
        
        player = AVPlayer(url: videoURL! as URL)
        player?.isMuted = false
        player?.automaticallyWaitsToMinimizeStalling = false
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        
        playerLayer.frame = videoView.bounds
        playerLayer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.7)
        
        videoView.layer.addSublayer(playerLayer)
        pausePlayer()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(playerDidFinishPlaying),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: player?.currentItem
            )
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        loopVideo()
    }
    
    @objc func loopVideo() {
        player?.seek(to: CMTime.zero)
        pausePlayer()
    }
    
    func pausePlayer(){
        player?.pause()
        playImageView.isHidden = false
    }
    
    func playPlayer(){
        player?.play()
        playImageView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        if player != nil{
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    @IBAction func videoTapAction(_ sender: UITapGestureRecognizer) {
        playStatus()
    }
    
    func playStatus(){
        if player?.timeControlStatus == .playing {
            pausePlayer()
        } else if player?.timeControlStatus == .paused {
            playPlayer()
        }else{
            playPlayer()
        }
    }
    
    @IBAction func playImageTapAction(_ sender: UITapGestureRecognizer) {
        playStatus()
    }
    
    func addScroll() {
        if place.images?.count ?? 0 > 0{
            pageControl.numberOfPages = self.images.count
            
            for index in 0..<(self.images.count){
                
                frame.origin.x = sliderScrollView.frame.size.width * CGFloat(index)
                frame.size = sliderScrollView.frame.size
                
                let imageView = UIImageView(frame: frame)
                imageView.contentMode = .scaleAspectFill
                
                if (self.images[index]) != ""{
                    
                    imageView.image = UIImage(named: images[index])
                    
                    self.sliderScrollView.addSubview(imageView)
                }else{
                
                }
            }
            sliderScrollView.contentSize = CGSize(width: (sliderScrollView.frame.size.width * CGFloat((self.images.count))), height: sliderScrollView.frame.size.height)
            
        }else{
            pageControl.numberOfPages = self.uiImages.count
            
            for index in 0..<(self.uiImages.count){
                
                frame.origin.x = sliderScrollView.frame.size.width * CGFloat(index)
                frame.size = sliderScrollView.frame.size
                
                let imageView = UIImageView(frame: frame)
                imageView.contentMode = .scaleAspectFill
                imageView.image = uiImages[index]
                
                self.sliderScrollView.addSubview(imageView)
                
            }
            sliderScrollView.contentSize = CGSize(width: (sliderScrollView.frame.size.width * CGFloat((self.uiImages.count))), height: sliderScrollView.frame.size.height)
        }
        sliderScrollView.delegate = self
    }
    
    func scrollToPage(page: Int) {
        var frame: CGRect = self.sliderScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.sliderScrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
}

extension ViewPlaceViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
}
