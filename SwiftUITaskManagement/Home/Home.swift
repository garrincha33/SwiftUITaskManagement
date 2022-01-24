//
//  Home.swift
//  SwiftUITaskManagement
//
//  Created by Richard Price on 21/01/2022.
//

import SwiftUI
//step 3 create a home view and update content view
struct Home: View {
    //step 11 create a reference to view model
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    //step 19 use a namespace animation
    @Namespace var animation
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    //step 12 loop through currentweek to
                    //get required day
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(taskViewModel.currentWeek, id: \.self) { day in
                                //step 14 use new function EEE will return dat as MON TUE, use inside a V stack to add multiple lines
                                VStack(spacing: 10) {
                                    Text(taskViewModel.extractDate(date: day, format: "dd"))
                                    Text(taskViewModel.extractDate(date: day, format: "EEE"))
                                    
                                    //step 15 add some circle fill with a frame
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                    //step 18 use function to highlight current day
                                        .opacity(taskViewModel.isToday(date: day) ? 1 : 0)
                                }
                                //step 16 add a capsule shaoe around the formatted dates
                                .foregroundStyle(taskViewModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskViewModel.isToday(date: day) ? .white : .orange)    //step 20 if today is selected use orange otherwise use white also add a different style if not selected day
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        if taskViewModel.isToday(date: day) {
                                            
                                            
                                            Capsule()
                                                .fill(.orange)
                                            //NEW VIDEO step 19 add of check and add matched geometry when week day changes
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    })
                                //step 21 lets update the current day when selected capsule with an anumation
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskViewModel.currentDay = day
                                    }
                                }
                            }
                        }.padding(.horizontal)
                    }
                    //step 22 new tasks view after HStack here
                    TasksView()
                } header: {
                    HeaderView()
                }
            }
        } //step 30 ignore safe area to avoid scrolling off the screen
        .ignoresSafeArea(.container, edges: .top)
    }
    //step 22 NEW VIDEO NEW FEATURE build tasks view, dynamic updates when user taps on another date
    func TasksView()->some View{
        //step 26 create a task view filteredn results
        LazyVStack(spacing: 20){
            if let tasks = taskViewModel.filteredTasks{
                if tasks.isEmpty{
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }
                else{
                    ForEach(tasks){task in
                        TaskCardView(task: task)
                    }
                }
            }
            else{
                // MARK: Progress View
//                ProgressView()
//                    .offset(y: 100)
                
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Tasks
        .onChange(of: taskViewModel.currentDay) { newValue in
            taskViewModel.filterTodayTasks()
        }
    }
    
    //step 25 create a taskcardView
    func TaskCardView(task: Task)-> some View {
        HStack(alignment: .top, spacing: 30) {
            //Text(task.taskTitle)
            //step 27 NEW VIDEO create a card view for each task
            VStack(spacing: 10) {
                Circle()
                //step 37 clear circle of not current task
                    .fill(taskViewModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3))
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
                
            }
            //step 28 create another Vstack which will hold the tasks
            VStack {
                //step 29 inside here will hold the actual task so inside our gray card
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                //step 33 add in the members for the task
                if taskViewModel.isCurrentHour(date: task.taskDate) {
                    HStack(spacing: 0) {
                        HStack(spacing: -10) {
                            ForEach(["test1", "test2", "test3", "test4"],id:\.self) {user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(.orange, lineWidth: 5))
                            }
                        }
                    }.hLeading()
                    
                    
                    
                    //step 34 check button for the task
                    Button {
                        
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                    }.hTrailing()
                }
            }
            //foregroundColor(Color.white)
            //step 36 only set to white if active task
            .foregroundColor(taskViewModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding()
            .hLeading()
            .background(Color.gray
                            .cornerRadius(25)
                            .opacity(taskViewModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
            )
            //step 37
            
        }.hLeading()
    }
    
    //step 4 create your header view
    func HeaderView()-> some View {
        HStack(spacing: 10) {
            //step 5
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
                //step 7 add new extension function
            }.hLeading()
            
            //step 9 create a button for the profile pic
            Button {
                //button actions here
            } label : {
                Image("test1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                
            }
        }
        //step 8 give some padding and background color
        .padding()
        //step 32 add safe area function
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
