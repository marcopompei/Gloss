//
//  Decoder.swift
//  Gloss
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

public struct Decoder {
    
    /**
    Returns function to decode JSON to value type
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to value type
    */
    public static func decode<T>(key: String) -> JSON -> T? {
        return {
            json in
            
            if let value = json[key] as? T {
                return value
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to value type
    for objects that conform to the Glossy protocol
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to value type
    */
    public static func decode<T: Glossy>(key: String) -> JSON -> T? {
        return {
            json in
            
            if let value = json[key] as? JSON {
                return T(json: value)
            }
            
            return nil
            
        }
    }
    
    // MARK: - Custom Decoders
    
    /**
    Returns function to decode JSON to array
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to array
    */
    public static func decodeArray<T>(key: String) -> JSON -> [ [String : T] ]? {
        return { return $0[key] as? [ [String : T] ] }
    }
    
    /**
    Returns function to decode JSON to array
    for objects that conform to the Glossy protocol
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to array
    */
    public static func decodeArray<T: Glossy>(key: String) -> JSON -> [T]? {
        return {
            json in
            
            if let jsonArray = json[key] as? [JSON] {
                var models: [T] = []
                
                for subJSON in jsonArray {
                    models.append(T(json: subJSON))
                }
                
                return models
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to date
    
    - parameter key:           JSON key used to set value
    - parameter dateFormatter: Formatter used to format date
    
    - returns: Function decoding JSON to date
    */
    public static func decodeDate(key: String, dateFormatter: NSDateFormatter) -> JSON -> NSDate? {
        return {
            json in
            
            if let dateString = json[key] as? String {
                return dateFormatter.dateFromString(dateString)
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to ISO8601 date
    
    - parameter key:           JSON key used to set value
    - parameter dateFormatter: Formatter with ISO8601 format
    
    - returns: Function decoding JSON to ISO8601 date
    */
    public static func decodeDateISO8601(key: String, dateFormatter: NSDateFormatter) -> JSON -> NSDate? {
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return Decoder.decodeDate(key, dateFormatter: dateFormatter)
    }
    
    /**
    Returns function to decode JSON to enum value
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to enum value
    */
    public static func decodeEnum<T: RawRepresentable>(key: String) -> JSON -> T? {
        return {
            json in
            
            if let rawValue = json[key] as? T.RawValue {
                return T(rawValue: rawValue)
            }
            
            return nil
        }
    }
    
    /**
    Returns function to decode JSON to URL
    
    - parameter key: JSON key used to set value
    
    - returns: Function decoding JSON to URL
    */
    public static func decodeURL(key: String) -> JSON -> NSURL? {
        return {
            json in
            
            if let urlString = json[key] as? String {
                return NSURL(string: urlString)
            }
            
            return nil
        }
    }
}

// MARK: - Convenience functions

/**
Convenience function to decode JSON to value type

- parameter key: Key used to create JSON property

- returns: Function encoding URL as JSON
*/
public  func decode<T>(key: String) -> JSON -> T? { return { return Decoder.decode(key)($0) } }

/**
Convenience function to decode JSON to value type
for objects that conform to the Glossy protocol

- parameter key: Key used to create JSON property

- returns: Function encoding URL as JSON
*/
public  func decode<T: Glossy>(key: String) -> JSON -> T? { return { return Decoder.decode(key)($0) } }
