//
//  DefaultGroupedTableCell.h
//  HC
//
//  Created by panda on 13-1-11.
//  Copyright (c) 2013 panda. All rights reserved.
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
  NSInteger tableCellFooterHeight;
  UIImageView* sepImageView;
}
@property (nonatomic, assign)CellStyle theCellStyle;
@property (nonatomic, assign)NSInteger tableCellBodyHeight;
@property (nonatomic, assign)NSInteger tableCellHeaderHeight;
@property (nonatomic, assign)NSInteger tableCellFooterHeight;
@property (nonatomic, retain)UIImageView* sepImageView;

- (void)setCellStyle:(NSInteger)_count Index:(NSInteger)_index;

- (CellStyle)checkCellStyleWith:(NSInteger)_count Index:(NSInteger)_index;

@end
