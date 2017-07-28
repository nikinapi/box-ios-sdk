//
//  BOXClient+CollectionAPI.h
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/15/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXContentClient.h"

@class BOXCollectionItemsRequest;
@class BOXCollectionListRequest;
@class BOXItemSetCollectionsRequest;
@class BOXCollectionFavoritesRequest;

@interface BOXContentClient (CollectionAPI)

/**
 *  Generate a request to retrieve the collections of the current user.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollectionListRequest *)collectionsRequestForCurrentUser;

/**
 *  Generate a request to retrieve the Favorites collection.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollectionFavoritesRequest *)collectionInfoRequestForFavorites;

/**
 *  Generate a request to retrieve the items in a collection.
 *
 *  @param collectionID Collection ID.
 *  @param range        An offset (NSRange location) and limit (NSRange limit). The maximum limit allowed is 1000.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXCollectionItemsRequest *)collectionItemsRequestWithID:(NSString *)collectionID
                                                    inRange:(NSRange)range;

/**
 *  Generate a request to set the collections that a file belongs to.
 *
 *  @param fileID        File ID.
 *  @param collectionIDs Array of Collection IDs.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXItemSetCollectionsRequest *)collectionsSetRequestForFileWithID:(NSString *)fileID
                                                       collectionIDs:(NSArray *)collectionIDs;


/**
 *  Generate a background request to set the collections that a file belongs to.
 *
 *  @param fileID File ID.
 *  @param localPath of file containing array of collection IDs; json formatting:
 *
 *                  {
 *                      collections =  ({
 *                          id = <collection id>;
 *                      });
 *                  }
 *
 *  @param associateId Unique ID to associate with the operation to manage when in the background queue.
 *  @return A request that can be customized and then executed
 */
- (BOXItemSetCollectionsRequest *)collectionsSetRequestForFileWithID:(NSString *)fileID
                                                           localPath:(NSString *)localPath
                                                         associateId:(NSString *)associateId;

/**
 *  Generate a request to set the collections that a folder belongs to.
 *
 *  @param folderID      Folder ID.
 *  @param collectionIDs Array of Collection IDs.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXItemSetCollectionsRequest *)collectionsSetRequestForFolderWithID:(NSString *)folderID
                                                         collectionIDs:(NSArray *)collectionIDs;

/**
 *  Generate a background request to set the collections that a folder belongs to.
 *
 *  @param folderID Folder ID.
 *  @param localPath of file containing array of collection IDs; json formatting:
 *
 *                  {
 *                      collections =  ({
 *                          id = <collection id>;
 *                      });
 *                  }
 *
 *  @param associateId Unique ID to associate with the operation to manage when in the background queue.
 *  @return A request that can be customized and then executed
 */
- (BOXItemSetCollectionsRequest *)collectionsSetRequestForFolderWithID:(NSString *)folderID
                                                             localPath:(NSString *)localPath
                                                           associateId:(NSString *)associateId;

/**
 *  Generate a request to set the collections that a bookmark belongs to.
 *
 *  @param bookmarkID    Bookmark ID.
 *  @param collectionIDs Array of Collection IDs.
 *
 *  @return A request that can be customized and then executed.
 */
- (BOXItemSetCollectionsRequest *)collectionsSetRequestForBookmarkWithID:(NSString *)bookmarkID
                                                           collectionIDs:(NSArray *)collectionIDs;

/**
 *  Generate a background request to set the collections that a bookmark belongs to.
 *
 *  @param bookmarkID Bookmark ID.
 *  @param localPath of file containing array of collection IDs; json formatting:
 *
 *                  {
 *                      collections =  ({
 *                          id = <collection id>;
 *                      });
 *                  }
 *
 *  @param associateId Unique ID to associate with the operation to manage when in the background queue.
 *  @return A request that can be customized and then executed
 */
- (BOXItemSetCollectionsRequest *)collectionsSetRequestForBookmarkWithID:(NSString *)bookmarkID
                                                               localPath:(NSString *)localPath
                                                             associateId:(NSString *)associateId;

@end
