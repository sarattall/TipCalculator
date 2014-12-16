//
//  TipViewController.m
//  tipcalculator
//
//  Created by Sarat Tallamraju on 12/13/14.
//  Copyright (c) 2014 sarattallamraju. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

// Properties
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serviceSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *tipPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UIStepper *tipPercentStepper;
@property (weak, nonatomic) IBOutlet UIStepper *numberOfPeopleStepper;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *youPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

// Actions
- (IBAction)onSegmentedControlValueChanged:(id)sender;
- (IBAction)onTap:(id)sender;
- (IBAction)onTipPercentStepperValueChanged:(id)sender;
- (IBAction)onNumberOfPeopleStepperValueChanged:(id)sender;
- (IBAction)billTextFieldDidBeginEditing:(id)sender;
- (IBAction)onBillTextFieldEditingChanged:(id)sender;
- (IBAction)billTextFieldEditingDidEnd:(id)sender;

// Helper Functions
- (void)updateValues;

@end

@implementation TipViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // self = [super initWithNibName:nibNameOrNil bundle:<#nibBundleOrNil#>];
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
    }
    return self;
}

-(void)updateValues
{
    NSLog(@"updateValues called");
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    // inputs
    float billAmount = [[nf numberFromString:self.billTextField.text] floatValue];
    if (billAmount == 0.0) {
        billAmount = [self.billTextField.text floatValue];
    }
    float tipPercent = [self.tipPercentLabel.text intValue] / 100.0;
    int numPeople = [self.numberOfPeopleLabel.text intValue];
    
    // outputs
    float tipAmount = billAmount * tipPercent;
    float totalAmount = billAmount + tipAmount;
    float youPay = totalAmount / numPeople;
    
    // update labels
    self.billTextField.text = [NSString stringWithFormat:@"$%0.2f", billAmount];
    self.tipAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.youPayLabel.text = [NSString stringWithFormat:@"$%0.2f", youPay];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: [self getCustomSettingsButton]];
    [self updateValues];
}

-(UIButton *)getCustomSettingsButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"⚙" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25.0f];

    button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [button addTarget:self action:@selector(onSettingsButton)  forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void) onSettingsButton
{
    NSLog(@"onSettingsButton");
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // DIspose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

- (IBAction)onSegmentedControlValueChanged:(id)sender {
    NSLog(@"onSegmentedControlValueChanged");
    [self.view endEditing: YES];

    NSArray *tipValues = @[@(0.1), @(0.15), @(0.20)];
    
    int tipPercent = [tipValues[self.serviceSegmentedControl.selectedSegmentIndex] floatValue] * 100;
    [self.tipPercentStepper setValue: tipPercent];
    self.tipPercentLabel.text = [NSString stringWithFormat:@"%d%%", tipPercent];
    [self updateValues];

}


- (IBAction)onTap:(id)sender {
    [self.view endEditing: YES];
    [self updateValues];
}

- (IBAction)onTipPercentStepperValueChanged:(UIStepper *)sender {
    [self.view endEditing: YES];

    int tipPercent = sender.value;
    self.tipPercentLabel.text = [NSString stringWithFormat:@"%d%%", tipPercent];
    [self updateValues];
}

- (IBAction)onNumberOfPeopleStepperValueChanged:(UIStepper *)sender {
    [self.view endEditing: YES];

    int numPeople = sender.value;
    self.numberOfPeopleLabel.text = [NSString stringWithFormat: @"%d", numPeople];
    [self updateValues];
}

- (IBAction)billTextFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"billTextFieldDidBeginEditing");
    textField.text = @"$";
}

- (IBAction)onBillTextFieldEditingChanged:(UITextField *)textField {
    // NSLog(@"billTextFieldEditingChagned");
    NSString *billText = textField.text;
    if ([billText isEqualToString:@""]) {
        textField.text = @"$";
    }
    
    if ([billText rangeOfString:@"."].location != NSNotFound) {
        NSString *stringAfterDot = [[billText componentsSeparatedByString:@"."] lastObject];
        if ([stringAfterDot length] == 2) {
            [self.view endEditing: YES];
            [self updateValues];
        }
    }
}

- (IBAction)billTextFieldEditingDidEnd:(UITextField *)textField {
    NSLog(@"billTextFieldEditingDidEnd");
}

@end
