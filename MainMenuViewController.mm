//
//  MainMenuViewController.m
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/25/14.
//
//

#import "MainMenuViewController.h"
#include "ofxiPhoneExtras.h"
#include "CreditsViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    myApp = (testApp*)ofGetAppPtr();

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playGame:(id)sender {
    myApp->play();
}

- (IBAction)showGamecenter:(id)sender {
    GKLeaderboardViewController *lb = [[GKLeaderboardViewController alloc] init];
    if(lb != nil){
        lb.leaderboardDelegate = self;
        [self presentViewController:lb animated:YES completion:nil];
        
    }

}

- (IBAction)showCredits:(id)sender {
        CreditsViewController *credits = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];
        [self presentViewController:credits animated:YES completion:nil];

}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{

    [self dismissModalViewControllerAnimated:YES];
    [viewController release];
}



@end
