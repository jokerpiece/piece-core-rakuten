//
//  RakutenCoreDelegate.h
//  pieceRakutenSample
//
//  Created by ハマモト  on 2016/11/24.
//  Copyright © 2016年 jokerpiece. All rights reserved.
//

#import "CoreDelegate.h"
#import "PieceRakutenConfig.h"

@interface RakutenCoreDelegate : CoreDelegate{
    UIView *startView;
    UIImageView *splashImg;
    CALayer *layer;
}
@property (nonatomic) BOOL isTapSplash;
-(void)splashAction;
-(void)tapRakutenImg;
-(void)tapShopImg;
@end
