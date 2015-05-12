//
//  OptionsViewController.m
//  Wilson: Traveler's Guide
//
//  Created by Kevin Islas Abud on 3/2/15.
//  Copyright (c) 2015 Kevin Islas Abud. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@property NSMutableArray *paises;
@property NSArray *continentes;
@property NSString *pathForEuropeCountries;
@property NSString *pathForAmericanCountries;
@property NSString *pais;

@property NSInteger europeRow;
@property NSInteger americanRow;

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fondoOpciones.png"]];
    //[self.view insertSubview:backgroundView atIndex:0];
    
    //
    NSString *pathForContinents = [[NSBundle mainBundle] pathForResource:@"Continentes" ofType:@"plist"];
    _pathForEuropeCountries = [[NSBundle mainBundle] pathForResource:@"PaisesEuropa" ofType:@"plist"];
    _pathForAmericanCountries = [[NSBundle mainBundle] pathForResource:@"PaisesAmerica" ofType:@"plist"];
    _continentes = [[NSArray alloc] initWithContentsOfFile:pathForContinents];
    _paises = [[NSMutableArray alloc] initWithContentsOfFile:_pathForAmericanCountries];
    
    //_continentes = [[NSDictionary alloc] initWithContentsOfFile:path];
    //NSArray *capitales = [dict objectForKey:@"Capitales"];
    //NSArray *urls = [dict objectForKey:@"Web"];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0){
        return _continentes.count;
    }else {
        return _paises.count;
    }
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0){
        return _continentes[row];
    } else{
        return _paises[row];
    }
}

//DidSelectRow
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0){
        if(row==0){
        
            _europeRow = [pickerView selectedRowInComponent:1];
            NSMutableArray *paisesDos = [[NSMutableArray alloc] initWithContentsOfFile:_pathForAmericanCountries];
            _paises = paisesDos;
            [pickerView reloadComponent:1];
            
            [pickerView selectRow:_americanRow inComponent:1 animated:NO];
        }
        else if (row==1){
            _americanRow = [pickerView selectedRowInComponent:1];
            NSMutableArray *paisesDos = [[NSMutableArray alloc] initWithContentsOfFile:_pathForEuropeCountries];
            _paises = paisesDos;
            [pickerView reloadComponent:1];
            
            [pickerView selectRow:_europeRow inComponent:1 animated:NO];
        }
    }
    
    _pais = [self pickerView:pickerView titleForRow:row forComponent:1];
    
}
- (IBAction)saveButtonPressed:(id)sender {
    
    /*NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults]; [prefs setObject:_pais forKey:@"paisSeleccionado"]; [prefs synchronize];
     */
    
    NSInteger primerComponente = [self.picker selectedRowInComponent:0];
    NSInteger segundoComponente = [self.picker selectedRowInComponent:1];
    
    NSInteger identificadorPais = primerComponente*100+segundoComponente;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults]; [prefs setInteger:identificadorPais forKey:@"idPais"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Country was saved successfully"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
