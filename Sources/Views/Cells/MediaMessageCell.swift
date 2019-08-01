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
import UICircularProgressRing
import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class MediaMessageCell: MessageContentCell {
    
    /// The play button view to display on video messages.
    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        
        return playButtonView
    }()
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15.0
        imageView.clipsToBounds = true
        return imageView
    }()
    open var prograssIndicator:UICircularProgressRing = {
        let progressRing = UICircularProgressRing()
        
        // Change any of the properties you'd like
        progressRing.maxValue = 50
        progressRing.startAngle = -90
        progressRing.outerRingColor = .lightGray
        progressRing.style = .ontop
        progressRing.outerRingWidth = 5
        progressRing.innerRingWidth = 5
        progressRing.shouldShowValueText = false
        return progressRing
    }()
    let gradient = CAGradientLayer()
    // MARK: - Methods
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        
        fillSuperviewWithMargin(3)
        playButtonView.centerInSuperview()
        playButtonView.constraint(equalTo: CGSize(width: 40, height: 40))
        prograssIndicator.centerInSuperview()
        prograssIndicator.constraint(equalTo: CGSize(width: 50, height: 50))
        
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(playButtonView)
        messageContainerView.addSubview(prograssIndicator)
        //Apply
        setupConstraints()
        applyGradiant()
        
        
    }
    func fillSuperviewWithMargin(_ margin: CGFloat) {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = imageView.leftAnchor.constraint(equalTo: messageContainerView.leftAnchor, constant: margin)
        rightConstraint = imageView.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor, constant: -margin)
        let top = imageView.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: margin)
        let bottom = imageView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -margin)
        let constraints: [NSLayoutConstraint] = [leftConstraint!,rightConstraint!,top,bottom]
        
        NSLayoutConstraint.activate(constraints)
    }
    func applyGradiant()  {
        
        
        self.gradient.frame = self.imageView.bounds
        self.gradient.opacity = 0.5
        //Pink color to set with your needs
        self.gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor,
            ].compactMap { $0 }
        
        //You may have to change these values to your needs.
        self.gradient.locations = [ NSNumber(value: 0.6), NSNumber(value: 1.0)]
        
        //From Upper Right to Bottom Left
        self.gradient.startPoint = CGPoint(x: 0.9, y: 0.5)
        self.gradient.endPoint = CGPoint(x: 1, y: 1)
        DispatchQueue.main.async {
            self.imageView.layer.insertSublayer(self.gradient, at: 0)
        }
        
        
    }
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.prograssIndicator.value = 0
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        updateMargin(superX: self.messageContainerView, incomming: ( messagesCollectionView.messagesDataSource?.currentSender().senderId == message.sender.senderId ? false : true ), margin: 3.0)
        //        updateMargin(superX: self.messageContainerView, incomming: self.messageContainerView, incomming: ( messagesCollectionView.messagesDataSource?.currentSender().senderId == message.sender.senderId ? false : true ), margin: 3)
        //        DispatchQueue.main.async {
        //            self.imageView.fillSuperviewX(superX: self.messageContainerView, incomming: messagesCollectionView.messagesDataSource?.currentSender().senderId == message.sender.senderId ? false : true)
        //        }
        
        switch message.kind {
        case .photo(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            playButtonView.isHidden = message.isDownloaded
            playButtonView.isDownload = !message.isDownloaded
            playButtonView.actionButton.setImage(UIImage.messageKitImageWith(type: .download), for: .normal)
            
            
            
            playButtonView.isHidden = message.isDownloaded
        case .video(let mediaItem):
            playButtonView.isHidden = false
            playButtonView.isDownload = !message.isDownloaded
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            playButtonView.actionButton.setImage(message.isDownloaded ? UIImage.messageKitImageWith(type: .playArrow) : UIImage.messageKitImageWith(type: .download), for: .normal)
            
        default:
            break
        }
        displayDelegate.configureMediaMessageImageView(imageView, progressIndicator: prograssIndicator, for: message, at: indexPath, in: messagesCollectionView)
    }
    func updateMargin(superX:MessageContainerView,incomming:Bool,margin:CGFloat) {
        var xxx:CGFloat = 0.0
        switch superX.style{
        case .bubble:
            xxx = -margin
        case .bubbleTail:
            xxx = -(margin+4)
        default:
            xxx = -margin
        }
        leftConstraint?.constant = incomming ? -xxx : margin
        rightConstraint?.constant  = incomming ? -margin : xxx
        DispatchQueue.main.async {
            
            self.gradient.frame = self.imageView.bounds
        }
        
        
    }
}
