//
//  SortListView.m
//  SinoCommunity
//
//  Created by df on 2017/3/21.
//  Copyright © 2017年 df. All rights reserved.
//

#import "SortListView.h"
#import "UIView+DyfAdd.h"

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define LineColor [UIColor colorWithRed:0.7019 green:0.7019 blue:0.7019 alpha:1.0]

@interface SortListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *titleBg;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UITableView *leftTableV;

@property (nonatomic, strong) UITableView *rightTableV;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSString *selectTitle;

@property (nonatomic, strong) UILabel *selectLabel;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) SortListStyle sortStyle;

@property (nonatomic, assign) NSInteger selectLeftIndex;


@end
@implementation SortListView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr andDelegateAndDataSource:(id)vc {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleArr = titleArr;
        
        self.delegate = vc;
        self.dataSource = vc;
        
        [self prepareLayout];
    }
    
    return self;
}

- (void)prepareLayout {
    
    self.titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.titleBg.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleBg];
    
    
    
    CGFloat viewWidth = (ScreenWidth - self.titleArr.count - 1) / self.titleArr.count;

    for (int i = 0; i < self.titleArr.count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1 + i * (viewWidth + 1), 0, viewWidth, self.frame.size.height)];
        
        [self.titleBg addSubview:label];
        
        label.userInteractionEnabled = YES;
        
        label.tag = 1000 + i;
        
        label.textColor = i == 0 ? [UIColor blackColor] : LineColor;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = self.titleArr[i];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        
        [label addGestureRecognizer:tap];
        
        if ([self.dataSource haveSplitLineInTitle] && i != self.titleArr.count - 1) {
            
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) - 1, self.frame.size.height/4, 1, self.frame.size.height/2)];
            
            [self.titleBg addSubview:lineV];
            
            if ([self.dataSource respondsToSelector:@selector(splitLineColor)]) {
                
                lineV.backgroundColor = [self.dataSource splitLineColor];
                
            }else {
                
                lineV.backgroundColor = [UIColor colorWithWhite:0.855 alpha:1.000];
            }
        }
        
    }

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.sortStyle == SortListStyleOne) {
        
        if ([self.delegate respondsToSelector:@selector(numberOfRowInSortListView:andTitle:)]) {
            
            return [self.dataSource numberOfRowInSortListView:self andTitle:self.selectTitle];
            
        }else {
            
            return 0;
        }
    }else {
        
        if (tableView  == self.leftTableV) {
            
            if ([self.dataSource respondsToSelector:@selector(numberOfRowInSortListView:withList:andCurrentIndex:)]) {
                
                
                return [self.dataSource numberOfRowInSortListView:self withList:(SortListTableViewStateLeft) andCurrentIndex:0];
            }else {
                
                return 0;
            }

        }else {
            
            if ([self.dataSource respondsToSelector:@selector(numberOfRowInSortListView:withList:andCurrentIndex:)]) {
                
                
                return [self.dataSource numberOfRowInSortListView:self withList:(SortListTableViewStateRight) andCurrentIndex:self.selectLeftIndex];
            }else {
                
                return 0;
            }

        }
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.sortStyle == SortListStyleOne) {
        
        SortListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftSortListCell" forIndexPath:indexPath];
        
        if ([self.delegate respondsToSelector:@selector(sortListView:detailTextForRowAtIndexPath:andTitle:)]) {
            
            [cell setLeftText:[self.dataSource sortListView:self detailTextForRowAtIndexPath:indexPath andTitle:self.selectTitle] andSelectText:self.selectTitle];
        }
        
        return cell;
        
    }else if (tableView == self.leftTableV) {
        
        SortListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftSortListCell" forIndexPath:indexPath];
        
        if ([self.delegate respondsToSelector:@selector(sortLeftListView:detailTextForRowAtIndexPath:)]) {
            
            [cell setLeftText:[self.dataSource sortLeftListView:self detailTextForRowAtIndexPath:indexPath] andSelectText:self.selectTitle];
        }
        
        return cell;
        
    }else {
        
        SortListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightSortListCell" forIndexPath:indexPath];
        
        if ([self.delegate respondsToSelector:@selector(sortRightListView:detailTextForRowAtIndexPath:andLeftSlectIndex:)]) {
            
            [cell setLeftText:[self.dataSource sortRightListView:self detailTextForRowAtIndexPath:indexPath andLeftSlectIndex:self.selectLeftIndex] andSelectText:self.selectTitle];
        }
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.sortStyle == SortListStyleOne) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemWithIndex:)]) {
            
            self.selectLabel.text = [self.delegate selectItemWithIndex:indexPath.row];
            self.selectLabel.textColor = [UIColor blackColor];
        }
        
        
        [self dismiss];
        
    }else {
        
        if (tableView == self.leftTableV) {
            
//            [self.leftTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            
            self.selectLeftIndex = indexPath.row;
            
            [self.rightTableV reloadData];
            
        }else if (tableView == self.rightTableV) {
            
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemWithIndex:andSelectLeftIndex:)]) {
                
                self.selectLabel.text = [self.delegate selectItemWithIndex:indexPath.row andSelectLeftIndex:self.selectLeftIndex];
                self.selectLabel.textColor = [UIColor blackColor];
            }
            
            
            [self dismiss];

        }
    }
    
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    

    
    self.selectTitle =  [(UILabel *)tap.view text];
    self.selectLabel = (UILabel *)tap.view;
    
    for (UIView *subview in self.titleBg.subviews) {
        
        if ([subview isKindOfClass:[UILabel class]]) {
            
            [(UILabel *)subview setTextColor: LineColor];
            
        }
        
    }
    
    [(UILabel *)tap.view setTextColor:[UIColor blackColor]];
    
    [self dismiss];
    
    self.sortStyle = [self.dataSource haveTableViewListInColumn:tap.view.tag - 1000];
    
    switch (self.sortStyle) {
            
        case SortListStyleNone:
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemWithTitle:)]) {
                
                [self.delegate selectItemWithTitle:[(UILabel *)tap.view text]];
            }

            break;
        case SortListStyleOne:
            
            if (!self.isShow) {
                
                [self showListHaveRightList:NO];
                
                [self.leftTableV reloadData];
                
                
            }else {
                
                [self dismiss];
            }

            
            break;
        case SortListStyleTwo:
            
            [self showListHaveRightList:YES];
            
            [self.leftTableV reloadData];
            
            [self.leftTableV selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];

            break;
            
        default:
            break;
    }
    
    
}

