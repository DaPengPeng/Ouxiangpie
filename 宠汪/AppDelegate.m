//
//  AppDelegate.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "CustomTabBarController.h"
#import "SuperNavigationController.h"
#import "LeftViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

#import <AVOSCloud/AVOSCloud.h>

#import <CoreData/CoreData.h>

#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () <UMSocialUIDelegate, CLLocationManagerDelegate> {
    CLGeocoder *_geocoder;

}

@property (nonatomic,retain) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //learnClould
    [AVOSCloud setApplicationId:@"ybExJDSn6mdtHz7iTh085twx-gzGzoHsz" clientKey:@"dxwcqdUjdJ71KkYpowRvUKOV"];
    //统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //实例主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //实例控制器
    [self setController];
    
    //友盟分享初始化
//    [self uMengSet];
    
    //定位服务
//    [self location];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirst = [userDefaults objectForKey:@"isFirst"];
    if (!isFirst) {
        [self loadEmotcionData];
        [userDefaults setObject:@(NO) forKey:@"isFirst"];
    }
    
    
    
    
    
    return YES;
}

- (void)setController {
    //实例主控制器
    NSArray *controllerNames = @[@"HomeViewController", @"InterestController", @"MainViewController", @"MyInfoViewController"];
    NSMutableArray *controllerArray = [NSMutableArray array];
    for (NSString *controllerName in controllerNames) {
        
        UIViewController *viewContrller = [[NSClassFromString(controllerName) alloc] init];
        SuperNavigationController *navigationController = [[SuperNavigationController alloc] initWithRootViewController:viewContrller];
        [controllerArray addObject:navigationController];
        
    }
    
    CustomTabBarController *tabBarController = [[CustomTabBarController alloc] init];
    tabBarController.viewControllers = controllerArray;
    
    //实例左侧控制器
    LeftViewController *letViewController = [[LeftViewController alloc] init];
    
    //实例侧滑控制器
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:tabBarController leftDrawerViewController:letViewController];
    self.window.rootViewController = drawerController;
    
    //设置
    //设置左侧视图打开方式
    //    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //设置左侧视图关闭方法
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //设置左视图宽度
    [drawerController setMaximumLeftDrawerWidth:kScreenW*0.65];
    //设置阴影
    [drawerController setShowsShadow:NO];
}

- (void)uMengSet {
    //友盟分享初始化
    [UMSocialData setAppKey:@"57baa4fee0f55adfe200231b"];//友盟key
    
    [UMSocialWechatHandler setWXAppId:@"wxa7107aba86fec64c" appSecret:@"01fa1ac8ec367495b1e88bbd4266db4e" url:@"www.baidu.com"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"181483834" secret:@"c15c53d3fe16d58b49e3c25455f7c814" RedirectURL:@"www.baidu.com"];
    
    [UMSocialQQHandler setQQWithAppId:@"1105637442" appKey:@"Uw1fokwxgS48tBxc" url:@"www.baidu.com"];
}

- (void)loadEmotcionData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AVQuery *query = [[AVQuery alloc] initWithClassName:@"Emoticon"];
        NSArray *data = [query findObjects];
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
        
        //    2.添加数据到数据库
        //取出_dataList中的AVObject
        for (AVObject *object in data) {
            
            NSString *pngFace = [object valueForKey:@"pngFace"];
            NSString *pngFaceH = [object valueForKey:@"pngFaceH"];
            NSString *gifFace = [object valueForKey:@"gifFace"];
            NSString *png = [object valueForKey:@"png"];
            NSString *gif = [object valueForKey:@"gif"];
            NSString *cht = [object valueForKey:@"cht"];
            NSString *chs = [object valueForKey:@"chs"];
            NSNumber *type = [object valueForKey:@"type"];
            NSDate *time = [object valueForKey:@"updatedAt"];
            NSData *pngData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pngFace]];
            NSData *gifData = [NSData dataWithContentsOfURL:[NSURL URLWithString:gifFace]];
            NSData *pngHData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pngFaceH]];
            NSManagedObject *emoticon = [NSEntityDescription insertNewObjectForEntityForName:@"Emoticon" inManagedObjectContext:context];
            [emoticon setValue:pngData forKey:@"pngFace"];
            [emoticon setValue:gifData forKey:@"gifFace"];
            [emoticon setValue:pngHData forKey:@"pngFaceH"];
            [emoticon setValue:png forKey:@"png"];
            [emoticon setValue:gif forKey:@"gif"];
            [emoticon setValue:cht forKey:@"cht"];
            [emoticon setValue:chs forKey:@"chs"];
            [emoticon setValue:type forKey:@"type"];
            [emoticon setValue:time forKey:@"time"];
            //利用上下文，将数据同步持久化存储库
            NSError *error = nil;
            BOOL success = [context save:&error];
            if (!success) {
                [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
            }
        }
        
        //3.从数据库中查询数据
        //初始化一个查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        //设置查询实体
        request.entity = [NSEntityDescription entityForName:@"Emoticon" inManagedObjectContext:context];
        //设置排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
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
        int i = 0;
        for (NSManagedObject *obj in bojs) {
            NSLog(@"obj.chs:%@%d",[obj valueForKey:@"chs"],i++);
        }
        
    });

}

- (void)location {
    _locationManager =[[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    _locationManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
        
        //前台授权（默认情况下不可以在后台获取位置，勾选后台模式 location upData 但是会出现蓝条）（background modes）中的location pData
        //NSLocationWhenInUseUsageDescription info 文件中必须设置这个key
        [_locationManager requestWhenInUseAuthorization];//请求使用应用的时候定位
        
        //前后台定位授权
        //+authorzationStatus != kCLAutorizationStatusNotDetaramined
        //这个方法不会有效（用户拒绝了请求或者请求未通过）
        //当前的授权状态为前台授权时此方法也会有效
//        [_locationManager requestAlwaysAuthorization];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 9.0) {
        
        _locationManager.allowsBackgroundLocationUpdates = YES;
        NSLog(@"定位开启了");
    }
    [_locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //这个方法一直调用
    CLLocation *location = [locations firstObject];
    [_locationManager stopUpdatingLocation];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"locationError:%@",error.localizedDescription);
        }
        CLPlacemark *placemark=[placemarks firstObject];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *locationString = [placemark.locality stringByAppendingFormat:@"·%@",placemark.name];
        [userDefaults setObject:locationString forKey:@"location"];
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

#pragma mark - Status Bar Touch Event
//状态栏点击事件
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (CGRectContainsPoint(statusBarFrame, touchLocation))
    {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusBarTap object:nil];
}

@end
