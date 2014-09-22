//
//  IZValueSelectorView.h
//  IZValueSelector
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IZValueSelectorView;

@protocol IZValueSelectorViewDelegate <NSObject>

- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index;
@optional
- (void)selector:(IZValueSelectorView *)valueSelector selectorPassRowAtIndex:(NSInteger)index;
@end

@protocol IZValueSelectorViewDataSource <NSObject>
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector;
- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger) index;
- (UIView*)selectorViewForSelectorView:(IZValueSelectorView *)valueSelector;
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector;
- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector;
@end



@interface IZValueSelectorView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDelegate> delegate;
@property (nonatomic,assign) IBOutlet id <IZValueSelectorViewDataSource> dataSource;
@property (nonatomic,assign) BOOL shouldBeTransparent;
@property (nonatomic,assign) BOOL horizontalScrolling;

@property (nonatomic,assign) BOOL debugEnabled;

- (void)selectItemAtIndex:(NSInteger)index;
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (NSInteger)currentSelectedIndex;
- (void)reloadData;

@end
