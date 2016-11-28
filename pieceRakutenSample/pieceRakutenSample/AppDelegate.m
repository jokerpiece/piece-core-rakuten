//
//  pieceAppDelegate.m
//  piece
//
//  Created by ハマモト  on 2014/09/09.
//  Copyright (c) 2014年 ハマモト . All rights reserved.
//

#import "AppDelegate.h"
#import "FlyerViewController.h"
#import "InfoListViewController.h"
#import "CategoryViewController.h"
#import "TabbarViewController.h"


@implementation AppDelegate

-(void)setConfig{
    [PieceCoreConfig setShopId:@"kodomogokoro"];
    [PieceCoreConfig setAppKey:@"jokerpiece_appKey"];
    [PieceCoreConfig setAppId:@"kodomogokoro"];
    //[PieceCoreConfig setSplashInterval:[NSNumber numberWithInt:2.0]];
    [PieceCoreConfig setLinePayConfirmUrl:@"piece://pay"];
    [PieceCoreConfig setCookieDomainName:@"otonagokoro.com"];
//    [PieceCoreConfig setCartUrl:@"https://otonagokoro.com/cart/"];
    [PieceCoreConfig setDispSearchBar:YES];
    // google Analytics
    [PieceCoreConfig setGoogleAnalitics:YES];
    
    
    [PieceCoreConfig setLinePay:YES];
    [PieceRakutenConfig setShopUrl:@"http://otonagokoro.com"];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application

{
    [super applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//-(void)splashAction{
//    startView = [[UIView alloc] initWithFrame:self.window.frame];
//    splashImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Default-667h@2x.png"]];
//    [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRakutenImg)]];
//    splashImg.alpha = 1.0;
//    splashImg.frame = self.window.frame;
//    [startView addSubview:splashImg];
//    [self.window.rootViewController.view addSubview:startView];
//    [self.window makeKeyAndVisible];
//    
//    layer = splashImg.layer;
//    [UIView animateWithDuration:2.0f
//                     animations:^{
//                         //splashImg.alpha = 0.0f;
//                     }
//                     completion:^(BOOL finished){
//                         [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopImg)]];
//                         UIImage *image =[UIImage imageNamed:@"sample"];
//                         splashImg.image = image;
//                         splashImg.frame = self.window.frame;
//                         [UIView animateWithDuration:2.5f
//                                          animations:^{
//                                              splashImg.alpha = 1.0f;
//                                          }
//                                          completion:^(BOOL finished){
//                                              startView.backgroundColor = [UIColor blackColor];
//                                              [UIView animateWithDuration:2.5f
//                                                               animations:^{
//                                                                   splashImg.alpha = 0.0f;
//                                                               }
//                                                               completion:^(BOOL finished){
//                                                                   if(!self.isTapSplash){
//                                                                       
//                                                                       [self setTabBarController];
//                                                                   }
//                                                               }];
//                                              
//                                          }];
//                     }];
//}

@end
