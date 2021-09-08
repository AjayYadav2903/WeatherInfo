//
//  GeoLocationSearchVC.swift
//  WeatherInfo
//
//  Created by Ajay Yadav on 07/09/21.
//

import Foundation
import UIKit
import MapKit
import CoreData

class GeoLocationSearchVC : UIViewController {
    
    var context = WeatherInfo.kAppDelegate.persistentContainer.viewContext
    
    //Views
    //TextField SearchBar
    lazy var locationSearchField : PaddedTextField = {
        let txtFld = PaddedTextField()
        txtFld.attributedPlaceholder = NSAttributedString(string: Constant().SearchPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor : Constant().appColor])
        txtFld.textColor = Constant().appColor
        txtFld.layer.borderWidth = 0
        txtFld.layer.cornerRadius = 10
        txtFld.layer.masksToBounds = true
        txtFld.padding = 18
        txtFld.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        return txtFld
    }()
    
    //TableView
    lazy var searchResultTable : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var searchTimer: Timer?
    var interactionType: String?
    var typeOfVC: String?
    
    // MARK: View controller lifecycle methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Background View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if traitCollection.userInterfaceStyle == .dark {
        }else{
            self.view.backgroundColor = Constant().BgColor
        }
        
        DispatchQueue.main.async {
            self.locationSearchField.text = ""
            self.searchResults.removeAll()
            self.searchResultTable.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: File private
    
    fileprivate func setupView() {
        //Set delegate
        searchCompleter.delegate = self
        
        self.view.addSubview(self.locationSearchField)
        
        self.locationSearchField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.leading.equalTo(self.view.snp.leading).offset(17)
            make.trailing.equalTo(self.view.snp.trailing).offset(-17)
            make.height.equalTo(60)
        }
        
        AppUtils.sharedInstance.addImageInTextFieldRight(textfield: self.locationSearchField, imageName: Constant().Search)
        
        if traitCollection.userInterfaceStyle == .dark{
            
        }else{
            locationSearchField.backgroundColor = .white
        }
        
        self.searchResultTable.register(UINib.init(nibName: Constant().CurrentLocationCell, bundle: nil), forCellReuseIdentifier: Constant().CurrentLocationCell)
        self.searchResultTable.dataSource = self
        self.searchResultTable.delegate = self
        
        self.searchResultTable.tableFooterView = UIView()
        self.searchResultTable.separatorStyle = .none
        
        self.view.addSubview(self.searchResultTable)
        self.searchResultTable.snp.makeConstraints { (make) in
            make.top.equalTo(self.locationSearchField.snp.bottom).offset(5)
            make.leading.equalTo(self.view.snp.leading).offset(10)
            make.trailing.equalTo(self.view.snp.trailing).inset(10)
            make.bottom.equalTo(self.view)
        }
    }
}

//MARK: TextField Delegate
extension GeoLocationSearchVC : UITextFieldDelegate{
    @objc func textFieldDidChange(textField: UITextField){
        if textField.text != "" {
            self.searchCompleter.filterType = .locationsOnly
            searchCompleter.queryFragment = textField.text ?? Constant().Empty
        }else{
            self.searchResults.removeAll()
            self.searchResultTable.reloadData()
        }
    }
}

//MARK: TableView DataSource
extension GeoLocationSearchVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0{
            if getAllOfflineItems()?.count ?? 0 > 0 {
                return getAllOfflineItems()?.count ?? 0
            }else {
                return 1
            }
        }else{
            let rowCount = searchResults.count + 1
            return rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant().CurrentLocationCell, for: indexPath) as! CurrentLocationCell
            cell.backgroundColor = .clear
            return cell
        }else{
            if searchResults.count == 0 {
                if getAllOfflineItems()?.count ?? 0 > 0 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.backgroundColor = .clear
                    cell.textLabel?.textColor = Constant().appColor
                    cell.detailTextLabel?.textColor = Constant().appColor
                    cell.textLabel?.text = getAllOfflineItems()?[indexPath.row].address
                    //cell.detailTextLabel?.text = searchResult.subtitle
                    return cell
                }
            }
            
            let searchResult = searchResults[indexPath.row - 1]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = Constant().appColor
            cell.detailTextLabel?.textColor = Constant().appColor
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            print(indexPath.row)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsCoreModel")
            
            // remove the deleted item from the model
          //  context.delete((getAllOfflineItems()?[indexPath.row])! as NSManagedObject)
            
            
            if let result = try? context.fetch(fetchRequest) {
                for object in 0..<result.count {
                    if (indexPath.row) == object {
                        if getAllOfflineItems()?[indexPath.row].address == (result[object] as! LocationsCoreModel).address {
                            context.delete(result[object] as! LocationsCoreModel)
                            WeatherInfo.kAppDelegate.saveContext()
                        }
                    }
                }
                self.searchResultTable.reloadData()
            }
        }
    }
    
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Your Location Selected")
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: Constant().MapLocationVC) as! MapLocationVC
            self.navigationController?.pushViewController(mapVC, animated: true)
        }else{
            if searchResults.count == 0 {
                if getAllOfflineItems()?.count ?? 0 > 0 {
                    let weatherVC = WeatherInfoList()
                    weatherVC.latitude = self.getAllOfflineItems()?[indexPath.row].latitude
                    weatherVC.longitude = self.getAllOfflineItems()?[indexPath.row].longitude
                    
                    self.navigationController?.pushViewController(weatherVC, animated: true)
                }
            }else {
                let completion = searchResults[indexPath.row - 1]
                let searchRequest = MKLocalSearch.Request(completion: completion)
                let search = MKLocalSearch(request: searchRequest)
                search.start { (response, error) in
                    if let placeMark = response?.mapItems.first?.placemark {
                        print("Latitude=====>" ,placeMark.coordinate.latitude, "Longitude=======>", placeMark.coordinate.longitude )
                        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: Constant().MapLocationVC) as! MapLocationVC
                        mapVC.selectedPlace = placeMark.location
                        mapVC.selectedPlaceMark = placeMark
                        self.navigationController?.pushViewController(mapVC, animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: MKLocalSearchCompleterDelegate
extension GeoLocationSearchVC : MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.searchResultTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print("No Results Found")
    }
}

extension GeoLocationSearchVC {
    func getAllOfflineItems() -> [LocationsCoreModel]?  {
        var product = [LocationsCoreModel]()
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "LocationsCoreModel")
            product = try self.context.fetch(fetchRequest) as! [LocationsCoreModel]
            let sortedStudents = product.sorted { (lhs: LocationsCoreModel, rhs: LocationsCoreModel) -> Bool in
                return lhs.latitude ?? "" < rhs.longitude ?? ""
            }
            return sortedStudents
        } catch  {
            print("can not get data")
        }
        let sortedStudents = product.sorted { (lhs: LocationsCoreModel, rhs: LocationsCoreModel) -> Bool in
            return lhs.latitude ?? "" < rhs.longitude ?? ""
        }
        
        
        return sortedStudents
    }
}
