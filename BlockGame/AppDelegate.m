//
//  AppDelegate.m
//  BlockGame
//
//  Created by tomohiko on 2013/02/17.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "AppDelegate.h"
#import "BlockViewController.h"

//AppDelegateの実装
@implementation AppDelegate

//プロパティの実装
@synthesize window=_window;

//アプリ起動時に呼ばれる
- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    //ウィンドウの生成
    _window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    
    //ビューコントローラの生成
    UIViewController* viewCtl=[[[BlockViewController alloc] init] autorelease];
    _window.rootViewController=viewCtl;
    return YES;
}

//メモリの解放
- (void)dealloc {
    [_window release];
    [super dealloc];
}
@end
