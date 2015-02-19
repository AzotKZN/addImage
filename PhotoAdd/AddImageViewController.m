//
//  AddImageViewController.m
//  PhotoAdd
//
//  Created by Азат on 16.02.15.
//  Copyright (c) 2015 Azat Minvaliev. All rights reserved.
//

#import "AddImageViewController.h"
#import "ViewController.h"
#define DOCUMENTS_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@interface AddImageViewController ()
{
    IBOutlet UIButton *cameraButton;
    IBOutlet UIButton *galleryButton;
    IBOutlet UIImageView *fullAttachmentImage;
    IBOutlet UITextField *textField;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *fullAttachmentImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    attachPhoto = [[NSMutableArray alloc] init];
    descriptionPhoto = [[NSMutableArray alloc] init];
    [self registerForKeyboardNotifications];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem=doneButton;
}

-(void)done:(UIBarButtonItem *)sender {
    if (attachPhoto.count != 0){
    [self.navigationController popToRootViewControllerAnimated:YES];
    ViewController* vc = [[ViewController alloc] init];
    [vc printPictureAndDescription:attachPhoto and:descriptionPhoto];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ой!"
                                                        message:@"Вы еще не добавили вложения"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

-(IBAction) addPhotoFromGallery:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction) addPhotoFromCamera:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self addImage:img];
}

-(void)addImage:(UIImage*)img
{
    if (img != nil)
    {
        NSString * timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent: (timeStamp)];
        NSData* data = UIImagePNGRepresentation(img);
        [data writeToFile:path atomically:YES];
        [attachPhoto addObject:timeStamp];
        [descriptionPhoto addObject:@""];
        
        if (attachPhoto.count >= 1) {
            _textField.hidden = NO;
        } else {
           _textField.hidden = YES;
        }
        
    }
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return attachPhoto.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: identifier forIndexPath:indexPath];
    NSString *urlImage = [DOCUMENTS_DIRECTORY stringByAppendingString:@"/"];
    urlImage = [urlImage stringByAppendingString:attachPhoto[indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:urlImage]];
    if (attachPhoto.count == 1) {
    self.fullAttachmentImage.image = [UIImage imageNamed:urlImage];
    self.fullAttachmentImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return cell;
}

NSUInteger *indexCell;

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    NSString *urlImage = [DOCUMENTS_DIRECTORY stringByAppendingString:@"/"];
    urlImage = [urlImage stringByAppendingString:attachPhoto[indexPath.row]];
    self.fullAttachmentImage.image = [UIImage imageNamed:urlImage];
    self.textField.text = descriptionPhoto[indexPath.row];
    indexCell = indexPath.row;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldDescription {
    [textFieldDescription resignFirstResponder];
    [descriptionPhoto replaceObjectAtIndex:(int)indexCell
                                withObject:[textFieldDescription text]];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect frame = self.view.frame;
    frame.origin.y = height*(-1)+120;
    [self.view setFrame:frame];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
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
