//
//  ViewController.swift
//  api(D)
//
//  Created by undhad kaushik on 02/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var arr:  Main!
    
    @IBOutlet weak var getTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibRegister()
        ApiCallD()
    }
    
    private func nibRegister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        getTabelView.register(nibFile, forCellReuseIdentifier: "cell")
        getTabelView.separatorStyle = .none
        getTabelView.dataSource = self
        getTabelView.delegate = self
    }
    
    
    private func ApiCallD(){
        AF.request("https://archive.org/metadata/TheAdventuresOfTomSawyer_201303", method: .get).responseData{ [self] response in
            debugPrint(response)
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(Main.self, from: apiData)
                    print(result)
                    arr = result
                    getTabelView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("Wrong")
            }
        }
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.files.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
       
        cell.label1.text = "\(arr.files[indexPath.row].name)"
        cell.label2.text = "\(arr.files[indexPath.row].source)"
        cell.layer.cornerCurve = .circular
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    
}





struct Main: Decodable{
    var created: Int
    var d1: String
    var d2: String
    var dir: String
    var files: [File]
}

struct File: Decodable{
    var name: String
    var source: String
    var format: String
    var original: String?
    var mtime: String?
    var size: String?
    var md5: String
    var crc32: String?
    var sha1: String?
  
}

struct Second: Decodable{
    var name: String
    var source: String
    var format: String
    var md5: String
    var summation: String
   
}
