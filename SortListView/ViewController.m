//
//  ViewController.m
//  SortListView
//
//  Created by df on 2017/4/10.
//  Copyright © 2017年 df. All rights reserved.
//

#import "ViewController.h"
#import "SortListView.h"

@interface ViewController ()<SortListViewDelegate,SortListViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    SortListView *sortList = [[SortListView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 40) andTitleArr:@[@"好评优先",@"人气优先",@"最新发布",@"筛选"]  andDelegateAndDataSource:self];
    
    [self.view addSubview:sortList];
}



- (NSInteger)numberOfRowInSortListView:(SortListView *)sortList withList:(SortListTableViewState)state andCurrentIndex:(NSInteger)index {
    
    if (state == SortListTableViewStateLeft) {
        
        return 3;
    }else {
        
        switch (index) {
            case 0:
                return 3;
                break;
            case 1:
                return 2;
                break;
            case 2:
                return 4;
                break;
            default:
                return 0;
                break;
        }
        
    }
}

- (NSInteger)numberOfRowInSortListView:(SortListView *)sortList andTitle:(NSString *)title {
    
    return 3;
}

- (NSString *)sortLeftListView:(SortListView *)sortList detailTextForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @[@"区域",@"分类",@"价格"][indexPath.row];
    
}

- (NSString *)sortRightListView:(SortListView *)sortList detailTextForRowAtIndexPath:(NSIndexPath *)indexPath andLeftSlectIndex:(NSInteger)index {
    
    return @[@[@"aa",@"bb",@"cc"],@[@"dd",@"ee"],@[@"ff",@"gg",@"hh",@"jj"]][index][indexPath.row];
}

- (NSString *)sortListView:(SortListView *)sortList detailTextForRowAtIndexPath:(NSIndexPath *)indexPath andTitle:(NSString *)title {
    
    
    
    return @[@"a",@"b",@"c"][indexPath.row];
}

- (NSString *)selectItemWithIndex:(NSInteger)index {
    
    NSLog(@"select %@",@[@"a",@"b",@"c"][index]);
    
    return @[@"a",@"b",@"c"][index];
;
}

- (NSString *)selectItemWithIndex:(NSInteger)index andSelectLeftIndex:(NSInteger)leftIndex {
    
    NSLog(@"select %@",@[@[@"aa",@"bb",@"cc"],@[@"dd",@"ee"],@[@"ff",@"gg",@"hh",@"jj"]][leftIndex][index]);
    
    return @[@[@"aa",@"bb",@"cc"],@[@"dd",@"ee"],@[@"ff",@"gg",@"hh",@"jj"]][leftIndex][index];
}

- (void)selectItemWithTitle:(NSString *)title {
    
    NSLog(@"%@",title);
    
}

- (BOOL)haveSplitLineInTitle {
    
    return YES;
}

- (SortListStyle)haveTableViewListInColumn:(NSInteger)column {
    
    if (column == 3) {
        
        return SortListStyleTwo;
        
    }else if(column == 2) {
        
        return SortListStyleOne;
        
    }else {
        
        return 0;
    }
}



@end
