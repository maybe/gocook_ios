//
//  RecipeDetailHeaderTableViewCell.m
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeDetailMaterialTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"


@implementation RecipeDetailMaterialTableViewCell
@synthesize mTitleLabel, mWeightLabelArray, mLineArray,mMaterialLabelArray,buyButton,shoppingListButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setFrame:CGRectMake(0, 0, 320, 210)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
    [self addSubview: [self mTitleLabel]];
    [self addSubview:[self buyButton]];
    [self addSubview:[self shoppingListButton]];
    // mTemplateMaterialLabel = [self createMaterialLabel];
    
    mMaterialLabelArray = [[NSMutableArray alloc]init];
    mWeightLabelArray = [[NSMutableArray alloc]init];
    mLineArray = [[NSMutableArray alloc]init];

    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
    self.backgroundView = backView;
  }
  return self;
}


- (UILabel*)mTitleLabel
{
  if (!mTitleLabel) {
    mTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, 10)];
    [mTitleLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [mTitleLabel setFont: [UIFont boldSystemFontOfSize:18]];
    mTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    mTitleLabel.numberOfLines = 0;
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setText:@"用料"];
  }
  return mTitleLabel;
}

- (UILabel*)createMaterialLabel
{
  UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(32, 150, 256, 10)];
  [label setTextColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]];
  [label setFont: [UIFont systemFontOfSize:15]];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
  [label setBackgroundColor:[UIColor clearColor]];
  [label setText:@""];
  return label;
}

- (UIButton*)buyButton
{
  if (!buyButton) {
    buyButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 100, 84, 20)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RDBuyButtonNormal.png"];
    [buyButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [buyButton setAssociativeObject:@"未加入" forKey:@"title"];
    [buyButton addTarget:nil action:@selector(addToShoppingList) forControlEvents:UIControlEventTouchUpInside];
  }

  return buyButton;
}

- (UIButton*)shoppingListButton
{
  if (!shoppingListButton) {
    shoppingListButton = [[UIButton alloc]initWithFrame:CGRectMake(248, 100, 56, 20)];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/RDShopingListButtonNormal.png"];
    [shoppingListButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage2 = [UIImage imageNamed:@"Images/RDShopingListButtonHighLight.png"];
    [shoppingListButton setBackgroundImage:buttonBackgroundImage2 forState:UIControlStateHighlighted];
    [shoppingListButton addTarget:nil action:@selector(gotoShoppingList) forControlEvents:UIControlEventTouchUpInside];
  }

  return shoppingListButton;
}

-(UIImageView*)createLine
{
  UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 260, 1)];
  [imageView setImage: [UIImage imageNamed:@"Images/line.png"]];
  
  return imageView;
}

