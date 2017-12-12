//
//  JPCertificateInfoViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/23.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCertificateInfoViewController.h"
#import "JPCollectionReusableView.h"
#import "JPPhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JPCommitSucViewController.h"

@interface JPCertificateInfoViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JPPhotoView      *photoView;
@property (nonatomic, strong) NSIndexPath      *selectIndexPath;
@property (nonatomic, strong) UIView           *navImageView;
@property (nonatomic, strong) JPDocumentsModel *documentsModel;
@property (nonatomic, strong) JPCollectFooterView *footerView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

static NSString *const collectCellReuseIdentifier = @"collectCellReuseIdentifier";
static NSString *const headerViewReuseIdentifier = @"headerView";
static NSString *const footerViewReuseIdentifier = @"footerView";

@implementation JPCertificateInfoViewController

//  证件资料列表信息获取
- (void)createRequestWithType:(NSString *)type {
    [SVProgressHUD showWithStatus:@"信息加载中，请稍后..."];
//    [self canDoSthInView:NO];
    weakSelf_declare;
    [JPNetTools1_0_2 getInfoListWithType:type callback:^(NSString *code, NSString *msg, id resp) {
        NSLog(@"证件资料列表信息获取 %@ - %@ - %@", code, msg, resp);
        if ([code isEqualToString:@"00"]) {
            //  成功
            if ([resp isKindOfClass:[NSDictionary class]]) {
                
                weakSelf.documentsModel = [JPDocumentsModel yy_modelWithJSON:resp];
                [weakSelf.dataSource removeAllObjects];
                for (JPCertificateData *certificateData in weakSelf.documentsModel.data) {
                    for (JPImageModel *imgModel in certificateData.imgList) {
                        [weakSelf.dataSource addObject:imgModel];
                    }
                    weakSelf.footerView.confirmButton.enabled = YES;
                    weakSelf.footerView.confirmButton.backgroundColor = JPBaseColor;
                }
            }
        } else {
            //  失败
            [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
            weakSelf.footerView.confirmButton.enabled = NO;
            weakSelf.footerView.confirmButton.backgroundColor = [UIColor lightGrayColor];
        }
        [weakSelf.collectionView reloadData];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - lazy
- (JPPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [[JPPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _photoView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        float margin = JPRealValue(30);
        // !!!: flowLayout布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = (CGSize){(kScreenWidth - margin * 3) /2.0, JPRealValue(220)};
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = margin;
        //  设置item的偏移量
        flowLayout.sectionInset = (UIEdgeInsets){0, JPRealValue(45), 0, JPRealValue(15)};
        //  设置collectionView的headerView
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, JPRealValue(340));
        //  设置collectionView的footerView
        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, JPRealValue(380));
        
        // !!!: CollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = JP_viewBackgroundColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[JPCredentialsCell class] forCellWithReuseIdentifier:collectCellReuseIdentifier];
        //  注册collectionView的headerView
        [_collectionView registerClass:[JPCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewReuseIdentifier];
        //  注册collectionView的footerView
        [_collectionView registerClass:[JPCollectFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewReuseIdentifier];
    }
    return _collectionView;
}

- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    //    _navImageView.alpha = 0;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"证件信息";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [_navImageView addSubview:titleLab];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
    [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:leftButton];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
    NSInteger type = self.isEnterprise ? 0 : self.hasLicence ? 1 : 2;
    [self createRequestWithType:[NSString stringWithFormat:@"%ld", (long)type]];
    
    [self layoutHomeView];
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPCredentialsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectCellReuseIdentifier forIndexPath:indexPath];
    cell.canEditing = NO;
    
    JPImageModel *imgModel = self.dataSource[indexPath.row];
    cell.imgCode = imgModel.imgDesc;
    cell.isNeed = imgModel.isNeed;
    cell.placeholderName = imgModel.imgDesc;
    
    cell.image = [UIImage imageWithData:[JPUserInfoHelper objectForKey:imgModel.imgDesc]];
    return cell;
}

#pragma mark - collectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //  HeaderView
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JPCollectHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewReuseIdentifier forIndexPath:indexPath];
        return headerView;
    }
    //  FooterView
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewReuseIdentifier forIndexPath:indexPath];
        weakSelf_declare;
        // !!!: 确定提交
        self.footerView.jp_commitUserInfoBlock = ^{
            
            weakSelf.view.userInteractionEnabled = NO;
            
            for (NSInteger j = 0; j < weakSelf.dataSource.count; j ++) {
                JPCredentialsCell *cell = (JPCredentialsCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                if (!cell.hasImage && cell.isNeed) {
                    [SVProgressHUD showInfoWithStatus:@"证件资料缺失，请补齐资料后重新提交！"];
                    weakSelf.view.userInteractionEnabled = YES;
                    return;
                }
            }
            
            dispatch_group_t group = dispatch_group_create();
            
            for (NSInteger i = 0; i < weakSelf.dataSource.count; i ++) {
                
                JPCredentialsCell *cell = (JPCredentialsCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                if (cell.hasImage) {
                    
                    [weakSelf logImageLengthWithImage:cell.bgView.image];
                    [SVProgressHUD showWithStatus:@"进件信息提交中，请耐心等待"];
                    
                    dispatch_group_enter(group);
                    [JPNetTools1_0_2 uploadImage:cell.bgView.image isUpdate:false checkContent:weakSelf.qrcodeid tagStr:cell.imgCode progress:nil callback:^(NSString *code, NSString *msg, id resp) {
                        JPLog(@"图片上传 %@ - %@ - %@", code, msg, resp);
                        if ([code isEqualToString:@"00"]) {
                            
                            for (JPCertificateData *dataModel in weakSelf.documentsModel.data) {
                                for (JPImageModel *imgModel in dataModel.imgList) {
                                    if ([imgModel.imgDesc isEqualToString:msg]) {
                                        [imgModel setUrl:resp];
                                    }
                                }
                            }
                        } else {
                            [SVProgressHUD showInfoWithStatus:@"网络异常，请重新提交！"];
                            weakSelf.view.userInteractionEnabled = YES;
                        }
                        dispatch_group_leave(group);
                    }];
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                //  请求完毕后的处理                
                //  Model转dictionary
                NSDictionary *dic = [JPTransferMJ getObjectData:weakSelf.documentsModel];
                
                NSLog(@"dic - %@", dic);
                NSArray *dataArray = dic[@"data"];
                
                NSString *merchantCategory = weakSelf.isEnterprise ? @"1" : @"2";
                NSString *certificateImgType = weakSelf.isEnterprise ? @"0" : weakSelf.hasLicence ? @"1" : @"2";
                NSString *accountType = weakSelf.isPublic ? @"1" : @"2";
                
                [MobClick event:@"credentialsCommit"];
                
                [JPNetTools1_0_2 commitWithMerchantCategory:merchantCategory
                                         certificateImgType:certificateImgType
                                               merchantName:weakSelf.merchantName
                                          merchantShortName:weakSelf.merchantShortName
                                       registerProvinceCode:weakSelf.registerProvince
                                           registerCityCode:weakSelf.registerCity
                                       registerDistrictCode:weakSelf.registerCounty
                                            registerAddress:weakSelf.detailAddress
                                               industryType:weakSelf.mainIndustry
                                                        mcc:weakSelf.mcc
                                                 industryNo:weakSelf.secondaryIndustry
                                            legalPersonName:weakSelf.legalName
                                                   username:weakSelf.userName
                                              accountIdcard:weakSelf.IDCardNumber
                                                accountType:accountType
                                        accountProvinceCode:weakSelf.accountProvinceName
                                            accountCityCode:weakSelf.accountCityName
                                          accountBankNameId:weakSelf.bankName
                                             alliedBankCode:weakSelf.alliedBankCode
                                      accountBankBranchName:weakSelf.accountBankBranchName
                                                    account:weakSelf.account
                                                accountName:weakSelf.accountUserName
                                         contactMobilePhone:weakSelf.contactMobilePhone
                                                   qrcodeId:weakSelf.qrcodeid
                                                 merchantId:@""
                                                     remark:weakSelf.remark
                                                       imgs:dataArray
                                                   callback:^(NSString *code, NSString *msg, id resp) {
                    JPLog(@"商户进件信息提交 - %@ - %@ - %@", code, msg, resp);
                    if ([code isEqualToString:@"00"]) {
                        [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
                        
                        JPCommitSucModel *model = [JPCommitSucModel yy_modelWithDictionary:resp];
                        JPCommitSucViewController *commitSucVC = [[JPCommitSucViewController alloc] init];
                        commitSucVC.userName = model.userName;
                        commitSucVC.password = model.password;
                        [weakSelf.navigationController pushViewController:commitSucVC animated:YES];
                        
                        [JP_UserDefults setObject:model.userName forKey:@"userLogin"];
//                        [JP_UserDefults setObject:model.password forKey:@"passLogin"];
                        
                        [JPUserInfoHelper clearData];
                    } else {
                        [SVProgressHUD showInfoWithStatus:@"网络异常，请重新提交！"];
                    }
                    //  让collectionView可操作
                    weakSelf.view.userInteractionEnabled = YES;
                }];
            });
        };
        // !!!: 返回上一步
        self.footerView.jp_backBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        return self.footerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view.window addSubview:self.photoView];
    self.selectIndexPath = indexPath;
    
    weakSelf_declare;
    self.photoView.jp_takePhotoBlock = ^{
        // !!!: 调用相机
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerC.showsCameraControls = YES;
        pickerC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerC.delegate = weakSelf;
        [weakSelf presentViewController:pickerC animated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }];
    };
    self.photoView.jp_accessAlbumBlock = ^{
        // !!!: 调用相册
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerC.delegate = weakSelf;
        [weakSelf presentViewController:pickerC animated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }];
    };
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    weakSelf_declare;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        UIImage *compressedImage = [UIImage imageWithData:imageData];
        
        UIImage *scaleImage = [compressedImage jp_scaleToTargetWidth:kScreenWidth];
        
        JPCredentialsCell *cell = (JPCredentialsCell *)[weakSelf.collectionView cellForItemAtIndexPath:weakSelf.selectIndexPath];
        cell.image = scaleImage;
        [JPUserInfoHelper addObject:UIImageJPEGRepresentation(scaleImage, 1) forKey:cell.imgCode];
    }];
}

#pragma mark - Action
//  返回
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航栏渐变效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat borderLine = 64;
    if (scrollView.contentOffset.y < borderLine && scrollView.contentOffset.y > 0) {
        _navImageView.alpha = scrollView.contentOffset.y / borderLine;
    } else if (scrollView.contentOffset.y >= borderLine) {
        _navImageView.alpha = 0;
    } else if (scrollView.contentOffset.y <= 0) {
        _navImageView.alpha = 1;
    }
}

//  是否可操作，用于提交信息时，保证提交的同时不能作修改
//- (void)canDoSthInView:(BOOL)canDo {
//    self.collectionView.userInteractionEnabled = canDo;
//}

- (void)logImageLengthWithImage:(UIImage *)image {
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"length -- %ld", (unsigned long)imageData.length);
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
