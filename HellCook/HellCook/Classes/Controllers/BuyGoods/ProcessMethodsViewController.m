//
//  ProcessMethodsViewController.m
//  HellCook
//
//  Created by lxw on 13-11-23.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "ProcessMethodsViewController.h"
#import "ProcessMethodCell.h"
#import "EditProcessMethodCell.h"

@interface ProcessMethodsViewController ()

@end

@implementation ProcessMethodsViewController
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil withMethods:(NSMutableArray*)data bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    methodsArray = [NSMutableArray arrayWithArray:data];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterConfirmMethod:) name:@"afterChangeMethod" object:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationItem setLeftBarButtonItem:nil];
}

-(void)confirm:(UIButton*)btn
{
  NSString *content = [btn associativeObjectForKey:@"content"];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  NSString *temp;
  temp = [NSString stringWithFormat:@"%d",0];
  [dict setObject:temp forKey:@"type"];
  [dict setObject:content forKey:@"content"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmMethod" object:dict];
}

-(void)afterConfirmMethod:(NSNotification *)notification
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([methodsArray count] == 0)
  {
    return 2;
  }
  else
  {
    return [methodsArray count]+1;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([methodsArray count] == 0)
  {
    if (indexPath.row == 0)
    {
      return 70;
    }
    else
    {
      return 270;
    }
  }
  else
  {
    if (indexPath.row == [methodsArray count])
    {
      return 270;
    }
    else
    {
      return 70;
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([methodsArray count] == 0)
  {
    if (indexPath.row == 0)
    {
      NSString *CellIdentifier = @"ProcessMethodCell";
      
      ProcessMethodCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (!cell)
      {
        cell = [[ProcessMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:@"无"];
      }
      
      return cell;
    }
    else
    {
      NSString *CellIdentifier = @"EditProcessMethodCell";
      
      EditProcessMethodCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (!cell)
      {
        cell = [[EditProcessMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      return cell;
    }
  }
  else
  {
    if (indexPath.row == [methodsArray count])
    {
      NSString *CellIdentifier = @"EditProcessMethodCell";
      
      EditProcessMethodCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (!cell)
      {
        cell = [[EditProcessMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      return cell;
    }
    else
    {
      NSString *CellIdentifier = @"ProcessMethodCell";
      
      ProcessMethodCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (!cell)
      {
        cell = [[ProcessMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withContent:[methodsArray objectAtIndex:indexPath.row]];
      }
      
      return cell;
    }
  }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([methodsArray count] == 0)
  {
    if (indexPath.row == 0)
    {
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
      NSString *temp;
      temp = [NSString stringWithFormat:@"%d",0];
      [dict setObject:temp forKey:@"type"];
      [dict setObject:@"无" forKey:@"content"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmMethod" object:dict];
    }
  }
  else
  {
    if (indexPath.row != [methodsArray count])
    {
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
      NSString *temp;
      temp = [NSString stringWithFormat:@"%d",1];
      [dict setObject:temp forKey:@"type"];
      temp = [NSString stringWithFormat:@"%d",indexPath.row];
      [dict setObject:temp forKey:@"content"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmMethod" object:dict];
    }
  }
}

@end
