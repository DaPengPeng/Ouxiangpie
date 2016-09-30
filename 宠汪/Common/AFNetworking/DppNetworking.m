//
//  DppNetworking.m
//  DppWB
//
//  Created by bever on 16/4/9.
//  Copyright © 2016年 贝沃. All rights reserved.
//

#import "DppNetworking.h"
#import "AFNetworking.h"

@implementation DppNetworking

+ (void)GET:(NSString *)url parmeters:(NSDictionary *)parmeters resulteBlock:(resulteBlock)block withFilePath:(NSString *)path {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parmeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:responseObject];
        [archiver finishEncoding];
        
        BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        if (isSuccess) {
            NSLog(@"保存成功");
        }else {
        
            NSLog(@"保存失败");
        }
        
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is:%@",error);
        
    }];
}

+ (void)POST:(NSString *)url parmeters:(NSDictionary *)parmeters withBlcok:(resulteBlock)blocck{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:parmeters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        blocck(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

+ (void)POST:(NSString *)url parmeters:(NSDictionary *)parmeters imageName:(NSString *)imageName imageType:(NSString *)imageType withBlcok:(resulteBlock)blocck{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        [formData appendPartWithFileData:imageData name:imageName fileName:[imageName stringByAppendingString:@".png"] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        blocck(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

+(void)downLoadWithUrl:(NSURL *)url fliePath:(NSURL *)filePath
{
    //下载任务
    AFURLSessionManager *urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    
    //下载任务
    NSURLSessionDownloadTask *downLoad = [urlManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //需要返回url地址  该地址为数据下载完成后存储的位置
        
        return filePath;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error is:%@",error);
        }
        
        
    }];
    
    //执行任务
    [downLoad resume];
}


@end
