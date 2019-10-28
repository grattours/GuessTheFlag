//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Luc Derosne on 18/10/2019.
//  Copyright © 2019 Luc Derosne. All rights reserved.
//SwiftUI GuesTheflag avec animations J34

import SwiftUI

struct ContentView: View {
    @State private var userScore = 0
    @State private var scoreMessage = ""
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var rotation = 0.0
    @State private var isCorrect = false
    @State private var opacity = 1.0
    @State private var currentAnswer = 0
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            AngularGradient(gradient: Gradient(colors: [.blue, .black]), center: .bottomTrailing).edgesIgnoringSafeArea(.all)
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
                        self.opacity = 0.25
                        self.flagTapped(number)
                        self.rotation = 0
                        if self.isCorrect {
                            withAnimation {
                                self.rotation = 360
                            }
                        } else {
                            self.rotation = 0
                            
                        }
                    }) {
                        FlagImage(country: self.countries[number])
                    }
                    .opacity((number == self.correctAnswer) ? 1 : self.opacity)
                    .animation(.default)
                    .rotation3DEffect(.degrees((number == self.correctAnswer) ? self.rotation : 0), axis: (x: 0, y: 1, z: 0))
                    .animation(.easeInOut(duration: 1.0), value: self.isCorrect)
                }
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }.alert(isPresented: $showingScore) { () -> Alert in
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continuer")) { self.askQuestion() })
        }
    }
    func flagTapped(_ number: Int) {
        currentAnswer = number
        if number == correctAnswer {
            isCorrect = true
            scoreTitle = "Correct"
            userScore += 1
            scoreMessage = "Bravo, ton score passe à \(userScore)"
        } else {
            isCorrect = false
            scoreTitle = "Faux"
            scoreMessage = "Dommage, c'est le drapeau de \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        rotation = 0
        opacity = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            //.clipShape(Capsule())
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black, lineWidth: 1))
            //.overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
