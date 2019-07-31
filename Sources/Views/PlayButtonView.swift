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

open class PlayButtonView: UIView {

    // MARK: - Properties
    public var isDownload = false
    public let actionButton = UIButton(type: .custom)
    private var cacheFrame: CGRect = .zero
 private var triangleCenterXConstraint: NSLayoutConstraint?
    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubviews()
        setupConstraints()
        setupView()
    }

    // MARK: - Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !cacheFrame.equalTo(frame) else { return }
        cacheFrame = frame
        updateTriangleConstraints()

        applyCornerRadius()

    }

    private func setupSubviews() {
        addSubview(actionButton)

    }
    
    private func setupView() {

        actionButton.contentMode = .center
        
        backgroundColor = .playButtonLightGray
    }

    private func setupConstraints() {
        
         actionButton.translatesAutoresizingMaskIntoConstraints = false
         let centerX = actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
         let centerY = actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
         let width = actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
         let height = actionButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        triangleCenterXConstraint = centerX
         NSLayoutConstraint.activate([centerX, centerY, width, height])
        
        
        
    }


    private func updateTriangleConstraints() {
        triangleCenterXConstraint?.constant = isDownload ? 0 : frame.width/18
    }
    private func applyCornerRadius() {
        layer.cornerRadius = frame.width / 2
    }
    
}
