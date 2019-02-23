//
//  ViewController.swift
//  BlogReader
//
//  Created by IMCS2 on 2/21/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let mainUrl = URL(string: "https://www.googleapis.com/blogger/v3/blogs/1707408888855399567/posts?key=AIzaSyD_E9S2px3HzBSf1yS5hItGSKQqFKS7izA")
    var blogArr: [(title: String,url: String,content: String)] = []
//    var index = 0
    @IBOutlet weak var tableViewBlog: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("in table view num of cells", titles.count)
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogTitleCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = titles[indexPath.row]
//        print("in tableview of titles of cells", titles[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        index = indexPath.row
        blogUrl = URL(string: urls[indexPath.row])!
//        print(blogUrl)
        performSegue(withIdentifier: "WebView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let task = URLSession.shared.dataTask(with: mainUrl!){ (data, response, error) in
            if error == nil{
                if let unwrappedData = data{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        let items = jsonResult["items"] as! NSArray
                        for item in items{
                            let i = item as! NSDictionary
                            titles.append(i["title"] as! String)
//                            print(i["title"]!)
//                            let j = i["author"] as! NSDictionary
                            urls.append(i["url"] as! String)
//                            print(i["title"] as! String, i["url"] as! String)
                            self.blogArr.append((i["title"] as! String, i["url"] as! String, i["content"] as! String))
                        }
//                        print(items[0])
                        self.tableViewBlog.reloadData()
//                        self.insertCoreData()
//                        if path.status == .satisfied {
////                            self.makeApiCall() // Call API and set data
//                        }else {
//                            print("No Connection")
//                            self.displayWithNoConnection()
//                        }
                    }catch{
                        print("Error in json result")
                    }
                }
            }
        }
        task.resume()
    }
    
//    private func displayWithNoConnection() {
//        DispatchQueue.main.async {
//            self.getCoreData() // This set the array filled with core data
//            print(self.blogArr)
//            self.blogTable.reloadData() // Data reloaded
//        }
//        removeSpinner()
//    }
    
    func insertCoreData(){
//        var theblogList = titles
        for theblogList in blogArr {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "BlogData", in: context)
            let newBlog = NSManagedObject(entity: entity!, insertInto: context)
            newBlog.setValue(theblogList.title, forKey: "title")
//            newBlog.setValue(theblogList.postDate, forKey: "postDate")
            newBlog.setValue(theblogList.content, forKey: "content")
            newBlog.setValue(theblogList.url, forKey: "url")
            do {
                try context.save()
//                print("Data Saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}

