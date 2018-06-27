//
//  ZZNetworkHelp.m
//  AFN二次封装
//
//  Created by 久其智通 on 2018/6/20.
//  Copyright © 2018年 jiuqizhitong. All rights reserved.
//

#import "ZZNetworkHelp.h"

#ifdef DEBUG
#define ZZLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define ZZLog(...)
#endif


@interface ZZNetworkHelp ()

@end


@implementation ZZNetworkHelp

static bool isNetwork;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 监听网络
+ (void)startMonitor{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                isNetwork = NO;
                ZZLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                isNetwork = NO;
                ZZLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                isNetwork = YES;
                ZZLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                isNetwork = YES;
                ZZLog(@"手机自带网络");
                break;
        }
    }];
    [manager startMonitoring];
}

+ (BOOL)currentNetwork{
    return  isNetwork;
}


#pragma mark - 请求不带自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    AFHTTPSessionManager *manager = [self setAFHttpSessionManager];
    
   return [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error):nil;
        
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    AFHTTPSessionManager *manager = [self setAFHttpSessionManager];
    
    return [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error):nil;
        failure && error ? failure(error) : nil;

    }];
    
}

#pragma mark - 上传图片文件
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                        images:(NSArray<UIImage *> *)images
                        name:(NSString *)name
                        filename:(NSString *)fileName
                        mimeType:(NSString *)mimeType
                        propress:(HttpProgress)progress
                        success:(HttpRequestSuccess)success
                        failure:(HttpRequestFailed)failure{
    
    AFHTTPSessionManager *manager = [self setAFHttpSessionManager];
    
   return  [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:[NSString stringWithFormat:@"%@%lu.%@",fileName,(unsigned long)idx,mimeType?mimeType:@"jpeg"]
                                    mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
            
        }];
       
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        
    }];
}

#pragma mark - 下载文件
+ (AFHTTPSessionManager *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure{
    AFHTTPSessionManager *manager = [self setAFHttpSessionManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDataTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress ? progress(downloadTask) : nil;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        // 打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 创建download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        // 拼接文件路径
        NSString *filepath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        // 返回文件位置的url路径
        return [NSURL fileURLWithPath:filepath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;

    }];
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
}

#pragma 设置AFHttpSessionManager 相关属性
+ (AFHTTPSessionManager *)setAFHttpSessionManager{
    // 打开状态栏的等待菊花
//    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    return manager;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
