//
//  FirstViewController.h
//  ZOBluetoothUART
//
//  Created by Micah Pearlman on 2/7/15.
//  Copyright (c) 2015 Micah Pearlman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZOMainViewController : UIViewController

@property IBOutlet UILabel*			_connectionStatusLabel;
@property IBOutlet UITextView*		_outputTextView;
@property IBOutlet UITextField*		_inputTextField;
@property IBOutlet UIButton*		_sendButton;

- (IBAction) onSendPressed:(id)sender;

@end

