
import UIKit

final class SHLongRoundedTextfield: UITextView, UITextViewDelegate {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont(name: "Poppins-Regular", size: 14)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .systemBackground
        
        self.textColor = .lightGray
        self.text = "Contoh: Jalan Ikan Hiu 33"
        self.isScrollEnabled = false
        self.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if self.textColor == UIColor.lightGray && self.isFirstResponder {
            self.text = nil
            self.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.text.isEmpty || self.text == "" {
                self.textColor = .lightGray
                self.text = "Contoh: Jalan Ikan Hiu 33"
        }
    }
    
}

