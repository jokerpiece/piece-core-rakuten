//
//  BaseViewController.m
//  piece
//
//  Created by ハマモト  on 2014/10/03.
//  Copyright (c) 2014年 ハマモト . All rights reserved.
//

#import "BaseViewController.h"
#import "CoreDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewSize = [UIScreen mainScreen].bounds.size;
    SDWebImageManager.sharedManager.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                                            style:UIBarButtonItemStylePlain
                                                           target:nil
                                                           action:nil];
    self.navigationItem.backBarButtonItem = btn;
    
    if (self.titleImgName.length > 0) {
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.titleImgName]];
        self.navigationItem.titleView = titleImageView;
    }
    
    [self viewDidLoadLogic];
}
-(void)viewDidLoadLogic{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidAppearLogic];
}

-(void)viewDidAppearLogic{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTracking];
    [self viewWillAppearLogic];
    
}

-(void)startTracking{
    if (![PieceCoreConfig isGoogleAnalitics]) {
        return;
    }
    if (NULL != self.title){
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:self.pageCode];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

- (void)viewWillAppearLogic
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self viewWillDisappearLogic];
}

- (void)viewWillDisappearLogic{
    
}

-(void)receiveSucceed:(NSDictionary *)receivedData sendId:(NSString *)sendId{
    self.isResponse = YES;
    BaseRecipient *recipient = [[self getDataWithSendId:sendId] initWithResponseData:receivedData];
    if (recipient.error_code.intValue != 0) {
        [self showAlert:@"エラー" message:recipient.error_message];
     return;
     }
    if (recipient.error_message.length > 0) {
        DLog(@"%@",recipient.error_message);
    }
    [self setDataWithRecipient:recipient sendId:sendId];
    
}

-(void)receiveError:(NSError *)error sendId:(NSString *)sendId{
    CoreDelegate *delegate = (CoreDelegate *)[[UIApplication sharedApplication] delegate];
    if (!delegate.isUpdate) {
        NSString *errMsg;
        switch (error.code) {
            case NSURLErrorBadServerResponse:
                errMsg = @"現在メンテナンス中です。\n大変申し訳ありませんがしばらくお待ち下さい。";
                break;
            case NSURLErrorTimedOut:
                errMsg = @"通信が混み合っています。\nしばらくしてからアクセスして下さい。";
                break;
                
            case kCFURLErrorNotConnectedToInternet:
                errMsg = @"通信できませんでした。\n電波状態をお確かめ下さい。";
                break;
            default:
                errMsg = [NSString stringWithFormat:@"エラーコード：%ld",(long)error.code];
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お知らせ"
                                                        message:errMsg
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)setDataWithRecipient:(BaseRecipient *)recipient sendId:(NSString *)sendId{
}
-(BaseRecipient *)getDataWithSendId:(NSString *)sendId{
    return nil;
}

- (void)timeoutRequest{
    [self showAlert:@"エラー" message:@"通信がタイムアウトしました。時間をおいて再度お試し下さい。"];
}
-(void)showAlert:(BaseRecipient *)recipient {
    if (![recipient.error_code isEqualToString:@"0"]) {
        [self showAlert:@"エラー" message:recipient.error_message];
    }
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:title
     message:message
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    
    [alert show];
}

- (void)dealloc {
    DLog(@"NSNotificationCenter delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didEnterRegion" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didExitRegion" object:nil];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@""])
    {
        return [self openURL:url];
    }
    return NO;
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString *)message cancelBtnTitle:(NSString*)cancelBtnTitle otherBtnTitle:(NSString*)otherBtnTitle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:otherBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 何もしない
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 設定画面へのURLスキーム
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)cancelBtnAction{
    
}

@end
