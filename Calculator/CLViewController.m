//
//  CLViewController.m
//  Calculator
//
//  Created by MAI THE TAI on 2014/02/23.
//  Copyright (c) 2014年 MAI THE TAI. All rights reserved.
//

#import "CLViewController.h"

@interface CLViewController () {
    BOOL _isMainLabelTextTemporary;
    double _lastValue;
    int _operand;
}

@property (strong, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation CLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numericTap:(UIButton *)sender {
    // reset label after calculation are show from previous operations
    if (_isMainLabelTextTemporary) {
        self.mainLabel.text = @"0";
        _isMainLabelTextTemporary = NO;
    }
    
    if (_operand == 0) {
        _lastValue = 0;
    }
    
    // get string from button tag vs main label
    NSString *mainLabelString = self.mainLabel.text;
    NSString *numString = [NSString stringWithFormat:@"%d", sender.tag];
    if ([mainLabelString doubleValue] == 0 && [self doesStringContainDecimal:mainLabelString] == NO) {
        mainLabelString = @"";
    }
    //Combine the 2 strings to gether
    self.mainLabel.text = [mainLabelString stringByAppendingString:numString];
    
}

- (BOOL)doesStringContainDecimal:(NSString*) string
{
    NSString *searchForDecimal = @".";
    NSRange range = [self.mainLabel.text rangeOfString:searchForDecimal];
    
    //If we find a decimal return YES. Otherwise, NO
    if (range.location != NSNotFound)
        return YES;
    return NO;
}

- (void)calculate{
    double currentValue = [self.mainLabel.text doubleValue];
    if (_operand == 12)
        _lastValue = currentValue/100;
    else if (_operand == 11)
        _lastValue = -currentValue;
    else if (_lastValue != 0 && currentValue != 0) {
        if (_operand == 16)
            _lastValue += currentValue;
        else if (_operand == 15)
            _lastValue -= currentValue;
        else if (_operand == 14)
            _lastValue *= currentValue;
        else if (_operand == 13) {
            if (currentValue == 0) {
                [self clearTap:nil];
            } else {
                _lastValue /= currentValue;
            }
        }
    }
    else {
        _lastValue = currentValue;
    }
    
    self.mainLabel.text = [NSString stringWithFormat:@"%g", _lastValue];
    _isMainLabelTextTemporary = YES;
}

- (IBAction)operatorTap:(UIButton *)sender {
    _operand = sender.tag;
    [self calculate];
}

- (IBAction)clearTap:(id)sender {
    // clear label and value
    _lastValue = 0;
    self.mainLabel.text = @"0";
    //    _currentOperator = [OperatorButton new];
    _isMainLabelTextTemporary = NO;
}


- (IBAction)decimalTap:(id)sender {
    if ([self doesStringContainDecimal:_mainLabel.text] == NO) {
        self.mainLabel.text = [self.mainLabel.text stringByAppendingString:@"."];
    }
}

- (IBAction)equalTap:(id)sender {
    // = press
    [self calculate];
    _operand = 0;
}

@end
