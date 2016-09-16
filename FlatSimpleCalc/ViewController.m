//
//  ViewController.m
//  FlatSimpleCalc
//
//  Created by Ernest Chechelski on 01.03.2016.
//  Copyright © 2016 Ernest Chechelski. All rights reserved.
//

#import "ViewController.h"
#import "FlatUIkit.h"
@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(FUIButton) NSArray *myButtons;
@property (strong, nonatomic) IBOutlet FUIButton *myScreen;

typedef enum {
    ADD,
    SUB,
    MULTI,
    DIV,
    NONE
} OperationType;

@property OperationType operationType;
@property NSNumber *lastNumber;
@property NSNumber *currentNumber;
@property BOOL resultGiven;
@property BOOL reloadValuesCalled;





@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _operationType = NONE;
    _reloadValuesCalled = false;
   
    NSString *aCButtonColor = @"#536DFE";
    NSString *aCButtonShadowColor = @"#C5CAE9";
    
    NSString *screenColor = @"#303F9F";
    NSString *screenShadowColor = @"#3F51B5";
    
    NSString *resultButtonColor = @"#3F51B5";
    NSString *resultButtonShadowColor = @"#C5CAE9";

    NSString *functionButtonsColor = @"#C5CAE9";
    NSString *functionButtonsShadowColor = @"#FFFFFF";
    
    NSString *backGroundColor = @"#FFFFFF";
    UIColor *fontColor = [UIColor blackColor];
    


    
    for (FUIButton *myButton in _myButtons) {
        
        myButton.shadowHeight = 2.0f;
        myButton.cornerRadius = 0.0f;
        myButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        
        
        if(myButton.tag == 17)//Result button
        {
            myButton.buttonColor = [UIColor colorFromHexCode:resultButtonColor];
            myButton.shadowColor = [UIColor colorFromHexCode:resultButtonShadowColor];
            [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [myButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        }
        else if(myButton.tag == 10)//AC button
        {
            myButton.buttonColor = [UIColor colorFromHexCode:aCButtonColor];
            myButton.shadowColor = [UIColor colorFromHexCode:aCButtonShadowColor];
            [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [myButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        }
        else
        {
            myButton.buttonColor = [UIColor colorFromHexCode:functionButtonsColor];
            myButton.shadowColor = [UIColor colorFromHexCode:functionButtonsShadowColor];
            [myButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [myButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        }
        if(myButton.tag >= 10 && myButton.tag <= 17)
        {
            [myButton addTarget:self action:@selector(functionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [myButton setTitleColor:fontColor forState:UIControlStateNormal];
            [myButton setTitleColor:fontColor forState:UIControlStateHighlighted];
        }
        if((myButton.tag >= 0 && myButton.tag <= 9) || myButton.tag == 18)
        {
            [myButton addTarget:self action:@selector(digitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [myButton setTitleColor:fontColor forState:UIControlStateNormal];
            [myButton setTitleColor:fontColor forState:UIControlStateHighlighted];
        }
       
    }
    
    self.view.backgroundColor =[UIColor colorFromHexCode:backGroundColor];
    [_myScreen setTitle:@" " forState:UIControlStateNormal]; // To set the title
    [_myScreen setEnabled:NO]; // To toggle enabled / disabled
    _myScreen.buttonColor = [UIColor colorFromHexCode:screenColor];
    _myScreen.shadowColor = [UIColor colorFromHexCode:screenShadowColor];
    _myScreen.shadowHeight = 5.0f;
    _myScreen.cornerRadius = 0.0f;
    _myScreen.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _myScreen.titleLabel.font = [UIFont boldFlatFontOfSize:22];
    [_myScreen setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction) digitButtonPressed:(id)sender {
    FUIButton *buttonClicked = (FUIButton *)sender;
    NSLog(@"Reload values called: %d, resultGiven: %d, operation type: %d",_reloadValuesCalled, _resultGiven, _operationType!=NONE);
    
    
    NSInteger *bTag = buttonClicked.tag;
    if(_resultGiven || _reloadValuesCalled)
    {
        NSLog(@"CLEAR WANTED");
        _myScreen.titleLabel.text = @" ";
        _resultGiven =false;
     // [_myScreen setTitle:@"XDD " forState:UIControlStateDisabled];
        _reloadValuesCalled = false;
       
    }
    if (buttonClicked.tag == 18) {
        //if (_lastNumberEntered) {
         //   [_myScreen setTitle:@" " forState:UIControlStateDisabled];
        //}
        NSString *countString = _myScreen.titleLabel.text;
        countString = [countString stringByAppendingString:@"."];
        [_myScreen setTitle:countString forState:UIControlStateDisabled];
    }
    else
    {
        NSString *myString = [NSString stringWithFormat:@"%i",bTag];
        NSString *countString = _myScreen.titleLabel.text;
        countString = [countString stringByAppendingString:myString];
        [_myScreen setTitle:countString forState:UIControlStateDisabled];
    }
    
}


- (IBAction) functionButtonPressed:(id)sender {
    
    FUIButton *buttonClicked = (FUIButton *)sender;
    if (buttonClicked.tag==10) {
        NSLog(@"AC");
        [_myScreen setTitle:@" " forState:UIControlStateDisabled];
        _currentNumber = @(0);
        _lastNumber = @(0);
        
    }
    if (buttonClicked.tag==11) {
        NSLog(@"PLUSMINUS");
        NSNumber *number = _myScreen.titleLabel.text;
        number = @(number.doubleValue*-1);
        NSString *numberString = [number stringValue];
        [_myScreen setTitle:numberString forState:UIControlStateDisabled];
        
    }
    
    if (buttonClicked.tag==12) {
        NSLog(@"PROCENT");
        NSNumber *number = _myScreen.titleLabel.text;
        number = @(number.doubleValue*0.01);
        NSString *numberString = [number stringValue];
        [_myScreen setTitle:numberString forState:UIControlStateDisabled];

    }
    
    if (buttonClicked.tag==13) {
        NSLog(@"DIVIDE");
         _operationType = DIV;
        [self reloadValues];
        
        
    }
    
    if (buttonClicked.tag==14) {
        NSLog(@"MULTI");
        _operationType = MULTI;
         [self reloadValues];
    }
    
    if (buttonClicked.tag==15) {
        NSLog(@"SUB");
        _operationType = SUB;
        [self reloadValues];
    }
    
    if (buttonClicked.tag==16) {
        NSLog(@"PLUS");
        _operationType = ADD;
        [self reloadValues];
        
    }
    if (buttonClicked.tag==17) {
        NSLog(@"RESULT");
        [self reloadValues];
        [self calculate];
        _operationType = NONE;
          }
    
    
    /*
     AC 10
     PLUSMINUS 11
     PROCENT 12
     DIVIDE 13
     MULTI 14
     SUB 15
     PLUS 16
     RESULT 17
     */
}

- (void)reloadValues {
    if ([_myScreen.titleLabel.text hasSuffix:@"."]) {
    
    }
    else{
        NSNumber *tempValue = _lastNumber;
        _lastNumber = _currentNumber;
        _currentNumber = _myScreen.titleLabel.text;
        NSLog(@"Values: %@ %@",_lastNumber, _currentNumber);
        _reloadValuesCalled = true;
  }
}
- (void)calculate {
    
    if (_operationType ==ADD) {
        NSNumber *number = @(_lastNumber.doubleValue+_currentNumber.doubleValue);
        NSString *numberString = [number stringValue];
        [_myScreen setTitle:numberString forState:UIControlStateDisabled];
    }
    if (_operationType ==SUB) {
        NSNumber *number = @(_lastNumber.doubleValue-_currentNumber.doubleValue);
        NSString *numberString = [number stringValue];
        [_myScreen setTitle:numberString forState:UIControlStateDisabled];
    }
    if (_operationType ==MULTI) {
        NSNumber *number = @(_lastNumber.doubleValue*_currentNumber.doubleValue);
        NSString *numberString = [number stringValue];
        [_myScreen setTitle:numberString forState:UIControlStateDisabled];
    }
    if (_operationType ==DIV) {
        
        NSNumber *number = @(_lastNumber.doubleValue/_currentNumber.doubleValue);
        NSString *numberString = [number stringValue];
        [_myScreen setTitle:numberString forState:UIControlStateDisabled];
    }
    _resultGiven = TRUE;
    _operationType = NONE;
    // Dispose of any resources that can be recreated.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
