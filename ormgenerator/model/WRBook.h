//
//  WRBook.h
//  ormgenerator
//
//  Created by jasenhuang on 15/8/14.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ormtype.h"

@interface WRBook : NSObject
ORMDataBase(WRModelDatabase)
ORMTable(WRBookTable)
@property (nonatomic, copy, primary) NSString *bookId;              //服务器id
@property (nonatomic, copy, datafield) NSString *title;
@property (nonatomic, copy, datafield) NSString *author;
@property (nonatomic, copy, datafield) NSString *intro;              //介绍
@property (nonatomic, copy, datafield) NSString *coverUrl;           //封面url
@property (nonatomic, copy, datafield) NSString *format;
@end
