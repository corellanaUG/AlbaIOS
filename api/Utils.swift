//
//  Utils.swift
//  api
//
//  Created by Alejandro Alvarado on 6/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

let ISO8601dateTimeFormat = "yyyy-MM-dd HH:mm:ss"
let locale = NSLocale(localeIdentifier: "en_US_POSIX")

func dateFromString(string: String, format: String) -> NSDate?
{
    let formatter = NSDateFormatter()
    formatter.dateFormat = format
    formatter.locale = locale
    return formatter.dateFromString(string)
}

func stringFromDate(date:NSDate, format:String = ISO8601dateTimeFormat) -> String?
{
    let formatter = NSDateFormatter()
    let spanish = NSLocale(localeIdentifier: "es")
    formatter.locale = spanish
    formatter.dateFormat = format
    return formatter.stringFromDate(date)
}