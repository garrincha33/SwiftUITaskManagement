//
//  Task.swift
//  SwiftUITaskManagement
//
//  Created by Richard Price on 21/01/2022.
//

//step 1 set our data model attributes
import SwiftUI

// Task Model
struct Task: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
