//
//  ViewController.m
//  AstroMath
//
//  Created by steven wong on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define kStateGameRunning 1
#define kStateGameOver 2
#define kStateMenu 3
#define kStateSettings 4
#define kStateHighScore 5

#define kLeftDown 1
#define kRightDown 2
#define kTouchEnded 3

#define kTouch 1
#define kTilt 2

#define kshuttleMaxSpeed 10

@interface ViewController ()

@end

@implementation ViewController
@synthesize background2;
@synthesize scTouchTiltOutlet;
@synthesize gameTitle;
@synthesize asteroid3;
@synthesize asteroid2;
@synthesize asteroid1;
@synthesize backBtnOutlet;
@synthesize shuttle;
@synthesize HighscoreOutlet;
@synthesize settingOutlet;
@synthesize playBtnOutlet;
@synthesize line;
@synthesize wall1;
@synthesize wall2;
@synthesize wall3;
@synthesize wallUnderAns1And2;
@synthesize wall;
@synthesize background;
@synthesize answer3;
@synthesize answer2;
@synthesize answer1;
@synthesize questionLabel;
@synthesize scoreLabel;

NSInteger gameState;
NSString *symbol;
float realAnswer;
NSInteger score;
float wrongAns1;
float wrongAns2;
NSInteger evaluatingAnswer;
float sinkValue = 2;
float y = 118;
NSInteger previousState;
NSInteger highscore;
NSInteger touchState;
CGPoint shuttleVelocity;
int scrollSpeed = 2;
NSInteger controlType;
CGPoint gravity;
NSInteger speedOfShuttle = 10;
NSInteger symbolInt;
NSInteger multiply = 0;
NSInteger division =3;
NSInteger subtraction = 2;
NSInteger addition =1;

UIAlertView *alert1;
UIAlertView *alert2;
int firstLoop = 1;

