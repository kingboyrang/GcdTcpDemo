//
//  ViewController.h
//  socketDemo
//
//  Created by 吳瀾洲 on 2020/7/28.
//  Copyright © 2020 kingboyrang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)btnConnect:(id)sender;
- (IBAction)resetConnect:(id)sender;
- (IBAction)closeConnect:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
- (IBAction)sendBtnAction:(id)sender;

@end

