//
//  BackEnd.swift
//  MetroTweet
//
//  Created by bl on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//


import Foundation


protocol BackEndDelegate: class {
    func didGetAccessToken()
    func failedToGetAccessToken(_ errorMsg: String)
    func didGetSubwayTweets(_ tweets: [Tweet])
    func failedToGetSubwayTweets(_ errorMsg: String)
}


class BackEnd {
    // MARK: - Public Properties
    
    weak var delegate: BackEndDelegate?
    static let sharedInstance = BackEnd()
    
    // MARK: - Private Properties
    
    private var accessToken: String? = nil
    private var lastSubwayTweetId: Int64 = 0

    // MARK: - Public Methods
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to request an access token from Twitter.
    //  See https://dev.twitter.com/oauth/application-only for details.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    public func getAccessToken() {
        // If have accessToken already then ...
        if accessToken != nil {
            // Inform delegate that we have a token
            DispatchQueue.main.async {
                self.delegate?.didGetAccessToken()
            }
            return
        }
        
        // Format the credentials
        // For info, see https://dev.twitter.com/oauth/application-only
        let credentials = String(format: "%@:%@", ConsumerKey, ConsumerSecret)
        let encodedCredentials = credentials.data(using: String.Encoding.utf8)!
        let base64Credentials = encodedCredentials.base64EncodedString()
        
        // Create the request
        let url = URL(string: "https://api.twitter.com/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let parameter = "grant_type=client_credentials"
        let data = parameter.data(using: String.Encoding.utf8)!
        request.httpBody = data
        
        // Create a session for managing data transfer tasks
        let session = URLSession.shared
        
        // Execute the request in the background
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            var errorMsg = ""
            
            // If there was a connectivity issues then ...
            if let error = error {
                errorMsg = "Connectivity error: \(error.localizedDescription)."
                
                // If receive a HTTP response then ...
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        if let data = data,
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let tokenType = json["token_type"] as? String {
                                if tokenType == "bearer" {
                                    self.accessToken = json["access_token"] as? String
                                    DispatchQueue.main.async {
                                        self.delegate?.didGetAccessToken()
                                    }
                                    return
                                } else {
                                    errorMsg = "Received unexpected token type: \(tokenType)."
                                }
                            } else {
                                errorMsg = "Missing token_type key in response."
                            }
                        }
                    } catch {
                        errorMsg = "[200] Error deserializing JSON: \(error.localizedDescription)."
                    }
                    
