//
//  NYPullToRefresh.h
//  NYPullToRefresh Demo
//
//  Created by Cassius Pacheco on 11/10/12.
//  Copyright (c) 2012 Nyvra Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYPullToRefresh : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

- (void)beginRefreshing;
- (void)endRefreshing;
- (void)triggerRefresh;
- (void)triggerAction;

@end

@interface UITableViewController (NYPullToRefresh)

@property (nonatomic, strong) NYPullToRefresh   *pullToRefresh;

- (void)addPullToRefreshWithAction:(void (^)(void))action;

@end
