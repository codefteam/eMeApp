//
//  BrowserViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "BrowserViewController.h"


@interface BrowserViewController ()<UIWebViewDelegate>
{
	UIWebView *_webView;
	UIBarButtonItem *_refreshBtn;
	UIBarButtonItem *_stopBtn;
	UIBarButtonItem *_nextBtn;
	UIBarButtonItem *_backBtn;
}
@end

@implementation BrowserViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	CGRect rect = self.view.frame;
	rect.size.height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-44.f;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
		rect.size.height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - 44.f;
		
	}
#endif
		
	// UIWebViewのインスタンス
	_webView = [[UIWebView alloc]initWithFrame:rect];
	
	// Webページの大きさを自動的に画面にフィットさせる
	_webView.scalesPageToFit = YES;
	
	// デリゲートを指定
	_webView.delegate = self;
	
	// URLを指定
	NSURL *url = [NSURL URLWithString:self.requestURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	// リクエストを投げる
	[_webView loadRequest:request];
	
	// UIWebViewのインスタンスをビューに追加
	[self.view addSubview:_webView];
	
	
	UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, rect.size.height, self.view.frame.size.width, 44.0f)];
	tb.tintColor = [UIColor blackColor];
	[self.view addSubview:tb];
	
	if ([UIImage respondsToSelector:@selector(imageWithRenderingMode:)]) {
		
		_backBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(backDidAction:)];
		
		_nextBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"next.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(nextDidAction:)];
		
	}
	else {
		_backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"]
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(backDidAction:)];
		
		_nextBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"]
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(nextDidAction:)];
	}
	
	

	_refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshDidAction:)];
	_stopBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopDidAction:)];
	
	UIBarButtonItem *fixspacer1 = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
								   target:nil
								   action:nil];
	fixspacer1.width = 10.0;
	
	UIBarButtonItem *fixspacer2 = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
								   target:nil action:nil];
	fixspacer2.width = 130.0;
	

	UIBarButtonItem *fixspacer3 = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
								   target:nil action:nil];
	fixspacer3.width = 10.0;
	
	NSArray *items = [NSArray arrayWithObjects:_backBtn, fixspacer1, _nextBtn, fixspacer2, _refreshBtn, fixspacer3, _stopBtn, nil];
	[tb setItems:items];
	
	[self changeFBButtonStatus];
	
	
	
	UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardGesture:)];
	leftSwipe.numberOfTouchesRequired = 1;
	leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
	[_webView addGestureRecognizer:leftSwipe];

	UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture:)];
	rightSwipe.numberOfTouchesRequired = 1;
	rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
	[_webView addGestureRecognizer:rightSwipe];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	}


}

- (void)viewWillDisappear:(BOOL)animated
{
	if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
	}
	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[super viewWillDisappear:animated];
}

#pragma mark - GestureRecognizer
- (void)backGesture:(UISwipeGestureRecognizer*)recognizer
{
	[_webView goBack];
}

- (void)forwardGesture:(UISwipeGestureRecognizer*)recognizer
{
	[_webView goForward];
}

#pragma mark - UIWebView delegate
/**
 *  Webページのロード時にインジケータを動かす
 *
 *  @param webView WebView
 */
- (void)webViewDidStartLoad:(UIWebView*)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	_refreshBtn.enabled = NO;
	_stopBtn.enabled = YES;
	
	[self changeFBButtonStatus];
}

/**
 *  Webページのロード完了時にインジケータを非表示にする
 *
 *  @param webView
 */
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	_refreshBtn.enabled = YES;
	_stopBtn.enabled = NO;
	
	[self changeFBButtonStatus];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
	if ([error code] != NSURLErrorCancelled) {
		
		NSString *html = [NSString stringWithFormat:@"<html><head><style>p {font-size:50;margin:80px;word-break:keep-all;text-align:center;color:#AAAAAA;}</style></head><body><p>%@</p></body></html>", error.localizedDescription];
		NSData *bodyData = [html dataUsingEncoding:NSUTF8StringEncoding];
		[webView loadData:bodyData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
		
	}

}

#pragma mark - Action
//前のWebページに戻るボタンが押された
- (void)backDidAction:(id)sender
{
	if (_webView.canGoBack == YES) {
		[_webView goBack];
	}
}

//次のWebページに進むボタンが押された
- (void)nextDidAction:(id)sender
{

	if (_webView.canGoForward == YES) {
		[_webView goForward];
	}
}

//ページを更新するボタンが押された
- (void)refreshDidAction:(id)sender
{
	
	
	if (_webView) {
		if ([_webView canGoBack]) {
			[_webView reload];
			
			_refreshBtn.enabled = NO;
			_stopBtn.enabled = YES;
			
		} else {
			//最初に呼び出すのと同じページを読み込む処理
			NSURL *url = [NSURL URLWithString:self.requestURL];
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			// リクエストを投げる
			[_webView loadRequest:request];
			
		}
	}
	
	

	

	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//ページの更新を停止するボタンが押された
- (void)stopDidAction:(id)sender
{
	[_webView stopLoading];
	
	_refreshBtn.enabled = YES;
	_stopBtn.enabled = NO;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//現在のページの状態から、前のページに戻る、次のページに進むの有効/無効判定をしてButtonの有効/無効を設定
- (void)changeFBButtonStatus
{
	if (_webView.canGoForward == YES) {
		_nextBtn.enabled = YES;
	} else {
		_nextBtn.enabled = NO;
	}
	
	if (_webView.canGoBack == YES) {
		_backBtn.enabled = YES;
	} else {
		_backBtn.enabled = NO;
	}
}

@end
