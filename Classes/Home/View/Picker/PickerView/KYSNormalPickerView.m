//
//  KYSNormalPickerView.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 2016/11/17.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNormalPickerView.h"
#import "KYSPickerView.h"


@interface KYSNormalPickerView()<KYSPickerViewDelegate,KYSPickerViewDataSource>

@property(nonatomic,weak) UIWindow *window;

@property(nonatomic,strong) KYSPickerView *pickerView;

@end

@implementation KYSNormalPickerView


+ (instancetype)KYSShowWithDataArray:(NSArray *)dataArray
                       completeBlock:(KYSLinkagePickerViewCompleteSelectedBlock)selectedBlock {
    
    KYSNormalPickerView *normalPickerView = [[KYSNormalPickerView alloc] init];
    normalPickerView.dataArray = dataArray;
    normalPickerView.selectedBlock = selectedBlock;
    [normalPickerView KYSShow];
    return normalPickerView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = self.window.bounds;
        [self addSubview:self.pickerView];
    }
    return self;
}

- (void)KYSShow{
    [self.window addSubview:self];
    [self.pickerView KYSReloadData];
    [self.pickerView KYSShow];
}

#pragma mark - KYSPickerViewDelegate
- (void)hideWithPickerView:(KYSPickerView *)pickerView {
    NSLog(@"hideWithPickerView:");
    [self removeFromSuperview];
}

- (void)KYSPickerView:(KYSPickerView *)pickerView selectedIndexInComponents:(NSArray *)selectedIndexInComponents {
    NSLog(@"selectedIndexInComponents:");
    if (self.selectedBlock) {
        self.selectedBlock(selectedIndexInComponents);
    }
}


#pragma mark - KYSPickerViewNormalDataSource
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView{
    return [self.dataArray count];
}

//配置数据源
- (NSArray *)KYSPickerView:(KYSPickerView *)pickerView dataInComponent:(NSInteger)component{
    return self.dataArray[component];
}

//默认选中哪一项
- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView selectedIndexInComponent:(NSInteger)component{
    //NSLog(@"默认选中哪一项 component：%ld,selected：%ld",(long)component,(long)[self.selectedIndexInComponents[component] integerValue]);
    return [self.selectedIndexInComponents[component] integerValue];
}

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component<self.widthInComponents.count) {
        return [self.widthInComponents[component] integerValue];
    }
    return CGRectGetWidth(self.frame)/self.dataArray.count;
}

- (NSInteger)KYSPickerView:(KYSPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    if (component<self.heightInComponents.count) {
        return [self.heightInComponents[component] integerValue];
    }
    return 30;
}

#pragma mark - lazy load
- (KYSPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView=[[KYSPickerView alloc] initWithFrame:self.bounds];
        //_pickerView.backgroundColor=[UIColor clearColor];
        _pickerView.delegate=self;
        _pickerView.normalDataSource=self;
    }
    return _pickerView;
}

- (NSMutableArray *)selectedIndexInComponents {
    if (!_selectedIndexInComponents) {
        _selectedIndexInComponents=[NSMutableArray arrayWithCapacity:self.dataArray.count];
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            [_selectedIndexInComponents addObject:@(0)];
        }
    }else{
        //如果 selectedIndexInComponents 元素个数小于 self.dataArray.count 增加元素至 self.dataArray.count 个
        if (_selectedIndexInComponents.count<self.dataArray.count) {
            for (NSInteger i=_selectedIndexInComponents.count; i<self.dataArray.count; i++) {
                [_selectedIndexInComponents addObject:@(0)];
            }
        }
    }
    return _selectedIndexInComponents;
}

#pragma mark - private
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
