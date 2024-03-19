//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Aishwarya Roy on 3/18/24.
//

import Foundation

class TriviaQuestionService {
  
  static func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
    let urlString = "https://opentdb.com/api.php?amount=7"
    
    guard let url = URL(string: urlString) else {
      completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        completion(nil, error ?? NSError(domain: "", code: -1, userInfo: nil))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(TriviaResponse.self, from: data)
        let questions = decodedData.results.map { TriviaQuestion(from: $0) }
        completion(questions, nil)
      } catch {
        completion(nil, error)
      }
    }
    
    task.resume()
  }
}

struct TriviaResponse: Decodable {
    let results: [TriviaResult]
}

struct TriviaResult: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}


