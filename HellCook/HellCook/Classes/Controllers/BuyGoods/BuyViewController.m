//
//  BuyViewController.m
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "BuyViewController.h"
#import "MaterialSearchBuyViewController.h"
#import "ProcessMethodsViewController.h"

@interface BuyViewController ()

@end

@implementation BuyViewController
@synthesize nameLabel,priceTitleLabel,priceLabel,unitLabel,specLabel,processTitleLabel,buyTitleLabel,amountTextField,confirmBtn,dropBtn,methodTextField,picker,unitLabel2,methodLabel,labelBackgroundView,arrowImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableDictionary*)data
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    goodsDataDict = [NSMutableDictionary dictionaryWithDictionary:data];
    dealMethodLabelArray = [[NSMutableArray alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMethod:) name:@"ConfirmMethod" object:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  self.navigationItem.title = @"输入购买信息";
  [self setLeftButton];
  [self initControls];

  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  viewFrame.size.width = _sideWindowWidth;
  [self.view setFrame:viewFrame];
  self.view.autoresizesSubviews = NO;
  [self hidePicker];

  UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
  [self.view addGestureRecognizer:gestureRecognizer];
  self.view.userInteractionEnabled = YES;

  [self autoLayout];
  [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([amountTextField isFirstResponder])
    [amountTextField resignFirstResponder];
}

- (void)tapGestureRecognizer
{
  if ([amountTextField isFirstResponder])
    [amountTextField resignFirstResponder];
}

-(void)initControls
{
  //nameLabel
  nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320 - _offset - 15, 20)];
  nameLabel.backgroundColor = [UIColor clearColor];
  [nameLabel setTextColor:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
  nameLabel.font = [UIFont boldSystemFontOfSize:18];
  [nameLabel setText:goodsDataDict[@"name"]];
  //priceTitleLabel
  priceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 50, 16)];
  priceTitleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  priceTitleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  priceTitleLabel.backgroundColor = [UIColor clearColor];
  priceTitleLabel.font = [UIFont systemFontOfSize:16];
  [priceTitleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [priceTitleLabel setText:@"价格："];
  //priceLabel
  priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 42, 120, 20)];
  [priceLabel setTextColor:[UIColor colorWithRed:121.0/255.0 green:143.0/255.0 blue:57.0/255.0 alpha:1.0]];
  priceLabel.backgroundColor = [UIColor clearColor];
  priceLabel.font = [UIFont systemFontOfSize:20];
  [priceLabel setText:[NSString stringWithFormat:@"%.2f元",[goodsDataDict[@"price"] floatValue]]];
  //unitLabel
  unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, 80, 18)];
  unitLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  unitLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  unitLabel.backgroundColor = [UIColor clearColor];
  unitLabel.font = [UIFont systemFontOfSize:16];
  [unitLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [unitLabel setText:[NSString stringWithFormat:@"单位：%@",goodsDataDict[@"unit"]]];
  //specLabel
  specLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 75, 80, 18)];
  specLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  specLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  specLabel.backgroundColor = [UIColor clearColor];
  specLabel.font = [UIFont systemFontOfSize:16];
  [specLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [specLabel setText:[NSString stringWithFormat:@"规格：%@",goodsDataDict[@"norm"]]];
  //buyTitleLabe
  buyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 108, 80, 16)];
  buyTitleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  buyTitleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  buyTitleLabel.backgroundColor = [UIColor clearColor];
  buyTitleLabel.font = [UIFont systemFontOfSize:16];
  [buyTitleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [buyTitleLabel setText:@"购买数量："];
  //amountTextField
  amountTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 106, 70, 20)];
  [amountTextField setDelegate:self];
  [amountTextField setBackgroundColor: [UIColor whiteColor]];
  amountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  amountTextField.keyboardType = UIKeyboardTypeNumberPad;
  amountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  [amountTextField setFont:[UIFont systemFontOfSize:16]];
  amountTextField.returnKeyType = UIReturnKeyDone;
  amountTextField.tag = 0;
  //unitLabel2
  unitLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(173, 108, 50, 18)];
  unitLabel2.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  unitLabel2.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  unitLabel2.backgroundColor = [UIColor clearColor];
  unitLabel2.font = [UIFont systemFontOfSize:16];
  [unitLabel2 setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [unitLabel2 setText:[NSString stringWithFormat:@"%@",goodsDataDict[@"unit"]]];
  //processTitleLabel
  processTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 143, 80, 16)];
  processTitleLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  processTitleLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  processTitleLabel.backgroundColor = [UIColor clearColor];
  processTitleLabel.font = [UIFont systemFontOfSize:16];
  [processTitleLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [processTitleLabel setText:@"加工方式："];
  //dropBtn
  dropBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 140, 20, 20)];
  //  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"];
  UIImage *buttonBackgroundImage = [UIImage imageNamed:@"Images/DownArrow.png"];
  UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:2 topCapHeight:0];
  [dropBtn setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
  UIImage *btnBakimagePressed = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundHighlighted.png"];
  UIImage *stretchedBackgroundPressed = [btnBakimagePressed stretchableImageWithLeftCapWidth:2 topCapHeight:0];
  [dropBtn setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
  [dropBtn addTarget:self action:@selector(dropDown) forControlEvents:UIControlEventTouchUpInside];
  dropBtn.hidden = YES;
  //methodTextField
  methodTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 140, 100, 20)];
  [methodTextField setDelegate:self];
  [methodTextField setBackgroundColor: [UIColor whiteColor]];
  methodTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  methodTextField.keyboardType = UIKeyboardTypeDefault;
  methodTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  [methodTextField setFont:[UIFont systemFontOfSize:16]];
  methodTextField.returnKeyType = UIReturnKeyDone;
  methodTextField.tag = 1;
  NSArray *dealMethodArray = goodsDataDict[@"deal_method"];
  if ([dealMethodArray count] > 0){
    [methodTextField setText:[NSString stringWithFormat:@"%@",[dealMethodArray objectAtIndex:0]]];
  }
  else{
    [methodTextField setText:[NSString stringWithFormat:@"用户指定"]];
  }
  methodTextField.hidden = YES;
  //labelBackgroundView
  labelBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 170, 300-_offset, 60)];
  [labelBackgroundView setImage:[UIImage imageNamed:@"Images/WhiteBlock.png"]];
  [labelBackgroundView setContentMode:UIViewContentModeScaleToFill];
  [self.view addSubview:labelBackgroundView];
  //methodLabel
  methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 280-_offset, 40)];
  methodLabel.backgroundColor = [UIColor clearColor];
  methodLabel.font = [UIFont boldSystemFontOfSize:16];
  methodLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
  methodLabel.lineBreakMode = NSLineBreakByWordWrapping;
  methodLabel.numberOfLines = 2;
  if ([dealMethodArray count] > 0){
    [methodLabel setText:[NSString stringWithFormat:@"%@",[dealMethodArray objectAtIndex:0]]];
  }
  else{
    [methodLabel setText:[NSString stringWithFormat:@"无"]];
  }
  [self.view addSubview:methodLabel];
  methodLabel.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethodLabel)];
  [methodLabel addGestureRecognizer:tapGestureTel];
  //arrowImage
  arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(290-_offset, 195, 10, 10)];
  [arrowImage setImage:[UIImage imageNamed:@"Images/arrow.png"]];
  [arrowImage setContentMode:UIViewContentModeScaleToFill];
  [self.view addSubview:arrowImage];
  //confirmBtn
  confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 250, 64, 29)];
  UIImage *btnBakImage = [UIImage imageNamed:@"Images/AddMaterialLineNormal.png"];
  UIImage *btnBakImage2 = [UIImage imageNamed:@"Images/AddMaterialLineHighLight.png"];
  [confirmBtn setBackgroundImage:btnBakImage forState:UIControlStateNormal];
  [confirmBtn setBackgroundImage:btnBakImage2 forState:UIControlStateHighlighted];
  [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
  [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
  [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:nameLabel];
  [self.view addSubview:priceTitleLabel];
  [self.view addSubview:priceLabel];
  [self.view addSubview:unitLabel];
  [self.view addSubview:unitLabel2];
  [self.view addSubview:specLabel];
  [self.view addSubview:buyTitleLabel];
  [self.view addSubview:amountTextField];
  [self.view addSubview:processTitleLabel];
  [self.view addSubview:dropBtn];
  [self.view addSubview:methodTextField];
  [self.view addSubview:confirmBtn];
}

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapMethodLabel
{
  ProcessMethodsViewController *pViewController = [[ProcessMethodsViewController alloc] initWithNibName:@"ProcessMethodsView" withMethods:goodsDataDict[@"deal_method"] bundle:nil];
  [self.navigationController pushViewController:pViewController animated:YES];
}

- (void)hidePicker
{
  CGRect pickerFrame = picker.frame;
  pickerFrame.origin.y = self.view.frame.size.height;
  [picker setFrame:pickerFrame];
}

- (void)showPicker
{
  CGRect pickerFrame = picker.frame;
  pickerFrame.origin.y = self.view.frame.size.height - pickerFrame.size.height;
  [picker setFrame:pickerFrame];
}

- (void)dropDown
{
  [self showPicker];
}

- (void)confirm
{
  if (amountTextField.text.length==0 || [amountTextField.text isEqual:@"0"])
  {
    HUD.labelText = @"购买数量不能为空或者0";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
    
    return;
  }
  if (methodTextField.text.length == 0)
  {
    HUD.labelText = @"加工方式不能为空";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
    
    return;
  }
  
  [goodsDataDict setObject:amountTextField.text forKey:@"Quantity"];
  [goodsDataDict setObject:methodTextField.text forKey:@"Remark"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmGoods" object:goodsDataDict];

  //
  int j = 0;
  for (; j < [[self.navigationController viewControllers] count]; j++) {
    UIViewController * controller = [[self.navigationController viewControllers] objectAtIndex:j];
    if ([controller isKindOfClass:[MaterialSearchBuyViewController class]]) {
      [self.navigationController popToViewController:controller animated:YES];
      break;
    }
  }
  if (j == [[self.navigationController viewControllers] count]) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

-(void)changeMethod:(NSNotification *)notification
{
  NSMutableDictionary *dict = (NSMutableDictionary*)notification.object;
  if ([(NSString*)dict[@"type"] isEqualToString:@"0"])//用户指定，内容是string
  {
    if (dict[@"content"] && ![dict[@"content"] isEqual:@""]) {
      [methodLabel setText:(NSString*)dict[@"content"]];
    }
  }
  else if ([(NSString*)dict[@"type"] isEqualToString:@"1"])//预先指定，内容是索引号
  {
    NSInteger index = [(NSString*)dict[@"content"] intValue];
    NSArray *dealMethodArray = goodsDataDict[@"deal_method"];
    [methodLabel setText:[dealMethodArray objectAtIndex:index]];
  }
  }

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  return YES;
}



#pragma mark - Picker Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  NSInteger numOfMethods = [goodsDataDict[@"deal_method"] count] + 1;
  return numOfMethods;
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSArray *dealMethodArray = goodsDataDict[@"deal_method"];
  if (row < [dealMethodArray count])
  {
    return [dealMethodArray objectAtIndex:row];
  }
  else
  {
    return @"用户指定";
  }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  NSArray *dealMethodArray = goodsDataDict[@"deal_method"];
  if (row < [dealMethodArray count])
  {
    [methodTextField setText:[dealMethodArray objectAtIndex:row]];
  }
  else
  {
    [methodTextField setText:@"用户指定"];
  }
  
  [self hidePicker];
}


#pragma mark - MBProgressHUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{

}







@end
