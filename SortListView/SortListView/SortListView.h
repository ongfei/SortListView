//
//  SortListView.h
//  SinoCommunity
//
//  Created by df on 2017/3/21.
//  Copyright © 2017年 df. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

@class SortListView;

typedef enum : NSUInteger {
    SortListStyleNone,
    SortListStyleOne,
    SortListStyleTwo,
} SortListStyle;

typedef enum : NSUInteger {
    SortListTableViewStateLeft,
    SortListTableViewStateRight,
} SortListTableViewState;

@protocol SortListViewDataSource <NSObject>

@required

//单列表
- (NSInteger)numberOfRowInSortListView:(SortListView *)sortList andTitle:(NSString *)title;

- (NSString *)sortListView:(SortListView *)sortList detailTextForRowAtIndexPath:(NSIndexPath *)indexPath andTitle:(NSString *)title;

//是否有列表
- (SortListStyle)haveTableViewListInColumn:(NSInteger)column;
//是否有分割线
- (BOOL)haveSplitLineInTitle;

@optional

- (UIColor *)splitLineColor;

//双列表
- (NSInteger)numberOfRowInSortListView:(SortListView *)sortList withList:(SortListTableViewState)state andCurrentIndex:(NSInteger)index;

- (NSString *)sortLeftListView:(SortListView *)sortList detailTextForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)sortRightListView:(SortListView *)sortList detailTextForRowAtIndexPath:(NSIndexPath *)indexPath andLeftSlectIndex:(NSInteger)index;

@end

@protocol SortListViewDelegate <NSObject>

- (void)selectItemWithTitle:(NSString *)title;

- (NSString *)selectItemWithIndex:(NSInteger)index;
- (NSString *)selectItemWithIndex:(NSInteger)index andSelectLeftIndex:(NSInteger)leftIndex;

@end

@interface SortListView : UIView

@property (nonatomic, weak) id<SortListViewDelegate> delegate;
@property (nonatomic, weak) id<SortListViewDataSource> dataSource;


- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr andDelegateAndDataSource:(id)vc;

//- (void)reloadData;

- (void)dismiss;

@end

@interface SortListCell : UITableViewCell

- (void)setLeftText:(NSString *)text andSelectText:(NSString *)selectText;

@end
