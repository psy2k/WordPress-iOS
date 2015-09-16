#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BasePost.h"
#import "ReaderPostContentProvider.h"

@class ReaderAbstractTopic;
@class SourcePostAttribution;
@class Comment;

extern NSString * const ReaderPostStoredCommentIDKey;
extern NSString * const ReaderPostStoredCommentTextKey;

@interface ReaderPost : BasePost <ReaderPostContentProvider>

@property (nonatomic, strong) NSString *authorDisplayName;
@property (nonatomic, strong) NSString *authorEmail;
@property (nonatomic, strong) NSString *authorURL;
@property (nonatomic, strong) NSString *blogName;
@property (nonatomic, strong) NSString *blogDescription;
@property (nonatomic, strong) NSString *blogURL;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic) BOOL commentsOpen;
@property (nonatomic, strong) NSString *featuredImage;
@property (nonatomic, strong) NSString *globalID;
@property (nonatomic) BOOL isBlogPrivate;
@property (nonatomic) BOOL isFollowing;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL isReblogged;
@property (nonatomic) BOOL isWPCom;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *siteID;
@property (nonatomic, strong) NSDate *sortDate;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSSet *comments;
@property (nonatomic, readonly, strong) NSURL *featuredImageURL;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) ReaderAbstractTopic *topic;
@property (nonatomic) BOOL isLikesEnabled;
@property (nonatomic) BOOL isSharingEnabled;
@property (nonatomic) BOOL isSiteBlocked;
@property (nonatomic, strong) SourcePostAttribution *sourceAttribution;

@property (nonatomic, strong) NSString *primaryTag;
@property (nonatomic, strong) NSString *primaryTagSlug;
@property (nonatomic, strong) NSString *secondaryTag;
@property (nonatomic, strong) NSString *secondaryTagSlug;
@property (nonatomic) BOOL isExternal;
@property (nonatomic) BOOL isJetpack;
@property (nonatomic) NSNumber *wordCount;
@property (nonatomic) NSNumber *readingTime;

- (BOOL)isPrivate;
- (NSString *)authorString;
- (NSString *)avatar;
- (UIImage *)cachedAvatarWithSize:(CGSize)size;
- (void)fetchAvatarWithSize:(CGSize)size success:(void (^)(UIImage *image))success;
- (BOOL)contentIncludesFeaturedImage;
- (BOOL)isSourceAttributionWPCom;

@end

@interface ReaderPost (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end

