//
//  circulo.swift
//  pokeApp
//
//  Created by Victor Garcia on 11/10/24.
//clase para dibujar los circulos  que son como focos de la pokedex

import UIKit


class circulo: UIView {

    var circleColor: UIColor = .blue
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let circleRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height).insetBy(dx: 10, dy: 10)
        context.setFillColor(circleColor.cgColor)
        context.fillEllipse(in: circleRect)
    }
}
