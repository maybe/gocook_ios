//
//  DefaultGroupedTableCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "DefaultGroupedTableCell.h"


@implementation DefaultGroupedTableCell
@synthesize theCellStyle,tableCellHeaderHeight,tableCellBodyHeight,sepImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self.textLabel setFont:[UIFont systemFontOfSize:16]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.backgroundView = [[UIImageView alloc] init];
    self.selectedBackgroundView = [[UIImageView alloc] init];

    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    
    sepImageView = [[UIImageView alloc]init];
    
  }
  return self;
}

- (void)setCellStyle:(NSInteger)_count Index:(NSInteger)_index
{
  self.theCellStyle = [self checkCellStyleWith:_count Index:_index];
  
  UIImage *rowBackground;
  UIImage *selectionBackground;
  
  if (self.theCellStyle == CellStyle_Single)
  {
    rowBackground = [UIImage imageNamed:@"Images/TableCellSingle.png"];
    selectionBackground = [UIImage imageNamed:@"Images/TableCellSingleSelected.png"];
  }
  else if (self.theCellStyle == CellStyle_Top)
  {
    rowBackground = [UIImage imageNamed:@"Images/TableCellHeader.png"];
    selectionBackground = [UIImage imageNamed:@"Images/TableCellHeaderSelected.png"];
  }
  else if (self.theCellStyle == CellStyle_Bottom)
  {
    rowBackground = [UIImage imageNamed:@"Images/TableCellFooter.png"];
    selectionBackground = [UIImage imageNamed:@"Images/TableCellFooterSelected.png"];
  }
  else
  {
    rowBackground = [UIImage imageNamed:@"Images/TableCellBody.png"];
    selectionBackground = [UIImage imageNamed:@"Images/TableCellBodySelected.png"];
  }
  
  ((UIImageView *)self.backgroundView).image = rowBackground; 
  ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;

  [sepImageView removeFromSuperview];

  if (self.theCellStyle == CellStyle_Top||self.theCellStyle == CellStyle_Middle) {
    [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];

    if (self.theCellStyle == CellStyle_Middle) {
      [sepImageView setFrame:CGRectMake(12, tableCellBodyHeight-1, 295, 1)];
    }else{
      [sepImageView setFrame:CGRectMake(12, tableCellHeaderHeight, 295, 1)];
    }
    [self addSubview:sepImageView];
  }
  
}

#pragma mark -
#pragma mark Check Cell Style
- (CellStyle)checkCellStyleWith:(NSInteger)_count Index:(NSInteger)_index
{
  if (_count > 0) {
    if (_count > 1) {
      if (_index == 0) {
        return CellStyle_Top;
      }
      if (_index == _count - 1) {
        return CellStyle_Bottom;
      }
      return CellStyle_Middle;
    }
    return CellStyle_Single;
  }
  return CellStyle_None;
}

@end
