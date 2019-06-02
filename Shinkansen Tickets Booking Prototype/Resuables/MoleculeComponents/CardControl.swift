//
//  CardControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class CardControl: UIControl {
    enum _Type {
        case regular
        case large
        
        func layerStyle(by state: State) -> LayerStyle {
            switch self {
            case .regular:
                switch state {
                case .normal:
                    return DesignSystem.layerStyle.card.normal()
                case .highlighted:
                    return DesignSystem.layerStyle.card.highlighted()
                case .disabled:
                    return DesignSystem.layerStyle.card.disabled()
                default:
                    return DesignSystem.layerStyle.card.normal()
                }
            case .large:
                switch state {
                case .normal:
                    return DesignSystem.layerStyle.largeCard.normal()
                case .highlighted:
                    return DesignSystem.layerStyle.largeCard.highlighted()
                case .disabled:
                    return DesignSystem.layerStyle.largeCard.disabled()
                default:
                    return DesignSystem.layerStyle.largeCard.normal()
                }
            }
        }
        
        func layoutMargin() -> NSDirectionalEdgeInsets {
            switch self {
            case .regular:
                return DesignSystem.layoutMargins.card()//Constant().cardLayoutMarginInset
            case .large:
                return DesignSystem.layoutMargins.largeCard()//Constant().largeCardLayoutMarginInset
            }
        }
    }
    
    public var contentView: UIView
    
    override var isEnabled: Bool {
        didSet {
            currentState = isEnabled ? .normal : .disabled
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            currentState = isHighlighted ? .highlighted : .normal
        }
    }
    
    fileprivate var currentState: State {
        didSet {
            updateAppearance()
        }
    }
    
    fileprivate var type: _Type
    
    init(type: _Type) {
        contentView = UIView()
        self.type = type
        currentState = .normal
        super.init(frame: .zero)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        contentView = UIView()
        self.type = .regular
        currentState = .normal
        super.init(frame: .zero)
        
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Manually defining shadowPath helps the system to perform better by not having them redefine the shape of the layer ever single time when the view needs to be rendered
        layer.shadowPath = CGPath(roundedRect: rect,
                                  cornerWidth: layer.cornerRadius,
                                  cornerHeight: layer.cornerRadius,
                                  transform: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = false
        contentView.directionalLayoutMargins = type.layoutMargin()
        addSubview(contentView, withConstaintEquals: .edges)
        contentView.layer.setLayer(type.layerStyle(by: currentState).withShadowStyle(shadowStyle.noShadow()))
        layer.setLayer(type.layerStyle(by: currentState))
    }
    
    private func updateAppearance(animated: Bool = true) {
        let contentViewOpacity = currentState == .highlighted ? DesignSystem.opacity.highlighted : 1
        contentView.layer.setAnimatedLayer(type.layerStyle(by: currentState)
            .withShadowStyle(shadowStyle.noShadow())
            .withOpacity(contentViewOpacity),
                               using: CABasicAnimationStyle.layerAnimationStyle)
        let transform = currentState == .highlighted ? DesignSystem.CATransform.highlighted : DesignSystem.CATransform.normal
        layer.setAnimatedLayer(type.layerStyle(by: currentState)
            .withTransform(transform),
                               using: CABasicAnimationStyle.layerAnimationStyle)
        
    }
}
