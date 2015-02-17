//
//  AddImageViewController.m
//  PhotoAdd
//
//  Created by Азат on 16.02.15.
//  Copyright (c) 2015 Azat Minvaliev. All rights reserved.
//

#import "AddImageViewController.h"

@interface AddImageViewController ()
{
    NSMutableArray *attachPhoto;
    NSIndexPath *indexPath;
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
    [self registerForKeyboardNotifications];
}

-(IBAction) addPhotoFromGallery:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:picker animated:YES];
}

-(IBAction) addPhotoFromCamera:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;

    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self addImage:img];
}

-(void)addImage:(UIImage*)img
{
    [attachPhoto addObject:img];
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return attachPhoto.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: identifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithPatternImage: attachPhoto[indexPath.row]];
    if (attachPhoto.count == 1) {
        self.fullAttachmentImage.image = attachPhoto[0];
    }
    return cell;
}

NSInteger selectedPhotoIndex;


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    UIImage *pic = attachPhoto[indexPath.row];
    self.fullAttachmentImage.image = pic;

    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    frame.origin.y = height*(-1);
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
