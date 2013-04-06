//
//  SearchBarView.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarView : UIView <UITextFieldDelegate>
{
  UIImageView* backImageView;
  UITextField* searchField;
  UIView* maskView;
}

@property (nonatomic,retain) UIImageView* backImageView;
@property (nonatomic,retain) UITextField* searchField;
@property (nonatomic,retain) UIView* maskView;


- (void)InitLayout;
- (void)showMaskView;
- (void)hideMaskView;

@end
