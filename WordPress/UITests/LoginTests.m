#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "WordPressTestCredentials.h"
#import "WPUITestCase.h"

@interface LoginTests : WPUITestCase

@end

@implementation LoginTests

- (void)beforeEach
{
    if([tester tryFindingViewWithAccessibilityLabel:@"OK" error:nil]){
        [tester tapViewWithAccessibilityLabel:@"OK"];
    }
    
    if([tester tryFindingViewWithAccessibilityLabel:@"Sign in to WordPress.com" error:nil]){
        [tester tapViewWithAccessibilityLabel:@"Sign in to WordPress.com"];
    }
}

- (void)afterEach
{
    
}

- (void)testUnsuccessfulLogin
{
    [tester clearTextFromAndThenEnterText:@"unknow@unknow.com" intoViewWithAccessibilityLabel:@"Username / Email"];
    [tester clearTextFromAndThenEnterText:@"failpassword" intoViewWithAccessibilityLabel:@"Password"];
    [tester tapViewWithAccessibilityLabel:@"Sign In"];
    
    [tester waitForTimeInterval:3];
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"GenericErrorMessage"];
    
    [tester tapViewWithAccessibilityLabel:@"OK"];
}

- (void)testSimpleLogin
{
    [tester clearTextFromAndThenEnterText:oneStepUser intoViewWithAccessibilityLabel:@"Username / Email"];
    [tester clearTextFromAndThenEnterText:oneStepPassword intoViewWithAccessibilityLabel:@"Password"];
    [tester tapViewWithAccessibilityLabel:@"Sign In"];
    
    [tester waitForTimeInterval:3];
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"Main Navigation"];
    
    [self logout];
}

- (void)testTwoStepLogin
{
    [tester clearTextFromAndThenEnterText:twoStepUser intoViewWithAccessibilityLabel:@"Username / Email"];
    [tester clearTextFromAndThenEnterText:twoStepPassword intoViewWithAccessibilityLabel:@"Password"];
    [tester tapViewWithAccessibilityLabel:@"Sign In"];
    
    [tester waitForTimeInterval:3];
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"Main Navigation"];
    
    [self logout];
}

- (void)testSelfHostedLoginWithJetPack
{
    [tester tapViewWithAccessibilityLabel:@"Add Self-Hosted Site"];
    [tester enterText:selfHostedUser intoViewWithAccessibilityLabel:@"Username / Email"];
    [tester enterText:selfHostedPassword intoViewWithAccessibilityLabel:@"Password"];
    [tester enterText:selfHostedSiteURL intoViewWithAccessibilityLabel:@"Site Address (URL)"];
    [tester tapViewWithAccessibilityLabel:@"Add Site"];
    
    [tester waitForTimeInterval:3];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    
    [tester waitForTimeInterval:3];
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"Main Navigation"];
    
    [tester tapViewWithAccessibilityLabel:@"Edit"];
    
    [tester tapViewWithAccessibilityLabel:[NSString stringWithFormat:@"Delete %@, %@", selfHostedSiteName, selfHostedSiteURL]];
    [tester tapViewWithAccessibilityLabel:@"Remove"];
}

- (void) testCreateAccount {
    NSString * username = [NSString stringWithFormat:@"%@%u", oneStepUser, arc4random()];
    [tester tapViewWithAccessibilityLabel:@"Create Account"];
    [tester enterText:[NSString stringWithFormat:@"%@@gmail.com", username] intoViewWithAccessibilityLabel:@"Email Address"];
    [tester enterText:username intoViewWithAccessibilityLabel:@"Username"];
    [tester enterText:oneStepPassword intoViewWithAccessibilityLabel:@"Password"];
    [tester clearTextFromAndThenEnterText:username intoViewWithAccessibilityLabel:@"Site Address (URL)"];
    [tester tapViewWithAccessibilityLabel:@"Create Account"];
    [tester waitForTimeInterval:10];
    [self logout];
}





@end
