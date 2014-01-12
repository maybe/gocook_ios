//
//  RecipeDetailHeaderTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeDetailBaseTableViewCell : UITableViewCell{
  CGFloat mCellHeight;
}

- (CGFloat)GetCellHeight;
- (void)CalculateCellHeight;
- (void)ReformCell;

- (void)setData:(NSDictionary*) dictionary;

@end
