//
//  OSEditablePickerViewTableViewCell.h
//  TestPicker
//
//  Created by Daniel Vela on 15/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSFloatingPickerViewDelegate

-(void)addPressed;
-(void)minusPressed;

@end


// [self.tableView registerClass:[OSEditablePickerViewTableViewCell class] forCellReuseIdentifier:@"OSPickerCell"];

// UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OSPickerCell" forIndexPath:indexPath];

@interface OSEditablePickerViewTableViewCell : UITableViewCell

@property (nonatomic, strong) id<OSFloatingPickerViewDelegate> delegate2;
@property (nonatomic, strong) id<UIPickerViewDelegate> delegate;
@property (nonatomic, strong) id<UIPickerViewDataSource> dataSource;
@property (nonatomic, strong) UIPickerView* pickerView;

@end
