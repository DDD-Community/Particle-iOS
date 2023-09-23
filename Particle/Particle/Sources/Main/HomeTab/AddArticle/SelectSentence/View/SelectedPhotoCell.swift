//
//  SelectedPhotoCell.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/30.
//

import UIKit
import Photos
import VisionKit

protocol SelectedPhotoCellListener: AnyObject {
    func copyButtonTapped(with text: String)
}

final class SelectedPhotoCell: UICollectionViewCell {
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var interaction: ImageAnalysisInteraction = {
        let interaction = ImageAnalysisInteraction()
        interaction.preferredInteractionTypes = .automatic
        interaction.allowLongPressForDataDetectorsInTextMode = true
        return interaction
    }()

    private let imageAnalyzer = ImageAnalyzer()
    
    private var copiedText = ""
    weak var listener: SelectedPhotoCellListener?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
        contentView.clipsToBounds = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(copyButtonTapped),
            name: UIPasteboard.changedNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func showLiveText() {
        guard let image = imageView.image else {
            Console.error("imageView.image == nil 입니다.")
            return
        }
        
        Task {
            let configuration = ImageAnalyzer.Configuration([.text])
            
            do {
                let analysis = try await imageAnalyzer.analyze(image, configuration: configuration)
                
                DispatchQueue.main.async {
                    self.interaction.analysis = nil
                    self.interaction.preferredInteractionTypes = []
                    
                    self.interaction.analysis = analysis
                    self.interaction.preferredInteractionTypes = .textSelection
                }
            } catch {
                Console.error(error.localizedDescription)
            }
        }
    }
    
    
    @objc func copyButtonTapped() {
        if let theString = UIPasteboard.general.string {
            copiedText = theString
            Console.log(copiedText)
            listener?.copyButtonTapped(with: copiedText)
        }
    }
    
    func setImage(with asset: PHAsset) {
        imageView.addInteraction(interaction)
        
        imageView.fetchImage(
            asset: asset,
            contentMode: .default,
            targetSize: imageView.frame.size
        ) { [weak self] aspectRatio in
            self?.imageView.snp.makeConstraints {
                $0.width.equalTo(DeviceSize.width)
                $0.height.equalTo(aspectRatio * DeviceSize.width)
            }
            self?.showLiveText()
        }
    }
}

// MARK: - Layout Settting

private extension SelectedPhotoCell {
    
    func addSubviews() {
        contentView.addSubview(mainScrollView)
        mainScrollView.addSubview(imageView)
    }
    
    func setConstraints() {
        mainScrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(mainScrollView)
        }
    }
}