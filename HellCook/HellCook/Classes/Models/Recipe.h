//
//  Recipe.h
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  RecipeImage_UPLOADED = 0,                      // 已上传
  RecipeImage_UNSELECTED = 1,                    // 未选择
} RecipeImageStatus;


@interface RecipeData : NSObject
{
  NSInteger recipe_id;
  NSInteger user_id;
  NSString* create_time;
  NSString* name;
  NSString* description;
  NSInteger collected_count;
  NSInteger dish_count;
  NSInteger comment_count;
  NSInteger browse_count;
  NSString* category;
  NSString* cover_img;
  RecipeImageStatus cover_img_status;
  NSMutableArray* materials;
  NSMutableArray* recipe_steps;
  NSString* tips;
}

@property NSInteger recipe_id;
@property NSInteger user_id;
@property (nonatomic, retain) NSString* create_time;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property NSInteger collected_count;
@property NSInteger dish_count;
@property NSInteger comment_count;
@property NSInteger browse_count;
@property (nonatomic, retain) NSString*category;
@property (nonatomic, retain) NSString* cover_img;
@property RecipeImageStatus cover_img_status;
@property (nonatomic, retain) NSMutableArray* materials;
@property (nonatomic, retain) NSMutableArray* recipe_steps;
@property (nonatomic, retain) NSString* tips;

@end

@interface Recipe : NSObject
{
  RecipeData* mCreateRecipeData;
  RecipeData* mModifyRecipeData;

  bool isCreate;
}

- (RecipeData*)getCreateRecipeData;
- (void)resetCreateRecipeData;
- (RecipeData*)getModifyRecipeData;
- (void)resetModifyRecipeData;

- (void)setIsCreate:(BOOL)bCreate;
- (BOOL)getIsCreate;

@end
