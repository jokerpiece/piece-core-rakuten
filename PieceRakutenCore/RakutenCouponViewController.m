#import "RakutenCouponViewController.h"

@interface RakutenCouponViewController ()

@end
static const int *flag=1;
static const int *current_page_num=0;
static const NSString *webviewurl =nil;
@implementation RakutenCouponViewController



-(void)viewDidLoadLogic{
    self.messageLbl.frame = CGRectMake(self.viewSize.width * 0.5 - (223 * 0.5), self.viewSize.height * 0.5 - 88 , 223, 61);
    SDWebImageManager.sharedManager.delegate = self;
    if (self.pageCode.length < 1) {
        self.pageCode = [PieceCoreConfig pageCodeData].CouponTitle;
    }
    
    self.navigationController.navigationBar.topItem.title = @"クーポンを使う";
    //    [self dispUseCouponMode];
    //    if (self.isDispGetBtn) {
    //        self.getCoupnBtnRactHeight = self.viewSize.height * 0.57;
    //        UIImage *img = [UIImage imageNamed:@"coupon_search.png"];
    //        self.chengeCoupnTypeBtn = [[UIButton alloc]init];
    //        [self.chengeCoupnTypeBtn setBackgroundImage:img forState:UIControlStateNormal];
    //        self.chengeCoupnTypeBtn.frame = CGRectMake(30, 0, 80, 30);
    //        [self.chengeCoupnTypeBtn addTarget:self action:@selector(changeCoupnTypeAction:)
    //                          forControlEvents:UIControlEventTouchUpInside];
    //        UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithRakutenView:self.chengeCoupnTypeBtn];
    //
    //        self.navigationItem.rightBarButtonItem = barbtn;
    //    }
    
    
    
}


- ( void )onTapButton:( id )sender
{
    if (self.isResponse) {
        self.getPage = (int)self.page.currentPage;
        if (self.mode == useCoupon) {
            
        } else {
            UIButton *btn = sender;
            CouponData *coupn = [self.couponRecipient.list objectAtIndex:btn.tag];
            [self getCouponAction:coupn.coupon_id];
            self.couponId = coupn.coupon_id;
            [self startAnimation:sender];
        }
        
        DLog(@"ボタン押下");
    }
    
}

-(void)startAnimation:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    [btn setFrame:CGRectMake(350,self.getCoupnBtnRactHeight,self.viewSize.width, 65)];
    [UIView commitAnimations];
}

- (void)maksmr{
    //    [super viewWillAppear:animated];
    if ((int)flag == 1) {
        flag = 0;
        UITabBarController *controller = self.tabBarController;
        for (int i=0; i<4; i++) {
            controller.selectedViewController = [controller.viewControllers objectAtIndex: i];
        }
    }
}
-(void)dispUseCouponMode{
    UIImage *img = [UIImage imageNamed:@"coupon_search.png"];
    [self.chengeCoupnTypeBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    // self.navigationController.navigationBar.topItem.title = @"クーポンを使う";
    self.chengeCoupnTypeBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.31 blue:0.31 alpha:1.0];
}

-(void)dispGetCouponMode{
    UIImage *img = [UIImage imageNamed:@"coupon_use.png"];
    [self.chengeCoupnTypeBtn setBackgroundImage:img forState:UIControlStateNormal];
    self.navigationController.navigationBar.topItem.title = [PieceCoreConfig titleNameData].useCouponTitle;
    self.chengeCoupnTypeBtn.backgroundColor = [UIColor orangeColor];
}

-(BaseRecipient *)getDataWithSendId:(NSString *)sendId{
    if ([sendId isEqualToString:SendIdGetCoupon]) {
        return [BaseRecipient alloc];
    } else if ([sendId isEqualToString:SendIdItemCoupon]) {
        return [ItemRecipient alloc];
    } else {
        return [CouponRecipient alloc];
    }
}

-(void)receiveSucceed:(NSDictionary *)receivedData sendId:(NSString *)sendId{
    self.isResponse = YES;
    BaseRecipient *recipient = [[self getDataWithSendId:sendId] initWithResponseData:receivedData];
    //後で外す
    if (recipient.error_code.intValue != 0){
        //SN  && data.error_code.intValue !=999) {
        //[self showAlert:@"エラー" message:recipient.error_message];
        [self showAlertWithTitle:@"クーポンを利用していただくためにはプッシュ通知を許可してください" message:@"" cancelBtnTitle:@"設定" otherBtnTitle:@"後で通知"];
        return;
    }
    if (recipient.error_message.length > 0) {
        DLog(@"%@",recipient.error_message);
    }
    
    [self setDataWithRecipient:(CouponRecipient *)recipient sendId:sendId];
    
}

