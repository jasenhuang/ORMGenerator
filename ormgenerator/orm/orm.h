//
//  orm.h
//  orm
//
//  Created by jasenhuang on 15/8/14.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WRBook.h"

#import "WRModel.h"


@interface WRBook (orm)

+ (id)instanceObject;

+ (NSString *)dbName;

+ (NSString *)tableName;

+ (NSString *)primaryKey;

+ (NSArray *)persistentProperties;

@end

@interface WRModel (orm)

+ (id)instanceObject;

+ (NSString *)dbName;

+ (NSString *)tableName;

+ (NSString *)primaryKey;

+ (NSArray *)persistentProperties;

@end




