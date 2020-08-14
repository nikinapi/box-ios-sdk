//
//  BOXItemArrayRequests.h
//  BoxContentSDK
//

#import <BoxContentSDK/BOXRequestWithSharedLinkHeader.h>

@interface BOXItemArrayRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;

/**
 * The list of fields to exclude from the list of fields requested
 * This works in conjuntion with requestAllItemFields to exclude fields from the list of all item fields
 * If requestAllItemFields is NO, fieldsToExclude will not have any effect,
 * and the response will include default fields from API
 */
@property (nonatomic, readwrite, strong) NSArray *fieldsToExclude;

/**
 * The list of fields to include in the response, besides default fields from API
 * @note If requestAllItemFields is YES, fieldsToInclude is ignored
 */
@property (nonatomic, readwrite, strong) NSArray *fieldsToInclude;

- (void)performRequestWithCompletion:(BOXItemArrayCompletionBlock)completionBlock;
- (void)performRequestWithCached:(BOXItemArrayCompletionBlock)cacheBlock refreshed:(BOXItemArrayCompletionBlock)refreshBlock;

@end