- (void)CalculateCellHeight
{  
  //离title高度
  mCellHeight = 10;
  
  //计算title高度
  CGSize titleLabelSize = [mTitleLabel.text sizeWithFont:mTitleLabel.font constrainedToSize:CGSizeMake(256, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  
  mTitleLabelTop = mCellHeight;
  mCellHeight += titleLabelSize.height;
  mTitleLabelHeight = titleLabelSize.height;
  
  mCellHeight += 20;
  
  mMaterialTop = mCellHeight;
  
  //计算用料高度
  for (int i = 0; i < mMaterialLabelArray.count; i++) {
    UILabel* label = [mMaterialLabelArray objectAtIndex:i];
    UILabel* label2 = [mWeightLabelArray objectAtIndex:i];
    CGSize materialLabelSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(128, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize weightLabelSize = [label2.text sizeWithFont:label2.font constrainedToSize:CGSizeMake(128, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat label_height;
    if (materialLabelSize.height >= weightLabelSize.height) {
      [label setAssociativeObject:[NSNumber valueWithCGSize:materialLabelSize] forKey:@"size"];
      [label2 setAssociativeObject:[NSNumber valueWithCGSize:materialLabelSize] forKey:@"size"];
      label_height = materialLabelSize.height;
    } else {
      [label setAssociativeObject:[NSNumber valueWithCGSize:weightLabelSize] forKey:@"size"];
      [label2 setAssociativeObject:[NSNumber valueWithCGSize:weightLabelSize] forKey:@"size"];
      label_height = weightLabelSize.height;
    }

    mCellHeight += 10;
    mCellHeight += label_height;
    mCellHeight += 10;
  }
  
  mCellHeight += 20;
}

- (void)ReformCell
{
  CGRect titleRect = CGRectMake(32, mTitleLabelTop, 256, mTitleLabelHeight);
  [mTitleLabel setFrame: titleRect];

  CGRect buyRect = CGRectMake(145, mTitleLabelTop + 3, 84, 20);
  [buyButton setFrame: buyRect];

  CGRect slRect = CGRectMake(233, mTitleLabelTop + 3, 56, 20);
  [shoppingListButton setFrame: slRect];

  //计算用料高度
  CGFloat material_top = mMaterialTop + 10;
  for (int i = 0; i < mMaterialLabelArray.count; i++) {
    CGFloat label_height = 30;
    UILabel* label1 = [mMaterialLabelArray objectAtIndex:i];
    UILabel* label2 = [mWeightLabelArray objectAtIndex:i];

    CGSize size = [[label1 associativeObjectForKey:@"size"] CGSizeValue];
    label_height = size.height;

    [label1 setFrame:CGRectMake(30, material_top, 128, label_height)];
    
    [label2 setFrame:CGRectMake(160, material_top, 128, label_height)];
    
    UIImageView* imageView = [mLineArray objectAtIndex:i];
    [imageView setFrame:CGRectMake(30, material_top - 10, 260, 1)];

    material_top = material_top + label_height + 20;

    if (i == mMaterialLabelArray.count - 1) {
      UIImageView* lastImageView = [mLineArray objectAtIndex:i+1];
      CGFloat last_y = material_top;
      [lastImageView setFrame:CGRectMake(30, last_y - 10, 260, 1)];
    }

  }
  
  CGRect selfRect = CGRectMake(0, 0, 320, mCellHeight);
  [self setFrame:selfRect];
}

- (void)setData:(NSDictionary*) dictionary
{  
  NSArray* materialArray = [dictionary[@"materials"] componentsSeparatedByString:@"|"];
  
  int materialCount = materialArray.count/2;
  if (mMaterialLabelArray.count < materialCount) {
    int labelcount = mMaterialLabelArray.count;
    for (int i = 0; i < materialCount - labelcount; i++) {
      UILabel* label1 = [self createMaterialLabel];
      [mMaterialLabelArray addObject: label1];
      
      UILabel* label2 = [self createMaterialLabel];
      [mWeightLabelArray addObject: label2];
      
      UIImageView* image = [self createLine];
      [mLineArray addObject:image];
      
      [self addSubview:label1];
      [self addSubview:label2];
      [self addSubview:image];
    }
    
    UIImageView* lastImageView = [self createLine];
    [mLineArray addObject:lastImageView];
    [self addSubview:lastImageView];

  }
  else if (mMaterialLabelArray.count > materialCount) {
    int labelcount = mMaterialLabelArray.count;
    for (int i = 0; i < labelcount - materialCount; i++) {
      [[mMaterialLabelArray lastObject] removeFromSuperview];
      [[mWeightLabelArray lastObject] removeFromSuperview];
      [[mLineArray lastObject] removeFromSuperview];
      [mMaterialLabelArray removeLastObject];
      [mWeightLabelArray removeLastObject];
      [mLineArray removeLastObject];
    }
  }
  
  for (int i = 0; i < materialArray.count/2; i++) {
    UILabel* label1 = [mMaterialLabelArray objectAtIndex:i];
    [label1 setText:[materialArray objectAtIndex:i*2]];
    
    UILabel* label2 = [mWeightLabelArray objectAtIndex:i];
    [label2 setText:[materialArray objectAtIndex:i*2+1]];
  }
}


@end
