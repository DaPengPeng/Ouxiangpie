//
//  CNLabel.m
//  WeiBoBV53
//
//  Created by wangjin on 16/1/5.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "CNLabel.h"
#import <CoreData/CoreData.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UserInfoController.h"
#import "HomeTableViewCell.h"
#import "UserInfoCell.h"
#import "DetailTopicController.h"

@implementation CNLabel
{
    NSMutableDictionary *_iconDic;
}

- (void)awakeFromNib {

    self.frame = CGRectMake(0, 0, self.superview.width, 0);
    
    //初始化textView
    [self createTextView];
    
    //清空背景颜色
    self.backgroundColor = [UIColor clearColor];
    
    //解析plist文件 中文字符--图片
    [self loadIconDic];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //初始化textView
        [self createTextView];
        
        //清空背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        //解析plist文件 中文字符--图片
        [self loadIconDic];
    }
    
    return self;
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

//初始化textView
-(void)createTextView
{
    _textView = [[UITextView alloc] initWithFrame:self.bounds];
    
    _textView.scrollEnabled = NO;
    
    _textView.editable = NO;
    _textView.delegate = self;
    
    _textView.dataDetectorTypes = UIDataDetectorTypeAll;
    _textView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_textView addGestureRecognizer:tap];
    
    [self addSubview:_textView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {

    if ([[self tableViewCell] isKindOfClass:[HomeTableViewCell class]]) {
      
        HomeTableViewCell *cell = (HomeTableViewCell *)[self tableViewCell];
        DetailTopicController *detailVC = [[DetailTopicController alloc] init];
        detailVC.messageModle = cell.messageModel;
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    } else if ([[self tableViewCell] isKindOfClass:[UserInfoCell class]]) {
        UserInfoCell *cell = (UserInfoCell *)[self tableViewCell];
        DetailTopicController *detailVC = [[DetailTopicController alloc] init];
        detailVC.messageModle = cell.model;
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (UITableViewCell *)tableViewCell {
    UIResponder *responder = self;
    do {
        if ([responder isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)responder;
        } else {
            responder = responder.nextResponder;
        }
    } while (responder != nil);
    return nil;
}

//复写set方法
-(void)setText:(NSString *)text
{
    _text = [text copy];
    //实现文本高度的计算
    [self loadAttributedString];    
}

-(void)loadAttributedString
{
    //将普通文本字符串转化为带有富文本属性的字符串
    NSMutableAttributedString *att;
    
    if (self.textAttributes) {
        if (_text != nil) {
            //如果在外部设置了文本的其它属性则使用该方式初始化
            att = [[NSMutableAttributedString alloc] initWithString:_text attributes:_textAttributes];
            
        }
    }
    else
    {
        if (_text != nil) {
            att = [[NSMutableAttributedString alloc] initWithString:_text];
        }
    }
    
    //图文混排
    [self praseString:att];
    
    //超链接
    [self praseLink:att];
    
    //计算文本高度
    [self height:att];
    
    //给textview设置富文本字符串
    _textView.attributedText = att;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _textView.width, _textView.height);
}

//实现图文混排
-(void)praseString:(NSMutableAttributedString *)att
{
    //1.查找符合要求的字符串 并且获取range范围
    NSArray *ranges = [self rangeOfString:@"\\[\\w{1,5}\\]"];
    
    //2.倒叙遍历数组 并且替换字符串
    for (int i = (int)ranges.count-1; i>=0; i--) {
        
        //获取到range范围 --将要替换的字符串的范围
        NSRange range = [ranges[i] rangeValue];
        
        //通过range截取字符串
        NSString *substr = [_text substringWithRange:range];
        
        //通过截取的字符串去替换图片
        NSString *imgName = [_iconDic objectForKey:substr];
        
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
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"png like %@",imgName];
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
//        attachment.bounds = CGRectMake(0, 0, 16, 16);
        
        //删除原有字符串
        if (imgName) {
            
            [att deleteCharactersInRange:range];
        }
        
        //将带有图片属性的attachment对象转化NSAttributedString
        NSAttributedString *insertStr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //在删除原有字符串的location位置插入图片文本字符串
        [att insertAttributedString:insertStr atIndex:range.location];
        
    }
}

//超链接字符
-(void)praseLink:(NSMutableAttributedString *)att
{
    if (att != nil) {
        //连接字符串
//        NSString *linkStr = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
        
        //@用户 字符串
        NSString *userStr = @"@[\\w]+";
        
        //话题 字符串
        NSString *topicStr = @"#[\\w]+#";
        
        NSArray *arr = @[userStr,topicStr];
        
        for (NSString *str in arr) {
            
            //将字符串初始化为正则对象
            NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:str options:NSRegularExpressionCaseInsensitive error:nil];
            
            //通过正则对象 到文本中找到适配的字符  并且返回一组结果
            NSArray *results = [regular matchesInString:att.string options:NSMatchingReportProgress range:NSMakeRange(0, att.length)];
            
            //遍历结果数组
            for (NSTextCheckingResult *result in results) {
                //获取range
                NSRange range = result.range;
                
                //通过range获取到适配的字符串
                NSString *str = [att.string substringWithRange:range];
                
                if ([str rangeOfString:@"@"].length>0) {
                    
                    AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
                    [query whereKey:kUAlais equalTo:[str substringFromIndex:1]];
                    NSArray *array = [query findObjects];
                    if (array.count > 0) {
                        //转化字符串为超链接样式
                        NSString *linkStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        //在富文本字符串中将适配的字符转化为可连接属性
                        [att addAttribute:NSLinkAttributeName value:linkStr range:range];
                    }
                } else {
                    //转化字符串为超链接样式
                    NSString *linkStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    //在富文本字符串中将适配的字符转化为可连接属性
                    [att addAttribute:NSLinkAttributeName value:linkStr range:range];
                }
            }
            
        }
    }
}

