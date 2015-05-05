//
//  TelephonesViewController.m
//  Wilson: Traveler's Guide
//
//  Created by Kevin Islas Abud on 5/2/15.
//  Copyright (c) 2015 Kevin Islas Abud. All rights reserved.
//

#import "TelephonesViewController.h"

@interface TelephonesViewController ()

@property NSInteger idPais;
@property NSString *file;
@property NSMutableDictionary *diccionarioIDPaises;

@end

@implementation TelephonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fondoTelefonos.png"]];
    [self.view insertSubview:backgroundView atIndex:0];
    
    //Police
    
    UITapGestureRecognizer* phone1LblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone1LblTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_policeLabel setUserInteractionEnabled:YES];
    [_policeLabel addGestureRecognizer:phone1LblGesture];
    
    //Health
    
    UITapGestureRecognizer* healthGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(healthTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_healthLabel setUserInteractionEnabled:YES];
    [_healthLabel addGestureRecognizer:healthGesture];
    
    //Firemen
    
    UITapGestureRecognizer* firemenGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firemenTapped)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_firemenLabel setUserInteractionEnabled:YES];
    [_firemenLabel addGestureRecognizer:firemenGesture];
    
    
    
}

- (void)firemenTapped
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:_firemenLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (void)healthTapped
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:_healthLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (void)phone1LblTapped
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:_policeLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self obtenerPaisSeleccionado];
    
}

-(void) obtenerPaisSeleccionado{
    
    //Load IDPAIS
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults]; [prefs synchronize];
    _idPais = [prefs integerForKey:@"idPais"];
    
    //SeleccionarArchivo
    
    _file = [[NSBundle mainBundle] pathForResource:@"IDPaises" ofType:@"plist"];
    
    NSString *stringIDPais = [NSString stringWithFormat:@"%li", (long)_idPais];
    
    _diccionarioIDPaises = [[NSMutableDictionary alloc] initWithContentsOfFile:_file];
    
    NSString *nombrePais = [_diccionarioIDPaises objectForKey:stringIDPais];
    
    NSString *str = [NSString stringWithFormat:@"Emergency numbers for %@", nombrePais];
    
    _titleLabel.text = str;
    
    //Numeros de policia
    
    NSString *strPolice = [[NSBundle mainBundle] pathForResource:@"PoliceNumbers" ofType:@"plist"];
    
    NSDictionary *dictNumPolice = [[NSDictionary alloc] initWithContentsOfFile:strPolice];
    
    NSString *numPolice = [dictNumPolice objectForKey:nombrePais];
    
    _policeLabel.text = numPolice;
    
    
    //Numeros de emergencia
    
    NSString *strHealth = [[NSBundle mainBundle] pathForResource:@"HealthNumbers" ofType:@"plist"];
    
    NSDictionary *dictNumHealth = [[NSDictionary alloc] initWithContentsOfFile:strHealth];
    
    NSString *numHealth = [dictNumHealth objectForKey:nombrePais];
    
    _healthLabel.text = numHealth;
    
    //Numeros de bomberos
    
    NSString *strFiremen = [[NSBundle mainBundle] pathForResource:@"FiremenNumbers" ofType:@"plist"];
    
    NSDictionary *dictNumFiremen = [[NSDictionary alloc] initWithContentsOfFile:strFiremen];
    
    NSString *numFiremen = [dictNumFiremen objectForKey:nombrePais];
    
    _firemenLabel.text = numFiremen;
    
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
