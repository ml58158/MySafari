//
//  InternetViewController.m
//  MySafari
//
//  Created by Matt Larkin on 3/11/15.
//  Copyright (c) 2015 Matt Larkin. All rights reserved.
//

#import "InternetViewController.h"

@interface InternetViewController () <UIWebViewDelegate , UITextFieldDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *teaserButton;

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBarItem;

@property CGPoint pointNow;

- (void)loadUrlRequestFromString:(NSString *)string;

@end



@implementation InternetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
     self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString: @"http://www.mobilemakers.co"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: urlRequest];
    self.urlTextField.delegate = self;
    self.webView.scrollView.delegate = self;
    self.navigationBarItem.title = @"MySafari App";

}



-(void)userDidScrollWebView:(id)scrollPoint{
    // NSLog(@"scrolled:::");

    NSString *x1 = [self.webView stringByEvaluatingJavaScriptFromString: @"scrollX"];


    NSString *y1 = [self.webView stringByEvaluatingJavaScriptFromString: @"scrollY"];


    NSLog(@"scroll x=%@ y=%@", x1,y1);

    if ([y1 isEqualToString: @"0"]) {
        NSLog(@"RELOAD ME");
    }   
}

#pragma mark -UIScrollView

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pointNow = scrollView.contentOffset;

    // change the opacity of the textField
    self.urlTextField.backgroundColor = [UIColor clearColor];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // checking if it is scrolling up or down
    // down - show textfield
    if (scrollView.contentOffset.y <= self.pointNow.y) {
        self.urlTextField.hidden = NO;
        self.urlTextField.backgroundColor = [UIColor whiteColor];
        // up - hide textField
    } else if (scrollView.contentOffset.y > self.pointNow.y) {
        self.urlTextField.hidden = YES;
    }
}



#pragma Button Logic



-(void)loadUrlRequestFromString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
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

     self.urlTextField.text = [[self.webView.request URL] absoluteString];
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
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationBarItem.title = title;

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

   // [webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(document.body.scrollWidth, document.body.scrollHeight);"];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text hasPrefix:@"http://"]) {
        textField.text = [NSString stringWithFormat:@"http://%@", textField.text];
    }

    [self loadUrlRequestFromString:textField.text];
    return true;
}





@end
