//
//  KYSDatePickerView.m
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSDatePickerView.h"
#import "NSDate+KYSAddition.h"

@interface KYSDatePickerView()

@property(nonatomic,weak) UIWindow *window;
@property (nonatomic,strong) UIView *selectView;
@property (nonatomic,strong) UIDatePicker *datePicker;

@end


@implementation KYSDatePickerView

+ (instancetype)KYSShowWithCompleteBlock:(KYSDatePickerViewCompleteSelectedBlock)selectedBlock{
    KYSDatePickerView *datePickerView=[[KYSDatePickerView alloc] init];
    datePickerView.selectedBlock=selectedBlock;
    [datePickerView KYSShow];
    return datePickerView;
}

- (instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.15];
        self.frame=self.window.bounds;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
        self.datePickerMode=UIDatePickerModeDate;
        
        //黑色半透明北京
        _selectView=[[UIView alloc] init];
        _selectView.backgroundColor=[UIColor whiteColor];
        _selectView.frame=CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180);
        _selectView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_selectView];
        
        //左侧取消按钮
        UIButton *btn1=[[UIButton alloc] init];
        btn1.tag=1;
        btn1.frame=CGRectMake(0, 0, 50, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        btn1.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn1 setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn1];
        
        //右侧确定按钮
        UIButton *btn2=[[UIButton alloc] init];
        btn2.tag=2;
        btn2.frame=CGRectMake(self.frame.size.width-50, 0, 50, 40);
        [btn2 setTitle:@"确定" forState:UIControlStateNormal];
        btn2.titleLabel.font=[UIFont systemFontOfSize:17.0];
        [btn2 setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn2];
        
        [self p_setPickerView];
        
    }
    return self;
}


- (void)KYSShow{
    [self.window addSubview:self];
    self.selectView.frame=[self hideSelectViewFrame];
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=[self showSelectViewFrame];
    } completion:^(BOOL finished) {
        self.selectView.frame=[self showSelectViewFrame];
    }];
}

- (void)KYSHide{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame=[self hideSelectViewFrame];
    } completion:^(BOOL finished) {
        self.selectView.frame=[self hideSelectViewFrame];
        [self removeFromSuperview];
    }];
}

- (void)KYSReloadData{
    
    _datePicker.datePickerMode=self.datePickerMode;
    
    // 默认日期
    if (self.currentDate) {
        if ([self.currentDate earlierDate:_datePicker.minimumDate]) {
            self.currentDate = _datePicker.minimumDate;
        } else if ([self.currentDate laterDate:_datePicker.minimumDate]) {
            self.currentDate = _datePicker.maximumDate;
        }
        _datePicker.date=self.currentDate;
    }
    // 最小时间
    if (self.minimumDate) {
        _datePicker.minimumDate=self.minimumDate;
    }
    // 最大时间
    if (self.maximumDate) {
        _datePicker.maximumDate=self.maximumDate;
    }
}

#pragma mark - Action
- (void)tap{
    [self p_getSelected];
    [self KYSHide];
}

- (void)btnAction:(UIButton *)btn{
    if(2==btn.tag){
        [self p_getSelected];
    }else if(1==btn.tag){

    }
    [self KYSHide];
}


#pragma mark - private
- (void)p_setPickerView{
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.frame=CGRectMake(0, 30, _selectView.frame.size.width, _selectView.frame.size.height-30);
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
//    _datePicker.minimumDate = [NSDate getLastMonth];
    _datePicker.maximumDate = [NSDate date];
    [_selectView addSubview:self.datePicker];
}

- (void)p_getSelected{
    if (self.selectedBlock) {
        self.selectedBlock(_datePicker.date);
    }
}

#pragma mark -
- (CGRect)showSelectViewFrame{
    return CGRectMake(0, CGRectGetHeight(self.frame)-180, CGRectGetWidth(self.frame), 180);
}

- (CGRect)hideSelectViewFrame{
    return CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 180);
}

// 获取当前处于activity状态的Window
- (UIWindow *)window{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows){
            if(tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

@end
