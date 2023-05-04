//
//  ViewController.m
//  CalculateTest
//
//  Created by 宋卫星 on 2023/5/4.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, assign) double currentNumber; //一个值分配给它时，该值将被直接赋值给属性，而不是被保留
@property (nonatomic, assign) double previousNumber;
@property (nonatomic, assign) BOOL isTypingNumber;
@property (nonatomic, copy) NSString *operation;   //操作符

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    // UI展示
//    self.displayLabel = [[UILabel alloc] initWithFrame::CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.view.bounds.size.width - 40, 60)];
    self.displayLabel.backgroundColor = [UIColor blackColor];
    self.displayLabel.textColor = [UIColor whiteColor];
    self.displayLabel.textAlignment = NSTextAlignmentRight;
    self.displayLabel.font = [UIFont systemFontOfSize:48];
    self.displayLabel.text = @"0";
    [self.view addSubview:self.displayLabel];
    
    // Buttons
    NSArray *buttonTitles = @[@"C", @"+/-", @"%", @"÷",
                              @"7", @"8", @"9", @"×",
                              @"4", @"5", @"6", @"-",
                              @"1", @"2", @"3", @"+",
                              @"0", @".", @"="];
    
    CGFloat buttonWidth = (self.view.bounds.size.width - 40) / 4;
    CGFloat buttonHeight = 60;
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 4; j++) {
            int index = i * 4 + j;
            if (index >= buttonTitles.count) {
                break;
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(20 + j * buttonWidth, 120 + i * buttonHeight, buttonWidth, buttonHeight);
            [button setTitle:buttonTitles[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:24];
            button.backgroundColor = [UIColor darkGrayColor];
            button.tag = index;
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
}

- (void)buttonTapped:(UIButton *)sender {
    NSString *buttonTitle = sender.currentTitle;
    
    if ([buttonTitle isEqualToString:@"C"]) {
        self.currentNumber = 0;
        self.previousNumber = 0;
        self.operation = nil;
        self.isTypingNumber = NO;
        self.displayLabel.text = @"0";
    } else if ([buttonTitle isEqualToString:@"+"] ||
               [buttonTitle isEqualToString:@"-"] ||
               [buttonTitle isEqualToString:@"×"] ||
               [buttonTitle isEqualToString:@"÷"] ||
               [buttonTitle isEqualToString:@"%"]) {
        self.isTypingNumber = NO;
        self.previousNumber = self.currentNumber;
        self.operation = buttonTitle;
    } else if ([buttonTitle isEqualToString:@"="]) {
        [self performOperation];
        self.isTypingNumber = NO;
    } else {
        if (self.isTypingNumber) {
            self.displayLabel.text = [self.displayLabel.text stringByAppendingString:buttonTitle];
        } else {
            self.displayLabel.text = buttonTitle;
            self.isTypingNumber = YES;
        }
        self.currentNumber = self.displayLabel.text.doubleValue;
    }
}

- (void)performOperation {
    if ([self.operation isEqualToString:@"+"]) {
        self.currentNumber = self.previousNumber + self.currentNumber;
    } else if ([self.operation isEqualToString:@"-"]) {
        self.currentNumber = self.previousNumber - self.currentNumber;
    } else if ([self.operation isEqualToString:@"×"]) {
        self.currentNumber = self.previousNumber * self.currentNumber;
    } else if ([self.operation isEqualToString:@"÷"]) {
        if (self.currentNumber != 0) {
            self.currentNumber = self.previousNumber / self.currentNumber;
        }
    } else if ([self.operation isEqualToString:@"%"]) {
        self.currentNumber = fmod(self.previousNumber, self.currentNumber);
    }
    
    self.displayLabel.text = [NSString stringWithFormat:@"%g", self.currentNumber];
}

@end
