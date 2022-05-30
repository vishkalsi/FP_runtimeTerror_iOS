import UIKit

class PlacesHandler: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    let placesCell = "placesCell"
    var placeList = [Place]()
    var onNameClick:((Place) -> Void)!
    var tableView:UITableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = placeList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: placesCell, for: indexPath) as! PlacesTableViewCell
        cell.name.text = place.name
        
        cell.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(nameClick))
        cell.addGestureRecognizer(tap)
        
        
        return cell
    }
    
    @objc func nameClick(_ sender:UITapGestureRecognizer){
        let index = (sender.view?.tag)!
        onNameClick(placeList[index])
    }
    
    
    
    
}
