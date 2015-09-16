#import <Availability.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^WordPressComApiRestSuccessResponseBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^WordPressComApiRestSuccessFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef NS_ENUM(NSUInteger, WordPressComApiError) {
    WordPressComApiErrorJSON,
    WordPressComApiErrorNoAccessToken,
    WordPressComApiErrorLoginFailed,
    WordPressComApiErrorInvalidToken,
    WordPressComApiErrorAuthorizationRequired,
};

extern NSString *const WordPressComApiErrorDomain;
extern NSString *const WordPressComApiErrorCodeKey;
extern NSString *const WordPressComApiErrorMessageKey;
extern NSString *const WordPressComApiPushAppId;

@interface WordPressComApi : AFHTTPRequestOperationManager
@property (nonatomic, readonly, strong) NSString *username;
@property (nonatomic, readonly, strong) NSString *password;
@property (nonatomic, readonly, strong) NSString *authToken;

/**
 Returns an API without an associated user
 
 Use this only for things that don't require an account, like signup or logged out reader
 */
+ (WordPressComApi *)anonymousApi;
- (instancetype)initWithOAuthToken:(NSString *)authToken;

/**
 Reset the API instance
 
 @discussion Clears cookies, and sets `authToken`, `username`, and `password` to nil.
 */
- (void)reset;


///-------------------------
/// @name Account management
///-------------------------


- (BOOL)hasCredentials;

// Wipe the OAuth2 token
- (void)invalidateOAuth2Token;


///--------------------
/// @name Notifications
///--------------------

- (void)unregisterForPushNotificationsWithDeviceId:(NSString *)deviceId
                                           success:(void (^)())success
                                           failure:(void (^)(NSError *error))failure;

- (void)syncPushNotificationInfoWithDeviceToken:(NSString *)token
                                        success:(void (^)(NSString *deviceId, NSDictionary *settings))success
                                        failure:(void (^)(NSError *error))failure;

@end
