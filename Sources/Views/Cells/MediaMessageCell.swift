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
    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        imageView.fillSuperviewX()
        playButtonView.centerInSuperview()
        playButtonView.constraint(equalTo: CGSize(width: 35, height: 35))
        prograssIndicator.centerInSuperview()
        prograssIndicator.constraint(equalTo: CGSize(width: 50, height: 50))
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(playButtonView)
        messageContainerView.addSubview(prograssIndicator)
        setupConstraints()
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame = self.imageView.bounds
            gradient.opacity = 0.5
            //Pink color to set with your needs
            gradient.colors = [
                UIColor.clear.cgColor,
                UIColor.black.cgColor,
                ].compactMap { $0 }
            
            //You may have to change these values to your needs.
            gradient.locations = [ NSNumber(value: 0.6), NSNumber(value: 1.0)]
            
            //From Upper Right to Bottom Left
            gradient.startPoint = CGPoint(x: 0.9, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            //Apply
            self.imageView.layer.insertSublayer(gradient, at: 0)
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

        switch message.kind {
        case .photo(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            playButtonView.isHidden = true
        case .video(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            playButtonView.isHidden = false
        default:
            break
        }
displayDelegate.configureMediaMessageImageView(imageView, progressIndicator: prograssIndicator, for: message, at: indexPath, in: messagesCollectionView)
    }
}
