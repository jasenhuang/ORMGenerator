//
//  WRModel.h
//  ormgenerator
//
//  Created by jasenhuang on 15/8/14.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ormtype.h"

@interface WRModel : NSObject
ORMDataBase(WRModelDatabase)
ORMTable(WRModelTable)
@property (nonatomic, copy, primary) NSString *bookId;              //服务器id
@property (nonatomic, copy, datafield) NSString *title;
@property (nonatomic, copy, datafield) NSString *author;
@property (nonatomic, copy, datafield) NSString *intro;              //介绍
@property (nonatomic, copy, datafield) NSString *coverUrl;           //封面url
@property (nonatomic, copy, datafield) NSString *format;
@end
