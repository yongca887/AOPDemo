//
//  LoginViewController.m
//  AOPDemo
//
//  Created by thejoyrun on 2016/11/4.
//  Copyright © 2016年 xtcel.com Inc. All rights reserved.
//

#import "LoginViewController.h"

#define SCREEN_WIDHT    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface LoginViewController ()

@property (nonatomic, strong) UILabel *nameLabel;   /**< appName Label */
@property (nonatomic, strong) UITextField *usernameTextField;/**< 用户名输入框 */
@property (nonatomic, strong) UITextField *passwordTextField;/**< 密码输入框 */
@property (nonatomic, strong) UIButton *loginButton;        /**< 登录按钮 */
@property (nonatomic, strong) UIButton *registerButton;     /**< 注册按钮 */
@property (nonatomic, strong) UIButton *forgetPWButton;     /**< 忘记密码按钮 */

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
//    [self.view addSubview:self.registerButton];
//    [self.view addSubview:self.forgetPWButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest

- (void)requestLoginWithUsername:(NSString *)username password:(NSString *)password {
    //发起网络请求
    
}

#pragma mark - Event Response

- (void)loginButtonClickedEvent:(id)sender {
    // 登录按钮点击事件
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    
    if ([username isEqualToString:@""] && [password isEqualToString:@""]) {
        return;
    }
    
    // 登录
    [self requestLoginWithUsername:username password:password];
}

#pragma mark - Getter/Setter

- (UILabel *)nameLabel {
    if (nil == _nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDHT-100)/2.0, 80, 100, 30)];
        _nameLabel.text = @"AOPDemo";
        _nameLabel.textColor = [UIColor darkTextColor];
    }
    
    return _nameLabel;
}

- (UITextField *)usernameTextField {
    if (nil == _usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, (SCREEN_WIDHT-40), 35)];
        _usernameTextField.placeholder = @"用户名";
        _usernameTextField.layer.borderColor = [UIColor grayColor].CGColor;
        _usernameTextField.layer.borderWidth = 0.5f;
    }
    
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (nil == _passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 250, (SCREEN_WIDHT-40), 35)];
        _passwordTextField.placeholder = @"密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.layer.borderColor = [UIColor grayColor].CGColor;
        _passwordTextField.layer.borderWidth = 0.5f;
    }
    
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (nil == _loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(20, 300, (SCREEN_WIDHT-40), 35);
        _loginButton.layer.borderColor = [UIColor redColor].CGColor;
        _loginButton.layer.borderWidth = 0.5f;
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.backgroundColor = [UIColor redColor];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClickedEvent:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

@end
