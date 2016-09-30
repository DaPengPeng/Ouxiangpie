//
//  DPTextViewManager.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DPTextViewManager.h"
#import <CoreData/CoreData.h>

@interface DPTextViewManager() {
    NSMutableDictionary *_iconDic;
    
}

@end

@implementation DPTextViewManager

+ (instancetype)shareManager {
    static DPTextViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DPTextViewManager alloc] init];
    });
    return manager;
}
- (instancetype)init {
    if (self = [super init]) {
        [self loadIconDic];
        _string = [[NSMutableString alloc] init];
    }
    return self;
}

- (NSMutableArray *)attInfo {
    if (!_attInfo) {
        _attInfo = [NSMutableArray array];
    }
    return _attInfo;
}






//解析 中文字符对应图片的数据
-(void)loadIconDic
{
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    
    //解析该文件
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    //初始化字典
    _iconDic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in arr) {
        
        //拿出代表图片的字符串 [**]
        NSString *imgNameKey = [dic objectForKey:@"chs"];
        
        //拿出图片
        NSString *imgNameValue = [dic objectForKey:@"png"];
        
        //将图片与名字 作为键值对存放入新的字典
        [_iconDic setValue:imgNameValue forKey:imgNameKey];
    }
}




- (NSAttributedString *)attributedStringWtihName:(NSString *)string {
 
    //用来接受图片
    CNTextAttachMent *attachment = [[CNTextAttachMent alloc] init];
    
    //从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //构建SQLite数据库文件路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"myEmoticon.data"]];
    //添加持久化存储库，这是使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"添加数据库错误" format:@"%@",[error localizedDescription]];
    }
    //初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
    //3.从数据库中查询数据
    //初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置查询实体
    request.entity = [NSEntityDescription entityForName:@"Emoticon" inManagedObjectContext:context];
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"png" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    //设置条件过滤，搜索chs中包含字符串“哈哈”的记录，注意:设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%哈哈%应该写成*哈哈*
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs like %@",string];
    request.predicate = predicate;
    //执行请求
    error = nil;
    NSArray *bojs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    //设置image属性
    
    attachment.image = [UIImage imageWithData:[[bojs firstObject] valueForKey:@"pngFace"]];
    //可以设置图像文本大小
    attachment.bounds = CGRectMake(0, 0, 20, 20);

    
    //将带有图片属性的attachment对象转化NSAttributedString
    NSAttributedString *insertStr = [NSAttributedString attributedStringWithAttachment:attachment];
    NSDictionary *dic = @{string:insertStr.string};
    [self.attInfo addObject:dic];
    return insertStr;
}

- (NSString *)stringWithAttString:(NSString *)attStr {
    
    if ([attStr isEqualToString:@""] || attStr == nil) {
        return nil;
    }
    _string = [NSMutableString stringWithString:attStr];
    for (NSDictionary *dic in self.attInfo) {
        NSString *info = [dic.allValues firstObject];
        NSRange range = [_string rangeOfString:info];
        if (range.length != 0) {
            
            [_string replaceCharactersInRange:range withString:[dic.allKeys firstObject]];
        } else {
            NSLog(@"replace string erroer:range not error");
        }
        
    }
    
    return _string;
}

@end
