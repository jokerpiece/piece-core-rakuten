//
//  RakutenInfoViewController.m
//  Coca
//
//  Created by ハマモト  on 2015/04/22.
//  Copyright (c) 2015年 jokerpiece. All rights reserved.
//

#import "RakutenInfoViewController.h"

@interface RakutenInfoViewController ()

@end

@implementation RakutenInfoViewController

- (void)loadView {
    [[NSBundle mainBundle] loadNibNamed:@"RakutenInfoViewController" owner:self options:nil];
    self.pageCode = @"INFOMATION";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
