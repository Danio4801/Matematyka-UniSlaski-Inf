//
 //  ContentView.swift
 //  NWW i NWD
 //
 //  Created by Daniel Nowak on 17/04/2024.
 //
 import SwiftUI

 struct ContentView: View {
     @State private var inputNumbers = ""
     @State private var gcdResult = ""
     @State private var lcmResult = ""
     @State private var showingAlert = false
     @State private var alertMessage = ""

     var body: some View {
         NavigationView {
             Form {
                 Section(header: Text("Wprowadź liczby (rozdzielone przecinkami)")) {
                     TextField("np. 2, 4, 16", text: $inputNumbers)
                         .keyboardType(.numbersAndPunctuation)
                 }
                 Section {
                     Button("Oblicz") {
                         calculateResults()
                     }
                     Button("Wyczyść") {
                         clearFields()
                     }
                 }
                 Section(header: Text("Największy wspólny dzielnik")) {
                     Text(gcdResult)
                 }
                 Section(header: Text("Najmniejsza wspólna wielokrotność")) {
                     Text(lcmResult)
                 }
             }
             .navigationBarTitle("NWD i NWW")
             .alert(isPresented: $showingAlert) {
                 Alert(title: Text("Błąd"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
             }
         }
     }
     
     func calculateResults() {
         let numbers = inputNumbers.components(separatedBy: ", ")
                                     .compactMap { Int($0) }
         if inputNumbers.isEmpty || !inputNumbers.isValidInput() {
             alertMessage = "Proszę wprowadzić tylko liczby całkowite rozdzielone przecinkami."
             showingAlert = true
             return
         }

         if numbers.isEmpty {
             alertMessage = "Proszę wprowadzić prawidłowe liczby całkowite."
             showingAlert = true
             return
         }

         if numbers.contains(where: { $0 < 0 }) {
             alertMessage = "Liczby nie mogą być ujemne (automatyczna konwersja na przeciwny znak)"
             showingAlert = true
             inputNumbers = numbers.map { String(abs($0)) }.joined(separator: ", ")
         }

         if let gcd = numbers.gcd(), let lcm = numbers.lcm() {
             gcdResult = "\(gcd)"
             lcmResult = "\(lcm)"
         }
     }

     func clearFields() {
         inputNumbers = ""
         gcdResult = ""
         lcmResult = ""
     }
 }

 extension String {
     func isValidInput() -> Bool {
         let regex = "^[0-9,\\s]+$"
         return self.range(of: regex, options: .regularExpression) != nil
     }
 }

 extension Array where Element == Int {
     func gcd() -> Int? {
         guard !isEmpty else { return nil }
         return reduce(abs(self[0])) { calculateGCD($0, $1) }
     }

     func lcm() -> Int? {
         guard !isEmpty else { return nil }
         return reduce(1) { calculateLCM($0, $1) }
     }
 }

 func calculateGCD(_ a: Int, _ b: Int) -> Int {
     var a = a
     var b = b
     while b != 0 {
         let t = b
         b = a % b
         a = t
     }
     return a
 }

 func calculateLCM(_ a: Int, _ b: Int) -> Int {
     if a == 0 || b == 0 {
         return 0
     } else {
         return abs(a * b) / calculateGCD(a, b)
     }
 }
