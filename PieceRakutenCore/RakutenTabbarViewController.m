//
//  RakutenTabbarViewController.m
//  pieceRakutenSample
//
//  Created by OhnumaRina on 2016/12/19.
//  Copyright © 2016年 jokerpiece. All rights reserved.
//

#import "RakutenTabbarViewController.h"

@interface RakutenTabbarViewController ()

@end

@implementation RakutenTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.delegate = self;
    [super viewWillAppear:animated];
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //同タブを押された時の処理
    if(tabSelectedView != viewController)
    {
        tabSelectedView = viewController;
    }else{
        //最初にページを表示
        [viewController loadView];
    }
}
@end
