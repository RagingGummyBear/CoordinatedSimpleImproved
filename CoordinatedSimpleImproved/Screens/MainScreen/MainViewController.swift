//___FILEHEADER___

import UIKit

class MainViewController: UIViewController, Storyboarded {

    // MARK: - Custom references and variables
    weak var coordinator: MainCoordinator? // Don't remove

    // MARK: - IBOutlets references
    @IBOutlet weak var multiLinkUILabel: UILabel!
    
    // MARK: - IBOutlets actions
    @IBAction func displayUsersAction(_ sender: Any) {
        self.coordinator?.transitionUserDisplay()
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.initalUISetup()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {
            self.finalUISetup()
        }
    }

    // MARK: - UI Functions
    func initalUISetup(){
        // Change label's text, etc.
        let text = (multiLinkUILabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        multiLinkUILabel.attributedText = underlineAttriString
    }

    func finalUISetup(){
        // Here do all the resizing and constraint calculations
        // In some cases apply the background gradient here
    }

    // MARK: - Other functions
    // Remember keep the logic and processing in the coordinator
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (multiLinkUILabel.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: multiLinkUILabel, inRange: termsRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: multiLinkUILabel, inRange: privacyRange) {
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
    }
    
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        print(indexOfCharacter)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
