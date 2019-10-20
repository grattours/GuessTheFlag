//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Luc Derosne on 18/10/2019.
//  Copyright © 2019 Luc Derosne. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var userScore = 0
    @State private var scoreMessage = ""
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("clic le drapeaux de : ")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(country: self.countries[number])
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                    }
                }
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }.alert(isPresented: $showingScore) { () -> Alert in
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) { self.askQuestion() })
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            scoreMessage = "Bravo, ton score passe à \(userScore)"
        } else {
            scoreTitle = "Faux"
             scoreMessage = "Dommage, c'est le drapeau de \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
