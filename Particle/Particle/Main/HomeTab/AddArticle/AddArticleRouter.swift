//
//  AddArticleRouter.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol AddArticleInteractable: Interactable,
                                 PhotoPickerListener,
                                 SelectSentenceListener {
    
    var router: AddArticleRouting? { get set }
    var listener: AddArticleListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol AddArticleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class AddArticleRouter: Router<AddArticleInteractable>, AddArticleRouting {
    
    private var navigationControllable: NavigationControllerable?
    
    private let photoPickerBuildable: PhotoPickerBuildable
    private var photoPickerRouting: PhotoPickerRouting?
    
    private let selectSentenceBuildable: SelectSentenceBuildable
    private var selectSentenceRouting: SelectSentenceRouting?
    
    private let editSentenceBuildable: EditSentenceBuildable
    private var editSentenceRouting: EditSentenceRouting?
    
    
    init(
        interactor: AddArticleInteractable,
        viewController: ViewControllable,
        photoPickerBuildable: PhotoPickerBuildable,
        selectSentenceBuildable: SelectSentenceBuildable,
        editSentenceBuildable: EditSentenceBuildable
    ) {
        self.viewController = viewController
        self.selectSentenceBuildable = selectSentenceBuildable
        self.photoPickerBuildable = photoPickerBuildable
        self.editSentenceBuildable = editSentenceBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func attachPhotoPicker() {
        if photoPickerRouting != nil {
            return
        }
        let router = photoPickerBuildable.build(withListener: interactor)
        
//        if let navigation = navigationControllable {
//          navigation.setViewControllers([router.viewControllable])
//          resetChildRouting()
//        } else {
//            presentInsideNavigation(router.viewControllable)
//        }
        
        presentInsideNavigation(router.viewControllable)
        
        attachChild(router)
        photoPickerRouting = router
        
        
        // TODO: - 레퍼런스 참고해서 네비게이션 연계하기.
    }
    
    func detachPhotoPicker() {
        guard let router = photoPickerRouting else {
            return
        }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        photoPickerRouting = nil
        
    }
    
    func attachSelectSentence(with images: [NSItemProvider]) {
        if selectSentenceRouting != nil {
            return
        }
        let router = selectSentenceBuildable.build(
            withListener: interactor,
            images: images
        )
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        selectSentenceRouting = router
        attachChild(router)
    }
    
    
    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    // MARK: - Private
    private let viewController: ViewControllable
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
      let navigation = NavigationControllerable(root: viewControllable)
      navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
      self.navigationControllable = navigation
      viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
      if self.navigationControllable == nil {
        return
      }
      
      viewController.dismiss(completion: nil)
      self.navigationControllable = nil
    }
}

// MARK: - AdaptivePresentationControllerDelegateProxy

import UIKit

public protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  
  public weak var delegate: AdaptivePresentationControllerDelegate?
  
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
