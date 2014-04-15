#import "BlogServiceRemoteREST.h"

@implementation BlogServiceRemoteREST {
    WordPressComApi *_api;
}

- (instancetype)initWithApi:(WordPressComApi *)api {
    self = [super init];
    if (self) {
        _api = api;
    }
    return self;
}

- (void)syncPostsAndMetadataForBlog:(Blog *)blog
                  categoriesSuccess:(CategoriesHandler)categoriesSuccess
                     optionsSuccess:(OptionsHandler)optionsSuccess
                 postFormatsSuccess:(PostFormatsHandler)postFormatsSuccess
                       postsSuccess:(PostsHandler)postsSuccess
                     overallSuccess:(void (^)(void))overallSuccess
                            failure:(void (^)(NSError *))failure
{
}

- (void)syncPostsForBlog:(Blog *)blog batchSize:(NSUInteger)batchSize loadMore:(BOOL)more success:(PostsHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncPagesForBlog:(Blog *)blog batchSize:(NSUInteger)batchSize loadMore:(BOOL)more success:(PagesHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncCategoriesForBlog:(Blog *)blog success:(CategoriesHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncOptionsForBlog:(Blog *)blog success:(OptionsHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncCommentsForBlog:(Blog *)blog success:(CommentsHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncMediaLibraryForBlog:(Blog *)blog success:(MediaHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncPostFormatsForBlog:(Blog *)blog success:(PostFormatsHandler)success failure:(void (^)(NSError *))failure
{
}

- (void)syncBlogContentAndMetadata:(Blog *)blog
                 categoriesSuccess:(CategoriesHandler)categoriesSuccess
                   commentsSuccess:(CommentsHandler)commentsSuccess
                      mediaSuccess:(MediaHandler)mediaSuccess
                    optionsSuccess:(OptionsHandler)optionsSuccess
                      pagesSuccess:(PagesHandler)pagesSuccess
                postFormatsSuccess:(PostFormatsHandler)postFormatsSuccess
                      postsSuccess:(PostsHandler)postsSuccess
                    overallSuccess:(void (^)(void))overallSuccess
                           failure:(void (^)(NSError *error))failure
{
}

@end
