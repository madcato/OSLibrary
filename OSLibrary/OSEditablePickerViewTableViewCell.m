//
//  OSEditablePickerViewTableViewCell.m
//  TestPicker
//
//  Created by Daniel Vela on 15/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "OSEditablePickerViewTableViewCell.h"

@implementation OSEditablePickerViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initControls];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource {
    self.pickerView.dataSource = dataSource;
    _dataSource = dataSource;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate {
    self.pickerView.delegate = delegate;
    _delegate = delegate;
}

- (void)initControls {
    UIColor* kLightBlue = [UIColor colorWithRed:0.41f green:0.72f blue:1.0f alpha:1.0f];
    CGRect contentFrame = CGRectMake(0, 0, 320, 206);
    CGRect addButtonFrame = CGRectMake(263, 0, 44, 44);
    CGRect minusButtonFrame = CGRectMake(218, 0, 44, 44);
    CGRect pickerViewFrame = CGRectMake(0, 43, 320, 162);

    [self.contentView setFrame:contentFrame];

    UIButton* addButton = [[UIButton alloc] initWithFrame:addButtonFrame];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton addTarget:self
                  action:@selector(addPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitleColor:kLightBlue forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [addButton setUserInteractionEnabled:YES];
    addButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [addButton.titleLabel setFont:[UIFont systemFontOfSize:28.0f]];
    [self.contentView addSubview:addButton];

    UIButton* minusButton = [[UIButton alloc] initWithFrame:minusButtonFrame];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton addTarget:self
                    action:@selector(minusPressed)
          forControlEvents:UIControlEventTouchUpInside];
    [minusButton setTitleColor:kLightBlue forState:UIControlStateNormal];
    [minusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [minusButton setUserInteractionEnabled:YES];
    minusButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [minusButton.titleLabel setFont:[UIFont systemFontOfSize:28.0f]];
    [self.contentView addSubview:minusButton];

    self.pickerView = [[UIPickerView alloc] initWithFrame:
                       pickerViewFrame];
    UIPickerView* pickerView = self.pickerView;
	pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self.delegate;
    pickerView.dataSource = self.dataSource;
    pickerView.userInteractionEnabled = YES;
    pickerView.showsSelectionIndicator = YES;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:pickerView];


//    // Constraints
//    NSDictionary *views = NSDictionaryOfVariableBindings(addButton,minusButton,pickerView);
//
//
//    [self.contentView addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"[addButton]-13-|"
//                               options:0
//                               metrics:nil
//                               views:views]];
//    [self.contentView addConstraints:[NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"V:|[addButton]"
//                                      options:0
//                                      metrics:nil
//                                      views:views]];
//
//    [self.contentView addConstraints:[NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"[minusButton]-42-|"
//                                      options:0
//                                      metrics:nil
//                                      views:views]];
//    [self.contentView addConstraints:[NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"V:|[minusButton]"
//                                      options:0
//                                      metrics:nil
//                                      views:views]];
//
//    [self.contentView addConstraints:[NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"|[pickerView]|"
//                                      options:0
//                                      metrics:nil
//                                      views:views]];
//    [self.contentView addConstraints:[NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"V:|-29-[pickerView]"
//                                      options:0
//                                      metrics:nil
//                                      views:views]];

}


-(void)addPressed {
    [self.delegate2 addPressed];
}

-(void)minusPressed {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    [self.delegate2 minusPressed:row];
    [self.pickerView reloadAllComponents];

    row = [self.pickerView selectedRowInComponent:0];
    [self.delegate pickerView:self.pickerView didSelectRow:row inComponent:0];
}

@end
