# orm-generator
极简的ORM代码生成器，对Object-c的类进行语法解析， 可根据Object-c的类定义，自动生成ORM框架需要的函数。理论上可适配任意ObjC的ORM框架 !!!


1. 在model对象里标记成员
2. ORMDataBase(x) 标记数据库名字
3. ORMTable(x) 标记表名字
4. datafield 标记数据库字段
5. primary 标记主键

```
#import <Foundation/Foundation.h>
#import "ormtype.h"

@interface Book : NSObject
ORMDataBase(ModelDatabase)
ORMTable(BookTable)
@property (nonatomic, copy, primary) NSString *bookId;              //服务器id
@property (nonatomic, copy, datafield) NSString *title;
@property (nonatomic, copy, datafield) NSString *author;
@property (nonatomic, copy, datafield) NSString *intro;              //介绍
@end
```

* 运行命令生成代码
* jison orm.jison
* node generator.js [directory|file]

```
#import "orm.h"

@implementation Book (orm)
+ (id)instanceObject {
    return [[Book alloc] init];
}

+ (NSString *)dbName {
    return @"ModelDatabase.db";
}

+ (NSString *)tableName {
    return @"BookTable";
}

+ (NSString *)primaryKey {
    return @"bookId";
}

+ (NSArray *)mappings {
    static NSArray *properties;
    if (!properties) {
        properties = @[
    				@"bookId",
			    	@"title",
			    	@"author",
			    	@"intro"
			    	
			    	];
    }
    return properties;
}
@end
```

Dependencies:

1. nodejs
2. jison
3. swig 