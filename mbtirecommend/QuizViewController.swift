//
//  QuizViewController.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/16/25.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: – IBOutlets (스토리보드와 연결)
    @IBOutlet weak var gradientView:    GradientView!
    @IBOutlet weak var waveContainer:   WaveView!
    @IBOutlet weak var questionLabel:   UILabel!
    @IBOutlet weak var ringView:        ProgressRingView!
    @IBOutlet weak var checkButton:     UIButton!
    @IBOutlet weak var crossButton:     UIButton!
    
    // MARK: – 퀴즈 로직 변수
    private let questions: [String] = [
        // E/I 질문 4개
        "혼자 있는 시간이 필요하다",
        "새로운 사람들과 만나는 것이 즐겁다",
        "낯선 곳에서도 사람에게 먼저 다가가는 편이다",
        "사람들 앞에서 이야기하는 게 편하다",
        // S/N 질문 4개
        "세부적인 절차나 규칙을 잘 지키는 편이다",
        "전체적인 큰 그림을 보는 것이 더 흥미롭다",
        "실제 경험이 중요하다",
        "아이디어나 가능성에 더 끌린다",
        // T/F 질문 4개
        "결정을 할 때 논리적인 근거가 중요하다",
        "결정을 할 때 감정이나 분위기가 중요하다",
        "객관적인 사실에 집중하는 편이다",
        "타인의 감정을 세심히 살피는 편이다",
        // J/P 질문 4개
        "계획을 세워 미리 준비하는 게 좋다",
        "즉흥적으로 처리하는 게 더 편하다",
        "마감 기한을 꼭 지키려고 한다",
        "유연하게 상황에 맞춰 바꾸는 걸 선호한다"
    ]
    private var answers: [Bool] = []
    private var currentIndex: Int = 0
    
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        showQuestion(at: currentIndex)
    }
    
 

    
    
    // MARK: – UI 스타일링
    private func styleUI() {
        // GradientView / WaveView 는 IBDesignable 로 이미 그라데이션/물결 처리
        // 질문 레이블
        questionLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        questionLabel.textColor = .label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        
        // 체크 & 크로스 버튼
        [checkButton, crossButton].forEach {
            $0?.layer.cornerRadius = 32      // 버튼이 64×64 이므로 절반 값
            $0?.layer.masksToBounds = true
        }
        // SF Symbol tint 는 스토리보드에서 지정
    }
    
    
    // MARK: – 질문 표시 & 진행도 업데이트
    private func showQuestion(at index: Int) {
        questionLabel.text = questions[index]
        let progress = CGFloat(index + 1) / CGFloat(questions.count)
        ringView.setProgress(progress, animated: true)
    }
    
    
    // MARK: – 답변 버튼 액션
    @IBAction func answerTapped(_ sender: UIButton) {
        // 어떤 버튼인지 확인 (체크=true, 크로스=false)
        let isYes = (sender == checkButton)
        answers.append(isYes)
        
        // 다음 질문으로
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            showQuestion(at: currentIndex)
        } else {
            // 16개 다 풀었으면 결과 계산 & 화면 전환
            let resultMBTI = calculateMBTI()
            navigateToResult(mbti: resultMBTI)
        }
    }
    
    
    // MARK: – MBTI 계산 로직
    private func calculateMBTI() -> String {
        // 0...3  -> E/I, 4...7  -> S/N, 8...11 -> T/F, 12...15 -> J/P
        func score(in range: Range<Int>) -> Int {
            return answers[range].filter { $0 }.count
        }
        
        let ei = score(in: 0..<4)  >= 2 ? "E" : "I"
        let sn = score(in: 4..<8)  >= 2 ? "S" : "N"
        let tf = score(in: 8..<12) >= 2 ? "T" : "F"
        let jp = score(in: 12..<16) >= 2 ? "J" : "P"
        
        return ei + sn + tf + jp
    }
    
    func resetQuiz() {
        answers = []
        currentIndex = 0
        showQuestion(at: currentIndex)
    }
    
    
    // MARK: – 네비게이션
    private func navigateToResult(mbti: String) {
        // 스토리보드 ID = "ResultVC" 로 설정해야 함
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "ResultVC")
                        as? ResultViewController else {
          return
        }
        vc.receivedMBTI = mbti
        navigationController?.pushViewController(vc, animated: true)
      }
    }
