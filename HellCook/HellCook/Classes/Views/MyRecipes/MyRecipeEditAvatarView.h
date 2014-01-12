//
//  RegiserAvatarView.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecipeEditAvatarView : UIView
{
  //UISegmentedControl *permControl;
  UIButton* selectImageButton;
  UIButton* selectButton;
  UIImageView* upImageView;
  UIImage* defaultImage;
}

@property (nonatomic,retain) UIButton* selectButton;
@property (nonatomic,retain) UIButton* selectImageButton;
@property (nonatomic,retain) UIImageView* upImageView;
@property (nonatomic,retain) UIImage* defaultImage;


- (void)InitLayout;
@end
