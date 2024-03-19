//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

// TriviaQuestion.swift

import Foundation

// TriviaQuestion.swift

import Foundation

struct TriviaQuestion {
    let category: String
    let type: String // You have this property but are not initializing it
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    init(from result: TriviaResult) {
        category = result.category.decodingHTMLEntities()
        type = result.type // Make sure to initialize this property
        question = result.question.decodingHTMLEntities()
        correctAnswer = result.correct_answer.decodingHTMLEntities()
        incorrectAnswers = result.incorrect_answers.map { $0.decodingHTMLEntities() }
    }
}

extension String {
    func decodingHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return self }
        return attributedString.string
    }
}

