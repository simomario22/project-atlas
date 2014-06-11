//
//  YBNetrunnerDB.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

@objc protocol YBNetrunnerDelegate {
    func fetchedCards()
    @optional func progressed(progress:Float)
    @optional func errorFetchingCards(error: NSError)
}

class YBNetrunnerDB: NSObject {
    
    var baseURL:NSURL = NSURL(string: "http://netrunnerdb.com/api/cards/")
    var cards:Array<YBNetrunnerCard> = []
    var myDelegate:YBNetrunnerDelegate?
    
    func loadCards(){
        
        let request = NSURLRequest(URL: baseURL)
        var progress:NSProgress?
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        let operation = manager.HTTPRequestOperationWithRequest(request,
            success: {
                (operation:AFHTTPRequestOperation!, obj:AnyObject!) in
                self.receivedJSON(obj as? NSArray)
            }, failure: {
                (operation:AFHTTPRequestOperation!, error:NSError!) in
                self.errorReceived(error)
            })
        
        operation.setDownloadProgressBlock(){
            let progress:Float = Float($1)/Float($2)
            self.myDelegate?.progressed?(progress)
        }
        operation.start()
    }
    
    func receivedJSON(jsonCards:NSArray?){
        cards.removeAll(keepCapacity: true)
        for dict:AnyObject in jsonCards!{
            let card = YBNetrunnerCard(dictionary: dict as NSDictionary)
            if card.isReal{
                cards.append(card)
            }
        }
        
        self.myDelegate?.fetchedCards()
    }
    
    func errorReceived(error:NSError){
        self.myDelegate?.errorFetchingCards?(error)
    }
    
    func count() -> Int {
        return cards.count
    }
    
    subscript(index: Int) -> YBNetrunnerCard {
        get {
            return cards[index]
        }
    }

    
}
