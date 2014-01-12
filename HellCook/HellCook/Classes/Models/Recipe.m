//
//  Recipe.m
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "Recipe.h"

@implementation RecipeData
@synthesize recipe_id, user_id, create_time, cover_img_status, name, description, collected_count, dish_count, comment_count, browse_count, category, cover_img, materials, recipe_steps, tips;
-(id)init{
  if(self=[super init]){
    recipe_id = 0;
    user_id = 0;
    create_time = @"";
    name = @"";
    description = @"";
    collected_count = 0;
    dish_count = 0;
    comment_count = 0;
    browse_count = 0;
    category = @"";
    cover_img = @"";
    cover_img_status = RecipeImage_UNSELECTED;
    materials = [[NSMutableArray alloc]init];
    recipe_steps = [[NSMutableArray alloc]init];
    tips = @"";
  }
  return self;
}


@end

@implementation Recipe

-(id)init{
  if(self=[super init]){
    isCreate = YES;
  }
  return self;
}

-(RecipeData*)getCreateRecipeData
{
  return mCreateRecipeData;
}

-(void)resetCreateRecipeData
{
  mCreateRecipeData = [[RecipeData alloc]init];
}

-(RecipeData*)getModifyRecipeData
{
  return mModifyRecipeData;
}

-(void)resetModifyRecipeData
{
  mModifyRecipeData = [[RecipeData alloc]init];
}

- (void)setIsCreate:(BOOL)bCreate {
  isCreate = bCreate;
}

- (BOOL)getIsCreate {
  return isCreate;
}

@end