int gO = 1;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Get the path
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentPath = [paths objectAtIndex:0];
	NSString *path = [documentPath stringByAppendingPathComponent:@"highscore.save"];
	
	// Create a dictionary to hold objects
	NSMutableDictionary* myDict = [[NSMutableDictionary alloc] init];
	
	// Read objects back into dictionary
	myDict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	NSString *nssHighscore = [myDict objectForKey:@"Highscore"];
	highscore = [nssHighscore intValue];
    
    gameState=kStateMenu;
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(scrollBackgroundLoop) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [self setScoreLabel:nil];
    [self setQuestionLabel:nil];
    [self setAnswer1:nil];
    [self setAnswer2:nil];
    [self setAnswer3:nil];
    [self setBackground:nil];
    [self setWall:nil];
    [self setWallUnderAns1And2:nil];
    [self setWall3:nil];
    [self setWall2:nil];
    [self setWall1:nil];
    [self setLine:nil];
    [self setPlayBtnOutlet:nil];
    [self setSettingOutlet:nil];
    [self setHighscoreOutlet:nil];
    [self setShuttle:nil];
    [self setBackBtnOutlet:nil];
    [self setAsteroid1:nil];
    [self setAsteroid2:nil];
    [self setAsteroid3:nil];
    [self setGameTitle:nil];
    [self setScTouchTiltOutlet:nil];
    [self setBackground2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)gameLoop{
    //NSLog(@"gamestate = %i", gameState);
    if (gameState == kStateGameRunning) {
        if (previousState != kStateGameRunning) {
            
            NSString *nssScore = [NSString stringWithFormat:@"Score:%i",score];
            scoreLabel.text = nssScore;
            
            wall.hidden = 1;
            wall1.hidden = 1;
            wall2.hidden = 1;
            wall3.hidden = 1;
            wallUnderAns1And2.hidden = 1;
            gameTitle.hidden = 1;
            shuttle.hidden = 0;
            playBtnOutlet.hidden = 1;
            scoreLabel.hidden = 0;
            answer1.hidden = 0;
            answer2.hidden = 0;
            answer3.hidden = 0;
            questionLabel.hidden = 0;
            backBtnOutlet.hidden = 1;
            scTouchTiltOutlet.hidden = 1;
            settingOutlet.hidden = 1;
            HighscoreOutlet.hidden = 1;
            line.hidden = 0;
            asteroid1.hidden =0;
            asteroid2.hidden =0;
            asteroid3.hidden =0;
            
            // NSLog(@"gameloop:%i",gameState);
            if (score==500) {
                sinkValue += 0.5;
                scrollSpeed +=0.5;
                speedOfShuttle +=1;
            }
            
            if (score==1000) {
                sinkValue += 0.25;
                scrollSpeed +=0.25;
                speedOfShuttle +=1;
                
            }
            if (score==1500) {
                sinkValue += 0.25;
                scrollSpeed +=0.25;
                speedOfShuttle +=0.5;
                
            }
            
            if (score>=2000) {
                sinkValue += 0.25;
                scrollSpeed +=0.25;
                
            }
            
            [self gameStatePlayNormal];
        }
    }
    //Game Over
    else if (gameState == kStateGameOver) {
        
        
        if (previousState == kStateGameRunning) {
            score=0;
            if (score > highscore) {
                //    NSLog(@"game over in gameloop");
                highscore = score;
                NSString *nssHighscore = [NSString stringWithFormat:@"%i",highscore];
                
                //create the dictionary
                NSMutableDictionary* myDict = [[NSMutableDictionary alloc] init];
                
                //Add objects to dicitionary
                [myDict setObject:nssHighscore forKey:@"Highscore"];
                
                //get path
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath = [paths objectAtIndex:0];
                NSString *path = [documentPath stringByAppendingPathComponent:@"highscore.save"];
                
                //save to file
                [NSKeyedArchiver archiveRootObject:myDict toFile:path];
            }
        }
        
        
        previousState=kStateGameOver;
        
    }
    //Menu
    else if (gameState ==kStateMenu) {
        if(previousState != kStateMenu){
            // NSLog(@"Hide everything");
            gameTitle.hidden = 0;
            wall.hidden = 1;
            wall1.hidden = 1;
            wall2.hidden = 1;
            wall3.hidden = 1;
            wallUnderAns1And2.hidden = 1;
            shuttle.hidden = 1;
            scoreLabel.hidden = 1;
            answer1.hidden = 1;
            answer2.hidden = 1;
            answer3.hidden = 1;
            questionLabel.hidden = 1;
            playBtnOutlet.hidden = 0;
            backBtnOutlet.hidden = 1;
            scTouchTiltOutlet.hidden = 1;
            settingOutlet.hidden = 0;
            HighscoreOutlet.hidden = 0;
            line.hidden = 1;
            asteroid1.hidden =1;
            asteroid2.hidden =1;
            asteroid3.hidden =1;
        }
        previousState = kStateMenu;
    }
    //Settings
    else if (gameState == kStateSettings) {
        if (previousState != kStateSettings) {
            gameTitle.hidden = 1;
            wall.hidden = 1;
            wall1.hidden = 1;
            wall2.hidden = 1;
            wall3.hidden = 1;
            wallUnderAns1And2.hidden = 1;
            shuttle.hidden = 1;
            scoreLabel.hidden = 1;
            answer1.hidden = 1;
            answer2.hidden = 1;
            answer3.hidden = 1;
            questionLabel.hidden = 1;
            playBtnOutlet.hidden = 1;
            backBtnOutlet.hidden = 0;
            scTouchTiltOutlet.hidden = 0;
            settingOutlet.hidden = 1;
            HighscoreOutlet.hidden = 1;
            line.hidden = 1;
            asteroid1.hidden =1;
            asteroid2.hidden =1;
            asteroid3.hidden =1;
        }
        previousState = kStateSettings;
    }
    else if (gameState == kStateHighScore) {
        
        NSString *nssHighscore = [NSString stringWithFormat:@"%i", highscore];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"High Score" 
                              message:nssHighscore
                              delegate:nil 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil]; 
        [alert show];
        
        previousState = kStateHighScore;
        gameState=kStateMenu;
    }
    [self detectGameOver];  
}

-(void)gameStatePlayNormal{
    
	if (controlType == kTouch) {
		// If the player is touching the screen, move the ball
		if (touchState == kLeftDown) {shuttleVelocity.x -= speedOfShuttle;}
		if (touchState == kRightDown) {shuttleVelocity.x += speedOfShuttle;}
	}
	
	if (controlType == kTilt) {
		shuttleVelocity.x += gravity.x;
	}
    
    [self scoreLoop];
    //calls to the wallLoop
    [self wallLoop];
    [self asteroidLoop];
    
    
    // stops the shuttle from going off screen
    if (shuttle.center.x + 30 >= self.view.bounds.size.width) {
		shuttle.center = CGPointMake(451, shuttle.center.y);
	}
	if (shuttle.center.x -30 <= 0) {
		shuttle.center = CGPointMake(30, shuttle.center.y);
	}
    shuttle.center = CGPointMake(shuttle.center.x + shuttleVelocity.x,shuttle.center.y + shuttleVelocity.y);
}


