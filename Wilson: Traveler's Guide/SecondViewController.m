//
//  SecondViewController.m
//  Wilson: Traveler's Guide
//
//  Created by Kevin Islas Abud on 3/2/15.
//  Copyright (c) 2015 Kevin Islas Abud. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property NSInteger idPais;
@property NSString *file;
@property NSInteger continente;
@property NSMutableDictionary *diccionarioIDPaises;
@property NSString *codigoCambio;
@property NSArray *arregloMonedas;
@property NSMutableArray *monedasSinRepetir;

@property NSString *monedaSeleccionada;

@property NSDictionary *dict;

@end

@implementation SecondViewController

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_monedasSinRepetir count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _monedasSinRepetir[row];
}

//Veamos Si esto funciona

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* lbl = (UILabel*)view;
    // Customise Font
    if (lbl == nil) {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        
        lbl = [[UILabel alloc] initWithFrame:frame];
        
        [lbl setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [lbl setFont:[UIFont fontWithName:@"DJBStraightUpNow" size:20.0]];
        
    }
    //picker view array is the datasource
    [lbl setText:[_monedasSinRepetir objectAtIndex:row]];
    
    
    return lbl;
}

//DidSelectRow
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _monedaSeleccionada = [self pickerView:pickerView titleForRow:row forComponent:1];
    
}

- (IBAction)btnConvertir:(id)sender {
    
    [self dismissKeyboard];
    
    double moneda = _inputTF.text.doubleValue;
    
    double conversion = [[_dict objectForKey:_codigoCambio]doubleValue];
    
    if(_monedaSeleccionada==nil){
        _monedaSeleccionada = _monedasSinRepetir[0];
    }
    
    double divisor = [[_dict objectForKey:_monedaSeleccionada]doubleValue];
    
    
    double resultado = moneda/conversion * divisor;
    
    NSString *str = [NSString stringWithFormat:@"%f %@", resultado, _monedaSeleccionada];
    
    _resultLabel.text = str;
    
    str = [NSString stringWithFormat:@"Exchange rates last updated on : \n%@", [_dict objectForKey:@"Actualizado"]];
    _lastUpdateTF.text = str;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Background
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fondoConvertidor.png"]];
    [self.view insertSubview:backgroundView atIndex:0];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wilsonBueno"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //Keyboard
    
    
    NSString *archivo = [[NSBundle mainBundle] pathForResource:@"CodigoCambio" ofType:@"plist"];
    NSDictionary *diccionarioMonedas = [[NSDictionary alloc] initWithContentsOfFile:archivo];
    
    _arregloMonedas = [diccionarioMonedas allValues];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self actualizarValores];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"almacenarArchivo.plist"];
    
    _dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *arr = [_dict allKeys];
    
    _monedasSinRepetir = [[NSMutableArray alloc]init];
    
    for (id moneda in arr){
        if([moneda length]<5){
            [_monedasSinRepetir addObject:moneda];
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    _resultLabel.text = @"";
    _inputTF.text = @"";
    
    [self obtenerPaisSeleccionado];
    
    NSString *str = [NSString stringWithFormat:@"Convert %@ to ", _codigoCambio];
    _convertToLabel.text = str;
    
    str = [NSString stringWithFormat:@"%@ = ", _codigoCambio];
    _equalsLabel.text = str;

}

-(void)dismissKeyboard {
    [_inputTF resignFirstResponder];
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
    
    NSLog(@"Pais: %@", nombrePais);
    
    
    //Ya tenemos el nombre del pais seleccionado, ahora vamos a obtener su codigo de cambio
    
    NSString *nombreArchivoCambio = [[NSBundle mainBundle] pathForResource:@"CodigoCambio" ofType:@"plist"];
    NSMutableDictionary *diccionarioCodigoCambio = [[NSMutableDictionary alloc] initWithContentsOfFile:nombreArchivoCambio];
    
    _codigoCambio = [diccionarioCodigoCambio objectForKey:nombrePais];
    
    NSLog(@"Codigo Cambio %@", _codigoCambio);
    
    
    
}

-(void) actualizarValores{
    
    for (id moneda in _arregloMonedas){
        
        //Conseguir el id del pais seleccionado
        
        
        //
        
        NSString *strBusqueda = @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDMXN%22)&format=json&env=store://datatables.org/alltableswithkeys&callback=";
        
        NSString *strBusquedaFormateada = [strBusqueda stringByReplacingOccurrencesOfString:@"MXN" withString:moneda];
        
        //NSLog(@"String formateada: %@", strBusquedaFormateada);
        
        NSURL *url=[NSURL URLWithString:strBusquedaFormateada];   // pass your URL  Here.
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        if(data!=nil){
        
            NSError *error;
        
            NSMutableDictionary  *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
        
            if(json){
            
                NSDictionary *dictQuery = [json objectForKey:@"query"];
                //NSLog(@"%@", dictQuery);
            
                NSDictionary *dictRate = [[dictQuery objectForKey:@"results"]objectForKey:@"rate"];
                //NSLog(@"%@", dictRate);
            
                double rate = [[dictRate objectForKey:@"Rate"] doubleValue];
            
                //NSLog(@"rate = %f", rate);
            
            
                //Grabar valor
            
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:@"almacenarArchivo.plist"];
            
                NSMutableDictionary *diccionario = [NSMutableDictionary dictionaryWithContentsOfFile:path];

                if(diccionario ==nil){
                
                    diccionario = [[NSMutableDictionary alloc] init];
                }
            
                NSLocale *currentLocale = [NSLocale currentLocale];
                NSString *fecha = [[NSDate date] descriptionWithLocale:currentLocale];
            
            
                NSString *strValor = [NSString stringWithFormat:@"%f", rate];
                [diccionario setObject:strValor forKey:moneda];
                [diccionario setObject:fecha forKey:@"Actualizado"];
                [diccionario writeToFile:path atomically:YES];
            }
        
        }
        
    }
    
    
    
}

@end
