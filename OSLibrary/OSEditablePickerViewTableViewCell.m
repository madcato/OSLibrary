//
//  OSEditablePickerViewTableViewCell.m
//  TestPicker
//
//  Created by Daniel Vela on 15/09/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "OSEditablePickerViewTableViewCell.h"

@implementation OSEditablePickerViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier suplementaryButton:(NSString*)suplementaryButtonTitle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.suplementaryButtonTitle = suplementaryButtonTitle;
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
    UIColor* color = [UIWindow appearance].tintColor;
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
    [addButton setTitleColor:color forState:UIControlStateNormal];
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
    [minusButton setTitleColor:color forState:UIControlStateNormal];
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


    if (self.suplementaryButtonTitle) {
        CGRect supButtonFrame = CGRectMake(5, 0, 120, 44);
        UIButton* supButton = [[UIButton alloc] initWithFrame:supButtonFrame];
        [supButton setTitle:self.suplementaryButtonTitle forState:UIControlStateNormal];
        [supButton addTarget:self
                      action:@selector(supPressed)
            forControlEvents:UIControlEventTouchUpInside];
        [supButton setTitleColor:color forState:UIControlStateNormal];
        [supButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [supButton setUserInteractionEnabled:YES];
        supButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [supButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        supButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        supButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.contentView addSubview:supButton];
    }
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

-(void)supPressed {
    [self.delegate2 suplementaryPressed];
}

@end
