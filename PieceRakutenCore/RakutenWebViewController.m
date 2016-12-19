//
//  RakutenWebViewController.m
//  Coca
//
//  Created by ハマモト  on 2015/04/22.
//  Copyright (c) 2015年 jokerpiece. All rights reserved.
//

#import "RakutenWebViewController.h"
#import "PieceRakutenConfig.h"


static const int *flag=0;

@interface RakutenWebViewController ()

@end

@implementation RakutenWebViewController

- (void)loadView {
        [[NSBundle mainBundle] loadNibNamed:@"RakutenWebViewController" owner:self options:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    
    if (flag == 0) {
        flag = 1;
        UITabBarController *controller = self.tabBarController;
        for (int i=0; i<3; i++) {
            controller.selectedViewController = [controller.viewControllers objectAtIndex: i];
            if (i==2) {
                controller.selectedViewController = [controller.viewControllers objectAtIndex: 0];
            }
        }
    }
    // スワイプジェスチャーを作成して、登録する。
    UISwipeGestureRecognizer *rightSwipe
    = [[UISwipeGestureRecognizer alloc]
       initWithTarget:self action:@selector(rightSwipeAction:)];
    // スワイプの方向は右方向を指定する。
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    // スワイプ動作に必要な指は1本と指定する。
    rightSwipe.numberOfTouchesRequired = 1;
    
    // スワイプジェスチャーを作成して、登録する。
    UISwipeGestureRecognizer *leftSwipe
    = [[UISwipeGestureRecognizer alloc]
       initWithTarget:self action:@selector(leftSwipeAction:)];
    // スワイプの方向は右方向を指定する。
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    // スワイプ動作に必要な指は1本と指定する。
    leftSwipe.numberOfTouchesRequired = 1;
    
    [self.webView addGestureRecognizer:rightSwipe];
    [self.webView addGestureRecognizer:leftSwipe];
    
}

// スワイプされた際に呼び出される処理。
// NavigationViewで、現在の画面から一つ前の画面に戻る。
-(void)rightSwipeAction:(UISwipeGestureRecognizer *)gesture {
    //[self.navigationController popViewControllerAnimated:YES];
    if(self.webView.canGoBack){
        self.webView.goBack;
    }
}

-(void)leftSwipeAction:(UISwipeGestureRecognizer *)gesture{
    if(self.webView.canGoForward){
        self.webView.goForward;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.title isEqualToString:@"トップ"]){
        NSURL *url = [NSURL URLWithString:[PieceRakutenConfig ShopUrl]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }else if ([self.title isEqualToString:@"買い物カゴ"]){
        NSURL *url = [NSURL URLWithString:@"https://basket.step.rakuten.co.jp/rms/mall/bs/cartall/"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }else{
        [self.webView reload];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    // tab移動で消さないのための対策
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
