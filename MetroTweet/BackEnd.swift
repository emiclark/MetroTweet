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
    static let sharedInstance = BackEnd()
    weak var delegate: BackEndDelegate?
    
    private var accessToken: String? = nil
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to request an access token from Twitter.
    //  See https://dev.twitter.com/oauth/application-only for details.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    public func getAccessToken() {
        var errorMsg: String? = nil
        
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
                self.delegate?.failedToGetAccessToken(errorMsg!)
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
        var errorMsg: String? = nil
        
        // create the request
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=-Replying+from%3A%40NYCTSubway&count=100")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        // Create a session for managing data transfer tasks
        let session = URLSession.shared
        
        // Execute the request in the background
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
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
                self.delegate?.failedToGetSubwayTweets(errorMsg!)
            }
        })
        
        task.resume()
    }
    
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
        let subwayLineSet = Set<Character>(["1", "2", "3", "4", "5", "6", "7", "A", "B", "C", "D", "E", "F", "G", "J", "L", "M", "N", "Q", "R", "S", "W", "Z"])
        return subwayLineSet.contains(c)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to parse a substring for subway lines.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func parseForSubwayLines(in substring: String) -> Set<Character> {
        var subwayLineSet = Set<Character>()
        
        // Remove any trailing blank
        var trimmedString = substring.trimmingCharacters(in: .whitespaces)
        
        // Get the last character in the string
        var lastCharacter = trimmedString.characters.last
        
        // Remove the last character in the string
        trimmedString = String(trimmedString.characters.dropLast())
        
        // If the current last character in the string is a blank then ...
        if trimmedString.characters.last == " " {
            // If the last saved character is a subway line then ...
            if isSubwayLine(lastCharacter!) {
                // Add the found subway line to the set
                subwayLineSet.insert(lastCharacter!)
                
                // Remove any trailing blank
                trimmedString = trimmedString.trimmingCharacters(in: .whitespaces)
                
                if trimmedString.characters.count > 4 {
                    // Extract the rear 4 character substring
                    let index = trimmedString.index(trimmedString.endIndex, offsetBy: -4)
                    let rearSubstring = trimmedString.substring(from: index)
                    
                    // If the rear substring is the word " and" then ...
                    if rearSubstring == " and" {
                        // Remove the word " and" from the end
                        var newSubstring = String(trimmedString.characters.dropLast(4))
                        
                        // Remove any trailing blank
                        trimmedString = newSubstring.trimmingCharacters(in: .whitespaces)
                        
                        // Get the last character in the string
                        lastCharacter = trimmedString.characters.last
                        
                        // Remove the last character in the string
                        newSubstring = String(trimmedString.characters.dropLast())
                        
                        // If the current last character in the string is a blank then ...
                        if newSubstring.characters.last == " " {
                            // If the last saved character is a subway line then ...
                            if isSubwayLine(lastCharacter!) {
                                // Add the found subway line to the set
                                subwayLineSet.insert(lastCharacter!)
                            }
                        }
                    }
                }
            }
        }
        
        return subwayLineSet
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to parse a subway tweet text.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func parseSubway(tweetText text: String) -> Set<Character> {
        // Search for tweet for the word " train"
        var searchResult = text.range(of: " train",
                                      options: NSString.CompareOptions.literal,
                                      range: text.startIndex..<text.endIndex,
                                      locale: nil)
        // If " train" was found then ...
        if let range1 = searchResult {
            // Extract front half of the string
            let frontHalf = text.substring(to: range1.lowerBound)
            // Parse front half for subway lines
            var subwayLines = parseForSubwayLines(in: frontHalf)
            // If found then ...
            if subwayLines.count > 0 {
                return subwayLines
                // Otherwise, ...
            } else {
                // Shift the index to after the word train
                let rearIndex = text.index(range1.lowerBound, offsetBy: 6)
                // Extract rear half of the string
                let rearHalf = text.substring(from: rearIndex)
                
                // Search rear half for the word " train"
                searchResult = rearHalf.range(of: " train",
                                              options: NSString.CompareOptions.literal,
                                              range: rearHalf.startIndex..<rearHalf.endIndex,
                                              locale: nil)
                // If " train" was found then ...
                if let range2 = searchResult {
                    // Extract the substring
                    let substring = rearHalf.substring(to: range2.lowerBound)
                    // Parse rear half for train lines
                    subwayLines = parseForSubwayLines(in: substring)
                    // If found then ...
                    if subwayLines.count > 0 {
                        return subwayLines
                    }
                }
            }
        }
        
        return Set<Character>()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Method to process all the MTA's subway tweets.
    //
    //////////////////////////////////////////////////////////////////////////////////////////
    private func processSubwayTweets(_ statusArray: [[String:Any]]) {
        var tweets = [Tweet]()
        
        for tweetDictionary in statusArray {
            let tweetDate: String = tweetDictionary["created_at"]! as! String
            let tweetText: String = tweetDictionary["text"]! as! String
            if !tweetText.hasPrefix("@") {
                let subwayLines = parseSubway(tweetText: tweetText)
                if subwayLines.count > 0 {
                    for item in subwayLines {
                        let newTweet = Tweet(id: String(item), createdAt: tweetDate, tweetString: tweetText)
                        tweets.append(newTweet)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.didGetSubwayTweets(tweets)
        }
    }
    
    
}