                case 401, 403:
                    do {
                        if let data = data,
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let errorDictinary = json["errors"] as? [[String:Any]] {
                                if let message = errorDictinary[0]["message"] as? String {
                                    errorMsg = String(describing: message)
                                } else {
                                    errorMsg = "[\(httpResponse.statusCode)] Missing message key in response."
                                }
                            } else {
                                errorMsg = "[\(httpResponse.statusCode)] Missing errors key in response."
                            }
                        }
                    } catch {
                        errorMsg = "[\(httpResponse.statusCode)] Error deserializing JSON: \(error.localizedDescription)."
                    }
                    
                default:
                    errorMsg = "Twitter returned status code: \(httpResponse.statusCode)."
                }
                
            } else {
                errorMsg = "Received an unknown response from Twitter"
            }
            
            // Notify the delegate of the error.
            DispatchQueue.main.async {
                self.delegate?.failedToGetAccessToken(errorMsg)
            }
        })
        
        task.resume()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to return the file name for a subway line image.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    public func getImageName(for subwayLine: String) -> String? {
        let subwayLineImageDictionary = [
            "1" : "1.png",
            "2" : "2.png",
            "3" : "3.png",
            "4" : "4.png",
            "5" : "5.png",
            "6" : "6.png",
            "7" : "7.png",
            "A" : "A.png",
            "B" : "B.png",
            "C" : "C.png",
            "D" : "D.png",
            "E" : "E.png",
            "F" : "F.png",
            "G" : "G.png",
            "J" : "J.png",
            "L" : "L.png",
            "M" : "M.png",
            "N" : "N.png",
            "Q" : "Q.png",
            "R" : "R.png",
            "S" : "S.png",
            "W" : "W.png",
            "Z" : "Z.png"
        ]
        
        return subwayLineImageDictionary[subwayLine]
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to return the map URL for a subway line.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    public func getMapURL(for subwayLine: String) -> String? {
        // Dictionary containing urls to line routes
        let subwayLineURLDictionary = [
            "1" : "http://web.mta.info/nyct/service/oneline.htm",
            "2" : "http://web.mta.info/nyct/service/twoline.htm",
            "3" : "http://web.mta.info/nyct/service/threelin.htm",
            "4" : "http://web.mta.info/nyct/service/fourline.htm",
            "5" : "http://web.mta.info/nyct/service/fiveline.htm",
            "6" : "http://web.mta.info/nyct/service/sixline.htm",
            "6Exp" : "http://web.mta.info/nyct/service/6d.htm",
            "7" : "http://web.mta.info/nyct/service/sevenlin.htm",
            "7Exp" : "http://web.mta.info/nyct/service/7d.htm",
            "A" : "http://web.mta.info/nyct/service/aline.htm",
            "B" : "http://web.mta.info/nyct/service/bline.htm",
            "C" : "http://web.mta.info/nyct/service/cline.htm",
            "D" : "http://web.mta.info/nyct/service/dline.htm",
            "E" : "http://web.mta.info/nyct/service/eline.htm",
            "F" : "http://web.mta.info/nyct/service/fline.htm",
            "G" : "http://web.mta.info/nyct/service/gline.htm",
            "J" : "http://web.mta.info/nyct/service/jline.htm",
            "L" : "http://web.mta.info/nyct/service/lline.htm",
            "M" : "http://web.mta.info/nyct/service/mline.htm",
            "N" : "http://web.mta.info/nyct/service/nline.htm",
            "Q" : "http://web.mta.info/nyct/service/qline.htm",
            "R" : "http://web.mta.info/nyct/service/rline.htm",
            "Shuttle" : "http://web.mta.info/nyct/service/sline.htm",
            "W" : "http://web.mta.info/nyct/service/wline.htm",
            "Z" : "http://web.mta.info/nyct/service/zline.htm"
        ]
        
        return subwayLineURLDictionary[subwayLine]
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to request all of MTA's subway tweets.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    public func getSubwayTweets() {
        var urlStr: String
        
        // create the request
        if lastSubwayTweetId == 0 {
            urlStr = "https://api.twitter.com/1.1/search/tweets.json?q=-Replying+from%3A%40NYCTSubway&count=100"
        } else {
            urlStr = "https://api.twitter.com/1.1/search/tweets.json?q=-Replying+from%3A%40NYCTSubway&count=100&since_id=\(lastSubwayTweetId)"
        }
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        // Create a session for managing data transfer tasks
        let session = URLSession.shared
        
        // Execute the request in the background
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            var errorMsg = ""

            // If there was a connectivity issues then ...
            if let error = error {
                errorMsg = "Connectivity error: \(error.localizedDescription)."
                
                // If receive a HTTP response then ...
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        if let data = data,
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let statusArray = json["statuses"] as? [[String:Any]] {
                                self.processSubwayTweets(statusArray)
                                return
                            } else {
                                errorMsg = "Missing statuses key from response."
                            }
                        }
                    } catch {
                        errorMsg = "[200] Error deserializing JSON: \(error.localizedDescription)."
                    }
                    
                case 401, 403:
                    do {
                        if let data = data,
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let errorDictinary = json["errors"] as? [[String:Any]] {
                                if let message = errorDictinary[0]["message"] as? String {
                                    errorMsg = String(describing: message)
                                } else {
                                    errorMsg = "[\(httpResponse.statusCode)] Missing message key in response."
                                }
                            } else {
                                errorMsg = "[\(httpResponse.statusCode)] Missing errors key in response."
                            }
                        }
                    } catch {
                        errorMsg = "[\(httpResponse.statusCode)] Error deserializing JSON: \(error.localizedDescription)."
                    }
                    
                default:
                    errorMsg = "Twitter returned status code: \(httpResponse.statusCode)."
                }

            } else {
                errorMsg = "Received an unknown response from Twitter."
            }
            
            // Notify the delegate of the error.
            DispatchQueue.main.async {
                self.delegate?.failedToGetSubwayTweets(errorMsg)
            }
        })
        
        task.resume()
    }
    
    // MARK: - Private Methods
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  This prevents others from using the default '()' initializer
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private init() {
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to determine if the input is one the NYC subway line.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func isSubwayLine(_ c: Character) -> Bool {
        return getImageName(for: String(c)) != nil
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to parse a subway tweet text.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func parseSubway(tweetText text: String) -> Set<Character> {
        var index = 0
        var subwayLineSet = Set<Character>()
        
        // Break up the text string into an array of words
        let wordArray = text.components(separatedBy: " ")

        // Loop through the words
        while index < wordArray.count {
            // if a key word was found then ...
            if wordArray[index] == "train" || wordArray[index] == "trains" || wordArray[index] == "exp" || wordArray[index] == "express" {
                var backIndex = index - 1
                
                // Work backwards to find the subway line
                while backIndex >= 0 {
                    var c: Character
                    
                    if wordArray[backIndex].characters.count == 2 && wordArray[backIndex].characters.last == "," {
                        c = wordArray[backIndex].characters.first!
                    } else if wordArray[backIndex].characters.count == 1 {
                        c = wordArray[backIndex].characters.first!
                        
                    // If a word was found before the key word then ...
                    } else if subwayLineSet.count == 0 {
                        // terminate backward scan
                        break

                    // If the previous word was a subway line and ...
                    } else if subwayLineSet.count == 1 {
                        // the current word is some sort of conjunction then ...
                        if wordArray[backIndex] == "and" || wordArray[backIndex] == "&amp;" {
                            // continue with the backward scan
                            backIndex -= 1
                            continue
                            
                        // Otherwise, ...
                        } else {
                            // exit, scan has been completed
                            return subwayLineSet
                        }
                    // Otherwise, ...
                    } else {
                        // exit, scan of comma delimited list completed
                        return subwayLineSet
                    }
                    
                    // If subway line was found then ...
                    if isSubwayLine(c) {
                        // add it to the set and ...
                        subwayLineSet.insert(c)
                        // continue with the backward scan
                        backIndex -= 1

                    // Otherwise, ...
                    } else {
                        // terminate backward scan
                        break
                    }
                }
            }
            
            index += 1
        }
        
        return subwayLineSet
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to process all the MTA's subway tweets.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func processSubwayTweets(_ statusArray: [[String:Any]]) {
        var tweets = [Tweet]()
        var tweetId: Int64 = 0

        for tweetDictionary in statusArray {
            // Save the id of the first entry
            if tweetId == 0 {
                tweetId = tweetDictionary["id"]! as! Int64
                lastSubwayTweetId = tweetId
            }

            // Get the text
            let tweetText = tweetDictionary["text"]! as! String
            
            // If is not a response text then ...
            if !tweetText.hasPrefix("@") {
                // Search text for subway lines
                let subwayLines = parseSubway(tweetText: tweetText)
                // If found then ...
                if subwayLines.count > 0 {
                    // Get the tweet date/time
                    let tweetDate = tweetDictionary["created_at"]! as! String
                    
                    // Create an entry for each subway line found
                    for item in subwayLines {
                        let newTweet = Tweet(id: String(item), createdAt: tweetDate, tweetString: tweetText)
                        tweets.append(newTweet)
                    }
                }
            }
        }
        
        // Notify the delegate of all the applicable tweets found
        DispatchQueue.main.async {
            self.delegate?.didGetSubwayTweets(tweets)
        }
    }
}


