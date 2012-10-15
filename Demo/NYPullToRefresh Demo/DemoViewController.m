//
//  DemoViewController.m
//  NYPullToRefresh Demo
//
//  Created by Cassius Pacheco on 15/10/12.
//  Copyright (c) 2012 Nyvra Software. All rights reserved.
//

#import "DemoViewController.h"
#import "NYPullToRefresh.h"

@interface DemoViewController()

@property (nonatomic, strong) NSArray *list;

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add Pull To Refresh
    [self addPullToRefreshWithAction:^{
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        //Simulate delay
        [queue addOperationWithBlock:^{
            sleep(2);
            
            //Reload tableView
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.list = @[@"Cell Zero", @"Cell One", @"Cell Two", @"Cell Three", @"Cell Four", @"Cell Five"];
                [self.tableView reloadData];
                [self.pullToRefresh endRefreshing];
            }];
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Trigger programmatically pull to refresh with action
    [self.pullToRefresh triggerRefresh];
    
    //Execute the action block without animation
    //[self.pullToRefresh triggerAction];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;
}

@end
