//
//  EmoticonsView.m
//  Moron
//
//  Created by bever on 16/4/28.
//  Copyright © 2016年 清风. All rights reserved.
//

#import "EmoticonsView.h"
#import <AVOSCloud/AVOSCloud.h>

#import <CoreData/CoreData.h>

@interface EmoticonsView () <UIScrollViewDelegate>{

    UIScrollView *_scrollView;
    
    UIPageControl *_pageControl;
    
    NSMutableArray *_dataList;
    
    MyBlock _block;
    
    CGSize _itemSize;
    
    CGFloat _minSpace;
    
    UIImage *_bgImage;
    
    UIImageView *_magnifier;//放大镜图片
    
    UIImageView *_itemV;//被放大的图像
}

@end

@implementation EmoticonsView



- (instancetype)initWithFrame:(CGRect)frame  withBlock:(MyBlock)block{
    if (self = [super initWithFrame:frame]) {
        _block = block;
        
        //数据的读取
        [self loadData];
        
        //画表情
        [self createScrollView];
        
        //创建分页控制器
        [self createPageControl];
        
        //添加长按手势
//        [self addPan];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    _bgImage = [UIImage imageNamed:@"emoticon_keyboard_background"];
    [_bgImage drawInRect:self.bounds];
    
}

//数据的读取
- (void)loadData {
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
    //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs like %@",@"哈哈"];
    //        request.predicate = predicate;
    //执行请求
    error = nil;
    NSArray *bojs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@",[error localizedDescription]];
    }
    _dataList = [NSMutableArray arrayWithArray:bojs];
}

//创建scrollView
- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.bounds.size.height)];
    [self addSubview:_scrollView];
    _minSpace = 10;
    _itemSize = CGSizeMake(40, 40);
    
    _scrollView.delegate = self;
    //计算每一个页面上item的数量
    NSInteger widthCount = (self.bounds.size.width-_minSpace)/(_itemSize.width+_minSpace);
    NSInteger heightCount = (self.bounds.size.height-_minSpace)/(_itemSize.height+_minSpace);
    NSInteger onePageItemCount = widthCount * heightCount;
    BOOL hasMod = _dataList.count%onePageItemCount;
    NSInteger pageCount = _dataList.count/onePageItemCount+1*hasMod;
    
    //_scrollView的设置
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width*pageCount, self.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    CGFloat itemWidth = _itemSize.width;
    CGFloat itemHeight = _itemSize.height;
    
    for (int i = 0; i < _dataList.count; i++) {
        
        EmoticonImageView *imageView =[[EmoticonImageView alloc] initWithFrame:CGRectMake((i/onePageItemCount)*self.bounds.size.width+_minSpace+((i%onePageItemCount)%widthCount)*(itemWidth+_minSpace), _minSpace+((i%onePageItemCount)/widthCount)*(itemHeight+_minSpace), itemWidth, itemHeight)];
        NSManagedObject *object = _dataList[i];
        NSData *data = [object valueForKey:@"pngFace"];
        imageView.image = [UIImage imageWithData:data];
        imageView.emoticonText = [object valueForKey:@"chs"];
        imageView.block = _block;
        [_scrollView addSubview:imageView];
    }
}

//创建分页控制器
- (void)createPageControl {
    
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat height = _scrollView.bounds.size.height;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((width-70)/2, height-20, 70, 20)];
    
    //分也控制器的设置
    _pageControl.numberOfPages = _scrollView.contentSize.width/width;
    _pageControl.enabled = NO;
    _pageControl.tintColor = [UIColor greenColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self addSubview:_pageControl];
}

//scrollView与pageControl的绑定
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentPage = scrollView.contentOffset.x/_scrollView.bounds.size.width;
    _pageControl.currentPage = currentPage;
}

//- (void)addPan {
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    [self addGestureRecognizer:pan];
//}

//- (void)panAction:(UIPanGestureRecognizer *)pan {
//    
//    CGPoint point = [pan translationInView:_scrollView];
//    
//    NSInteger index = [self indexWithPoint:point];
//    
//    if (!_magnifier) {
//        _magnifier = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
//        
//        _magnifier.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
//        
//        [self addSubview:_magnifier];
//        
//        _itemV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 60, 60)];
//        
//        [_magnifier addSubview:_itemV];
//    }
//    _magnifier.image = [_dataList[index] valueForKey:@"pngHFace"];
//    //根据index获取frame
//    CGRect frame = [self frameWithIndex:index];
//    
//    CGFloat centerX = frame.origin.x + 15;
//    
//    CGFloat centerY = frame.origin.y + 15 - _magnifier.bounds.size.height/2;
//    
//    //设置中心点
//    _magnifier.center = CGPointMake(centerX, centerY);
//
//    
//    
//}

////根据下标计算frame
//-(CGRect)frameWithIndex:(NSInteger)index
//{
//    NSInteger x = index % 7;
//    
//    NSInteger y = index / 7;
//    
//    return CGRectMake(_itemSize.width*x+_minSpace*(x+1), _itemSize.height*y+_minSpace*(y+1), _itemSize.width, _itemSize.height);
//    
//}
//
////根据点计算下标
//-(NSInteger)indexWithPoint:(CGPoint)point
//{
//    int x = (point.x-_minSpace)/(_itemSize.width+_minSpace);
//    
//    int y = (point.y-_minSpace)/(_itemSize.width+_minSpace);
//    
//    return y*7+x;
//    
//}

@end

@implementation EmoticonImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
    }
    return self;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _block(_emoticonText);
}
@end
