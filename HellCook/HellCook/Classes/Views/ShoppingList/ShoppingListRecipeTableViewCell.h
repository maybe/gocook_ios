//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListRecipeTableViewCell : UITableViewCell{
  UIImageView* rightArrow;
  UIButton* delButton;
  UIButton* buyButton;
  UILabel* titleLabel;
}

@property (nonatomic, retain) UIImageView* rightArrow;
@property (nonatomic, retain) UIButton* delButton;
@property (nonatomic, retain) UIButton* buyButton;
@property (nonatomic, retain) UILabel* titleLabel;

- (void)setData:(NSMutableDictionary*) dictionary;

@end

@interface ShoppingListMaterialTableViewCell : UITableViewCell{
  UILabel* titleLabel;
  UIImageView* middleLine;
}

@property (nonatomic, retain) UIImageView* middleLine;
@property (nonatomic, retain) UILabel* titleLabel;

- (void)setData:(NSMutableDictionary*) dictionary;

@end
