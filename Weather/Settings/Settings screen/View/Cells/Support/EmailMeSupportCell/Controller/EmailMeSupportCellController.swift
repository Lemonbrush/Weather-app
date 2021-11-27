//
//  EmailMeSupportCellController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 27.11.2021.
//

import MessageUI

class EmailMeSupportCellController: NSObject {
    
    // MARK: - Properties
    
    var viewControllerOwner: UIViewController?

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
            print(error!.localizedDescription)
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
            case .sent: print("The email was sent")
            case .saved: print("The email was saved")
            case .cancelled: print("The email was cancelled")
            case .failed: print("Failed to send email")
            @unknown default: break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}

extension EmailMeSupportCellController: ReloadColorThemeProtocol {
    func reloadColorTheme() {
        cell.reloadColorTheme()
    }
}
