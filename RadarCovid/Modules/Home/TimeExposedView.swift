//

// Copyright (c) 2020 Gobierno de España
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// SPDX-License-Identifier: MPL-2.0
//

import UIKit
import RxSwift
import DP3TSDK
import SafariServices

class TimeExposedView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bullet1Label: UILabel!
    @IBOutlet weak var bullet2Label: UILabel!
    @IBOutlet weak var bullet3Label: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    var parentViewController: UIViewController?
    var viewModel: HomeViewModel?

    class func initWithParentViewController(viewController: HomeViewController) {
        
        guard let timeExposedView = UINib(nibName: "TimeExposed", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as? TimeExposedView else {
            return
        }
        
        timeExposedView.parentViewController = viewController
        timeExposedView.viewModel = viewController.viewModel
        timeExposedView.initValues()
        
        let newFrame = CGRect(x: viewController.view.frame.origin.x,
                              y: viewController.view.frame.origin.y,
                              width: viewController.view.frame.width * 92 / 100,
                              height: viewController.view.frame.height * 85 / 100)
        timeExposedView.frame = newFrame
        timeExposedView.center = viewController.view.center
        viewController.view.addSubview(timeExposedView)
    }

    @IBAction func onCloseAction(_ sender: Any) {
        removePopUpView()
    }
    
    @IBAction func onAcceptButton(_ sender: Any) {
        removePopUpView()
    }
    
    @objc func userDidTapClose(tapGestureRecognizer: UITapGestureRecognizer) {
        removePopUpView()
    }

    @objc func userDidTapPrecauciones(tapGestureRecognizer: UITapGestureRecognizer) {
        onWebTap(tapGestureRecognizer: tapGestureRecognizer,
                 urlString: "ALERT_HIGH_EXPOSURE_HEALED_BULLET_1".localized.getUrlFromHref())
    }

    @objc func userDidTapSintomas(tapGestureRecognizer: UITapGestureRecognizer) {
        onWebTap(tapGestureRecognizer: tapGestureRecognizer,
                 urlString: "ALERT_HIGH_EXPOSURE_HEALED_BULLET_2".localized.getUrlFromHref())
    }

    @objc func userDidTapInformacion(tapGestureRecognizer: UITapGestureRecognizer) {
        onWebTap(tapGestureRecognizer: tapGestureRecognizer,
                 urlString: "ALERT_HIGH_EXPOSURE_HEALED_MORE_INFO".localized.getUrlFromHref())
    }

    @objc func onWebTap(tapGestureRecognizer: UITapGestureRecognizer, urlString: String? = nil) {
        guard var urlString = urlString else {
            return
        }

        if !urlString.contains("://") {
            urlString = "https://\(urlString)"
        }
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()

            let viewController = SFSafariViewController(url: url, configuration: config)
            parentViewController?.present(viewController, animated: true)
        }
    }
    
    private func setupAccessibility() {
        closeButton.isAccessibilityElement = true
        closeButton.accessibilityLabel = "ACC_BUTTON_CLOSE".localized
        closeButton.accessibilityHint = "ACC_HINT".localized

        acceptButton.isAccessibilityElement = true
        acceptButton.accessibilityLabel = "ACC_BUTTON_ACCEPT".localized
        acceptButton.accessibilityHint = "ACC_HINT".localized
        
        bullet1Label.isAccessibilityElement = true
        bullet1Label.accessibilityTraits.insert(UIAccessibilityTraits.link)
        bullet1Label.accessibilityLabel = "ALERT_HIGH_EXPOSURE_HEALED_BULLET_1".localizedAttributed().string
        bullet1Label.accessibilityHint = "ACC_HINT".localized
        
        bullet2Label.isAccessibilityElement = true
        bullet2Label.accessibilityTraits.insert(UIAccessibilityTraits.link)
        bullet2Label.accessibilityLabel = "ALERT_HIGH_EXPOSURE_HEALED_BULLET_2".localizedAttributed().string
        bullet2Label.accessibilityHint = "ACC_HINT".localized
        
        moreInfoLabel.isAccessibilityElement = true
        moreInfoLabel.accessibilityTraits.insert(UIAccessibilityTraits.link)
        moreInfoLabel.accessibilityLabel = "ALERT_HIGH_EXPOSURE_HEALED_MORE_INFO".localizedAttributed().string
        moreInfoLabel.accessibilityHint = "ACC_HINT".localized
    }
    
    private func initValues() {
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        bullet1Label.isUserInteractionEnabled = true
        bullet2Label.isUserInteractionEnabled = true
        moreInfoLabel.isUserInteractionEnabled = true
        
        bullet1Label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                     action: #selector(userDidTapPrecauciones(tapGestureRecognizer:))))
        bullet2Label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                     action: #selector(userDidTapSintomas(tapGestureRecognizer:))))
        moreInfoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                      action: #selector(userDidTapInformacion(tapGestureRecognizer:))))
        setupAccessibility()
    }
    
    private func removePopUpView() {
        for view in parentViewController?.view.subviews ?? [] where view.tag == 1111 {
            view.fadeOut { (_) in
                view.removeFromSuperview()
            }
        }
    }
}
