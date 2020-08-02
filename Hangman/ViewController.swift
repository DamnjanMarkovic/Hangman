//
//  ViewController.swift
//  Consolidation4
//
//  Created by Damnjan Markovic on 29/07/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var requestedWord: String = ""
    var wonGames: Int = 0
    var numberOfPlayedGames = -1 {
        didSet {
            infoLabel.text = "You have played \(numberOfPlayedGames) games and won \(wonGames) times."
        }
    }
    var selectedCategory: String = ""
    
    
    var guessedChar: Character!
    var startLabel: UILabel!
    var infoLabel: UILabel!
    var submitButton: UIButton!
    var remainingNumberOfAttemptsLabel: UILabel!
    var letterPosition = UILabel()
    var letterPositions: [UILabel] = []
    var completedWord: String = ""
    var attemptedLetters: [String] = []
    var viewWidth: Int!
    var remainingNumberOfAttempts = 0 {
        didSet {
            remainingNumberOfAttemptsLabel.text = "Remaining number of attempts: \(remainingNumberOfAttempts)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth = Int(view.frame.width)
        startGame()
        
        
    }
    
    func getRequestedWord() -> String {
        let wordsFruit: [String] = ["grozdje", "sljive", "jabuke", "limun", "kruske", "maline", "pomorandza", "lubenica", "nar", "orah",
                               "grejpfrut"]
        let wordsVegetable: [String] = ["luk", "paradajz", "krastavac", "kupus", "sargarepa", "rotkvice"]
        let wordsCar: [String] = ["pezo", "mercedes", "audi", "opel", "bmw", "lada", "dacija", "kia", "jugo", "zastava"]
        let wordsAlkohol: [String] = ["pivo", "vino", "konjak", "viski", "vinjak", "rakija"]
        let wordsBezalkoholna: [String] = ["sok", "koka-kola", "fanta", "mleko", "voda", "kafa"]
        let options: [String:[String]] = ["AUTO": wordsCar, "POVRCE": wordsVegetable, "VOCE": wordsFruit, "BEZALKOHOLNO PICE": wordsBezalkoholna, "ALKOHOLNO PICE": wordsAlkohol]
        
        let selectedOption = options.randomElement()
        selectedCategory = selectedOption!.key
        let selectedValue = selectedOption?.value

        let  wordInHand = selectedValue!.randomElement()!.uppercased()
        return wordInHand
    }
    
    
    func startGame() {
        requestedWord = getRequestedWord()
        setUpUI()
        completedWord = ""
        numberOfPlayedGames += 1
        submitButton.isHidden = false
        deleteFields()
        remainingNumberOfAttempts = 12
        attemptedLetters.removeAll()


    }
    
    func setUpUI() {
                view = UIView()
                view.backgroundColor = .white
                startLabel = UILabel()
                startLabel.translatesAutoresizingMaskIntoConstraints = false
                startLabel.textAlignment = .center
                startLabel.numberOfLines = 2
                startLabel.text = "\(selectedCategory)"
                startLabel.font = UIFont.systemFont(ofSize: 25)
                view.addSubview(startLabel)
                
                remainingNumberOfAttemptsLabel = UILabel()
                remainingNumberOfAttemptsLabel.translatesAutoresizingMaskIntoConstraints = false
                remainingNumberOfAttemptsLabel.textAlignment = .center
                remainingNumberOfAttemptsLabel.layer.borderWidth = 1
                remainingNumberOfAttemptsLabel.layer.borderColor = UIColor.darkGray.cgColor
                remainingNumberOfAttemptsLabel.layer.cornerRadius = 20
                remainingNumberOfAttemptsLabel.font = UIFont.systemFont(ofSize: 20)
                view.addSubview(remainingNumberOfAttemptsLabel)
                
                let lettersView = UIView()
                lettersView.translatesAutoresizingMaskIntoConstraints = false
                lettersView.backgroundColor = .yellow
                lettersView.layer.borderWidth = 1
                lettersView.layer.borderColor = UIColor.darkGray.cgColor
                
        let width = Int(viewWidth!)/requestedWord.count
                print("Frame width je: \(viewWidth!)")
                print("Width je: \(width)")
                let height = 50
        let numberOfLetters = requestedWord.count
        print("izabrana rec je: \(requestedWord)")
        print("Broj slova u izabranoj reci je: \(numberOfLetters)")
                for position in 0...numberOfLetters {
                    letterPosition = UILabel()
                    letterPosition.layer.borderColor = UIColor.black.cgColor
                    letterPosition.layer.borderWidth = 1
                    letterPosition.text = "_"
                    letterPosition.textAlignment = .center

                    let frame = CGRect(x: position*width, y: 0, width: width, height: height)
                    letterPosition.frame = frame
                    letterPositions.append(letterPosition)
                    lettersView.addSubview(letterPosition)
                }
        
        
        view.addSubview(lettersView)
                

                submitButton = UIButton(type: .system)
                submitButton.layer.borderWidth = 1
                submitButton.backgroundColor = .green
                submitButton.layer.borderColor = UIColor.green.cgColor
                submitButton.layer.cornerRadius = 20
                submitButton.setTitleColor(UIColor.black, for: .normal)
                submitButton.translatesAutoresizingMaskIntoConstraints = false
                submitButton.setTitle("GUESS LETTER", for: .normal)
                submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
                view.addSubview(submitButton)
                
                infoLabel = UILabel()
                infoLabel.translatesAutoresizingMaskIntoConstraints = false
                infoLabel.textAlignment = .center
                infoLabel.font = UIFont.systemFont(ofSize: 17)
                view.addSubview(infoLabel)
                
                
                NSLayoutConstraint.activate([
                    startLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
                    startLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1),
                    startLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    remainingNumberOfAttemptsLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 10),
                    remainingNumberOfAttemptsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    remainingNumberOfAttemptsLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, constant: -10),
                    remainingNumberOfAttemptsLabel.heightAnchor.constraint(equalTo: startLabel.heightAnchor),
                    lettersView.topAnchor.constraint(equalTo: remainingNumberOfAttemptsLabel.bottomAnchor, constant: 180),
//                    lettersView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                    lettersView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
//                    lettersView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -5),
//                    lettersView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, constant: -10),
//                    lettersView.widthAnchor.constraint(equalToConstant: CGFloat(viewWidth/words.count)),
                    lettersView.heightAnchor.constraint(equalToConstant: 50),
                    submitButton.topAnchor.constraint(equalTo: lettersView.bottomAnchor, constant: 100),
                    submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    submitButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
                    submitButton.heightAnchor.constraint(equalTo: startLabel.heightAnchor),
                    
                    infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    infoLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, constant: -10),
                    infoLabel.heightAnchor.constraint(equalTo: startLabel.heightAnchor),
                    infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                    
                ])
    }
    

    func checkLetter(_ answer: String) {
        if answer.count == 0 {
            
            let ac = UIAlertController(title: "Please enter a letter!!!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: guessLetterAlertContinue))
            present(ac, animated: true)
        
        } else if answer.count == 1 {
            
            if attemptedLetters.contains(answer) {
                let ac = UIAlertController(title: "You have already tried that letter!!!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: guessLetterAlertContinue))
                present(ac, animated: true)
            } else {
                remainingNumberOfAttempts -= 1
                for (index, letter) in requestedWord.enumerated() {
                    if answer == String(letter) {
                        remainingNumberOfAttempts += 1
                        letterPositions[index].text = answer
                    }
                }
                completedWord = ""
                for (index, _) in letterPositions.enumerated() {
                        completedWord += "\(letterPositions[index].text!)"
                }
                attemptedLetters.append(answer)
                if (completedWord == requestedWord) {
                        let ac = UIAlertController(title: "You WON!!!", message: nil, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: startNewGame))
                        present(ac, animated: true)
                        wonGames += 1
                        letterPositions = []
                        
                }
                if remainingNumberOfAttempts > 0 {
                        guessLetterAlert()
                } else {
                        let ac = UIAlertController(title: "You lost!!!", message: "Word was    \(requestedWord)", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: startNewGame))
                        present(ac, animated: true)
                        letterPositions = []
                }
            }
        } else {
                let ac = UIAlertController(title: "Only one letter!!!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: guessLetterAlertContinue))
                present(ac, animated: true)
            }
    }
    
    func guessLetterAlert() {

        submitButton.isHidden = true
        let ac = UIAlertController(title: "Enter letter", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text?.uppercased() else { return }
            self?.checkLetter(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)

    }
    
    
    
    @objc func submitTapped(_ sender: UIButton) {
            guessLetterAlert()
    }
    
    

    func guessLetterAlertContinue(action: UIAlertAction) {
        guessLetterAlert()
    }
    
    func startNewGame(action: UIAlertAction) {
        startGame()
    }
    
    

    
    func deleteFields() {
        for (index, _) in letterPositions.enumerated() {
            letterPositions[index].text = ""
        }
    }


}

