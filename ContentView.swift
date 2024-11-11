//
//  ContentView.swift
//  49ermockup
//
//  Created by Payal Pawar on 10/22/24.
//

import SwiftUI
import CoreData
import Foundation

struct Game: Identifiable {
    var id = UUID()
    var imageName: String
}

struct Injury: Identifiable {
    var id = UUID()
    var player: String
    var injuryStatus: String
}

struct FantasyPoint: Identifiable {
    var id = UUID()
    var player: String
    var points: Int
}

struct Tip: Identifiable {
    var id = UUID()
    var content: String
}

struct MainView: View {
    @State private var gameScore: String = "SF: 23 || Buccaneers: 20"
    @State private var nextGame: String = "Next Game: Seattle Seahwaks at 49ers"
    @State private var previousStates: [ScenePhase] = []
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            VStack {
                // Game Score Display
                HStack(spacing: 10) {
                    VStack {
                        HStack {
                            Text("49ers: 23")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4))
                    }

                    Text("|")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    VStack {
                        HStack {
                                
                            Text("Buccaneers: 20")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4))
                    }
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)

                // Next Game Display
                Text(nextGame)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)

                Spacer(minLength: 30)
                Image("49ersLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()

                Spacer()

                HStack(spacing: 10) {
                    ButtonView(title: "Schedule", destination: ScheduleView())
                    ButtonView(title: "Injury", destination: InjuryReportView())
                    ButtonView(title: "Fantasy", destination: FantasyPointsView())
                    ButtonView(title: "Tips", destination: GameDayTipsView())
                }
                .padding()

                // Previous States Display
                Text("Previous States:")
                    .font(.headline)
                    .padding(.top)

                ForEach(previousStates, id: \.self) { state in
                    Text("\(state.description)")
                        .padding(5)
                }
            }
            
            .frame(maxHeight: .infinity)
            .navigationTitle("49ers App")
            .padding(.bottom)
        }
    }

    private func saveAppData() {
        UserDefaults.standard.set(gameScore, forKey: "LastGameScore")
        UserDefaults.standard.set(nextGame, forKey: "NextGame")
        print("Data saved: \(gameScore), \(nextGame)")
    }
}

extension ScenePhase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .background:
            return "Background"
        @unknown default:
            return "Unknown State"
        }
    }
}

struct ButtonView<Destination: View>: View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.subheadline)
                .padding(8)
                .frame(minWidth: 70)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.7), lineWidth: 1))
                .scaleEffect(1.0)
                .animation(.easeInOut, value: 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct ScheduleView: View {
    @State private var scheduleImageName: String = "49ersschedule"
    private var gameScheduleManager = GameScheduleManager()
    
    var body: some View {
        VStack {
            Text("Game Schedule")
                .font(.largeTitle)
                .padding()
                .onAppear {
                    if let savedImageName = gameScheduleManager.loadGameScheduleImage() {
                        scheduleImageName = savedImageName
                    }
                }
            
            // Schedule Image
            Image(scheduleImageName)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(maxWidth: .infinity)
            
            // Button to save a new image name
            Button("Save New Schedule Image") {
                let newImageName = "49ersschedule"
                gameScheduleManager.saveGameScheduleImage(imageName: newImageName)
                scheduleImageName = newImageName
            }
            .padding()
        }
        .navigationTitle("Schedule")
    }
}

struct InjuryReportView: View {
    let injuries: [Injury] = [
        Injury(player: "Chritian McCaffrey", injuryStatus: "Out"),
        Injury(player: "Deebo Sameul", injuryStatus: "Questionable"),
        Injury(player: "Brandon Aiyuk", injuryStatus: "Injured Reserve")
    ]
    
    var body: some View {
        NavigationView {
            List(injuries) { injury in
                HStack {
                   
                    Image("player_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        Text(injury.player)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Status: \(injury.injuryStatus)")
                            .font(.subheadline)
                            .foregroundColor(injury.injuryStatus == "Out" ? .red : .orange)
                            .bold()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .navigationTitle("Injury Report")
            .listStyle(PlainListStyle())
            .padding(.top)
        }
    }
}

struct FantasyPointsView: View {
    let fantasyPoints: [FantasyPoint] = [
        FantasyPoint(player: "Deebo Samuel", points: 25),
        FantasyPoint(player: "Gorge Kittle", points: 30),
        FantasyPoint(player: "Juan Jennings", points: 15)
        //sample data
    ]
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        NavigationView {
            List(fantasyPoints.indices, id: \.self) { index in
                HStack {
                   
                    Image("player_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        Text(fantasyPoints[index].player)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Points: \(fantasyPoints[index].points)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .bold()
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.1), value: isVisible)
            }
            .navigationTitle("Fantasy Points")
            .listStyle(PlainListStyle())
            .padding(.top)
            .onAppear {
                isVisible = true 
            }
        }
    }
}
struct GameDayTipsView: View {
    let tips: [Tip] = [
        Tip(content: "Arrive early for the best parking."),
        Tip(content: "Map can be found here."),
        
    ]
    
    var body: some View {
        List(tips) { tip in
            Text(tip.content)
        }
        .navigationTitle("Game Day Tips")
    }
}
class GameScheduleManager {
    private let userDefaultsKey = "gameScheduleImage"
    
    func saveGameScheduleImage(imageName: String) {
        UserDefaults.standard.set(imageName, forKey: userDefaultsKey)
    }
    
    func loadGameScheduleImage() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey)
    }
}

