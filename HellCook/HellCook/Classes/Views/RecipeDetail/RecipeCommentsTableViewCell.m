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

#define _commentLabelWidth 200

@implementation RecipeCommentsTableViewCell
@synthesize avataImageView;
@synthesize commentLabel,sepImageView, dateLabel;

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
    //nameLabel
    commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, _commentLabelWidth, 25)];
    commentLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    commentLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.font = [UIFont boldSystemFontOfSize:20];
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    commentLabel.numberOfLines = 0;
    //dateLabel
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, mCellHeight-30, 100, 20)];
    dateLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    dateLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:18];
    //seperator image
    sepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 89, 320, 1)];
    [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];
    
    [self addSubview:avataImageView];
    [self addSubview:commentLabel];
    [self addSubview:sepImageView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableDictionary*)dict
{
  NSString *name, *content;
  NSString *strComment;
  if (dict[@"name"]!=[NSNull null] && ![dict[@"name"] isEqual:@""]){
    name = [NSString stringWithString:dict[@"name"]];
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
  commentLabel.text = strComment;
  CGSize contentSize = [commentLabel.text sizeWithFont:commentLabel.font constrainedToSize:CGSizeMake(_commentLabelWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
  if ((contentSize.height+50) > mCellHeight)
  {
    mCellHeight = contentSize.height+50;
    
    CGRect cellRect = self.frame;
    cellRect.size.height = mCellHeight;
    [self setFrame:cellRect];
    [dateLabel setFrame:CGRectMake(90, mCellHeight-30, 100, 20)];
  }
  
  CGRect labelRect = commentLabel.frame;
  labelRect.size.height = contentSize.height;
  [commentLabel setFrame:labelRect];
}

@end