-(UIDeviceOrientation)interfaceOrientation
{
    
    return [[UIDevice currentDevice] orientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return  YES;
    }
    
    else 
        return NO;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	if (controlType == kTilt) {
		gravity.x = acceleration.x * 10;
	}
}

// identifies where the user has the screen and move the space shuttle over

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
    
    if (gameState == kStateGameRunning && controlType == kTouch) {
		if (location.x < (self.view.bounds.size.width/2)) {
			touchState = kLeftDown;
			shuttleVelocity.x -= 0.2;
		}
		else {
			touchState = kRightDown;
			shuttleVelocity.x += 0.2;
		}
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	touchState = kTouchEnded;
}

-(void)generateNewQuestion{
    
    //generates two random number and a random symbol
    
    NSLog(@"random numbers");
    int number1 = (arc4random()%8)+1;
    int number2 = (arc4random()%8)+1;
    int symbolNum = arc4random()%3;
    
    NSLog(@"random symbol");
    
    switch (symbolNum) {
        case 0:
            symbol = @"x";
            symbolInt =0;
            break;
            
        case 1:
            symbol = @"+";
            symbolInt = 1;
            break;
            
        case 2:
            symbol = @"-";
            symbolInt = 2;
            break;
            
        case 3:
            symbol = @"÷";
            symbolInt = 3;
            break;
            
        default:
            break;
    }
    
    //if the first number is smaller than the second number and that the operation symbol is subtraction, then number1 would change values with number2
    
    
    if (score<=750) {
        
        NSLog(@"switch big and small number");
        
        if (number1<=number2 && symbolInt==subtraction) {
            int bigNum = number2;
            int smallNum = number1;
            number1 = bigNum;
            number2 = smallNum;
        }
        
    }
    
    
    //if the score is less than 1000, and the operation is division, then get another operation which is not division.
    
    if (score<=750 && symbolInt==division) {
        
        NSLog(@"switch symbols");
        
        symbolNum = arc4random()%3;
        
        NSLog(@" symbol number is: %i", symbolNum);
        
        if (symbolNum==division) {
            NSLog(@"redo symbol");
            symbolNum = arc4random()%2;
            switch (symbolNum) {
                    switch (symbolNum) {
                            NSLog(@"inside switch case");
                        case 0:
                            symbol = @"x";
                            symbolInt =0;
                            break;
                            
                        case 1:
                            symbol = @"+";
                            symbolInt = 1;
                            break;
                            
                        case 2:
                            symbol = @"-";
                            symbolInt = 2;
                            break;
                            
                        default:
                            break;        
                    }
            }
        }
        NSLog(@"finsih generating question");
    }
    
    
    //outputs the question on the label
    
    NSLog(@"outputting question");
    
    NSString *question = [NSString stringWithFormat:@"%i %@ %i =?", number1,symbol, number2];
    questionLabel.text = question;
    
    //calculates the answer for question
    NSLog(@"calculates answer for  question");
    
    switch (symbolNum) {
        case 0:
            realAnswer = number1*number2;
            break;
            
        case 1:
            realAnswer = number1+number2;
            break;
            
        case 2:
            realAnswer = number1-number2;
            break;
            
        case 3:
            realAnswer = (float)number1/number2;
            break;
            
        default:
            break;
    }
    
    
    //calculates a wrong answer by adding or subracting from the right answer
    int ranNumForSymbol = arc4random()%1;
    int ranNum = (arc4random()%4)+1;
    
    switch (ranNumForSymbol) {
        case 0:
            wrongAns1= (realAnswer - ranNum);
            break;
            
        case 1:
            wrongAns1= (realAnswer + ranNum);
            break;
            
        default:
            break;
    }
    
    //calculates a second wrong answer by adding or subracting from the right answer
    
    switch (ranNumForSymbol) {
        case 0:
            wrongAns2 = (realAnswer+ranNum);
            break;
            
        case 1:
            wrongAns2 = (realAnswer-ranNum);
            break;
            
        default:
            break;
    }
    
    //creates a combination for outputting the answers
    int randNumForAnswers = arc4random()%5;
    
    switch (randNumForAnswers) {
        case 0:
            answer1.text = [NSString stringWithFormat:@"%0.2f",realAnswer];
            answer2.text = [NSString stringWithFormat:@"%0.2f",wrongAns1];
            answer3.text = [NSString stringWithFormat:@"%0.2f",wrongAns2];
            //   NSLog(@"%i",randNumForAnswers);
            evaluatingAnswer = 0;
            
            break;
            
        case 1:
            answer1.text = [NSString stringWithFormat:@"%0.2f",wrongAns1];
            answer2.text = [NSString stringWithFormat:@"%0.2f",realAnswer];
            answer3.text = [NSString stringWithFormat:@"%0.2f",wrongAns2];
            
            //    NSLog(@"%i",randNumForAnswers);
            evaluatingAnswer = 1;
            
            break;
            
        case 2:
            answer1.text = [NSString stringWithFormat:@"%0.2f",wrongAns1];
            answer2.text = [NSString stringWithFormat:@"%0.2f",wrongAns2];
            answer3.text = [NSString stringWithFormat:@"%0.2f",realAnswer];
            //  NSLog(@"%i",randNumForAnswers);
            evaluatingAnswer = 2;
            
            break;
            
        case 3:
            answer1.text = [NSString stringWithFormat:@"%0.2f",realAnswer];
            answer2.text = [NSString stringWithFormat:@"%0.2f",wrongAns2];
            answer3.text = [NSString stringWithFormat:@"%0.2f",wrongAns1];
            //   NSLog(@"%i",randNumForAnswers);
            evaluatingAnswer = 3;
            
            break;
            
        case 4:
            answer1.text = [NSString stringWithFormat:@"%0.2f",wrongAns2];
            answer2.text = [NSString stringWithFormat:@"%0.2f",realAnswer];
            answer3.text = [NSString stringWithFormat:@"%0.2f",wrongAns1];
            
            //  NSLog(@"%i",randNumForAnswers);
            evaluatingAnswer = 4;
            
            break;
            
        case 5:
            answer1.text = [NSString stringWithFormat:@"%0.2f",wrongAns2];
            answer2.text = [NSString stringWithFormat:@"%0.2f",wrongAns1];
            answer3.text = [NSString stringWithFormat:@"%0.2f",realAnswer];
            //  NSLog(@"%i",randNumForAnswers);
            evaluatingAnswer = 5;
            break;
            
        default:
            break;
    }
    
}

