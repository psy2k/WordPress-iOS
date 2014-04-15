#import <Foundation/Foundation.h>
#import "BlogServiceRemote.h"

@class WordPressComApi;

@interface BlogServiceRemoteREST : NSObject<BlogServiceRemote>

- (instancetype)initWithApi:(WordPressComApi *)api;

@end
