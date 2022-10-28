//
//  GradientView.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/28/22.
//

import UIKit

@IBDesignable class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var secondColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    @IBInspectable var vertical: Bool = true
    @IBInspectable var reverseColor: Bool = false {
        didSet {
            
        }
    }

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        if reverseColor {
            layer.colors = [firstColor.cgColor, secondColor.cgColor]
        }
        else {
            layer.colors = [secondColor.cgColor, firstColor.cgColor]
        }
        layer.startPoint = CGPoint.zero
        return layer
    }()

    //MARK: -

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        applyGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        applyGradient()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    //MARK: -

    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }

    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }

    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}
