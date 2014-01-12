//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecipeMaterialCellInputDelegate <NSObject>

// data change on material/weight
- (void)changeInputData:(NSString*)data On:(NSInteger)type WithIndex:(NSUInteger)index;

@end

@interface MyRecipeMaterialTableViewHeader : UIView

@end

@interface MyRecipeMaterialTableViewFooter : UIView
{
  UIButton* mAddButton;
}

@property (nonatomic, retain) UIButton* mAddButton;

@end

@interface MyRecipeMaterialTableViewCell : UITableViewCell<UITextFieldDelegate>{
  UITextField* materialTextField;
  UITextField* weightTextField;
  UIImageView* middleLine;
  UIImageView* bottomLine;
}

@property (nonatomic, retain) UITextField* materialTextField;
@property (nonatomic, retain) UITextField* weightTextField;
@property (nonatomic, retain) UIImageView* middleLine;
@property (nonatomic, retain) UIImageView* bottomLine;
@property(nonatomic, weak) id<RecipeMaterialCellInputDelegate> delegate;

- (void)setData:(NSMutableDictionary*) dictionary;

@end
