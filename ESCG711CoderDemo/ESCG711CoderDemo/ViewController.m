//
//  ViewController.m
//  ESCG711CoderDemo
//
//  Created by xiang on 2018/9/30.
//  Copyright © 2018年 xiang. All rights reserved.
//

#import "ViewController.h"
#import "libG711/include/g711codec.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pcmToG711];
    
    [self g711ToPCM];
}

- (void)pcmToG711 {
    NSString *pcmPath = [[NSBundle mainBundle] pathForResource:@"vocal.pcm" ofType:nil];
    NSData *pcmData = [NSData dataWithContentsOfFile:pcmPath];
    char *pcmCdata = (char *)[pcmData bytes];
    char *g711data = malloc(10 * 1024 * 1024);
    
    int lenth = PCM2G711a(pcmCdata, g711data, (int)pcmData.length, 10 * 1024 * 1024);
    if (lenth > 0) {
        NSData *data = [NSData dataWithBytes:g711data length:lenth];
        NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *g711Path = [NSString stringWithFormat:@"%@/vocal.g711",cachesPath];
        [data writeToFile:g711Path atomically:YES];
    }
}

- (void)g711ToPCM {
    NSString *g711Path = [[NSBundle mainBundle] pathForResource:@"vocal.g711" ofType:nil];
    NSData *g711Data = [NSData dataWithContentsOfFile:g711Path];
    char *g711Cdata = (char *)[g711Data bytes];
    char *pcmdata = malloc(10 * 1024 * 1024);
    
    int lenth = G711a2PCM(g711Cdata, pcmdata, (int)g711Data.length, 10 * 1024 * 1024);
    
    if (lenth > 0) {
        NSData *data = [NSData dataWithBytes:pcmdata length:lenth];
        NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *pcmPath = [NSString stringWithFormat:@"%@/vocal.pcm",cachesPath];
        [data writeToFile:pcmPath atomically:YES];
    }
}


@end

