//
//  ZZNetworkHelp.h
//  AFN二次封装
//
//  Created by 久其智通 on 2018/6/20.
//  Copyright © 2018年 jiuqizhitong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
//#import "UIKit+AFNetworking.h"
/** 请求成功的Block */
typedef void (^HttpRequestSuccess)(id responseObject);
/** 请求失败的Block */
typedef void (^HttpRequestFailed)(NSError *error);
/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);
/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);

@interface ZZNetworkHelp : UIViewController

// 监听网络的状态，整个程序运行中只要执行一次
+ (void)startMonitor;

// 当前的网络状态
+ (BOOL)currentNetwork;

/**
 Get请求

 @param URL 请求的地址
 @param parameters 参数
 @param responseCache 缓存
 @param success 成功回调
 @param failure 失败回调
 */
+ (NSURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


/**
 POST请求

 @param URL 请求地址
 @param parameters 参数
 @param responseCache 缓存
 @param success 成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求，用cancel
 */
+ (NSURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

/**
 上传图片

 @param URL 请求地址
 @param parameters 请求参数
 @param images 图片数组
 @param name 文件对应服务器字段，这个参数是后台取文件参数的时候用的名字，如果没有的话就传空字符串
 @param fileName 文件名，文件上传的名字，可以随便取，但是不要重名，所以一般是用拼接当前时间的方式作为文件名
 @param mimeType 图片的类型，比如png,jpeg..
 @param progress 上传进度
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回的对象可取消请求，用cancel
 */
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           filename:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           propress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure;


/**
 下载图片

 @param URL 请求地址
 @param fileDir 存储文件目录
 @param progress 进度
 @param success 下载成功回调
 @param failure 失败回调
 @return 返回NSURLSessionDownloadTask实例，可以用挂起，暂停，继续，恢复
 */
+ (AFHTTPSessionManager *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure;
@end
