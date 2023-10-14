import Foundation
class TriviaQuestionService {
    static func fetchQuestion(completion: ((TriviaQuestion) -> Void)? = nil) {
        
        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data else {
                assertionFailure("No data received")
                return
            }
            
            do {
                let question = try JSONDecoder().decode(TriviaQuestion.self, from: data)
                DispatchQueue.main.async {
                    completion?(question)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    
    private static func parse(data: Data) -> TriviaQuestion {
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            let category = json["category"] as! String
            let question = json["question"] as! String
            let correctAnswer = json["correct_answer"] as! String
            let incorrectAnswers = json["incorrect_answers"] as! [String]
            
            return TriviaQuestion(category: category, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
        }catch {
            // Handle JSON parsing errors here
            print("Error parsing JSON: \(error)")
            // You may want to return a default value or handle the error differently in your app
            return TriviaQuestion(category: "", question: "", correctAnswer: "", incorrectAnswers: [])
        }
    }
    
}
