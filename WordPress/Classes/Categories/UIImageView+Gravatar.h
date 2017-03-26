#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface UIImageView (Gravatar)

#pragma mark - Site Icon Helpers

- (void)setImageWithSiteIcon:(NSString *)siteIcon;
- (void)setImageWithSiteIcon:(NSString *)siteIcon placeholderImage:(UIImage *)placeholderImage;

#pragma mark - Blavatar Helpers

- (NSURL *)blavatarURLForHost:(NSString *)host;
- (NSURL *)blavatarURLForHost:(NSString *)host withSize:(NSInteger)size;

@end
