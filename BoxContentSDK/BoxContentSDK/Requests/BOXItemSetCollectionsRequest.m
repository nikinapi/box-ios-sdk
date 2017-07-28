//
//  BOXCollectionItemOperationRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXItemSetCollectionsRequest.h"

#import "BOXCollection.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXBookmark.h"
#import "BOXDispatchHelper.h"

@interface BOXItemSetCollectionsRequest()

@property (nonatomic, readwrite, strong) NSString *itemID;
@property (nonatomic, readwrite, strong) NSArray *collectionIDs;
@property (nonatomic, readwrite, strong) NSString *resource;

/// Properties related to Background tasks

/**
 Local path of json formatted collectionIDs
 */
@property (nonatomic, readwrite, strong) NSString *localFilePath;
/**
 Caller provided Unique ID to associate with the request newly added to the operations queue
 */
@property (nonatomic, readwrite, copy) NSString *associateId;

@end

@implementation BOXItemSetCollectionsRequest

- (instancetype)initWithItemID:(NSString *)itemID
                 collectionIDs:(NSArray *)collectionIDs
                      resource:(NSString *)resource
{
    if (self = [super init]) {
        _itemID = itemID;
        _collectionIDs = collectionIDs;
        _resource = resource;
    }
    return self;
}

- (instancetype)initWithItemID:(NSString *)itemID
                     localPath:(NSString *)localPath
                      resource:(NSString *)resource
                   associateId:(NSString *)associateId
{
    if (self = [super init]) {
        _itemID = itemID;
        _localFilePath = localPath;
        _resource = resource;
        _associateId = associateId;
    }
    return self;
}

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                             collectionIDs:(NSArray *)collectionIDs
{
    return [self initWithItemID:fileID
                  collectionIDs:collectionIDs
                       resource:BOXAPIResourceFiles];
}

- (instancetype)initFileSetCollectionsRequestForFileWithID:(NSString *)fileID
                                                 localPath:(NSString *)localPath
                                               associateId:(NSString *)associateId
{
    return [self initWithItemID:fileID
                      localPath:localPath
                       resource:BOXAPIResourceFiles
                    associateId:associateId];
}

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                 collectionIDs:(NSArray *)collectionIDs
{
    return [self initWithItemID:folderID
                  collectionIDs:collectionIDs
                       resource:BOXAPIResourceFolders];
}

- (instancetype)initFolderSetCollectionsRequestForFolderWithID:(NSString *)folderID
                                                     localPath:(NSString *)localPath
                                                   associateId:(NSString *)associateId
{
    return [self initWithItemID:folderID
                      localPath:localPath
                       resource:BOXAPIResourceFolders
                    associateId:associateId];
}

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                     collectionIDs:(NSArray *)collectionIDs
{
        return [self initWithItemID:bookmarkID
                      collectionIDs:collectionIDs
                           resource:BOXAPIResourceBookmarks];
}

- (instancetype)initBookmarkSetCollectionsRequestForBookmarkWithID:(NSString *)bookmarkID
                                                         localPath:(NSString *)localPath
                                                       associateId:(NSString *)associateId
{
    return [self initWithItemID:bookmarkID
                      localPath:localPath
                       resource:BOXAPIResourceBookmarks
                    associateId:associateId];
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIJSONOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:self.resource 
                                    ID:self.itemID
                           subresource:nil
                                 subID:nil];

    NSDictionary *queryParameters = nil;
    if (self.requestAllItemFields) {
        queryParameters = @{BOXAPIParameterKeyFields :[self fullItemFieldsParameterString]};
    }

    NSMutableArray *bodyContent = [NSMutableArray array];
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionary];
    
    if ([self.localFilePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:self.localFilePath]) {
        NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:self.localFilePath];
        bodyDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    } else {
        for (NSString *collectionID in self.collectionIDs) {
            [bodyContent addObject:@{BOXAPIObjectKeyID : collectionID}];
        }
        [bodyDictionary addEntriesFromDictionary:@{BOXAPIObjectKeyCollections : bodyContent}];
    }
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodPUT
                     queryStringParameters:queryParameters
                            bodyDictionary:bodyDictionary
                          JSONSuccessBlock:nil
                              failureBlock:nil];
    operation.associateId = self.associateId;
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXItemBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *collectionAddItemOperation = (BOXAPIJSONOperation *)self.operation;
    
    collectionAddItemOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {

            BOXItem *item = [[self class] itemWithJSON:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheItemSetCollectionsRequest:withUpdatedItem:error:)]) {
                [self.cacheClient cacheItemSetCollectionsRequest:self
                                                 withUpdatedItem:item
                                                           error:nil];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(item, nil);
                } onMainThread:isMainThread];
            }
    };
    collectionAddItemOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheItemSetCollectionsRequest:withUpdatedItem:error:)]) {
                [self.cacheClient cacheItemSetCollectionsRequest:self
                                                 withUpdatedItem:nil
                                                           error:error];
            }
            if (completionBlock) {
                [BOXDispatchHelper callCompletionBlock:^{
                    completionBlock(nil, error);
                } onMainThread:isMainThread];
            }
    };
    [self performRequest];
}

@end
