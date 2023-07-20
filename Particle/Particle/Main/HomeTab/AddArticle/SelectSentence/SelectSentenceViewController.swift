//
//  SelectSentenceViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import VisionKit
import Vision

protocol SelectSentencePresentableListener: AnyObject {
    
    func showEditSentenceModal()
    func backButtonTapped()
}

final class SelectSentenceViewController: UIViewController, SelectSentencePresentable, SelectSentenceViewControllable {
    
    enum Metric {
        enum Title {
            static let topMargin = 12
            static let leftMargin = 20
        }
        
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
    }

    weak var listener: SelectSentencePresentableListener?
    private var disposeBag: DisposeBag = .init()
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x1f1f1f)
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "문장 선택 1/7"
        label.font = .systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    private let infoBox: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x161616)
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 단어와 끝 단어를 터치해 주세요."
        label.textColor = .init(hex: 0x696969)
        return label
    }()
    
    private let textImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .title3)
        textView.textColor = .init(UIColor(hex: 0xededed))
        textView.backgroundColor = .black
        textView.tintColor = .init(UIColor(particleColor: .main))
        textView.text = "default Text"
        return textView
    }()
    
    init(selectedImages: [NSItemProvider]) {
        super.init(nibName: nil, bundle: nil)
        selectedImages.forEach { $0.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                guard let image = image as? UIImage else { return }
                self.textImage.image = image
                // TODO: 선택된 사진 속에서 글자를 뽑아 TextView로 나타내주기.
            }
        }}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.recognizeTextImage(self.textImage.image)
        }
    }
    
    private func setupInitialView() {
        view.backgroundColor = .black
        addSubviews()
        setConstraints()
        setupNavigationBar()
        configureTextView()
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.backButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureTextView() {
        textView.delegate = self
    }
    
    private func addCustomMenuItem() {
        let menuItem1 = UIMenuItem(title: "뽑기", action: #selector(textSelected(_:)))
        UIMenuController.shared.menuItems = nil
        UIMenuController.shared.menuItems = [menuItem1]
    }
    
    @objc private func textSelected(_ sender: UIMenuController) {
        if let selectedRange = textView.selectedTextRange {
            let selectedText = textView.text(in: selectedRange)
            Console.debug("드래그된 텍스트 \(selectedText!)")
            // TODO: EditSentenceRIB 띄우기
            listener?.showEditSentenceModal()
        }
    }
    
    func recognizeTextImage(_ image: UIImage?) {
        guard let image = image, let ciImage = CIImage(image: image) else {
            return
        }
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        let request = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard error == nil else {
                Console.error(error?.localizedDescription ?? "VNRecognizeTextRequestError")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            for observation in observations {
                
                guard let topCandidate = observation.topCandidates(1).first else {
                    continue
                }

                let recognizedText = topCandidate.string

                DispatchQueue.main.async {
                    self.textView.text += recognizedText
                }
            }
            
            DispatchQueue.main.async {
                self.textView.text += "\n\n\n"
            }
        })
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        request.usesLanguageCorrection = true
        
        do {
            try imageRequestHandler.perform([request])
        } catch let error {
            Console.error(error.localizedDescription)
        }
    }
    
    // MARK: - SelectSentenceViewControllable
    func present(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
}

// MARK: - UITextViewDelegate
extension SelectSentenceViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let selectedRange = textView.selectedRange
        
        if selectedRange.length > 0 {
            addCustomMenuItem()
        } else {
            UIMenuController.shared.menuItems = nil
        }
    }
}

// MARK: - Layout Settting

private extension SelectSentenceViewController {
    
    func addSubviews() {
        [backButton, navigationTitle].forEach {
            navigationBar.addSubview($0)
        }
        
        [navigationBar, infoBox, textView].forEach {
            view.addSubview($0)
        }
        
        infoBox.addSubview(infoLabel)
    }
    
    func setConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        infoBox.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(53)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(infoBox.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SelectSentenceViewController_Preview: PreviewProvider {
    static var previews: some View {
        SelectSentenceViewController(selectedImages: []).showPreview()
    }
}
#endif