//查找符合要求的字符串 并且返回一组range范围
-(NSArray *)rangeOfString:(NSString *)str
{
    //将传入的字符串初始化为正则表达式对象
    NSRegularExpression *reguler = [[NSRegularExpression alloc] initWithPattern:str options:NSRegularExpressionCaseInsensitive error:nil];
    
    //通过正则表达式到字符串中匹配正确对象
    if (self.text != nil) {
        NSArray *results = [reguler matchesInString:self.text options:NSMatchingReportProgress range:NSMakeRange(0, self.text.length)];
        NSMutableArray *ranges = [NSMutableArray array];
        
        //遍历匹配结果 获取range并放入新的数组
        for (NSTextCheckingResult *result in results) {
            //获取到匹配字符串的range范围
            NSRange range = result.range;
            
            //将range转化为oc对象  目的：放入数组中
            NSValue *value = [NSValue valueWithRange:range];
            
            [ranges addObject:value];
        }
        
        //返回数组
        return ranges;
    }
    return nil;
}

//计算高度
-(void)height:(NSMutableAttributedString *)att
{
    //根据富文本字符串 计算文本高度 会以cgrect类型返回
   CGRect frame = [att boundingRectWithSize:CGSizeMake(kScreenW, 9999.f) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    _textView.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, frame.size.width+20, frame.size.height+20);
}

#pragma mark-------
//点击超链接时执行
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    [[UIApplication sharedApplication] openURL:URL];
    NSString *string = [textView.text substringWithRange:characterRange];
    NSString *name = [string substringFromIndex:1];
    AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
    [query whereKey:kUAlais equalTo:name];
    AVObject *object = [[query findObjects] firstObject];
    if (object) {
        NSString *uid = [object objectForKey:kUserInfoId];
        UserInfoController *userInfoController = [[UserInfoController alloc] init];
        userInfoController.userId = uid;
        [self.viewController.navigationController pushViewController:userInfoController animated:YES];
    }
    return YES;
}

//-(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
//    
//    return NO;
//}



@end

@implementation CNTextAttachMent

//修改图像文本的大小
-(CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, lineFrag.size.height+2, lineFrag.size.height+2);
}


@end
