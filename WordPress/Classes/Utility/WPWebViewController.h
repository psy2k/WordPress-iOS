#import <UIKit/UIKit.h>

@interface WPWebViewController : UIViewController

// Interface
@property (nonatomic,   weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UINavigationBar *iPadNavBar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *optionsButton;
@property (nonatomic, strong) UIBarButtonItem *spinnerButton;
@property (nonatomic, strong) NSTimer *statusTimer;
@property (nonatomic, assign) BOOL hidesLinkOptions;

// Endpoint!
@property (nonatomic, strong) NSURL *url;

// Authentication
@property (nonatomic, strong) NSURL *wpLoginURL;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *authToken;

// Reader variables
@property (nonatomic, strong) NSString *detailContent;
@property (nonatomic, strong) NSString *detailHTML;
@property (nonatomic, strong) NSString *readerAllItems;
@property (nonatomic, assign) BOOL shouldScrollToBottom;

- (IBAction)showLinkOptions;
- (IBAction)dismiss;
- (IBAction)goForward;
- (IBAction)goBack;
- (IBAction)reload;

@end
