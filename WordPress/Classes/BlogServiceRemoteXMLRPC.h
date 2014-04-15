#import <Foundation/Foundation.h>
#import "BlogServiceRemote.h"

@interface BlogServiceRemoteXMLRPC : NSObject<BlogServiceRemote>

- (instancetype)initWithApi:(WPXMLRPCClient *)api username:(NSString *)username password:(NSString *)password;

@end
