//
//  RecipeEngine
//  HellCook
//
//  Created by panda on 4/16/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

@interface CookEngine : MKNetworkEngine

typedef void (^iosMainResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^topNewResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^topHotResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^searchResponseBlock)(NSMutableDictionary* resultDic);

- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock;

- (MKNetworkOperation*)getTopNewDataWithPage:(NSInteger)page
                           CompletionHandler:(topNewResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

- (MKNetworkOperation*)getTopHotDataWithPage:(NSInteger)page
                           CompletionHandler:(topHotResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

- (MKNetworkOperation*)searchWithKey:(NSString*)key AndPage:(NSInteger)page
                           CompletionHandler:(searchResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;
@end
