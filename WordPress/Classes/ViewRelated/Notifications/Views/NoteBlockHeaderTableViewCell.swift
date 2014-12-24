import Foundation


@objc public class NoteBlockHeaderTableViewCell : NoteBlockTableViewCell
{
    // MARK: - Public Properties
    public var name: String? {
        didSet {
            nameLabel.text  = name ?? String()
        }
    }
    public var snippet: String? {
        didSet {
            snippetLabel.text = snippet ?? String()
        }
    }
    
    // MARK: - Public Methods
    public func downloadGravatarWithURL(url: NSURL?) {
        if url == gravatarURL {
            return
        }
        
        let placeholderImage = WPStyleGuide.Notifications.gravatarPlaceholderImage
        let success = { (image: UIImage) in
            self.gravatarImageView.displayImageWithFadeInAnimation(image)
        }

        gravatarImageView.downloadImage(url, placeholderImage: placeholderImage, success: success, failure: nil)
        
        gravatarURL = url
    }
    
    // MARK: - View Methods
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryType                   = .DisclosureIndicator
        contentView.autoresizingMask    = .FlexibleHeight | .FlexibleWidth
        
        backgroundColor                 = WPStyleGuide.Notifications.blockBackgroundColor
        nameLabel.font                  = WPStyleGuide.Notifications.blockBoldFont
        nameLabel.textColor             = WPStyleGuide.Notifications.blockTextColor
        snippetLabel.font               = WPStyleGuide.Notifications.blockItalicsFont
        snippetLabel.textColor          = WPStyleGuide.Notifications.blockQuotedColor
        gravatarImageView.image         = WPStyleGuide.Notifications.gravatarPlaceholderImage!

        // iPad: Use a bigger image size!
        if UIDevice.isPad() {
            gravatarImageView.updateConstraint(.Height, constant: gravatarImageSizePad.width)
            gravatarImageView.updateConstraint(.Width,  constant: gravatarImageSizePad.height)
        }
    }
    

    // MARK: - Private
    private let gravatarImageSizePad:               CGSize      = CGSize(width: 36.0, height: 36.0)
    private var gravatarURL:                        NSURL?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var gravatarImageView:   UIImageView!
    @IBOutlet private weak var nameLabel:           UILabel!
    @IBOutlet private weak var snippetLabel:        UILabel!
}
