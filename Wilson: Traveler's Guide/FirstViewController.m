//
//  FirstViewController.m
//  Wilson: Traveler's Guide
//
//  Created by Kevin Islas Abud on 3/2/15.
//  Copyright (c) 2015 Kevin Islas Abud. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property NSInteger idPais;
@property NSString *file;
@property NSInteger continente;
@property NSMutableArray *arregloNoticias;
@property NSMutableDictionary *diccionario;

@end

@implementation FirstViewController

//Esperemos que funcione

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if([_diccionario objectForKey:@"Pi"]!=nil){
        return YES;
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"You can't change the tab until you read the tutorial"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (IBAction)btnPresionado:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"tutorialTerminado.plist"];
    [_diccionario setObject:@"Juan" forKey:@"Pi"];
    [_diccionario writeToFile:path atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you"
                                                    message:@"for reading this super cool tutorial, we will now take you to the country selection page"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self.tabBarController setSelectedIndex:4];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tabBarController.delegate = self;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bckWilson.png"]];
    [self.view insertSubview:backgroundView atIndex:0];
    
    self.newsLabel.font = [UIFont fontWithName:@"DJBStraightUpNow" size:28];
    
    
    _webView.alpha = 0.85f;
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"tutorialTerminado.plist"];
    
    _diccionario = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if(_diccionario ==nil){
        
        _diccionario = [[NSMutableDictionary alloc] init];
        
        
    } else{
        
        _welcomeLabel.text = @"";
        _labelOne.text = @"";
        _labelTwo.text = @"";
        _labelThree.text = @"";
        _labelFour.text = @"";
        _labelFive.text = @"";
        _btnOK.hidden = YES;
    
        //Load IDPAIS
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults]; [prefs synchronize];
        _idPais = [prefs integerForKey:@"idPais"];
    
        //Seleccionar continente segun IDPAIS
    
        if(_idPais<100){
            _file = [[NSBundle mainBundle] pathForResource:@"NoticiasAmerica" ofType:@"plist"];
            _continente =0;
        } else if (_idPais<200){
            _file = [[NSBundle mainBundle] pathForResource:@"NoticiasEuropa" ofType:@"plist"];
            _continente=100;
        }
    
        //Carga el documento con las url del continente
    
        _arregloNoticias = [[NSMutableArray alloc] initWithContentsOfFile:_file];
    
    
        //Carga el URL
        NSString *urlNoticias = _arregloNoticias[_idPais-_continente];
        //NSLog(@"%@", urlNoticias);
        NSURL *url = [NSURL URLWithString:urlNoticias];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:requestObj];
    

    }
    
    
    
    
    
    
}
@end
