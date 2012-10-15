//
//  NYPullToRefresh.m
//  NYPullToRefresh Demo
//
//  Created by Cassius Pacheco on 11/10/12.
//  Copyright (c) 2012 Nyvra Software. All rights reserved.
//

#import "NYPullToRefresh.h"
#import "SVPullToRefresh.h"

@interface NYPullToRefresh()
{
    UITableViewController   *tableViewController;
    BOOL                    refreshing;
    void (^action)(void);
}

- (void)addAction:(void (^)(void))action tableViewController:(UITableViewController *)controller;

@end

@implementation NYPullToRefresh

#pragma mark - Getters and Setters

- (UIColor *)tintColor
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.000000) {
        return tableViewController.tableView.pullToRefreshView.arrowColor;
    } else {
        return tableViewController.refreshControl.tintColor;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.000000) {
        tableViewController.tableView.pullToRefreshView.arrowColor = tintColor;
    } else {
        tableViewController.refreshControl.tintColor = tintColor;
    }
}

- (BOOL)isRefreshing
{
    return refreshing;
}

#pragma mark - Refreshing methods

- (void)beginRefreshing
{
    refreshing = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.000000) {
        [tableViewController.tableView.pullToRefreshView startAnimating];
    } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [tableViewController.refreshControl beginRefreshing];
        }];
    }
}

- (void)endRefreshing
{
    refreshing = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.000000) {
        [tableViewController.tableView.pullToRefreshView stopAnimating];
    } else {
        [tableViewController.refreshControl endRefreshing];
    }
}

#pragma mark - Action Methods

- (void)triggerRefresh
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.000000) {
        [tableViewController.tableView.pullToRefreshView triggerRefresh];
    } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [tableViewController.refreshControl beginRefreshing];
            [tableViewController.tableView scrollRectToVisible:CGRectMake(0, -5, 320, 20) animated:YES];
        }];
        [self triggerAction];
    }
}

- (void)triggerAction
{
    action();
}

- (void)addAction:(void (^)(void))_action tableViewController:(UITableViewController *)controller
{
    action = _action;
    tableViewController = controller;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.000000) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(triggerAction) forControlEvents:UIControlEventAllEvents];
        tableViewController.refreshControl = refreshControl;
    } else {
        [tableViewController.tableView addPullToRefreshWithActionHandler:action];
    }
}

@end

#pragma mark - UITableViewController (NYPullToRefresh)

#import <objc/runtime.h>

static char UITableViewControllerNYPullToRefresh;

@implementation UITableViewController (NYPullToRefresh)

- (NYPullToRefresh *)pullToRefresh
{
    NYPullToRefresh *nyPullToRefresh = objc_getAssociatedObject(self, &UITableViewControllerNYPullToRefresh);
    if (!nyPullToRefresh) {
        nyPullToRefresh = [[NYPullToRefresh alloc] init];
        self.pullToRefresh = nyPullToRefresh;
    }
    
    return nyPullToRefresh;
}

- (void)setPullToRefresh:(NYPullToRefresh *)pullToRefresh
{
    objc_setAssociatedObject(self, &UITableViewControllerNYPullToRefresh,
                             pullToRefresh,
                             OBJC_ASSOCIATION_RETAIN);
}

- (void)addPullToRefreshWithAction:(void (^)(void))action
{
    [self.pullToRefresh addAction:action tableViewController:self];
}

@end
