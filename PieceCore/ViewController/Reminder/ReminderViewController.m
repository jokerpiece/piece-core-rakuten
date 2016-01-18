//
//  ReminderViewController.m
//  pieceSample
//
//  Created by ハマモト  on 2016/01/18.
//  Copyright © 2016年 jokerpiece. All rights reserved.
//

#import "ReminderViewController.h"
#import "CoreDelegate.h"
#import <EventKit/EventKit.h>


@interface ReminderViewController ()

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.reminderData = [[ReminderData alloc]getDataForNSUserDefaults];

    [self setDispData];
    self.monthDateViewController = [[MonthAndDatePickerViewController alloc] initWithNibName:@"MonthAndDatePickerViewController" bundle:nil];
    self.monthDateViewController.delegate = self;
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.dateNameTf.delegate = self;
    self.dateTf.delegate = self;
    [self setKeybordNC];
    // Do any additional setup after loading the view from its nib.
}

-(void)setDispData{
    if (self.reminderData.notiflcationDate != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        NSString *dateStr = [formatter stringFromDate:self.reminderData.notiflcationDate];
        NSString *monthStr = [dateStr substringWithRange:NSMakeRange(6, 2)];
        NSString *DayStr = [dateStr substringWithRange:NSMakeRange(8, 2)];
        
        self.dateTf.text = [NSString stringWithFormat:@"%d月%d日",monthStr.intValue  , DayStr.intValue];
        
        
        
        
    }
    self.dateNameTf.text = self.reminderData.notiflcationDateName;
    self.fatherBtn.selected = self.reminderData.isFatherDay;
    self.motherBtn.selected = self.reminderData.isMotherDay;
    self.childBtn.selected = self.reminderData.isChildDay;
    self.silverBtn.selected = self.reminderData.isSeniorDay;
    self.valentineBtn.selected = self.reminderData.isValentine;
    
}


-(void)closeKeyboard{
    //キーボード以外を押された時の処理
    [self.view endEditing:YES];
}

