//
//  TaskViewModel.swift
//  SwiftUITaskManagement
//
//  Created by Richard Price on 21/01/2022.
//

import SwiftUI

class TaskViewModel: ObservableObject{
    
    // Sample Tasks //step 2 add sample data
    //use this website to get current date https://www.epochconverter.com/ 
    @Published var storedTasks: [Task] = [
        
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1643032930)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1643025553)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1643025553)),
        Task(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate: .init(timeIntervalSince1970: 1643025553)),
        Task(taskTitle: "Team party", taskDescription: "Make fun with team mates", taskDate: .init(timeIntervalSince1970: 1643198353)),
        Task(taskTitle: "Client Meeting", taskDescription: "Explain project to clinet", taskDate: .init(timeIntervalSince1970: 1643025553)),
        
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1643025553)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate: .init(timeIntervalSince1970: 1643025553)),
    ]
    
    //NEW VIDEO step 10 create published arrays to track week day and filtered tasks
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    init() {
        fetchCurrentDaysOfWeek()
    }
    
    //step 23 function for filtering today tasks
    //we re going to use some queues as updating the UI should be done
    //main thread
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay) //step 26 filter tasks based on the user selected date
                    
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }
            //step 24 lets udpate the UI with the filtered results for the user
            //jump back onto the main thread
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
    
    func fetchCurrentDaysOfWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let dayOfWeek = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(dayOfWeek)
            }
        }
        
    }
    
    //step 13, create a function to grab the data as string with the user defined Date Format
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //step 17 lets add a check when the app opens to highlight which day of the
    //the week we are currently using
    func isToday(date: Date)-> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    //step 35 NEW VIDEO code to check if the given task date and time is same
    //as current date and time (if so this will be highlighted)
    func isCurrentHour(date: Date)->Bool{
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
    
    
}

