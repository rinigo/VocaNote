//
//  DictionaryTableViewController.swift
//
//
//  Created by 宮本琳太郎 on 2016/08/06.
//
//

import UIKit
import Alamofire
import SWXMLHash
import SegueContext
import Regex

//正規表現可能に
extension String {
    func isMatch(pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regex?.matchesInString(self, options: NSMatchingOptions.Anchored, range: NSRange(location: 0, length: self.characters.count))
        return matches?.count > 0
    }
}

class DictionaryTableViewController: UITableViewController, UITextFieldDelegate,NSXMLParserDelegate {
    @IBOutlet weak var textField: UITextField!
    var elementName = ""
    var words:Array<Word> = []
    //  var params: [String: AnyObject] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.registerNib(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier: "WordCell")
        
        
    }
    func getData() {
        guard let word = textField.text else{
            return
        }
        var params: [String: AnyObject] = [
            "Dic": "EJdict",
            "Word": word,
            "Scope": "HEADWORD",
            "Match":"STARTWITH",
            "Merge":"AND",
            "Prof":"XML",
            "PageSize":"10",
            "PageIndex":"0"
            
        ]
        if word !~ "[a-z]" {
            params["Dic"] = "EdictJE"
        }
        
        let url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?"
        
        Alamofire.request(.GET, url, parameters: params)
            .response { (request, response, data, error) in
                
                guard let data = data else {
                    return
                }
                
                guard let string = String(data: data, encoding: NSUTF8StringEncoding) else {
                    return
                }
                let xml = SWXMLHash.parse(string)
                
                let dictItemArray = xml["SearchDicItemResult"]["TitleList"]["DicItemTitle"]
                // for in がrubyでいうeach
                
                //                ここはmapを使えば数行でかけるので試してみる
                var newwords:[Word] = []
                for item in dictItemArray {
                    if let id = item["ItemID"].element?.text, let name = item["Title"]["span"].element?.text {
                        newwords.append(Word(name: name, id: id))
                    }
                    
                    
                }
                self.words = newwords
                self.tableView.reloadData()
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //            print(words[1].name)
        return self.words.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 86
    }
    
    @IBAction func tapSearchButton(sender: UIBarButtonItem) {
        getData()
        textField.text = ""
        textField.resignFirstResponder()
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WordCell", forIndexPath: indexPath) as! WordCell
        let word = self.words[indexPath.row]
        cell.wordLabel.text = word.name
        //print("words[indexPath.row].name")
        
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    //ここではセルタップ時に渡す文字列をセットし、DefinitionViewControllerに遷移するSegueを呼び出す
    override func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        performSegueWithIdentifier("showDefinitionView",context: words[indexPath.row])
        
    }
    
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
