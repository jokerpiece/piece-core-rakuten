//
//
//  Copyright(c) JokerPiece Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NetworkConecter.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "BaseRecipient.h"
#import "RoundBtn.h"
#import "Common.h"
#import "UIColor+MLPFlatColors.h"
#import "PieceCoreConfig.h"
#import "DLog.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <CoreLocation/CoreLocation.h>
#import <Google/Analytics.h>

@interface BaseViewController : UIViewController<NetworkDelegate, SDWebImageManagerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) BaseRecipient *recipient;
@property (nonatomic) bool isResponse;
@property (strong, nonatomic) NSString *titleImgName;
@property (strong, nonatomic) NSString *pageCode;
@property (nonatomic) CGSize viewSize;
@property (nonatomic) UIButton *sosialBtn;
-(void)showAlert:(BaseRecipient *)recipient;
-(void)showAlert:(NSString *)title message:(NSString *)message;
-(void)viewDidLoadLogic;
-(void)viewDidAppearLogic;
- (void)viewWillAppearLogic;
- (void)viewWillDisappearLogic;
-(void)setSosialBtn;
-(BOOL)openURL:(NSURL *)url;
-(void)startTracking;
-(void)showAlertWithTitle:(NSString*)title message:(NSString *)message cancelBtnTitle:(NSString*)cancelBtnTitle otherBtnTitle:(NSString*)otherBtnTitle;
-(void)cancelBtnAction;
@end