//when the button is pressed the gameStatePlayNormal method is called
- (IBAction)backButton:(id)sender {
    gameState = kStateMenu;
}

// when the button is pressed it tells the programmer if the user chose the right answer
- (IBAction)playButton:(id)sender {
    NSLog(@"%f",wall.center.y);
    gameState =kStateGameRunning;
    // NSLog(@"play button pressed:%i",gameState);
    [self generateNewQuestion];
    
    sinkValue = 2;
    
    /*[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(wallLoop) userInfo:nil repeats:YES];
     
     NSLog(@"case = %i", evaluatingAnswer);
     switch (evaluatingAnswer) {
     case 0:
     
     if (shuttle.center.x < self.view.bounds.size.width/3) {
     
     NSLog(@"you are right");
     }
     
     else if (shuttle.center.x > self.view. bounds.size.width/3 && shuttle.center.x < self.view.bounds.size.width*2/3 ) {
     NSLog(@"you are wrong");
     //wallUnderAns2.center = CGPointMake(wallUnderAns2.center.x, wallUnderAns2.center.y + sinkValue);
     
     }
     
     else if (shuttle.center.x < self.view.bounds.size.width) {
     NSLog(@"you are wrong");
     //wallUnderAns3.center = CGPointMake(wallUnderAns3.center.x, wallUnderAns3.center.y + sinkValue);
     }
     
     break;
     
     case 1:
     
     if (shuttle.center.x < self.view.bounds.size.width/3) {
     
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x > self.view. bounds.size.width/3 && shuttle.center.x < self.view.bounds.size.width*2/3 ) {
     NSLog(@"you are right");
     }
     
     else if (shuttle.center.x < self.view.bounds.size.width) {
     NSLog(@"you are wrong");
     }
     break;
     
     case 2:
     
     if (shuttle.center.x < self.view.bounds.size.width/3) {
     
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x > self.view. bounds.size.width/3 && shuttle.center.x < self.view.bounds.size.width *2/3) {
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x < self.view.bounds.size.width) {
     NSLog(@"you are right");
     }
     
     break;
     
     case 3:
     
     if (shuttle.center.x < self.view.bounds.size.width/3) {
     
     NSLog(@"you are right");
     }
     
     else if (shuttle.center.x > self.view. bounds.size.width/3 && shuttle.center.x < self.view.bounds.size.width *2/3) {
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x < self.view.bounds.size.width) {
     NSLog(@"you are wrong");
     }
     
     break;
     
     case 4:
     
     if (shuttle.center.x < self.view.bounds.size.width/3) {
     
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x > self.view. bounds.size.width/3 && shuttle.center.x < self.view.bounds.size.width*2/3 ) {
     NSLog(@"you are right");
     }
     
     else if (shuttle.center.x < self.view.bounds.size.width) {
     NSLog(@"you are wrong");
     }
     break;
     
     case 5:
     
     if (shuttle.center.x < self.view.bounds.size.width/3) {
     
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x > self.view. bounds.size.width/3 && shuttle.center.x < self.view.bounds.size.width *2/3) {
     NSLog(@"you are wrong");
     }
     
     else if (shuttle.center.x < self.view.bounds.size.width) {
     NSLog(@"you are right");
     }
     break;
     
     default:
     break; */
}

