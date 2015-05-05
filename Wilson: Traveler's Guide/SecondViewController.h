//
//  SecondViewController.h
//  Wilson: Traveler's Guide
//
//  Created by Kevin Islas Abud on 3/2/15.
//  Copyright (c) 2015 Kevin Islas Abud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *convertToLabel;
@property (weak, nonatomic) IBOutlet UILabel *equalsLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (weak, nonatomic) IBOutlet UIButton *convertBtn;

@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTF;
@end

