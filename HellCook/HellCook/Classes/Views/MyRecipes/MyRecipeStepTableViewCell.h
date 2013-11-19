//
//  SearchTableViewCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"

@protocol RecipeStepCellInputDelegate <NSObject>

// data change
- (void)changeInputData:(NSString*)data WithIndex:(NSInteger)index;

@end

@interface MyRecipeStepTableViewHeader : UIView

@end

@interface MyRecipeStepTableViewFooter : UIView
{
  UIButton* mAddButton;
}

@property (nonatomic, retain) UIButton* mAddButton;

@end

@interface MyRecipeStepTableViewCell : UITableViewCell<UITextViewDelegate>{
  SSTextView* stepTextView;
  UIButton* selectButton;
  UIImageView* upImageView;
  UIImage* defaultImage;
  NSInteger indexInTable;
  UIButton* delButton;
}

@property (nonatomic, retain) SSTextView* stepTextView;
@property (nonatomic, retain) UIButton* selectButton;
@property (nonatomic, retain) UIImageView* upImageView;
@property (nonatomic, retain) UIImage* defaultImage;
@property (nonatomic,   weak) id<RecipeStepCellInputDelegate> delegate;
@property (nonatomic, retain) UIButton* delButton;
@property NSInteger indexInTable;

- (void)setData:(NSMutableDictionary*) dictionary;

@end
