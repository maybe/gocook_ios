//
//  DefaultGroupedTableCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "DefaultGroupedTableCell.h"


@implementation DefaultGroupedTableCell
@synthesize theCellStyle,tableCellHeaderHeight,tableCellBodyHeight,sepImageView,tableCellFooterHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self.textLabel setFont:[UIFont systemFontOfSize:16]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.backgroundView = [[UIImageView alloc] init];
    self.selectedBackgroundView = [[UIImageView alloc] init];
    self.backgroundColor = [UIColor clearColor];

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
    UIImage* tmpRowBackground = [UIImage imageNamed:@"Images/TableCellSingle.png"];
    rowBackground = [tmpRowBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];

    UIImage* tmpSelectionBackground = [UIImage imageNamed:@"Images/TableCellSingle.png"];
    selectionBackground = [tmpSelectionBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];

  }
  else if (self.theCellStyle == CellStyle_Top)
  {
    UIImage* tmpRowBackground = [UIImage imageNamed:@"Images/TableCellHeader.png"];
    rowBackground = [tmpRowBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    UIImage* tmpSelectionBackground = [UIImage imageNamed:@"Images/TableCellHeader.png"];
    selectionBackground = [tmpSelectionBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
  }
  else if (self.theCellStyle == CellStyle_Bottom)
  {
    UIImage* tmpRowBackground = [UIImage imageNamed:@"Images/TableCellFooter.png"];
    rowBackground = [tmpRowBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    UIImage* tmpSelectionBackground = [UIImage imageNamed:@"Images/TableCellFooter.png"];
    selectionBackground = [tmpSelectionBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
  }
  else
  {    
    UIImage* tmpRowBackground = [UIImage imageNamed:@"Images/TableCellBody.png"];
    rowBackground = [tmpRowBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    UIImage* tmpSelectionBackground = [UIImage imageNamed:@"Images/TableCellBody.png"];
    selectionBackground = [tmpSelectionBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
  }
  
  ((UIImageView *)self.backgroundView).image = rowBackground; 
  ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;

  [sepImageView removeFromSuperview];

  if (self.theCellStyle == CellStyle_Top||self.theCellStyle == CellStyle_Middle) {
    [sepImageView setImage:[UIImage imageNamed:@"Images/TableCellSeparater.png"]];

    if (self.theCellStyle == CellStyle_Middle) {
      [sepImageView setFrame:CGRectMake(20, tableCellBodyHeight-1, 280, 1)];
    }else if (self.theCellStyle == CellStyle_Top){
      [sepImageView setFrame:CGRectMake(20, tableCellHeaderHeight-1, 280, 1)];
    }else if (self.theCellStyle == CellStyle_Bottom){
      [sepImageView setFrame:CGRectMake(20, tableCellFooterHeight, 280, 1)];
    }else{
      [sepImageView setFrame:CGRectMake(20, tableCellHeaderHeight, 280, 1)];
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
