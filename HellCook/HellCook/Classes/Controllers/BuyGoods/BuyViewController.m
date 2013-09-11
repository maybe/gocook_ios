//
//  BuyViewController.m
//  HellCook
//
//  Created by lxw on 13-9-5.
//  Copyright (c) 2013年 panda. All rights reserved.
//

#import "BuyViewController.h"
#import "NetManager.h"

@interface BuyViewController ()

@end

@implementation BuyViewController
@synthesize nameLabel,priceTitleLabel,priceLabel,unitLabel,specLabel,processTitleLabel,buyTitleLabel,amountTextField,confirmBtn,dropBtn,methodTextField,picker,netOperation,unitLabel2;

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
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = @"输入购买信息";
  [self setLeftButton];
  [self initControls];
  
  [self hidePicker];
}

-(void)initControls
{
  //nameLabel
  nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-_offset, 20)];
  nameLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  nameLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  nameLabel.backgroundColor = [UIColor clearColor];
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
  priceLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  priceLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  priceLabel.backgroundColor = [UIColor clearColor];
  priceLabel.font = [UIFont systemFontOfSize:20];
  [priceLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [priceLabel setTextColor:[UIColor redColor]];
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
  amountTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 105, 80, 20)];
  [amountTextField setDelegate:self];
  [amountTextField setBackgroundColor: [UIColor whiteColor]];
  amountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  amountTextField.keyboardType = UIKeyboardTypeNumberPad;
  amountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  [amountTextField setFont:[UIFont systemFontOfSize:16]];
  amountTextField.returnKeyType = UIReturnKeyDone;
  amountTextField.tag = 0;
  //unitLabel2
  unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 105, 50, 18)];
  unitLabel.shadowOffset =  CGSizeMake(0.0f, 0.5f);
  unitLabel.shadowColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:0.8];
  unitLabel.backgroundColor = [UIColor clearColor];
  unitLabel.font = [UIFont systemFontOfSize:16];
  [unitLabel setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
  [unitLabel setText:[NSString stringWithFormat:@"%@",goodsDataDict[@"unit"]]];
  //processTitleLabel
  processTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 143, 70, 16)];
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
  //confirmBtn
  confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 180, 60, 27)];
  UIImage *btnBakImage = [UIImage imageNamed:@"Images/redNavigationButtonBackgroundNormal.png"];
  UIImage *strechBakImage = [btnBakImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
  [confirmBtn setBackgroundImage:strechBakImage forState:UIControlStateNormal];
  [confirmBtn setBackgroundImage:stretchedBackgroundPressed forState:UIControlStateHighlighted];
  [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
  [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:nameLabel];
  [self.view addSubview:priceTitleLabel];
  [self.view addSubview:priceLabel];
  [self.view addSubview:unitLabel];
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
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
   [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                               forState:UIControlStateHighlighted];
  [leftBarButtonView setTitle:@"  返回 " forState:UIControlStateNormal];
  [leftBarButtonView.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];
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
  
  NSString *content = [NSString stringWithFormat:@"\"Wares\":[{\"WareId\":%d,\"Quantity\":%@,\"Remark\":\"%@\"}]",[goodsDataDict[@"id"] intValue], amountTextField.text, methodTextField.text];
  NSMutableDictionary *finalDataDict = [[NSMutableDictionary alloc] init];
  [finalDataDict setObject:content forKey:@"wares"];
  [self buyGoods:finalDataDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - network
-(void)buyGoods:(NSMutableDictionary*)data
{
  self.netOperation = [[[NetManager sharedInstance] hellEngine]
                       buyGoodsWithDict:data
                       completionHandler:^(NSMutableDictionary *resultDic){
                         [self buyGoodsCallBack:resultDic];
                       }
                       errorHandler:^(NSError *error){}];
  
}

-(void)buyGoodsCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  NSString *content;
  if (result == 0)
  {
    content = [NSString stringWithFormat:@"下单成功，订单号%@",resultDic[@"order_id"]];
  }
  else
  {
    content = [NSString stringWithFormat:@"下单失败，错误代码%@",resultDic[@"errorcode"]];
  }
  
  HUD.labelText = content;
  [HUD show:YES];
  [HUD hide:YES afterDelay:2];
}




@end