-(void)getCouponAction:(NSString *)coupnId{
    self.isResponse = NO;
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[Common getUuid] forKey:@"uuid"];
    [param setValue:coupnId forKey:@"coupon_id"];
    
    [conecter sendActionSendId:SendIdGetCoupon param:param];
    
}


-(void)setDataWithRecipient:(CouponRecipient *)recipient sendId:(NSString *)sendId{
    
    if ([sendId isEqualToString:SendIdGetCoupon]) {
    } else if([sendId isEqualToString:SendIdItemCoupon]){
        
        if ([PieceCoreConfig tabnumberShopping]) {
            ItemRecipient *itemRecipient = (ItemRecipient *)recipient;
            
            UINavigationController *vc = self.tabBarController.viewControllers[[PieceCoreConfig tabnumberShopping].intValue];
            self.tabBarController.selectedViewController = vc;
            [vc popToRootViewControllerAnimated:NO];
            
            CouponData *couponModel = [self.couponRecipient.list objectAtIndex:self.getPage];
            
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            
            [PieceCoreConfig setUseCouponNum:couponModel.coupon_code];
            [board setValue:[NSString stringWithFormat:@"%@",couponModel.coupon_code] forPasteboardType:@"public.utf8-plain-text"];
            [super showAlert:@"確認" message:@"クーポン番号をコピーしました。\n購入画面でクーポン番号入力欄にペーストして下さい。"];
            
            if (itemRecipient.list.count != 0) {
                
                [vc.viewControllers[0] performSegueWithIdentifier:@"toItem" sender:nil];
                ItemListViewController * controller = vc.viewControllers[1];
                controller.isNext = YES;
                
                controller.searchType = coupon;
                controller.code = couponModel.coupon_id;
            }
        }
        
    } else{
        self.couponRecipient = recipient;
        if (recipient.list.count == 0) {
            if (self.mode == useCoupon) {
                self.messageLbl.text = @"使用できるクーポンを所持していません。";
                return;
            } else {
                //                self.messageLbl.text = @"現在、配布中のクーポンがありません。";
                //                 use Couponに遷移、データ取得
                self.mode = useCoupon;
                [self dispUseCouponMode];
                self.isResponse = NO;
                [self syncAction];
                return;
            }
        }else if (recipient.list.count != 0 && self.mode != useCoupon){
            //配布中クーポンを全てゲットする
            
            
            
            //            UIButton *btn = sender;
            for (CouponData *coupn in self.couponRecipient.list) {
                [self getCouponAction:coupn.coupon_id];
                self.couponId = coupn.coupon_id;
            }
            //            CouponData *coupn = [self.couponRecipient.list objectAtIndex:];
            
            
            
            //use Couponに遷移、データ取得
            self.mode = useCoupon;
            [self dispUseCouponMode];
            self.isResponse = NO;
            [self syncAction];
            return;
        }
        
        
        
        if (webviewurl == nil) {
            CouponData *couponData = [self.couponRecipient.list objectAtIndex:0];
            webviewurl = couponData.coupon_url;
        }
        [self createSlider];
        CGRect frame = self.scroll.frame;
        frame.origin.x = frame.size.width * self.page.currentPage;
        [self maksmr];
        [self.scroll scrollRectToVisible:frame animated:YES];
    }
    
}

- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    
    if(self.mode == useCoupon || !self.isDispGetBtn){
        //TODO couponidからitem一覧取得のapiが未実装
        //[self itemSyncAction];
        CouponData *couponData = [self.couponRecipient.list objectAtIndex:current_page_num];
        if ([Common isNotEmptyString:couponData.coupon_url]) {
            flag = 1;
            NSString *currentUrl;
            if ((int)current_page_num == 0) {
                currentUrl =  webviewurl;
            }else{
                currentUrl = couponData.coupon_url;
                
            }
            WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil url:currentUrl];
            
            [self presentViewController:vc animated:YES completion:nil];
            return;
        }
        [self setCouponNum];
    }
    
}


