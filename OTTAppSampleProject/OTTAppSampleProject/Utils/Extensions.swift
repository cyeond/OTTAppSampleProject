//
//  Extensions.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/20/23.
//

import UIKit
import RxRelay

extension String {
    var localized: Self {
        return NSLocalizedString(self, comment: "")
    }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

extension UILabel {
    func countNumberOfLines(text: String) -> Int {
        guard let font = self.font, text.count != 0 else { return 0 }
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let numberOfLine = Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
        
        return numberOfLine
    }
    
    var maxNumberOfLines: Int {
        guard let text = self.text else { return 0 }
        
        return countNumberOfLines(text: text)
    }
    
    var maxHeight: CGFloat {
        let alphaHeight: CGFloat = 30.0
        return self.font.lineHeight * CGFloat(maxNumberOfLines) + alphaHeight
    }
        
    func replaceEllipsis(with string: String, eventRelay: PublishRelay<Void>) {
        guard let text = self.text else { return }
        
        lineBreakMode = .byClipping
        sizeToFit()
        
        if maxNumberOfLines <= self.numberOfLines {
            return
        }
        
        var newText = text
        
        while countNumberOfLines(text: newText + string) > self.numberOfLines {
            newText.removeLast()
        }
        
        if newText.count < text.count {
            newText.removeLast("... ".count + string.count)
            newText += "... " + string
        } else {
            newText.removeLast(string.count)
            newText += string
        }

        let attributedString = NSMutableAttributedString(string: newText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: .init(location: newText.count-string.count, length: string.count))
        self.isUserInteractionEnabled = true

        let gestureRecognizer = RangeGestureRecognizer(target: self, action: #selector(didTapAttributedTextInLabel(_ :)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.range = .init(location: newText.count-string.count, length: string.count)
        gestureRecognizer.eventRelay = eventRelay
        
        self.addGestureRecognizer(gestureRecognizer)
        self.attributedText = attributedString
    }
    
    @objc fileprivate func didTapAttributedTextInLabel(_ sender: RangeGestureRecognizer) {
        guard let range = sender.range, let eventRelay = sender.eventRelay else { return }
        if sender.didTapAttributedTextInLabel(self, in: range) {
            eventRelay.accept(())
        }
    }
}
