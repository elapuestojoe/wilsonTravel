//
//  ThirdViewController.m
//  Wilson: Traveler's Guide
//
//  Created by Kevin Islas Abud on 3/2/15.
//  Copyright (c) 2015 Kevin Islas Abud. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property NSString *file;
@property NSMutableDictionary *diccionarioIDPaises;
@property NSInteger idPais;
@property NSString *nombrePais;
@property NSMutableArray *arrIdiomas;
@property NSMutableArray *arrFrases;
@property NSMutableArray *arrFrasesIdiomaLocal;

@property NSString *idiomaSeleccionado;

@property NSMutableDictionary *dictIdiomas;

@property NSString *idiomaPais;

@end

@implementation ThirdViewController

//TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrFrases count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [_arrFrases objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"DJBStraightUpNow" size:11];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _responseLabel.text = _arrFrasesIdiomaLocal[indexPath.row];
    //_responseLabel.backgroundColor = [UIColor whiteColor];

}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_arrIdiomas count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _arrIdiomas[row];
}

//JUANPI

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* lbl = (UILabel*)view;
    // Customise Font
    if (lbl == nil) {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        
        lbl = [[UILabel alloc] initWithFrame:frame];
        
        [lbl setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [lbl setFont:[UIFont fontWithName:@"DJBStraightUpNow" size:16.0]];
        
    }
    //picker view array is the datasource
    [lbl setText:[_arrIdiomas objectAtIndex:row]];
    
    
    return lbl;
}

//DidSelectRow
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _idiomaSeleccionado = [self pickerView:pickerView titleForRow:row forComponent:1];
    [self cargarFrases];
    _responseLabel.text=@"";
    //_responseLabel.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *archivoIdiomas = [[NSBundle mainBundle] pathForResource:@"IdiomaPorPais" ofType:@"plist"];
    _dictIdiomas = [[NSMutableDictionary alloc] initWithContentsOfFile:archivoIdiomas];
    
    //Crea el arreglo de idiomas
    _arrIdiomas = [[NSMutableArray alloc] init];
    
    NSArray *juanpi = [_dictIdiomas allValues];
    
    //Crea el arreglo de frases
    
    [self cargarFrases];
    
    //Agrega el idioma al arreglo sin repetir
    for(id idioma in juanpi){
        if(![_arrIdiomas containsObject:idioma]){
            [_arrIdiomas addObject:idioma];
    }
        
    
}

    //
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fondoFrases.png"]];
    [self.view insertSubview:backgroundView atIndex:0];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.tableViewOne.dataSource = self;
    self.tableViewOne.delegate = self;
    
    _tableViewOne.alpha = 0.85f;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // You code here to update the view.
    
    [self obtenerPaisSeleccionado];
    
    NSString *archivoFrasesLocal;
    NSString *str = [NSString stringWithFormat:@"Frases%@", _idiomaPais];
    archivoFrasesLocal = [[NSBundle mainBundle] pathForResource:str ofType:@"plist"];
    _arrFrasesIdiomaLocal = [[NSMutableArray alloc] initWithContentsOfFile:archivoFrasesLocal];

}

-(void) obtenerPaisSeleccionado{
    
    //Load IDPAIS
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults]; [prefs synchronize];
    _idPais = [prefs integerForKey:@"idPais"];
    
    //SeleccionarArchivo
    
    _file = [[NSBundle mainBundle] pathForResource:@"IDPaises" ofType:@"plist"];
    
    NSString *stringIDPais = [NSString stringWithFormat:@"%li", (long)_idPais];
    
    _diccionarioIDPaises = [[NSMutableDictionary alloc] initWithContentsOfFile:_file];
    
    _nombrePais = [_diccionarioIDPaises objectForKey:stringIDPais];
    
    _thirdViewLabel.text = _nombrePais;
    
    //Cargar el idioma del pais
    //NSString *archivoIdiomas = [[NSBundle mainBundle] pathForResource:@"IdiomaPorPais" ofType:@"plist"];
    //NSMutableDictionary *dictIdiomas = [[NSMutableDictionary alloc] initWithContentsOfFile:archivoIdiomas];
    _idiomaPais = [_dictIdiomas objectForKey:_nombrePais];
    NSString *str = [NSString stringWithFormat:@"to %@", _idiomaPais];
    _idiomaLabel.text = str;
}

-(void) cargarFrases{
    NSString *archivoFrases;
    
    if(_idiomaSeleccionado==nil){
        _idiomaSeleccionado = @"English";
    }
    
    NSString *str = [NSString stringWithFormat:@"Frases%@", _idiomaSeleccionado];
    archivoFrases = [[NSBundle mainBundle] pathForResource:str ofType:@"plist"];
    
    _arrFrases = [[NSMutableArray alloc] initWithContentsOfFile:archivoFrases];
    [_tableViewOne reloadData];
    
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
