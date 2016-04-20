//
//  HomeViewController.h
//  piece
//
//  Created by ハマモト  on 2014/09/10.
//  Copyright (c) 2014年 ハマモト . All rights reserved.
//


#import "BaseViewController.h"
#import "FlyerRecipient.h"
#import "ItemListViewController.h"
#import "WebViewController.h"
#import "CategoryViewController.h"
#import "SurveyViewController.h"
#import "InfoRecipient.h"
#import "ItemRecipient.h"
#import "linepay_ViewController.h"
#import "LinePayData.h"

@interface FlyerViewController : BaseViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic)UIPageControl *page;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) int pageSize;
@property (strong, nonatomic) FlyerRecipient *flyerRecipient;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) bool isDispSurvey;
@property (strong, nonatomic) NSString *fliyerId;
@property (nonatomic) float headerHeight;
@property (nonatomic) float pageControllHeight;
@property (nonatomic) float bodyWidh;
@property (nonatomic) UIButton *searchBtn;
@property (nonatomic) bool isSearchBtnInvisible;
@property (strong, nonatomic) ItemRecipient *itemRecipient;
@property (strong, nonatomic) ItemData *itemData;
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic)  UIView *loadingView;

- (void)view_Tapped:(UITapGestureRecognizer *)sender;

-(void)createSlider;
-(void)setCartBtn;
@end
