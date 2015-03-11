//
//  InternetViewController.m
//  MySafari
//
//  Created by Matt Larkin on 3/11/15.
//  Copyright (c) 2015 Matt Larkin. All rights reserved.
//

#import "InternetViewController.h"

@interface InternetViewController () <UIWebViewDelegate , UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *teaserButton;


@end





@implementation InternetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString: @"http://www.mobilemakers.com"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: urlRequest];
}



#pragma Button Logic

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    [self.webView canGoForward];
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];

}


- (IBAction)onReloadButtonPressed:(id)sender {

    [self.webView reload];
}

- (IBAction)onTeaserButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [UIAlertView new];
    alert.delegate = self;
    alert.title = @"New Features!";
    alert.message = @"Coming Soon!";
    [alert addButtonWithTitle:@"Dismiss"];
    [alert show];

}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.spinner startAnimating];
    if ([webView canGoBack]) {
        self.backButton.enabled = YES;
    }
    else {
        self.backButton.enabled = NO;
        }

    if ([webView canGoForward]) {
        self.forwardButton.enabled = YES;
    }
    else {
        self.backButton.enabled = NO;
    }


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinner stopAnimating];
    if ([webView canGoBack]) {
        self.backButton.enabled = YES;
    }
    else {
        self.backButton.enabled = NO;
    }

    if ([webView canGoForward]) {
        self.forwardButton.enabled = YES;
    }
    else {
        self.backButton.enabled = NO;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    NSString *http = @"http://";
    NSString *textFieldSubstring = [textField.text substringFromIndex:7];

    if (![textFieldSubstring isEqualToString: @"http"]) {
        NSString *enteredPlusHttp = [http stringByAppendingString:textField.text];
        NSString *newText = [NSString stringWithFormat:@"%@", enteredPlusHttp];
        textField.text = newText;
    }

    NSURL *url = [NSURL URLWithString: textField.text];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: urlRequest];
    return YES;


}

@end
