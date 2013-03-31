//
//  AccountEngine.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

@interface AccountEngine : MKNetworkEngine

typedef void (^LoginResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^RegResponseBlock)(NSMutableDictionary* resultDic);


- (MKNetworkOperation*)loginWithUser:(NSString*)username AndPass:(NSString*)pass
                   completionHandler:(LoginResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

- (MKNetworkOperation*)RegisterWithEmail:(NSString*)username AndNick:(NSString*)nick
                                 AndPass:(NSString*)pass AndRePass:(NSString*)repass
                           AndAvatarPath:(NSString*)avatar
                       completionHandler:(RegResponseBlock) completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock;

@end