- (void)dismiss {
    
    [self.bgView removeFromSuperview];
    
    self.bgView = nil;
    
    self.height = 40;
    
    self.isShow = NO;
}

- (void)showListHaveRightList:(BOOL)show {
    
    self.height = ScreenHeight;
    
    self.isShow = YES;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, ScreenHeight - 40)];
    
    self.bgView.backgroundColor = [UIColor colorWithRed:0.7019 green:0.7019 blue:0.7019 alpha:0.4];
    
    [self addSubview:self.bgView];
    
    [self bringSubviewToFront:self.titleBg];

    
    CGFloat height = show == YES ? ScreenHeight/3 : [self.dataSource numberOfRowInSortListView:self andTitle:self.selectTitle] * 50 > ScreenHeight/2 ? ScreenHeight/2 : [self.dataSource numberOfRowInSortListView:self andTitle:self.selectTitle] * 50;
    
    CGFloat width = show == NO ? self.width : self.width / 4;
    
    self.leftTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, 0) style:(UITableViewStylePlain)];
    [self.bgView addSubview:self.leftTableV];
    
    self.leftTableV.tableFooterView = [UIView new];
    
    self.leftTableV.delegate = self;
    self.leftTableV.dataSource = self;
    
    [self.leftTableV registerClass:[SortListCell class] forCellReuseIdentifier:@"leftSortListCell"];
    
    if (show) {
        
        self.rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(self.width / 4, 0, self.width/4*3, 0) style:(UITableViewStylePlain)];
        
        [self.bgView addSubview:self.rightTableV];
        
        self.rightTableV.tableFooterView = [UIView new];
        
        self.rightTableV.delegate = self;
        self.rightTableV.dataSource = self;
        
        [self.rightTableV registerClass:[SortListCell class] forCellReuseIdentifier:@"rightSortListCell"];
        
        self.selectLeftIndex = 0;
    }
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.leftTableV.frame = CGRectMake(0, 0, self.width, height);
        
        if (show) {
            self.rightTableV.frame = CGRectMake(self.width/4, 0, self.width/4*3, height);
        }
        
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if(!CGRectContainsPoint(self.leftTableV.frame, [touch locationInView:self])){
        
        [self dismiss];
    }
}


@end

@interface SortListCell ()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIImageView *rightImg;

@end

@implementation SortListCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self prepareLayoutCell];
    }
    return self;
}

- (void)prepareLayoutCell {
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, self.contentView.height)];
    
    [self.contentView addSubview:self.leftLabel];
    
    self.leftLabel.text = @"测试";
    
    self.rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.right - 35, 0, 15, 15)];
    
    
    self.rightImg.image = [UIImage imageNamed:@"ico_make"];
    
    self.rightImg.centerY = self.contentView.centerY;
    
    self.rightImg.hidden = YES;
    
    [self.contentView addSubview:self.rightImg];
}

- (void)setLeftText:(NSString *)text andSelectText:(NSString *)selectText {
   
    self.leftLabel.text = text;
    
    [text isEqualToString:selectText] ? (self.rightImg.hidden = NO) : (self.rightImg.hidden = YES);
    
}

@end