- (void)viewDidAppearLogic
{
    if (self.isDispGetBtn) {
        if (self.mode == useCoupon) {
            [self dispUseCouponMode];
        } else {
            [self dispGetCouponMode];
        }
    }
    DLog(@"受け取りcouponID:%@",self.couponId);
    
    [self syncAction];
}
-(void)createSlider{
    for(UIView* view in self.scroll.subviews) {
        [view removeFromSuperview];
    }
    [self.page removeFromSuperview];
    self.scroll = nil;
    self.page = nil;
    
    
    self.scroll = [[UIScrollView alloc] init];
    self.scroll.bounces = NO;
    self.pageSize = (int)self.couponRecipient.list.count; // ページ数
    CGFloat width = self.viewSize.width;
    CGFloat height = self.viewSize.height - NavigationHight - TabbarHight;
    self.scroll.frame = self.view.bounds;
    self.scroll.showsHorizontalScrollIndicator = YES;
    self.scroll.pagingEnabled = YES;
    
    self.scroll.userInteractionEnabled = YES;
    self.scroll.delegate = self;
    [self.scroll setContentSize:CGSizeMake((self.pageSize * width), height)];
    self.scroll.frame = CGRectMake(0, 0, width, height);
    
    int i=0;
    int currentPage = 0;
    for (CouponData *data in self.couponRecipient.list) {
        if ([Common isNotEmptyString:self.couponId]
            && [Common isNotEmptyString:data.coupon_code]){
            if([self.couponId isEqualToString:data.coupon_code]){
                currentPage = i;
            }
        }
        
        NSURL *imageURL = [NSURL URLWithString:data.img_url];
        UIImageView *iv = [[UIImageView alloc] init];
        [iv setImageWithURL:imageURL placeholderImage:nil options:SDWebImageCacheMemoryOnly usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        iv.frame = CGRectMake(i * width, 0, width, height);
        iv.userInteractionEnabled = YES;
        [iv addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                  initWithTarget:self action:@selector(view_Tapped:)]];
        iv.tag = i;
        if (self.mode == getCoupon && self.isDispGetBtn) {
            UIView *msk = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, iv.frame.size.height)];
            msk.backgroundColor = [UIColor blackColor];
            msk.alpha = 0.4f;
            [iv addSubview:msk];
        }
        if (self.isDispGetBtn) {
            [self setButton:iv tag:i];
        }
        
        [self.scroll addSubview:iv];
        
        i ++;
    }
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    
    self.page.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.0];
    self.page.currentPageIndicatorTintColor = [UIColor redColor];
    self.page.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.page.numberOfPages = self.pageSize;
    
    self.page.currentPage = currentPage;
    
    
    self.page.userInteractionEnabled = YES;
    [self.page addTarget:self
                  action:@selector(pageControl_Tapped:)
        forControlEvents:UIControlEventValueChanged];
    
    [self.mainView addSubview:self.scroll];
    if (self.couponRecipient.list.count > 1) {
        [self.mainView addSubview:self.page];
    }
    
}



-(void)setButton:(UIView *)view tag:(int)tag{
    
    if (self.mode == getCoupon) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( 0, self.getCoupnBtnRactHeight, self.viewSize.width, 65 );
        
        btn.tag = tag;
        UIImage *img = [UIImage imageNamed:@"coupon_get_btn.png"];
        [btn setImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside ];
        btn.alpha = 0.9f;
        [view addSubview:btn];
    }
    
    
}

-(void)syncAction{
    self.navigationController.navigationBar.topItem.title = @"クーポンを使う";
    
    self.isResponse = NO;
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    NSString *sendId = @"";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //device_tokenチェック(初回起動時はプッシュ通知ONだが途中でOFFにされた時)
    if([Common isNotEmptyString:[Common deviceToken]]){
        if (self.mode == useCoupon) {
            sendId = SendIdCouponTake;
            [param setValue:[Common getUuid] forKey:@"uuid"];
            [param setValue:[Common deviceToken] forKey:@"device_token"];
        } else {
            sendId = SendIdCouponGive;
            [param setValue:[Common getUuid] forKey:@"uuid"];
            [param setValue:[Common deviceToken] forKey:@"device_token"];
        }
        [conecter sendActionSendId:sendId param:param];
    }else{
        [self showAlertWithTitle:@"クーポンを利用していただくためにはプッシュ通知を許可してください" message:@"" cancelBtnTitle:@"設定" otherBtnTitle:@"後で通知"];
    }
    
}

-(void)cancelBtnAction{
    //push通知設定画面に遷移
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    // メソッドに渡された scrollView を使って、先ほどと同じ方法で、現在位置からページ番号を割り出します。
    NSUInteger page = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    // あらかじめ保存しておいたページ番号と照らし合わせます。
    
    current_page_num = page;
    
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