-(void)wallLoop{
    
    //identifies the wrong answers, and under the wrong answers a wall would appear sink
    switch (evaluatingAnswer) {
        case 0:
            wall.hidden=1;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            wall.center = CGPointMake(wall.center.x, wall.center.y+ sinkValue);
            line.center = CGPointMake(line.center.x, line.center.y+ sinkValue);
            break;
            
        case 1:
            wall.hidden=YES;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = 1;
            wall2.hidden = YES;
            wall3.hidden = 1;
            
            wall1.center = CGPointMake(wall1.center.x, wall1.center.y+ sinkValue);
            wall3.center = CGPointMake(wall3.center.x, wall3.center.y+ sinkValue);
            line.center = CGPointMake(line.center.x, line.center.y+ sinkValue);
            break;
            
        case 2:
            wall.hidden=YES;
            wallUnderAns1And2.hidden=1;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            
            wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, wallUnderAns1And2.center.y+ sinkValue);
            line.center = CGPointMake(line.center.x, line.center.y+ sinkValue);
            break;
            
        case 3:
            wall.hidden=1;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            wall.center = CGPointMake(wall.center.x, wall.center.y+ sinkValue);
            line.center = CGPointMake(line.center.x, line.center.y+ sinkValue);
            break;
            
        case 4:
            wall.hidden=YES;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = 1;
            wall2.hidden = YES;
            wall3.hidden = 1;
            
            wall1.center = CGPointMake(wall1.center.x, wall1.center.y+ sinkValue);
            wall3.center = CGPointMake(wall3.center.x, wall3.center.y+ sinkValue);
            line.center = CGPointMake(line.center.x, line.center.y+ sinkValue);
            break;
            
        case 5:
            wall.hidden=YES;
            wallUnderAns1And2.hidden=1;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            
            wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, wallUnderAns1And2.center.y+ sinkValue);
            line.center = CGPointMake(line.center.x, line.center.y+ sinkValue);
            break;
            
        default:
            break;
    }
    
    //when the wall reaches the edge of the screen, it will respawn at its original spot and hides
    if (wallUnderAns1And2.center.y >= self.view.bounds.size.height){
        wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, y);
        wallUnderAns1And2.hidden = YES;
        line.center = CGPointMake(line.center.x, y);
        [self generateNewQuestion];
    }
    
    if (wall.center.y >= self.view.bounds.size.height){
        wall.center = CGPointMake(wall.center.x, y);
        line.center = CGPointMake(line.center.x, y);
        wall.hidden = YES;
        [self generateNewQuestion];
    }
    
    if (wall3.center.y >= self.view.bounds.size.height) {
        wall3.center = CGPointMake(wall3.center.x, y);
        wall3.hidden = YES;
        line.center = CGPointMake(line.center.x, y);
        [self generateNewQuestion];
    }
    
    if (wall1.center.y >= self.view.bounds.size.height) {
        wall1.center = CGPointMake(wall1.center.x, y);
        wall1.hidden = YES;
        line.center = CGPointMake(line.center.x, y);
        [self generateNewQuestion];
    }
    
    if (wall2.center.y >= self.view.bounds.size.height) {
        wall2.center = CGPointMake(wall2.center.x, y);
        wall2.hidden=YES;
        line.center = CGPointMake(line.center.x, y);
        [self generateNewQuestion];
    }
    
    
}