- (void) showModal:(UIView *) modalView
{
    UIWindow *mainWindow = (((CoreDelegate *) [UIApplication sharedApplication].delegate).window);
    
    CGPoint offScreenCenter = CGPointMake(self.viewSize.width * 0.5f, self.viewSize.height * 1.5f);
    modalView.center = offScreenCenter;
    modalView.frame = CGRectMake(0, 0, self.viewSize.width, self.viewSize.height);
    [mainWindow addSubview:modalView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    modalView.center = CGPointMake(self.viewSize.width * 0.5f, self.viewSize.height * 0.5f);
    [UIView commitAnimations];
}

- (void) hideModal:(UIView*) modalView
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    [UIView beginAnimations:nil context:(__bridge_retained void *)(modalView)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
    
//    [self setReminder];
}


- (void) hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIView *modalView = (__bridge_transfer UIView *)context;
    [modalView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setKeybordNC{
    NSNotificationCenter *nc;
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keybaordWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)releaseKeybordNC{
    NSNotificationCenter *nc;
    nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.activeTf = textField;
        if (self.dateTf == textField) {
            self.monthDateViewController = [[MonthAndDatePickerViewController alloc] initWithNibName:@"MonthAndDatePickerViewController" bundle:nil];
            self.monthDateViewController.delegate = self;
            self.isDispDatePicker = YES;
            
            
            [self showModal:self.monthDateViewController.view];
            
            return NO;
        }
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
}

- (void)keybaordWillHide:(NSNotification*)notification
{

}

- (void)didCommitButtonClicked:(DatePickerViewController *)controller selectDate:(NSString *)selectDate{
    [self hideModal:controller.view];
    self.activeTf.text = selectDate;
    int month = (int)[self.monthDateViewController.pickerView selectedRowInComponent:0] + 1;
    int day = (int)[self.monthDateViewController.pickerView selectedRowInComponent: 1] + 1;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                        fromDate:[NSDate date]];
    
    
    
    
    
    
    NSString* dateString =  [NSString stringWithFormat:@"%04ld/%02d/%02d 20:40:00",(long)comps.year,month,day ];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *notiDate = [dateFormatter dateFromString:dateString];
    
    NSDate *calcDate = [notiDate dateByAddingTimeInterval:-20 * 24 * 60 * 60];
    
    NSComparisonResult result = [[NSDate date] compare:calcDate];
    
    switch (result) {
        case NSOrderedSame:
            // 同一時刻
            break;
        case NSOrderedAscending:
            // nowよりotherDateのほうが未来
            break;
        case NSOrderedDescending:
            // nowよりotherDateのほうが過去
            dateString =  [NSString stringWithFormat:@"%04ld/%02d/%02d 00:00:00",(long)comps.year + 1,month,day ];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            notiDate = [dateFormatter dateFromString:dateString];
            break;
    }

    self.reminderData.notiflcationDate = notiDate;
    
    
}
- (void)didCancelButtonClicked:(DatePickerViewController *)controller{
    [self hideModal:controller.view];
    //controller.delegate = nil;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onFatherBtn:(id)sender {
    self.fatherBtn.selected = !self.fatherBtn.selected;
    self.reminderData.isFatherDay = self.fatherBtn.selected;
}

- (IBAction)onMotherBtn:(id)sender {
    self.motherBtn.selected = !self.motherBtn.selected;
        self.reminderData.isMotherDay = self.motherBtn.selected;
}

- (IBAction)onSilverBtn:(id)sender {
    self.silverBtn.selected = !self.silverBtn.selected;
        self.reminderData.isSeniorDay = self.silverBtn.selected;
}

- (IBAction)onChildBtn:(id)sender {
    self.childBtn.selected = !self.childBtn.selected;
        self.reminderData.isChildDay = self.childBtn.selected;
}

- (IBAction)onValentineBtn:(id)sender {
    self.valentineBtn.selected = !self.valentineBtn.selected;
        self.reminderData.isValentine = self.valentineBtn.selected;
}

- (IBAction)onSaveBtn:(id)sender {
    [self setLocalNotification:self.reminderData.notiflcationDate DateName:self.reminderData.notiflcationDateName];
    self.reminderData.notiflcationDateName = self.dateNameTf.text;
    [self.reminderData saveDataForNSUserDefaults];
    [self showAlert:@"お知らせ" message:@"登録しました。"];
}

/*
- (void)readReminder{
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized) {
        // リマインダーにアクセスできる場合
    } else {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeReminder
                                   completion:^(BOOL granted, NSError *error) {
                                       if(granted) {
                                           
                                           // はじめてリマインダーにアクセスする場合にアラートが表示されて、OKした場合にここにくるよ
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               // アクセス権がありません。
                                               // "プライバシー設定"でアクセスを有効にできます。
                                               UIAlertView *alert = [[UIAlertView alloc]
                                                                     initWithTitle:NSLocalizedString(@"This app does not have access to you reminders.", nil)
                                                                     message:NSLocalizedString(@"To display your reminder, enable [YOUR APP] in the \"Privacy\" → \"Reminders\" in the Settings.app.", nil)
                                                                     delegate:nil
                                                                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                     otherButtonTitles:nil];
                                               [alert show];
                                           });
                                       }
                                   }
         ];
    }
}

-(void)setReminder{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
    reminder.title = @"サンプルリマインダー";
    reminder.calendar = [eventStore defaultCalendarForNewReminders];
    
    // 期限が必要な場合
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:2016];
    [dateComponents setMonth:1];
    [dateComponents setDay:18];
    [dateComponents setHour:20];
    reminder.dueDateComponents = dateComponents;
    
    // 通知を追加
    [reminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]]];
    
    NSError *error;
    if(![eventStore saveReminder:reminder commit:YES error:&error]) NSLog(@"%@", error);

}

 */
- (void)setLocalNotification:(NSDate *)date DateName:(NSString *)dateName
{
    
    
    
    //このアプリ名義で登録しているローカル通知を削除
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    

    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    //日付、時間の設定（作成）を行う。
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    //西暦を指定
//    [comps setYear:2016];
//    //月を指定
//    [comps setMonth:1];
    //日を指定
    [comps setDay:-20];
    NSDate *result = [calendar dateByAddingComponents:comps toDate:date options:0];
    
    //曜日を指定。0が日曜日。順に行って6が土曜日。
    //[comps setWeekday:5];
    //その月の何週目に通知させるか指定する。このメソッドを追加することにより、アラームを毎週リピートにしても、第２週にお知らせしてくれる。
    //[comps setWeekOfYear:1];
    //時間を指定。+9しているのは、GMT時間を日本時間に合わせる為。
    [comps setHour:17+9];
    //分を指定
    [comps setMinute:35];
    //NSDateに上記で設定した時間を挿入する。
    
    //NSDate *date = [calendar dateFromComponents:comps];
    
    //全てのローカル通知を削除する。（過去のローカル通知を削除する）
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //ローカル通知をさせるためのインスタンスを作成。
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    //ローカル通知させる時間を設定する。ここで設定した時間に繰り返しローカル通知されるようになる。
    //NSTimeInterval span = 10;
    notification.fireDate = date;
//    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:span];
    
    //毎週アラームを通知させる。
    //notification.repeatInterval = NSWeekOfYearCalendarUnit;
    //時間をその端末のあるロケーションに合わせる。
    notification.timeZone = [NSTimeZone localTimeZone];
    //通知されたときに、アイコンの右上に数字を表示させる。
    notification.applicationIconBadgeNumber = 1;
    //ローカル通知されたときの文字を設定する。
    notification.alertBody = [NSString stringWithFormat:@"もうすぐ%@です！\nプレゼントの準備はできていますか？",dateName];
    //通知されるときの音を指定する。
    notification.soundName = UILocalNotificationDefaultSoundName;
    //画面を閉じてた時にアラームが鳴った場合、スライドに表示させる文字を設定する。
    notification.alertAction = @"OPEN";
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"通知を受信しました。" forKey:@"EventKey"];
    notification.userInfo = infoDict;
    //作成したローカル通知をアプリケーションに登録する。
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    //登録されているアラームを配列に格納する。
    NSArray *notifiyItems = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //ローカル通知に登録されている件数を表示。
    NSLog(@"登録件数：%d",[notifiyItems count]);
    for(UILocalNotification *notifiy in notifiyItems){
        //ローカル通知に登録されている、alertBodyの文字列を表示する。
        NSLog(@"[LN]:%@",[notifiy alertBody]);
    }
    
    
    
    
}


@end