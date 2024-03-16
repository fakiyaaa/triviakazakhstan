import UIKit

class TriviaViewController: UIViewController {

    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!

    private var questionList = [Question]()
    private var selectedQuestionIndex = 0
    private var correctAnswerCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        questionList = setupQuestions()
             configure(with: questionList[selectedQuestionIndex])
        // Do any additional setup after loading the view.
    }

        private func configure(with question: Question) {
            questionNumberLabel.text = "Question: \(selectedQuestionIndex + 1)/3"
            TypeLabel.text = question.type.description
            
            QuestionLabel.text = question.text
            QuestionLabel.numberOfLines = 0
            QuestionLabel.lineBreakMode = .byWordWrapping

            answer1Button.setTitle(question.answers[0].text, for: .normal)
            answer2Button.setTitle(question.answers[1].text, for: .normal)
            answer3Button.setTitle(question.answers[2].text, for: .normal)
            answer4Button.setTitle(question.answers[3].text, for: .normal)

            resetButtonColors()
        }

        private func checkAndUpdateUI(selectedAnswerIndex: Int) {
            guard selectedQuestionIndex < questionList.count else {
                showResult()
                return
            }

            let currentQuestion = questionList[selectedQuestionIndex]
            guard selectedAnswerIndex < currentQuestion.answers.count else {
                print("Invalid selected answer index.")
                return
            }

            let selectedAnswer = currentQuestion.answers[selectedAnswerIndex]

            let answerButtons: [UIButton] = [answer1Button, answer2Button, answer3Button, answer4Button]

            for (index, answerButton) in answerButtons.enumerated() {

                if index == selectedAnswerIndex {
                    correctAnswerCount += selectedAnswer.correct ? 1 : 0
                }
            }

            selectedQuestionIndex += 1
            if selectedQuestionIndex < questionList.count {
                configure(with: questionList[selectedQuestionIndex])
            } else {
                showResult()
            }
        }


        @IBAction func answerSelected(_ sender: UIButton) {
            let selectedAnswerIndex: Int
            switch sender {
            case answer1Button: selectedAnswerIndex = 0
            case answer2Button: selectedAnswerIndex = 1
            case answer3Button: selectedAnswerIndex = 2
            case answer4Button: selectedAnswerIndex = 3
            default: return
            }

            checkAndUpdateUI(selectedAnswerIndex: selectedAnswerIndex)
        }

        private func showResult() {
            let message = "Number of correct answers: \(correctAnswerCount)/3"
            let alertController = UIAlertController(title: "Results", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

        private func resetButtonColors() {
            [answer1Button, answer2Button, answer3Button, answer4Button].forEach { $0?.backgroundColor = UIColor.darkGray }
        }

        private func setupQuestions() -> [Question] {
            let mockData1 = Question(type: .minerva, text: "When was the Kazakh 10:01 at Minerva University?", answers: [
                Answer(text: "15th January", correct: false),
                Answer(text: "16th January", correct: false),
                Answer(text: "21st January", correct: true),
                Answer(text: "22nd February", correct: false)
            ])
            let mockData2 = Question(type: .kazakh, text: "The most handsome Kazakh Guy?", answers: [
                Answer(text: "Madiyar", correct: false),
                Answer(text: "Aldiyar", correct: true),
                Answer(text: "Batyrkhan", correct: false),
                Answer(text: "Islam", correct: false)
            ])
            let mockData3 = Question(type: .vipKazakh, text: "VipKazakh", answers: [
                Answer(text: "Batyrkhan", correct: true),
                Answer(text: "Islam", correct: false),
                Answer(text: "Madiyar", correct: false),
                Answer(text: "Atai", correct: false)
            ])
            return [mockData1, mockData2, mockData3]
        }
    }

    struct Question {
        let type: QuestionType
        let text: String
        let answers: [Answer]
    }

    enum QuestionType {
        case minerva
        case kazakh
        case vipKazakh

        var description: String {
            switch self {
            case .minerva:
                return "Minerva 10:01"
            case .kazakh:
                return "Kazakhs"
            case .vipKazakh:
                return "Vip Kazakh"
            }
        }
    }

    struct Answer {
        let text: String
        let correct: Bool
    }