-(void)asteroidLoop{
    NSLog(@"asteroid reach");
    while (firstLoop == 1) {
        NSLog(@"loop1");
        asteroid1.center = CGPointMake(79.5, 41.5 + sinkValue);
        asteroid2.center = CGPointMake(240.5, 41.5 + sinkValue);
        asteroid3.center = CGPointMake(411.5, 41.5 + sinkValue);
        firstLoop ++;
    }
    
    float viewWidth = self.view.bounds.size.width;
    float fViewWidthMinusPlatformWidth = viewWidth - 75.0f;
    int iViewWidthMinusPlatformWidth = (int)fViewWidthMinusPlatformWidth;
    
    NSLog(@"reached here");
    
    if (asteroid1.center.y >= (self.view.bounds.size.height)) {
        float x = arc4random() % iViewWidthMinusPlatformWidth;
        float y = (arc4random()%182)+118;
        asteroid1.center = CGPointMake(x, y + sinkValue);
    }
    if (asteroid2.center.y >= (self.view.bounds.size.height)) {
        float x = arc4random() % iViewWidthMinusPlatformWidth;
        float y = (arc4random()%182)+118;
        asteroid2.center = CGPointMake(x, y + sinkValue);
    }
    if (asteroid3.center.y >= (self.view.bounds.size.height)) {
        float x = arc4random() % iViewWidthMinusPlatformWidth;
        float y = (arc4random()%182)+118;
        asteroid3.center = CGPointMake(x, y + sinkValue);
    }
    
}

-(void)detectGameOver{
    if(CGRectIntersectsRect(shuttle.frame, wall.frame)||CGRectIntersectsRect(shuttle.frame, wall1.frame)||CGRectIntersectsRect(shuttle.frame, wallUnderAns1And2.frame)||CGRectIntersectsRect(shuttle.frame, wall2.frame)||CGRectIntersectsRect(shuttle.frame, wall3.frame)||CGRectIntersectsRect(shuttle.frame, asteroid1.frame)||CGRectIntersectsRect(shuttle.frame, asteroid2.frame)||CGRectIntersectsRect(shuttle.frame, asteroid3.frame)){
        gameState=kStateGameOver;
        //    NSLog(@"game over in detectgameover");
        
        
        while (gO == 1) {
            
            if (score > highscore) {
                
                
                //   NSLog(@"game over in gameloop");
                NSLog(@"highscore");
                highscore = score;
                NSString *nssHighscore = [NSString stringWithFormat:@"%i",highscore];
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"High Score" 
                                      message:nssHighscore 
                                      delegate:self 
                                      cancelButtonTitle:@"Menu" 
                                      otherButtonTitles: nil];
                
                
                alert.tag = 2;
                [alert addButtonWithTitle:@"Restart"];
                [alert show];
                
                //create the dictionary
                NSMutableDictionary* myDict = [[NSMutableDictionary alloc] init];
                
                //Add objects to dicitionary
                [myDict setObject:nssHighscore forKey:@"Highscore"];
                
                //get path
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath = [paths objectAtIndex:0];
                NSString *path = [documentPath stringByAppendingPathComponent:@"highscore.save"];
                
                //save to file
                [NSKeyedArchiver archiveRootObject:myDict toFile:path];
            }
            
            else {
                NSString *nssScore = [NSString stringWithFormat:@"Your Score: %i",score];
                NSString *nssHighscore = [NSString stringWithFormat:@"Highscore: %i",highscore];
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nssScore 
                                      message:nssHighscore 
                                      delegate:self 
                                      cancelButtonTitle:@"Menu" 
                                      otherButtonTitles: nil];
                
                
                alert.tag = 1;
                [alert addButtonWithTitle:@"Restart"];
                [alert show];
                
            }
            
            gO ++;
        }
        
    }
    shuttleVelocity.x = 0;
    shuttleVelocity.y = 0;
}

//increase the score by 1 every time it is called
-(void)scoreLoop{
    //    NSLog(@"score Loop");
    score +=1;
    scoreLabel.text = [NSString stringWithFormat:@"score: %i",score];
}



- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%i", alertView.tag);
    
    
    if (alertView.tag == 1) {
        
        
        
        if (buttonIndex == 0) {
            NSLog(@"Menu Was pressed");
            gameState=3;
            shuttle.center = CGPointMake(240, shuttle.center.y);
            
            wall.hidden=YES;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            
            wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, y);
            wall.center = CGPointMake(wall.center.x, y);
            wall3.center = CGPointMake(wall3.center.x, y);
            wall1.center = CGPointMake(wall1.center.x, y);
            wall2.center = CGPointMake(wall2.center.x, y);
            line.center= CGPointMake(line.center.x, y);
            [self generateNewQuestion];
            gO = 1;
            sinkValue=2;
            
            score = 0;
        }
        
        else if (buttonIndex == 1) {
            //Restart was pressed
            NSLog(@"%i", gameState);
            
            gameState = kStateGameRunning;
            NSLog(@"%i", gameState);
            
            shuttle.center = CGPointMake(240, shuttle.center.y);
            
            wall.hidden=YES;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            
            wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, y);
            wall.center = CGPointMake(wall.center.x, y);
            wall3.center = CGPointMake(wall3.center.x, y);
            wall1.center = CGPointMake(wall1.center.x, y);
            wall2.center = CGPointMake(wall2.center.x, y);
            line.center= CGPointMake(line.center.x, y);
            [self generateNewQuestion];
            gO = 1;
            sinkValue=2;
            
            score = 0;
            
            
        }
    }
    
    
    
    if (alertView.tag == 2) {
        
        NSLog(@"Highscore Alert button pressed");
        
        if (buttonIndex == 0) {
            NSLog(@"Menu Was pressed");
            gameState=3;
            shuttle.center = CGPointMake(240, shuttle.center.y);
            
            wall.hidden=YES;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            
            wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, y);
            wall.center = CGPointMake(wall.center.x, y);
            wall3.center = CGPointMake(wall3.center.x, y);
            wall1.center = CGPointMake(wall1.center.x, y);
            wall2.center = CGPointMake(wall2.center.x, y);
            line.center= CGPointMake(line.center.x, y);
            [self generateNewQuestion];
            gO = 1;
            
            score = 0;
        }
        
        else if (buttonIndex == 1) {
            //Restart was pressed
            NSLog(@"%i", gameState);
            
            gameState = kStateGameRunning;
            NSLog(@"%i", gameState);
            
            shuttle.center = CGPointMake(240, shuttle.center.y);
            
            wall.hidden=YES;
            wallUnderAns1And2.hidden=YES;
            wall1.hidden = YES;
            wall2.hidden = YES;
            wall3.hidden = YES;
            
            wallUnderAns1And2.center = CGPointMake(wallUnderAns1And2.center.x, y);
            wall.center = CGPointMake(wall.center.x, y);
            wall3.center = CGPointMake(wall3.center.x, y);
            wall1.center = CGPointMake(wall1.center.x, y);
            wall2.center = CGPointMake(wall2.center.x, y);
            line.center= CGPointMake(line.center.x, y);
            [self generateNewQuestion];
            gO = 1;
            
            score = 0;
            
            
        }
    }
    
    
    
    else {
        
        NSLog(@"%i", alertView.tag);
        NSLog(@"This user has the talent of pushing buttons that don't exist. WOW!");
    }
}    




-(void)scrollBackgroundLoop{
    
    background.center = CGPointMake(background.center.x, background.center.y + scrollSpeed);
    background2.center = CGPointMake(background2.center.x, background2.center.y + scrollSpeed);
    
    
    if (background.center.y > self.view.bounds.size.height + (background.bounds.size.height/2)) {
        background.center = CGPointMake(background.center.x, background2.center.y - 300);
    }
    
    if (background2.center.y > self.view.bounds.size.height + (background2.bounds.size.height/2)) {
        background2.center = CGPointMake(background2.center.x, background.center.y - 300);
    }
    
    
}
- (IBAction)scTouchTilt:(id)sender {
    if (scTouchTiltOutlet.selectedSegmentIndex == 0) {
		controlType = kTilt;
	} else {
		controlType = kTouch;
	}
    
}
- (IBAction)settingsButton:(id)sender {
    gameState = kStateSettings;
}
- (IBAction)HighscoreButton:(id)sender {
    gameState = kStateHighScore;
    
}
@end
