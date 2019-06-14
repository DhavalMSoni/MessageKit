/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MapKit
import MessageKit
import InputBarAccessoryView

final class AdvancedExampleViewController: ChatViewController {
        
    let outgoingAvatarOverlap: CGFloat = 17.5
    
    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        messagesCollectionView.register(CustomCell.self)
        super.viewDidLoad()
        
        updateTitleView(title: "MessageKit", subtitle: "2 Online")
        let customMenuItem = UIMenuItem(title: "Quote", action: #selector(MessageCollectionViewCell.quote(_:)))
        UIMenuController.shared.menuItems = [customMenuItem]
    }
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if action == NSSelectorFromString("delete:") {
            return true
        } else if action == NSSelectorFromString("quote:") {
            return true
        }else {
            return super.collectionView(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        if action == NSSelectorFromString("delete:") {
            self.allowDelete = true
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
//
//                self.messagesCollectionView.performBatchUpdates({
//                    self.messagesCollectionView.reloadSections(IndexSet(integersIn:
//                        0...self.messageList.count - 1))
//                }, completion: { [weak self] _ in
//                    self!.messagesCollectionView.layoutSubviews()
//                    self!.messagesCollectionView.layoutIfNeeded()
            
//                })
//
            
            // 1.) Remove from datasource
            // insert your code here
            
            // 2.) Delete sections
//            collectionView.deleteSections([indexPath.section])
        } else {
            super.collectionView(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
        }
    }
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        attributes.avatarSize.width + attributes.messageContainerPadding.left + avatarPadding
//        if allowDelete == true {
//            
//            (cell as? MessageContentCell)?.messageContainerView.frame.origin.x += ((cell as? MessageContentCell)?.messageContainerView.frame.origin.x)! + 45
//        }
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "55", style: .plain, target: self, action: nil),UIBarButtonItem(title: "56", style: .plain, target: self, action: #selector(rightButtonAction))]
        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
            .onTypingStatus { [weak self] in
                self?.setTypingIndicatorViewHidden(false)
            }.onNewMessage { [weak self] message in
                self?.setTypingIndicatorViewHidden(true, performUpdates: {
                    self?.insertMessage(message)
                })
        }
    }
    @objc func rightButtonAction(){
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let texxt = UIBarButtonItem(title: "1 message selected", style: .plain, target: nil, action: nil)
        setToolbarItems([add,spacer,texxt,spacer], animated: true)
//        toolbarItems = [add,spacer]
//        UIView.animate(withDuration: 3) {
        
        messageInputBar.isHidden = true
            self.navigationController?.setToolbarHidden(false, animated: true)
//        }
    }
    override func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let count = UserDefaults.standard.mockMessagesCount()
            SampleData.shared.getAdvancedMessages(count: count) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
    }
    
    override func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getAdvancedMessages(count: 20) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 20)))
layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 20)))
        // Set outgoing avatar to overlap with the message bubble
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageCenter)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))

        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    override func configureMessageInputBar() {
        super.configureMessageInputBar()
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }

    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 150, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
        messageInputBar.sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
      messageInputBar.sendButton.image = #imageLiteral(resourceName: "ic_up")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 15
        messageInputBar.middleContentViewPadding.right = -115
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.rightStackView.distribution = .equalCentering
        messageInputBar.rightStackView.spacing = 5
        // This just adds some more flare
        
        
        let items = [
            makeButton(named: "ic_library")
                .configure {
                    $0.setSize(CGSize(width: 30, height: 30), animated: false)
                }
                .onSelected {
                    $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
                    let imagePicker = UIImagePickerController()
                    //  imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
            },
            makeButton(named: "ic_mic").onSelected {
                $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
                }.configure {
                    $0.setSize(CGSize(width: 30, height: 30), animated: false)
            },
            makeButton(named: "ic_camera").configure {
                    $0.setSize(CGSize(width: 30, height: 30), animated: false)
                }.onSelected {
                    $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
            },
            .fixedSpace(5),
            messageInputBar.sendButton
                .onEnabled { item in
                    UIView.animate(withDuration: 0.3, animations: {
                        item.imageView?.backgroundColor = .primaryColor
                    })
                }.onDisabled { item in
                    UIView.animate(withDuration: 0.3, animations: {
                        item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
                    })
            }
        ]
//        items.forEach { $0.tintColor = .lightGray }
      
        messageInputBar.setStackViewItems(items, forStack: .right, animated: false)
        
    }
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section + 1].user
    }
    
    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
//        updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
//        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
//            if success, self?.isLastSectionVisible() == true {
//                self?.messagesCollectionView.scrollToBottom(animated: true)
//            }
//        }
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .none
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 40, height: 40), animated: false)
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onSelected {
                $0.tintColor = .primaryColor
            }.onDeselected {
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onTouchUpInside {
                print("Item Tapped")
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                actionSheet.addAction(action)
                if let popoverPresentationController = actionSheet.popoverPresentationController {
                    popoverPresentationController.sourceView = $0
                    popoverPresentationController.sourceRect = $0.frame
                }
                self.navigationController?.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }

        // Very important to check this when overriding `cellForItemAt`
        // Super method will handle returning the typing indicator cell
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }

    // MARK: - MessagesDataSource

    override func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    override func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }

    override func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        if isFromCurrentSender(message: message) {
            let tick =  NSMutableAttributedString(string: "2:50 am", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.white])
            tick.append(NSAttributedString(string: "✓✓", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1),  .kern: -6, NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            return tick
        }else{
            return NSMutableAttributedString(string: "2:50 am", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        return nil
    }

}

// MARK: - MessagesDisplayDelegate

extension AdvancedExampleViewController: MessagesDisplayDelegate {

    // MARK: - Text Messages

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention:
            if isFromCurrentSender(message: message) {
                return [.foregroundColor: UIColor.white]
            } else {
                return [.foregroundColor: UIColor.primaryColor]
            }
        default: return MessageLabel.defaultAttributes
        }
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }

    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.primaryColor.cgColor
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear

        guard allowDelete else { return }

        let button = UIButton(type: .infoLight)
        button.tintColor = .primaryColor
        accessoryView.addSubview(button)
        button.frame = .zero
        UIView.animate(withDuration: 3) {
            
            button.frame = accessoryView.bounds
        }
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.3)
        
    }
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }

    // MARK: - Audio Messages

    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return self.isFromCurrentSender(message: message) ? .white : .primaryColor
    }

    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
    
}

// MARK: - MessagesLayoutDelegate

extension AdvancedExampleViewController: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 25
    }

}
extension MessageCollectionViewCell {
    
    override open func delete(_ sender: Any?) {
        
        // Get the collectionView
        if let collectionView = self.superview as? UICollectionView {
            // Get indexPath
            if let indexPath = collectionView.indexPath(for: self) {
                // Trigger action
                collectionView.delegate?.collectionView?(collectionView, performAction: NSSelectorFromString("delete:"), forItemAt: indexPath, withSender: sender)
            }
        }
    }
}
extension MessageCollectionViewCell {
    @objc func quote(_ sender: Any?) {
        
        // Get the collectionView
        if let collectionView = self.superview as? UICollectionView {
            // Get indexPath
            if let indexPath = collectionView.indexPath(for: self) {
                // Trigger action
                collectionView.delegate?.collectionView?(collectionView, performAction: #selector(MessageCollectionViewCell.quote(_:)), forItemAt: indexPath, withSender: sender)
            }
        }
    }
}
