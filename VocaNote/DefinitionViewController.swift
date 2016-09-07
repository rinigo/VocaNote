//
//  DefinitionViewController.swift
//  VocaNote
//
//  Created by 宮本琳太郎 on 2016/08/30.
//  Copyright © 2016年 rintaro. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import SegueContext
import Regex

class DefinitionViewController: UIViewController {
    @IBOutlet weak var meaningTextView: UITextView!
    
    
    var words:Array<Word> = []
    var meaning:String = ""
    var params: [String: AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value: Word = self.contextValue() {
            self.words.append(value)
        }
        getData()
        
        self.navigationItem.title = words[0].name
        //textviewを上寄せ
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func getData() {
        if self.words[0].name !~ "[a-z]" {
            let params: [String: AnyObject] = [
                "Dic": "EdictJE",
                "Item": words[0].id,
                "Loc": "",
                "Prof":"XML",
                ]
            self.params = params
            print(words[0].id)
            
        }else{
            let params: [String: AnyObject] = [
                "Dic": "EJdict",
                "Item": words[0].id,
                "Loc": "",
                "Prof":"XML",
                ]
            self.params = params
        }
        
        let url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?"
        
        Alamofire.request(.GET, url, parameters: params)
            .response { (request, response, data, error) in
                guard let data = data else {
                    return
                }
                
                guard let string = String(data: data, encoding: NSUTF8StringEncoding) else {
                    return
                }
                let xml = SWXMLHash.parse(string)
                
                if self.words[0].name !~ "[a-z]" {
                    let dictItemArray = xml["GetDicItemResult"]["Body"]["div"]["div"].children
                    //print(dictItemArray.element?.text)
                    for item in dictItemArray {
                        print(item.element?.text)
                    }
                    let text = dictItemArray.filter { $0.element != nil }.map { $0.element!.text! }.joinWithSeparator("\n")
                    self.meaningTextView.text = text
                }
                else{
                    let dictItemArray = xml["GetDicItemResult"]["Body"]["div"]["div"]
                    //print(dictItemArray.element?.text)
                    if let meaning = dictItemArray.element?.text{
                        // self.meaning = meaning
                        //viewDidloadにself.meaningTextView.text = meaningじゃだめ？？
                        self.meaningTextView.text = meaning
                    }
                
                }
                
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
