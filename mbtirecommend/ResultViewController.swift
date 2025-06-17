import UIKit

class ResultViewController: UIViewController {
    // MARK: IBOutlets (스토리보드 연결)
    @IBOutlet weak var gradientView:    GradientView!
    @IBOutlet weak var waveView:        WaveView!
    @IBOutlet weak var mbtiLabel:       UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var placesTableView: UITableView!
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        if let quizVC = navigationController?.viewControllers.first(where: { $0 is QuizViewController }) as? QuizViewController {
            quizVC.resetQuiz()
            navigationController?.popToViewController(quizVC, animated: true)
        }
    }
    
    @IBAction func showMapTapped(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "MapVC") as? MapViewController {
            vc.places = recommendedPlaces  // 전달
            navigationController?.pushViewController(vc, animated: true)
        }
    }



    // MARK: 상태 변수
    var receivedMBTI: String!
    private var allPlaces: [Place] = []
    private var recommendedPlaces: [Place] = []
    private var currentCategory: PlaceCategory = .cafe

    // MARK: 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPlacesFromJSON()
        navigationController?.isToolbarHidden = false
    }

    // MARK: UI 세팅
    private func setupUI() {
        // MBTI 레이블
        mbtiLabel.text = receivedMBTI
        mbtiLabel.font = .systemFont(ofSize: 32, weight: .bold)

        // 설명 레이블
        descriptionLabel.text = mbtiDescription(for: receivedMBTI)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        // 세그먼트 컨트롤 세팅
        categorySegmentedControl.removeAllSegments()
        for (idx, cat) in PlaceCategory.allCases.enumerated() {
            categorySegmentedControl.insertSegment(
                withTitle: cat.title,
                at: idx,
                animated: false
            )
            categorySegmentedControl.setImage(
                UIImage(systemName: cat.iconName),
                forSegmentAt: idx
            )
        }
        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.addTarget(
            self,
            action: #selector(categoryChanged(_:)),
            for: .valueChanged
        )
        categorySegmentedControl.backgroundColor        = .white
        categorySegmentedControl.selectedSegmentTintColor = .systemPurple
        categorySegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .normal
        )
        categorySegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )

        // 테이블뷰 세팅
        placesTableView.delegate           = self
        placesTableView.dataSource         = self
        placesTableView.rowHeight          = UITableView.automaticDimension
        placesTableView.estimatedRowHeight = 120
        placesTableView.separatorStyle     = .none

        // — Nib 등록 코드는 전부 제거 —
    }

    // MARK: JSON 로딩
    private func loadPlacesFromJSON() {
        guard let url = Bundle.main.url(
            forResource: "places_full_detailed",
            withExtension: "json"
        ) else {
            print("⚠️ places_full_detailed.json not found")
            return
        }
        do {
            let data    = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allPlaces    = try decoder.decode([Place].self, from: data)
            filterPlaces()
        } catch {
            print("⚠️ JSON decode error:", error)
        }
    }

    // MARK: 필터링
    @objc private func categoryChanged(_ sender: UISegmentedControl) {
        let idx = sender.selectedSegmentIndex
        guard PlaceCategory.allCases.indices.contains(idx) else { return }
        currentCategory = PlaceCategory.allCases[idx]
        filterPlaces()
    }

    private func filterPlaces() {
        recommendedPlaces = allPlaces.filter {
            $0.category == currentCategory &&
            $0.mbtiTypes.contains(receivedMBTI)
        }
        placesTableView.reloadData()
    }

    // MARK: MBTI 설명
    private func mbtiDescription(for mbti: String) -> String {
        let descriptions: [String:String] = [
            "ISTJ":"책임감이 강하고 현실적인 사고를 지닌 ISTJ는 신뢰할 수 있는 사람으로, 체계적이고 성실하게 일을 완수합니다.",
            "ISFJ":"따뜻하고 배려심이 깊은 ISFJ는 주변 사람들을 세심하게 챙기며, 조용하지만 헌신적인 성격을 가지고 있습니다.",
            "INFJ":"이상주의적이고 통찰력이 뛰어난 INFJ는 깊이 있는 생각과 강한 직관으로 사람들을 이끄는 조용한 지도자입니다.",
            "INTJ":"전략적 사고와 독립적인 성향의 INTJ는 장기적인 목표를 세우고 체계적으로 실행하는 혁신가입니다.",
            "ISTP":"실용적이고 모험을 즐기는 ISTP는 문제 해결 능력이 뛰어나며, 분석적 사고와 손재주가 좋은 유형입니다.",
            "ISFP":"감성적이고 예술적인 성향을 가진 ISFP는 조용하고 유연하며, 감정 표현에 능한 섬세한 성격입니다.",
            "INFP":"깊은 내면과 강한 이상주의를 지닌 INFP는 진정성과 가치 중심의 삶을 추구하는 공감 능력자입니다.",
            "INTP":"논리적이고 지적 호기심이 많은 INTP는 새로운 아이디어에 매력을 느끼며, 분석적이고 독창적인 문제 해결사입니다.",
            "ESTP":"에너지 넘치고 현실적인 ESTP는 즉흥적인 도전을 즐기며, 빠른 판단력과 실행력을 자랑합니다.",
            "ESFP":"활발하고 긍정적인 ESFP는 주변 사람들에게 즐거움을 주는 존재로, 지금 이 순간을 만끽하는 낙천주의자입니다.",
            "ENFP":"열정적이고 창의적인 ENFP는 상상력과 호기심이 풍부하며, 자유롭고 감성적인 리더십을 발휘합니다.",
            "ENTP":"지적인 대화를 즐기고 새로운 아이디어에 빠르게 몰입하는 ENTP는 도전적인 사고방식의 창조적 혁신가입니다.",
            "ESTJ":"체계적이고 현실적인 ESTJ는 명확한 기준과 높은 책임감으로 조직을 이끄는 지도자형 인물입니다.",
            "ESFJ":"친절하고 협력적인 ESFJ는 주변을 조화롭게 만드는 사교적 성격으로, 공동체의 분위기를 이끌어갑니다.",
            "ENFJ":"따뜻한 카리스마와 강한 리더십을 지닌 ENFJ는 타인의 성장을 돕고 조화로운 관계를 중요시하는 유형입니다.",
            "ENTJ":"대담하고 전략적인 ENTJ는 도전을 두려워하지 않으며, 비전을 향해 강력하게 나아가는 목표 지향형 리더입니다."
        ]
        return descriptions[mbti] ?? ""
    }
}

// MARK: — UITableView Delegate & DataSource
extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        recommendedPlaces.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let place = recommendedPlaces[indexPath.row]
        let cell  = tableView.dequeueReusableCell(
            withIdentifier: PlaceCell.reuseID,
            for: indexPath
        ) as! PlaceCell
        cell.configure(with: place)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let place = recommendedPlaces[indexPath.row]
        let name  = place.name.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""

        let lat = place.coordinates.latitude
        let lng = place.coordinates.longitude
        if let url = URL(
            string: "maps://?q=\(name)&ll=\(lat),\(lng)"
        ) {
            UIApplication.shared.open(url)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

