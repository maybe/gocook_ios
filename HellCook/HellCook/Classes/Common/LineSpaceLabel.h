//
//  LineSpaceLabel.h
//  HellCook
//
//  Created by panda on 7/21/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineSpaceLabel : UILabel{
  CGFloat charSpace_;
  CGFloat lineSpace_;
}
@property(nonatomic, assign) CGFloat charSpace;
@property(nonatomic, assign) CGFloat lineSpace;

@end