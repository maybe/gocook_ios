//
//  RecipeEngine
//  HellCook
//
//  Created by panda on 4/16/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

@interface RecipeEngine : MKNetworkEngine

typedef void (^iosMainResponseBlock)(NSMutableDictionary* resultDic);

- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock;

@end
