import Foundation
import WordPressShared.WPStyleGuide

@objc public class NoteBlockActionsTableViewCell : NoteBlockTableViewCell
{
    public typealias EventHandler = ((sender: AnyObject) -> Void)

    // MARK: - Public Properties
    public var onReplyClick:        EventHandler?
    public var onLikeClick:         EventHandler?
    public var onUnlikeClick:       EventHandler?
    public var onApproveClick:      EventHandler?
    public var onUnapproveClick:    EventHandler?
    public var onTrashClick:        EventHandler?
    public var onSpamClick:         EventHandler?

    public var isReplyEnabled: Bool = false {
        didSet {
            btnReply.hidden = !isReplyEnabled
        }
    }
    public var isLikeEnabled: Bool = false {
        didSet {
            btnLike.hidden = !isLikeEnabled
        }
    }
    public var isApproveEnabled: Bool = false {
        didSet {
            btnApprove.hidden = !isApproveEnabled
        }
    }
    public var isTrashEnabled: Bool = false {
        didSet {
            btnTrash.hidden = !isTrashEnabled
        }
    }
    public var isSpamEnabled: Bool = false {
        didSet {
            btnSpam.hidden = !isSpamEnabled
        }
    }
    public var isLikeOn: Bool {
        set {
            btnLike.selected = newValue
        }
        get {
            return btnLike.selected
        }
    }
    public var isApproveOn: Bool {
        set {
            btnApprove.selected = newValue
        }
        get {
            return btnApprove.selected
        }
    }

    
    
    // MARK: - View Methods
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle              = .None
        
        let textNormalColor         = WPStyleGuide.Notifications.blockActionDisabledColor
        let textSelectedColor       = WPStyleGuide.Notifications.blockActionEnabledColor
        
        let likeNormalTitle         = NSLocalizedString("Like",     comment: "Like a comment")
        let likeSelectedTitle       = NSLocalizedString("Liked",    comment: "A comment has been liked")

        let approveNormalTitle      = NSLocalizedString("Approve",  comment: "Approve a comment")
        let approveSelectedTitle    = NSLocalizedString("Approved", comment: "Unapprove a comment")

        let replyTitle              = NSLocalizedString("Reply",    comment: "Verb, reply to a comment")
        let spamTitle               = NSLocalizedString("Spam",     comment: "Verb, spam a comment")
        let trashTitle              = NSLocalizedString("Trash",    comment: "Move a comment to the trash")

        btnReply.setTitle(replyTitle, forState: .Normal)
        btnReply.setTitleColor(textNormalColor, forState: .Normal)
        btnReply.accessibilityLabel = replyTitle
        
        btnLike.setTitle(likeNormalTitle,           forState: .Normal)
        btnLike.setTitle(likeSelectedTitle,         forState: .Highlighted)
        btnLike.setTitle(likeSelectedTitle,         forState: .Selected)
        btnLike.setTitleColor(textNormalColor,      forState: .Normal)
        btnLike.setTitleColor(textSelectedColor,    forState: .Highlighted)
        btnLike.setTitleColor(textSelectedColor,    forState: .Selected)
        btnLike.accessibilityLabel = likeNormalTitle
        
        btnApprove.setTitle(approveNormalTitle,     forState: .Normal)
        btnApprove.setTitle(approveSelectedTitle,   forState: .Highlighted)
        btnApprove.setTitle(approveSelectedTitle,   forState: .Selected)
        btnApprove.setTitleColor(textNormalColor,   forState: .Normal)
        btnApprove.setTitleColor(textSelectedColor, forState: .Highlighted)
        btnApprove.setTitleColor(textSelectedColor, forState: .Selected)
        btnApprove.accessibilityLabel = approveNormalTitle
        
        btnSpam.setTitle(spamTitle, forState: .Normal)
        btnSpam.setTitleColor(textNormalColor, forState: .Normal)
        btnSpam.accessibilityLabel = spamTitle
        
        btnTrash.setTitle(trashTitle, forState: .Normal)
        btnTrash.setTitleColor(textNormalColor, forState: .Normal)
        btnTrash.accessibilityLabel = trashTitle
    }
    
    public override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        actionsView.spacing = buttonSpacingForCurrentTraits
    }
    
    
    
    // MARK: - IBActions
    @IBAction public func replyWasPressed(sender: AnyObject) {
        onReplyClick?(sender: sender)
    }
    
    @IBAction public func likeWasPressed(sender: AnyObject) {
        let onClick = isLikeOn ? onUnlikeClick : onLikeClick
        onClick?(sender: sender)
        isLikeOn = !isLikeOn
    }
    
    @IBAction public func approveWasPressed(sender: AnyObject) {
        let onClick = isApproveOn ? onUnapproveClick : onApproveClick
        onClick?(sender: sender)
        isApproveOn = !isApproveOn
    }
    
    @IBAction public func trashWasPressed(sender: AnyObject) {
        onTrashClick?(sender: sender)
    }
    
    @IBAction public func spamWasPressed(sender: AnyObject) {
        onSpamClick?(sender: sender)
    }
    


    // MARK: - Computed Properties
    private var buttonSpacingForCurrentTraits : CGFloat {
        let isHorizontallyCompact = traitCollection.horizontalSizeClass == .Compact && UIDevice.isPad()
        return isHorizontallyCompact ? buttonSpacingCompact : buttonSpacing
    }
    
    // MARK: - Private Constants
    private let buttonSpacing           = CGFloat(20)
    private let buttonSpacingCompact    = CGFloat(10)
    
    // MARK: - IBOutlets
    @IBOutlet private var actionsView   : UIStackView!
    @IBOutlet private var btnReply      : UIButton!
    @IBOutlet private var btnLike       : UIButton!
    @IBOutlet private var btnApprove    : UIButton!
    @IBOutlet private var btnTrash      : UIButton!
    @IBOutlet private var btnSpam       : UIButton!
}
