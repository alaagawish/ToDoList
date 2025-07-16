//
//  UIView+extension.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import Foundation
import UIKit

extension UIView {
    
    var parentViewController: UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentViewController
        } else {
            return nil
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue
            clipsToBounds = true }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func loadViewFromNib() {
        let views = Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        guard let view = views?[0] as? UIView else {
            return
        }
        self.addSubview(view)
        view.frame = bounds
    }
    
    func addDashedBorder(color: UIColor = .black, lineWidth: CGFloat = 2, dashPattern: [NSNumber] = [6, 3]) {
        self.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = color.cgColor
        dashedBorder.lineDashPattern = dashPattern
        dashedBorder.frame = self.bounds
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        dashedBorder.lineWidth = lineWidth
        
        self.layer.addSublayer(dashedBorder)
    }
    
    
    func showLoadingIndicator(color: UIColor = .white) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeAllActivityIndicators()
            let sideLength = min(self.frame.width, self.frame.height)
            let loadingIndicatorFrame = CGRect(x: 0.0, y: 0.0, width: sideLength, height: sideLength)
            let activityIndicatorView = UIActivityIndicatorView(frame: loadingIndicatorFrame)
            activityIndicatorView.color = color
            activityIndicatorView.center = self.convert(self.center, from: self.superview)
            self.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            self.isUserInteractionEnabled = false
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeAllActivityIndicators()
            self.isUserInteractionEnabled = true
        }
    }
    
    private func removeAllActivityIndicators() {
        self.subviews.forEach { view in
            if view is UIActivityIndicatorView {
                (view as? UIActivityIndicatorView)?.stopAnimating()
                view.removeFromSuperview()
            }
        }
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = UIScreen.main.bounds
        blurredEffectView.alpha = 0.88
        self.addSubview(blurredEffectView)
    }
    
    func roundCorners(corners: UIRectCorner = [.allCorners], radius: CGFloat = 6) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        gradientLayer.render(in: context)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image)
    }
}
