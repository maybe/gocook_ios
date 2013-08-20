//
//  RecipeCommentsTableViewCell.m
//  HellCook
//
//  Created by lxw on 13-8-17.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "RecipeCommentsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "QuartzCore/QuartzCore.h"
#import "NetManager.h"

#define _commentLabelWidth 235

@implementation RecipeCommentsTableViewCell
@synthesize avataImageView, avatarBtn, nameBtn;
@synthesize commentLabel, sepImageView, dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    mCellHeight = 90;
    [self setBackgroundColor: [UIColor clearColor]];
    [self setFrame:CGRectMake(0, 0, 320, mCellHeight)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //avatarImageView
    avataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 60)];
    [avataImageView setContentMode:UIViewContentModeScaleAspectFill];
    [avataImageView setClipsToBounds:YES];
    avataImageView.layer.cornerRadius = 4.0;
    avataImageView.layer.masksToBounds = YES;
    avataImageView.layer.borderColor = [UIColor clearColor].CGColor;
    avataImageView.layer.borderWidth = 1.0;
    //avatarBtn
    avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [avatarBtn setFrame:avataImageView.frame];
    [avatarBtn setBackgroundColor:[UIColor clearColor]];
    [avatarBtn addTarget:nil action:@selector(gotoOtherIntro:) forControlEvents:UIControlEventTouchUpInside];
    //commentLabel
    commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, _commentLabelWidth, 25)];
    commentLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    commentLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.font = [UIFont boldSystemFontOfSize:16];
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    commentLabel.numberOfLines = 0;
    //nameBtn
    nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameBtn setFrame:CGRectMake(75, 10, 0, 25)];
    [nameBtn setBackgroundColor:[UIColor clearColor]];
    [nameBtn addTarget:nil action:@selector(gotoOtherIntro:) forControlEvents:UIControlEventTouchUpInside];
    //dateLabel
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, mCellHeight-30, 200, 20)];
    dateLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    dateLabel.shadowColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.8];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:14];
    //seperator image
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mCellHeight-2, 320, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
    
    [self addSubview:avataImageView];
    [self addSubview:avatarBtn];
    [self addSubview:commentLabel];
    [self addSubview:nameBtn];
    [self addSubview:dateLabel];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)getCellHeight
{
  return mCellHeight;
}

- (void)setData:(NSMutableDictionary*)dict
{
  if (dict[@"user_id"]!=[NSNull null] && ![dict[@"user_id"] isEqual:@""])
  {
    [avatarBtn setAssociativeObject:dict[@"user_id"] forKey:@"userid"];
    [nameBtn setAssociativeObject:dict[@"user_id"] forKey:@"userid"];
  }
  else
  {
    [avatarBtn setAssociativeObject:@"" forKey:@"userid"];
    [nameBtn setAssociativeObject:@"" forKey:@"userid"];
  }
  
  NSString *name, *content;
  NSString *strComment;
  if (dict[@"name"]!=[NSNull null] && ![dict[@"name"] isEqual:@""])
  {
    name = [NSString stringWithString:dict[@"name"]];
    CGSize contentSize = [name sizeWithFont:commentLabel.font constrainedToSize:CGSizeMake(300, 25) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect btnRect = nameBtn.frame;
    btnRect.size.width = contentSize.width;
    [nameBtn setFrame:btnRect];
  }
  else{
    name = @"";
  }
  if (dict[@"content"]!=[NSNull null] && ![dict[@"content"] isEqual:@""]) {
    content = [NSString stringWithString:dict[@"content"]];
  }
  else{
    content = @"";
  }
  strComment = [NSString stringWithFormat:@"%@: %@",name,content];
  NSMutableAttributedString *attributedStrComment = [[NSMutableAttributedString alloc] initWithString:strComment];
  [attributedStrComment setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, [name length])];
  commentLabel.attributedText = attributedStrComment;
  [self caculateCellHeight:strComment];
  
  
  NSMutableDictionary *createTimeDict = dict[@"create_time"];
  if (createTimeDict[@"date"]!=[NSNull null] && ![createTimeDict[@"date"] isEqual:@""]) {
    dateLabel.text = createTimeDict[@"date"];
  }
  else{
    dateLabel.text = @"";
  }
  
  if (dict[@"portrait"]!=[NSNull null] && ![dict[@"portrait"] isEqual:@""])
  {
    NSString* avatarUrl = [NSString stringWithFormat: @"http://%@/%@", [[NetManager sharedInstance] host], dict[@"portrait"]];
    [avataImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  }
  else
  {
    [avataImageView setImage:[UIImage imageNamed:@"Images/avatar.jpg"]];
  }  
}

- (void)caculateCellHeight:(NSString*)strComment
{
//  commentLabel.text = strComment;
  CGSize contentSize = [strComment sizeWithFont:commentLabel.font constrainedToSize:CGSizeMake(_commentLabelWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  if ((contentSize.height+50) > 90)
  {
    mCellHeight = contentSize.height+50;
  }
  else
  {
    mCellHeight = 90;
  }
  
  CGRect cellRect = self.frame;
  cellRect.size.height = mCellHeight;
  [self setFrame:cellRect];
  
  [dateLabel setFrame:CGRectMake(90, mCellHeight-30, 200, 20)];
  [sepImageView setFrame:CGRectMake(0, mCellHeight-2, 320, 1)];
  
  CGRect labelRect = commentLabel.frame;
  labelRect.size.height = contentSize.height;
  [commentLabel setFrame:labelRect];
}

@end