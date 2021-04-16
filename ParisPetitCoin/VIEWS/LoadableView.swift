//
//  LoadableView.swift
//  ParisPetitCoin
//
//  Created by fred on 16/04/2021.
//

import UIKit

class LoadableView: UIView {

    var viewFromXib: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewFromXib = loadView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewFromXib = loadView()
    }

    func loadView() -> UIView {
        let name = String(describing: type(of: self))

        if let v = Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as? UIView {
            self.addSubview(v)
            v.frame = bounds
            v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return v
        } else {
            return UIView()
        }
    }

}
