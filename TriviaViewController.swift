//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    fetchTriviaQuestions()
    // TODO: FETCH TRIVIA QUESTIONS HERE
      
  }
    
    
    func fetchTriviaQuestions() {
        TriviaQuestionService.fetchTriviaQuestions { [weak self] triviaQuestions, error in
            DispatchQueue.main.async {
                if let questions = triviaQuestions {
                    self?.questions = questions
                    // Use currQuestionIndex instead of currentQuestionIndex
                    self?.updateQuestion(withQuestionIndex: self?.currQuestionIndex ?? 0)
                } else if let error = error {
                    print("Error fetching questions: \(error.localizedDescription)")
                    // Handle the error, e.g., by showing an alert
                }
            }
        }
    }

    
    
  
//  private func updateQuestion(withQuestionIndex questionIndex: Int) {
//    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
//    let question = questions[questionIndex]
//    questionLabel.text = question.question
//    categoryLabel.text = question.category
//    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
//    if answers.count > 0 {
//      answerButton0.setTitle(answers[0], for: .normal)
//    }
//    if answers.count > 1 {
//      answerButton1.setTitle(answers[1], for: .normal)
//      answerButton1.isHidden = false
//    }
//    if answers.count > 2 {
//      answerButton2.setTitle(answers[2], for: .normal)
//      answerButton2.isHidden = false
//    }
//    if answers.count > 3 {
//      answerButton3.setTitle(answers[3], for: .normal)
//      answerButton3.isHidden = false
//    }
//  }
    private func restartGame() {
        currQuestionIndex = 0
        numCorrectQuestions = 0
        fetchTriviaQuestions()
        // Reset button visibility here
        resetButtonVisibility()
    }

    // This method resets the visibility of all answer buttons
    private func resetButtonVisibility() {
        answerButton0.isHidden = false
        answerButton1.isHidden = false
        answerButton2.isHidden = false
        answerButton3.isHidden = false
    }

    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        currentQuestionNumberLabel.text = "Question \(questionIndex+1)/\(questions.count)"
        
        // Ensure button visibility is reset before configuring for the new question
        resetButtonVisibility()
        
        let isTrueFalse = question.type == "boolean"
        if isTrueFalse {
            // Hide buttons for true/false questions
            answerButton2.isHidden = true
            answerButton3.isHidden = true
            answerButton0.setTitle("True", for: .normal)
            answerButton1.setTitle("False", for: .normal)
        } else {
            // Show all buttons and assign titles for multiple-choice questions
            let allAnswers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
            answerButton0.setTitle(allAnswers[0], for: .normal)
            answerButton1.setTitle(allAnswers[1], for: .normal)
            answerButton2.setTitle(allAnswers[2], for: .normal)
            answerButton3.setTitle(allAnswers[3], for: .normal)
        }
    }

  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
//  private func showFinalScore() {
//    let alertController = UIAlertController(title: "Game over!",
//                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
//                                            preferredStyle: .alert)
//    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
//      currQuestionIndex = 0
//      numCorrectQuestions = 0
//      updateQuestion(withQuestionIndex: currQuestionIndex)
//    }
//    alertController.addAction(resetAction)
//    present(alertController, animated: true, completion: nil)
//  }
    
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            self.restartGame() // Call the restartGame function to reset the game
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }

  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

