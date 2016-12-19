//
//  RakutenCoreDelegate.m
//  pieceRakutenSample
//
//  Created by ハマモト  on 2016/11/24.
//  Copyright © 2016年 jokerpiece. All rights reserved.
//

#import "RakutenCoreDelegate.h"
#import "RakutenWebViewController.h"
#import "RakutenInfoViewController.h"
#import "RakutenCouponViewController.h"
#import "RakutenTabbarViewController.h"


@implementation RakutenCoreDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [self setConfig];
    [self setGoogleAnalitics];
    [self setPieceTitle];
    [self setPiecePageCode];
    [self setThemeColor];
    [self setNavibarTitleAttributes];
    [self registDeviceToken];
    [self splashIntarval];
    [self moveScreenWithLaunchOptions:launchOptions];
    [self splashAction];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return YES;
}


-(void)splashAction{
    self.window =  [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    startView = [[UIView alloc] initWithFrame:self.window.frame];
    splashImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Default-667h@2x.png"]];
    [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRakutenImg)]];
    splashImg.alpha = 1.0;
    splashImg.frame = self.window.frame;
    [startView addSubview:splashImg];
    [self.window.rootViewController.view addSubview:startView];
    [self.window makeKeyAndVisible];
    
    layer = splashImg.layer;
    [UIView animateWithDuration:2.0f
                     animations:^{
                         splashImg.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopImg)]];
                         UIImage *image =[UIImage imageNamed:@"splash_default"];
                         splashImg.image = image;
                         splashImg.frame = self.window.frame;
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              splashImg.alpha = 1.0f;
                                          }
                                          completion:^(BOOL finished){
                                              startView.backgroundColor = [UIColor blackColor];
                                              [UIView animateWithDuration:2.5f
                                                               animations:^{
                                                                   splashImg.alpha = 0.0f;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   if(!self.isTapSplash){
                                                                       
                                                                       [self setTabBarController];
                                                                   }
                                                               }];
                                              
                                          }];
                     }];
}

-(void)tapRakutenImg{
    [layer removeAllAnimations];
    
    layer = splashImg.layer;
    
    [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopImg)]];
    splashImg.image = [UIImage imageNamed:@"splash_default.png"];
    splashImg.alpha = 1.0f;
}

-(void)tapShopImg{
    self.isTapSplash = YES;
    //[layer removeAllAnimations];
    [self setTabBarController];
}

- (NSMutableArray *)getTabbarDataList
{
    NSMutableArray *tabbarDataList = [NSMutableArray array];
    
    
    WebViewSettingData *webSetting = [[WebViewSettingData alloc]init];
    webSetting.url = [PieceRakutenConfig ShopUrl];
    //    [webSetting.couponInputDomList setObject:@"document.forms[4].COUPONCODE.value" forKey:@"http://cart6.shopserve.jp/-/cocacoca.jp/smp_cart.php"];
    //    [webSetting.couponInputDomList setObject:@"document.forms[1].COUPONCODE.value" forKey:@"https://cart6.shopserve.jp/-/cocacoca.jp/smp_cart.php?CMD=VIEW"];
    //    [webSetting.couponInputDomList setObject:@"document.forms[4].COUPONCODE.value" forKey:@"https://cart6.shopserve.jp/-/cocacoca.jp/smp_cart.php"];
    //
    
    
    
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:[[RakutenWebViewController alloc]initWithNibName:@"RakutenWebViewController" bundle:nil webSetting:webSetting]
                                                                imgName:@"home_70_red.png"
                                                          selectImgName:@"home_70_white.png"
                                                               tabTitle:@"トップ"
                                                                  title:@"トップ"]];
    
    
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[InfoListViewController alloc] initWithNibName:@"InfoListViewController" bundle:nil]
                                                                imgName:@"asset.png"
                                                          selectImgName:@"asset_w.png"
                                                               tabTitle:@"お知らせ"
                                                                  title:@"お知らせ"]];
    
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:[[RakutenWebViewController alloc]initWithNibName:@"RakutenWebViewController" bundle:nil url:@"https://basket.step.rakuten.co.jp/rms/mall/bs/cartall/"]
                                                                imgName:@"cart_70_red.png"
                                                          selectImgName:@"cart_70_white.png"
                                                               tabTitle:@"買い物カゴ"
                                                                  title:@"買い物カゴ"]];
    
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[RakutenCouponViewController alloc] initWithNibName:@"RakutenCouponViewController" bundle:nil]
                                                                imgName:@"coupon_70_red.png"
                                                          selectImgName:@"coupon_70_white.png"
                                                               tabTitle:@"クーポン"
                                                                  title:@"クーポン"]];
    
    return tabbarDataList;
}

- (void)setTabBarController
{
    UIImage *unselectedImage = [UIImage imageNamed:@"select.png"];
    
    self.window =  [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[RakutenTabbarViewController alloc] init];
    NSMutableArray *navigationControllerList = [NSMutableArray array];
    NSMutableArray *tabbarDataList = [self getTabbarDataList];
    [[UITabBar appearance] setSelectionIndicatorImage:unselectedImage];
    int i = 0;
    
    for (TabbarData *tabbarData in tabbarDataList) {
        if (tabbarData.viewController != nil) {
            [self setTabbarNumberWithVc:tabbarData.viewController index:i];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarData.viewController];
            
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabbarData.tabTitle
                                                                            image:[[UIImage imageNamed:tabbarData.imgName] imageWithRenderingMode:UIImageRenderingModeAutomatic]
                                                                    selectedImage:[[UIImage imageNamed:tabbarData.selectImgName] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
            navigationController.tabBarItem.title = tabbarData.tabTitle;
            [navigationControllerList addObject:navigationController];
            
            
            [navigationController.tabBarItem setFinishedSelectedImage:[[UIImage imageNamed:tabbarData.selectImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                          withFinishedUnselectedImage:[[UIImage imageNamed:tabbarData.imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
             
             
             ];//
            
            i++;
        }
    }
    
    
    
    //タブのタイトル位置設定
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -1)];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:9.0f],
                                 NSForegroundColorAttributeName : [UIColor flatRedColor]};
    
    NSDictionary *attributes2 = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:9.0f],
                                  NSForegroundColorAttributeName : [UIColor whiteColor]};
    //    [UITabBar appearance].backgroundImage = [UIImage imageNamed:@"tab_background"];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
    [UITabBar appearance].tintColor = [UIColor whiteColor];
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
    
    
    [(UITabBarController *)self.tabBarController setViewControllers:navigationControllerList animated:NO];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
}
@end
