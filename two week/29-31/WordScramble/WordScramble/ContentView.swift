//
//  ContentView.swift
//  WordScramble
//
//  Created by Daria on 28.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var gameScore = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Section {
                        HStack {
                            Text("Your game score")
                            Spacer()
                            Text("\(gameScore)")
                        }
                    }
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar(content: {
                Button("Restart") {
                    newWord = ""
                    gameScore = 0
                    usedWords.removeAll()
                    startGame()
                }
            })
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
    
        guard answer.count > 2  else {
            wordError(title: "Word not possible", message: "A word that is less than \(answer.count) letters cannot be counted")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Word not possible", message: "You cannot enter the root word!")
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
                return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
            gameScore += calculateScore(word: answer)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word:String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word:String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func isShort(word: String) -> Bool {
        let enterWord = newWord
        if word.count < 3 || word == enterWord {
            return true
        } else {
            return false
        }
    }
    
    func calculateScore(word: String) -> Int {
        var score = 0
        score += word.count + 1
        return score
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
