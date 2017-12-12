//
//  KYSLinkagePickerView.m
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSLinkagePickerView.h"
#import "KYSPickerView.h"

@interface KYSLinkagePickerView()<KYSPickerViewDelegate,KYSPickerViewDataSource>

@property(nonatomic,weak) UIWindow *window;
@property(nonatomic,strong) KYSPickerView *pickerView;
@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,copy)KYSLinkagePickerViewCompleteSelected completeBlock;//选择完成回调

@end


@implementation KYSLinkagePickerView

+ (instancetype)KYSShowWithAnalyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData)analyzeBlock
                          completeBlock:(KYSLinkagePickerViewCompleteSelected)completeBlock{
    KYSLinkagePickerView *linkagePickerView=[[KYSLinkagePickerView alloc] init];
    [linkagePickerView setDataArrayWithAnalyzeBlock:analyzeBlock];
    linkagePickerView.completeBlock=completeBlock;
    [linkagePickerView KYSShow];
    return linkagePickerView;
}

- (instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.frame=self.window.bounds;
        [self addSubview:self.pickerView];
    }
    return self;
}

- (void)setDataArrayWithAnalyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData) block{
    self.dataArray=block();
}

- (void)KYSShow{
    [self.window addSubview:self];
    [self.pickerView KYSReloadData];
    [self.pickerView KYSShow];
}

#pragma mark - KYSPickerViewDelegate
- (void)hideWithPickerView:(KYSPickerView *)pickerView{
    NSLog(@"hideWithPickerView:");
    [self removeFromSuperview];
}

- (void)KYSPickerView:(KYSPickerView *)pickerView selectedIndexInComponents:(NSArray *)selectedIndexInComponents{
    if (self.completeBlock) {
        self.completeBlock(selectedIndexInComponents);
    }
}


//选中动画结束位置
- (void)KYSPickerView:(KYSPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //NSLog(@"动画停留位置start component：%ld,selected：%ld",(long)component,(long)row);
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        //之前的不变
        if (i < component) {
            continue;
        }
        //刷新后边的
        if (i==component) {
            [self.selectedIndexInComponents replaceObjectAtIndex:i withObject:@(row)];
        }else{
            [self.selectedIndexInComponents replaceObjectAtIndex:i withObject:@(-1)];
        }
    }
    //最后一个component不用刷新
    if (component == (self.dataArray.count-1)) {
        return;
    }
    //刷新之后的Component
    //NSLog(@"刷新之后的Component");
    [self.pickerView KYSReloadData];
}

#pragma mark - KYSPickerViewNormalDataSource
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView{
    return [self.dataArray count];
}

//配置数据源
- (NSArray *)KYSPickerView:(KYSPickerView *)pickerView dataInComponent:(NSInteger)component{
    //NSLog(@"获取数据源0：componentIndex：%ld",(long)component);
    if (component >= self.dataArray.count) {
        return nil;
    }
    
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        if (i == component) {
            if (-1==[self.selectedIndexInComponents[component] integerValue]) {
                [self.selectedIndexInComponents replaceObjectAtIndex:component withObject:@(0)];
            }
            break;
        }
    }
    //选择数据源
    NSArray *cArray=self.dataArray[component];
    for (NSInteger i=0; i < component; i++) {
        //NSLog(@"%@",cArray);
        cArray=cArray[[self.selectedIndexInComponents[i] integerValue]];
    }
    return cArray;
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

- (NSMutableArray *)selectedIndexInComponents{
    if (!_selectedIndexInComponents) {
        _selectedIndexInComponents=[NSMutableArray arrayWithCapacity:self.dataArray.count];
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            [_selectedIndexInComponents addObject:@(-1)];
        }
    }else{
        //如果 selectedIndexInComponents 元素个数小于 self.dataArray.count 增加元素至 self.dataArray.count 个
        if (_selectedIndexInComponents.count<self.dataArray.count) {
            for (NSInteger i=_selectedIndexInComponents.count; i<self.dataArray.count; i++) {
                [_selectedIndexInComponents addObject:@(-1)];
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
