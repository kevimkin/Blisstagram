//
//  HomeFeedTableViewController.m
//  Blisstagram
//
//  Created by Anders Chaplin on 6/9/15.
//  Copyright (c) 2015 ___AndersChaplin___. All rights reserved.
//

#import "HomeFeedTableViewController.h"
#import "MainFeedTableViewCell.h"

@interface HomeFeedTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property NSMutableArray *pictures;


@end

@implementation HomeFeedTableViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//
//}

- (IBAction)selectPhoto:(id)sender {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;


    [self presentViewController:picker animated:YES completion:NULL];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"yooo");
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.8);
    PFFile *imagefile = [PFFile fileWithName:@"diiiicksz" data:imageData];
    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
    [photo setObject:imagefile forKey:@"image"];
    //Indicate uploading
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //upload image to parse
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            //show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:@"Too bad Suckaa" delegate:self cancelButtonTitle:@"FAIL" otherButtonTitles:nil, nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    return cell;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    if (self) {
        // The className to query on
        self.parseClassName = @"Photo";

        //The key of the PFObject to display in the label of the default cell style
        self.textKey = @"image";

        //Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

        //Whether the built-in pagination is enabled
        self.paginationEnabled = NO;

    }

    return self;
}

-(MainFeedTableViewCell *)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath object:(nullable PFObject *)object{

    MainFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
        NSLog(@"test2");
    //Maybe need this\/?
    if (cell == nil) {
        cell = [[MainFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoCell"];
    }


    // Configure the cell
    PFFile *imageFile = [object objectForKey:@"image"];
    PFImageView *imageView = cell.myImageView;
    cell.myImageView.file = imageFile;
    imageView.file = imageFile;
    [cell.myImageView loadInBackground];
    NSLog(@"%@", imageFile);

    return cell;
}

-(PFQuery *)queryForTable{

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    NSLog(@"Query: %@",query);
    return query;
}
@end
