#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "KIFUITestActor-WPExtras.h"

@interface WPUITestCase : KIFTestCase

- (void) login;
- (void) loginOther;
- (void) logout;

@end