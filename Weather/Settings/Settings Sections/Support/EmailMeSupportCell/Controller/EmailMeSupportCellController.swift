//
//  EmailMeSupportCellController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 27.11.2021.
//

import MessageUI

class EmailMeSupportCellController: NSObject {
    
    // MARK: - Properties
    
    weak var viewControllerOwner: UIViewController?

    // MARK: - Private properties
    
    let cell: EmailMeSupportCell
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        cell = EmailMeSupportCell(colorThemeComponent: colorThemeComponent)
        super.init()
        cell.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmailMeSupportCellController: MFMailComposeViewControllerDelegate, EmailMeSupportCellDelegate {
    func triggerEmailForm() {
        guard MFMailComposeViewController.canSendMail() else {
                let alert = UIAlertController(title: "Send email",
                                              message: "Mail app unavailable",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewControllerOwner?.present(alert, animated: true, completion: nil)
                return
                
            }
            
            let email = MFMailComposeViewController()
            email.mailComposeDelegate = self
            email.setSubject("New post on my site!")
            email.setToRecipients(["some@body.abc", "another@recipient.xyz", "john@thefamous.doe"])
            email.setPreferredSendingEmailAddress("gabriel@serialcoder.dev")
            email.setMessageBody("This is a sample text!", isHTML: false)
            
            viewControllerOwner?.present(email, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
        guard error == nil else {
            let alertView = AlertViewBuilder()
                .build(title: "Failed to send email", message: error?.localizedDescription ?? ":(", preferredStyle: .alert)
                .build(title: "Ok", style: .default, handler: nil)
                .content
            
            DispatchQueue.main.async {
                controller.present(alertView, animated: true) {
                    controller.dismiss(animated: true, completion: nil)
                }
            }
            return
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension EmailMeSupportCellController: ReloadColorThemeProtocol {
    func reloadColorTheme() {
        cell.reloadColorTheme()
    }
}
