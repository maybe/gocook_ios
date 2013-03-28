//
//  NormalGroupedTableCell.h
//  LilyBBS
//
//  Created by panda on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum CellStyleT {
  CellStyle_None,
  CellStyle_Top,
  CellStyle_Middle,
  CellStyle_Bottom,
  CellStyle_Single
} CellStyle;

@interface DefaultGroupedTableCell : UITableViewCell
{
  CellStyle theCellStyle;
  NSInteger tableCellBodyHeight;
  NSInteger tableCellHeaderHeight;
  UIImageView* sepImageView;
}
@property (nonatomic, assign)CellStyle theCellStyle;
@property (nonatomic, assign)NSInteger tableCellBodyHeight;
@property (nonatomic, assign)NSInteger tableCellHeaderHeight;
@property (nonatomic, retain)UIImageView* sepImageView;

- (void)setCellStyle:(NSInteger)_count Index:(NSInteger)_index;

- (CellStyle)checkCellStyleWith:(NSInteger)_count Index:(NSInteger)_index;

@end
