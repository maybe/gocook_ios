//
//  RegiserAvatarView.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterAvatarView : UIView
{
  //UISegmentedControl *permControl;
  UIButton* selectButton;
  UIImageView* upImageView;
  UIImage* defaultImage;
}

@property (nonatomic,retain) UIButton* selectButton;
@property (nonatomic,retain) UIImageView* upImageView;
@property (nonatomic,retain) UIImage* defaultImage;


- (void)InitLayout;
@end
