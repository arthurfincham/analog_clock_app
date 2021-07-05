//
//  ContentView.swift
//  analog_clock
//
//  Created by Arthur Fincham on 04/07/2021.
//

import SwiftUI

struct ContentView: View {
    @State var isDark = false
    var body: some View {
        
        NavigationView{
            
            Home(isDark: $isDark)
                .navigationBarHidden(true)
                .preferredColorScheme(isDark ? .dark : .light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @Binding var isDark : Bool
    var width = UIScreen.main.bounds.width
    @State var current_Time = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    var body: some View{
        
        VStack{
            
            HStack{
                
                Text("Analog Clock")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.heavy)
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                Button(action: {isDark.toggle()}) {
                    
                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isDark ? .black : .white)
                        .padding()
                        .background(Color.primary)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }
            }
            .padding()
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            ZStack{
    
                Circle()
                    .fill(Color.primary.opacity(0.1))
                
                ForEach(0..<60,id: \.self){i in
                    
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                        .offset(y: (width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                }
                
                // Seconds hand
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 2, height: (width - 180) / 2)
                    .offset(y: (width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(current_Time.sec) * 6))
                
                // Minutes hand
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width - 200) / 2)
                    .offset(y: (width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(current_Time.min) * 6))
                
                // Hours hand
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 240) / 2)
                    .offset(y: (width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(current_Time.hour + (current_Time.min / 60)) * 30))
                
                // Center circle
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
                
            }
            .frame(width: width - 80, height: width - 80)
            
            
            // Getting locale region name
            
            Text(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!) ?? "")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top,35)
            
            Text(getTime())
                .font(.system(size: 45))
                .fontWeight(.heavy)
                .padding(.top,10)
            
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }
        .onAppear(perform: {
            let calender = Calendar.current
            
            let min = calender.component(.minute, from : Date())
            let sec = calender.component(.second, from : Date())
            let hour = calender.component(.hour, from : Date())
       
            withAnimation(Animation.linear(duration: 0.01)) {
                
                self.current_Time = Time(min: min, sec: sec, hour: hour)
            }
            })
        .onReceive(receiver) { (_) in
            
            let calender = Calendar.current
            
            let min = calender.component(.minute, from : Date())
            let sec = calender.component(.second, from : Date())
            let hour = calender.component(.hour, from : Date())
       
            withAnimation(Animation.linear(duration: 0.01)) {
                
                self.current_Time = Time(min: min, sec: sec, hour: hour)
            }
        }
    }
    
    func getTime()->String{
        
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }


// Calculating time

struct Time {
    var min : Int
    var sec : Int
    var hour : Int
}
}
