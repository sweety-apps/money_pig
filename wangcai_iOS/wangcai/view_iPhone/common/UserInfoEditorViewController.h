//
//  UserInfoEditorViewController.h
//  wangcai
//
//  Created by Lee Justin on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "IZValueSelectorView.h"

@interface UserInfoEditorViewController : BeeUIBoard <IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>
{
    CGRect _rectSelectBgView;
    NSMutableArray* _interestIds;
}

@property (nonatomic,retain) IBOutlet UIView* upSectionView;
@property (nonatomic,retain) IBOutlet UIView* downSectionView;
@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;

@property (nonatomic,retain) IBOutlet IZValueSelectorView* ageSelectorView;
@property (nonatomic,retain) IBOutlet UIView* selectionContainerView;

@property (nonatomic,retain) IBOutlet UIButton* sexMaleButton;
@property (nonatomic,retain) IBOutlet UIButton* sexFamaleButton;
@property (nonatomic,retain) NSMutableArray* hobbySelectorViews;

@property (nonatomic,retain) IBOutlet UIView* commitButtonView;
@property (nonatomic,retain) IBOutlet UIButton* commitButton;
@property (nonatomic,retain) IBOutlet UIImageView* commitButtonRedBag;

@property (nonatomic,retain) IBOutlet UIView* bindPhoneView;

- (IBAction)onPressedAttachPhone:(id)btn;
- (IBAction)onPressedBackPhone:(id)btn;

- (IBAction)onPressedMaleButton:(id)btn;
- (IBAction)onPressedFamaleButton:(id)btn;

- (IBAction)onPressedCommitButton:(id)btn;

- (void)showUpSectionView:(BOOL)shouldShow;

@end
