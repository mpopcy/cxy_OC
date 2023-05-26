//
//  ListLoader.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/18.
//

#import "ListLoader.h"
#import <AFNetworking.h>
#import "ListItem.h"

@implementation ListLoader

-(void)loadListDataWithFinishBlock:(ListLoaderFinishBlock)finishBlock{
    //AFNetworking完成网络请求
//    [[AFHTTPSessionManager manager] GET:@"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e" parameters:nil headers:nil progress:^(NSProgress *downloadProgress){
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
//        NSLog(@"success");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
//        NSLog(@"fail");
//    }];
    
    //在新请求之前先读取文件中的缓存数据
    NSArray<ListItem *> *listData=[self _readDataFromLocal];
    if(listData){
        //读取到上次数据后，直接展示列表
        finishBlock(YES,listData);
    }
    
    //session完成网络请求
    NSString *urlString=@"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e";
//    NSString *urlString=@"https://www.toutiao.com/?wid=1676881803914";
    NSURL *listURL=[NSURL URLWithString:urlString];
    NSURLRequest *listRequest=[NSURLRequest requestWithURL:listURL];

    NSURLSession *session=[NSURLSession sharedSession];
//    NSURLSessionTask *dataTask=[session dataTaskWithRequest:listRequest];
    __weak typeof(self) weakSelf=self;
    //网络请求回来的数据是一个json数据编码成的NSData类型的二进制数据流
    NSURLSessionTask *dataTask=[session dataTaskWithURL:listURL completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        __strong typeof(weakSelf) strongSelf=weakSelf;

        //将返回回来的NSData类型的对象转换为NSDictionary对象
        NSError *jsonError;
        id jsonObj= [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

#warning 类型检查
        //要做类型检查
        //先将字典中的数据部分取出
        NSArray *dataArray=[((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"result"]) objectForKey:@"data"];
        //字典数据不易使用，因此要结构化数据，把所有key作为model类的属性
        NSMutableArray *listItemArray=@[].mutableCopy;
        for(NSDictionary *info in dataArray){
            ListItem *listItem=[[ListItem alloc] init];
            [listItem configWithDictionary:info];
            [listItemArray addObject:listItem];
        }

        [strongSelf _archiveListDataWithArray:listItemArray.copy];

        //希望所有回包都在主线程中进行，将回调放到主线程中
        dispatch_async(dispatch_get_main_queue(), ^{
            //listItem会根据返回的数据刷新列表
            if(finishBlock){
                finishBlock(error==nil,listItemArray.copy);
            }
        });

        NSLog(@"session");
    }];
    [dataTask resume];
//    [self _getSandBox];

    NSLog(@"url");
}

#pragma mark - private method
//函数名之前加下划线，表明其是私有函数
//在新的数据拉取回来之前，暂时在列表中展示本地缓存的上一次的数据，新数据拉取回来后展示新数据
-(NSArray<ListItem *> *)_readDataFromLocal{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath=[pathArray firstObject];
    NSString *listDataPath=[cachePath stringByAppendingPathComponent:@"newData/newList"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSData *readListData=[fileManager contentsAtPath:listDataPath];
        
    //反序列化
    id unarchiveObj=[NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class],[ListItem class], nil] fromData:readListData error:nil];
    
    if([unarchiveObj isKindOfClass:[NSArray class]] && [unarchiveObj count]>0){
        return (NSArray<ListItem *> *)unarchiveObj;
    }
    return nil;
}

-(void)_archiveListDataWithArray:(NSArray<ListItem *> *)array{
    //沙盒是document的上层目录
    //在cache文件夹下创建一个新的文件夹，保存数据
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath=[pathArray firstObject];
    //创建文件夹manager单例
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //在cache目录下创建一个文件夹
    NSString *dataPath=[cachePath stringByAppendingPathComponent:@"newData"];
    NSError *createError;
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&createError];
    //在新文件夹中新建一个文件
    //如果想向文件中写数据，先将数据转换为NSData
//    NSData *listData=[@"hello~" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *listDataPath=[dataPath stringByAppendingPathComponent:@"newList"];
    
    
    //使用系统的NSKeyedArchive序列化整个array，然后存储到newList文件中
    NSData *listData=[NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:nil];
    
    [fileManager createFileAtPath:listDataPath contents:listData attributes:nil];
    
    
//    NSData *readListData=[fileManager contentsAtPath:listDataPath];
    
    //反序列化
//    id unarchiveObj=[NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class],[ListItem class], nil] fromData:readListData error:nil];
    
    //使用NSUserDefault，根据key值取出abc字符串，也可以存一个文件数据到”文件名“中
//    [[NSUserDefaults standardUserDefaults] setObject:@"abc" forKey:@"test"];
//    NSString *test=[[NSUserDefaults standardUserDefaults] stringForKey:@"test"];
    
    //查询文件
//    BOOL fileExist=[fileManager fileExistsAtPath:listDataPath];
    
    //删除文件
//    if(fileExist){
//        [fileManager removeItemAtPath:listDataPath error:nil];
//    }
//    BOOL fileExist2=[fileManager fileExistsAtPath:listDataPath];
    
    //如果想要修改已有文件的内容，需要创建handle
//    NSFileHandle *fileHandle=[NSFileHandle fileHandleForUpdatingAtPath:listDataPath];
//    //因为是在文件末尾追加内容，因此要将offset调整至末尾
//    [fileHandle seekToEndOfFile];
//    [fileHandle writeData:[@"i'm cxy!" dataUsingEncoding:NSUTF8StringEncoding]];
//    //刷新文件
//    [fileHandle synchronizeFile];
//    //如果不手动关闭文件，当fileHandle销毁时文件会关闭
//    [fileHandle closeFile];
    
//    NSLog(@"sandbox");
}

@end
