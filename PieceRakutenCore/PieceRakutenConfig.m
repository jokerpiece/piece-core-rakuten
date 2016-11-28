//
//  PieceCoreConfig.m
//  piece
//
//  Created by ハマモト  on 2015/02/13.
//  Copyright (c) 2015年 ハマモト . All rights reserved.
//

#import "PieceRakutenConfig.h"

@implementation PieceRakutenConfig
static NSString *_shopUrl = @"";

+ (void)setShopUrl:(NSString *)shopUrl {
    _shopUrl = shopUrl;
}

+ (NSString *)ShopUrl {
    return _shopUrl;
}

@end
