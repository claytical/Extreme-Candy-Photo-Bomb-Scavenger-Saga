
#include "testApp.h"
#include "MainMenuViewController.h"

#define GRID_WIDTH              8
#define GRID_HEIGHT             5
#define GRID_SQUARE_SIZE        40
#define TOP_PADDING             60
#define SCORE_PADDING           10
#define SCORE_PADDING_BOTTOM    10
#define STARTING_TIME           10
#define GAME_LENGTH             30
#define HURRY_UP_QUEUE          5
#define RED     ofColor(255,0,0)
#define GREEN   ofColor(0,255,0)
#define BLUE    ofColor(0,0,255)

#define RED_TYPE    0
#define GREEN_TYPE  1
#define BLUE_TYPE   2


#define MAIN_MENU_STATE         0
#define STARTING_STATE          1
#define TAKE_PICTURE_STATE      2
#define LOADING_GAME_STATE      3
#define PLAYING_GAME_STATE      4
#define GAME_OVER_STATE         5


MainMenuViewController *mainMenuViewController;

//--------------------------------------------------------------
void testApp::setup(){	
	//ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    player = [NSUserDefaults standardUserDefaults];
    introSound.loadSound("intro.caf");
    hurrySound.loadSound("hurryup.caf");
    soundtrack.loadSound("gamebg.caf");
    rememberSound.loadSound("remember.caf");
    soundtrack.setVolume(.5);
    soundtrack.setLoop(true);
    introSound.setLoop(true);
    introSound.play();
    for (int i = 0; i < 7 ; i++) {
        candyImages[RED_TYPE][i].loadImage("red1.png");
        candyImages[GREEN_TYPE][i].loadImage("green2.png");
        candyImages[BLUE_TYPE][i].loadImage("blue3.png");
        candySounds[i].loadSound("crunch"+ofToString(i)+".caf");
        
    }

    bulletImages[RED_TYPE].loadImage("red4.png");
    bulletImages[GREEN_TYPE].loadImage("green4.png");
    bulletImages[BLUE_TYPE].loadImage("blue4.png");

    for (int i = 0; i < 5 ; i++) {
        randomTaunt[i].loadSound("taunt"+ofToString(i)+".caf");
    }
        hourglassImage.loadImage("hourglass_white.png");
        scoreBarImage.loadImage("score_bar_longer.png");
        gameOverImage.loadImage("gameover_candies.png");
        themeImage.loadImage("game_quote.png");
        themeSound.loadSound("speech.caf");
        firingWand.loadSound("shoot.caf");
        startSound.loadSound("start.caf");
        cauldron.loadSound("bubble.caf");
        cauldron.setVolume(.8);
        cauldron.setLoop(true);
        cauldronMask.loadImage("caldron_text_masked.png");
        scoreText.loadFont("perp.ttf", 15);
        scoreTextBig.loadFont("perp.ttf", 30);
        messageText.loadFont("sbn.ttf", 30);
        capW = ofGetWidth();
        capH = ofGetHeight();
		vidGrabber.initGrabber(capW, capH);
		capW = vidGrabber.getWidth();
		capH = vidGrabber.getHeight();
        colorImg.allocate(capW,capH);
        bLearnPhoto = true;
        createGrid = true;
        playing = false;
        ofSetFrameRate(20);
        ofBackground(255,255,255);
        score = 0;
        candiesCollected = 0;
        ofEnableAlphaBlending();
        gameState = MAIN_MENU_STATE;
        mainMenuViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
        [ofxiPhoneGetGLParentView() addSubview:mainMenuViewController.view];
}

void testApp::play() {
    gameState = STARTING_STATE;
    introSound.stop();
    themeSound.play();
    mainMenuViewController.view.hidden = true;
}
//--------------------------------------------------------------
void testApp::update(){

    switch (gameState) {
        case MAIN_MENU_STATE:
            break;
        case STARTING_STATE:
            break;
        case TAKE_PICTURE_STATE:
            vidGrabber.update();
            if( vidGrabber.getPixels() != NULL ){
                colorImg.setFromPixels(vidGrabber.getPixels(), capW, capH);
            }
            
            break;
        case LOADING_GAME_STATE:
            /*
            for (int i = 0; i < 7 ; i++) {
                candyImages[RED_TYPE][i].loadImage("red"+ofToString(int(ofRandom(7)))+".png");
                candyImages[GREEN_TYPE][i].loadImage("green"+ofToString(int(ofRandom(7)))+".png");
                candyImages[BLUE_TYPE][i].loadImage("blue"+ofToString(int(ofRandom(7)))+".png");
            }
             */
            shooter.create(ofGetWidth()/2, ofGetHeight() - 130, GRID_SQUARE_SIZE, getAmmo());
            randomLevel();
            startTime = ofGetElapsedTimef();
            endTime = startTime + GAME_LENGTH;
            nextTaunt = startTime + ofRandom(5,10);
            gameState = PLAYING_GAME_STATE;
            cauldron.stop();
            soundtrack.play();
            break;
        case PLAYING_GAME_STATE:
            if (ofGetElapsedTimef() > nextTaunt) {
                int randomInt = ofRandom(0,5);
                randomTaunt[randomInt].play();
                nextTaunt = nextTaunt + ofRandom(5,10);
            }
            if (ofGetElapsedTimef() > endTime - HURRY_UP_QUEUE && !hurryUpPlayed) {
                //play hurry up
                hurrySound.play();
                hurryUpPlayed = true;
            }
                if (shooter.bulletBeingShot) {
                    for (int i = 0; i < candies.size(); i++) {
                        if (hitTest(candies[i], shooter.bullets[0])) {
                            cout << "hit something" << endl;
                            //stop the trajectory
                            shooter.bullets[0].beingShot = false;
                            shooter.bullets[0].transform = true;
                            Candy tmpCandy;
                            int randomInt = ofRandom(0,7);
                            tmpCandy.create(shooter.bullets[0].position.x, candies[i].position.y + GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[0].type, randomInt, &bulletImages[shooter.bullets[0].type]);
                            
                            candies.push_back(tmpCandy);
                            findMatchingColors(candies[candies.size()-1]);
                            shooter.bulletBeingShot = false;
                            break;
                            
                        }
                    }
                    
                    if (shooter.bullets[0].position.y <= TOP_PADDING) {
                        Candy tmpCandy;
                        int randomInt = ofRandom(0,7);
                        
                        tmpCandy.create(shooter.bullets[0].position.x, TOP_PADDING, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[0].type, randomInt, &bulletImages[shooter.bullets[0].type]);
                        
                        
                        candies.push_back(tmpCandy);
                        shooter.bulletBeingShot = false;
                        shooter.bullets[0].transform = true;
                        
                    }
                    
                    if (candiesCollected > 0) {
                        int additionalPoints = (candiesCollected * candiesCollected * 10);
                        ScorePop tmpPop;
                        tmpPop.create("+" + ofToString(additionalPoints), shooter.bullets[0].position);
                        scorePops.push_back(tmpPop);
                        score = score + additionalPoints;
                        candiesCollected = 0;
                    }
                }
            for (int i = 0; i < candies.size(); i++) {
                checkHangers(candies[i]);
                
            }
                //remove the bullet
                ofRemove(shooter.bullets, done);
                //remove any matched candies
                ofRemove(candies, matched);
                //remove score pop messages
                ofRemove(scorePops, popped);
                ofRemove(candies, hanging);

            if (ofGetElapsedTimef() > endTime) {
                    gameState = GAME_OVER_STATE;
                }

            if (tooManyCandies()) {
                gameState = GAME_OVER_STATE;
            }
            
            if (zappedAllCandies()) {
                float timeBonus = (endTime - ofGetElapsedTimef()) * 100;
                score += timeBonus;
                gameState = GAME_OVER_STATE;
            }
            if (gameState == GAME_OVER_STATE) {
                soundtrack.stop();
                if (score == highscore()) {
                    NSLog(@"New High Score");
                }
                else {
                    NSLog(@"Failed to achieve high score");
                }
            }
    
            break;
        case GAME_OVER_STATE:
            break;
            
        default:
            break;
    }
}
int testApp::highscore() {
    if (score > [[player valueForKey:@"highest_score"] intValue]) {
        NSLog(@"New High Score!");
        [player setValue:[NSString stringWithFormat:@"%i", score ] forKey:@"highest_score"];
        [player synchronize];

        return score;
    }
    else {
        return [[player valueForKey:@"highest_score"] intValue];
    }
}

bool testApp::matched(Candy &candy) {
    return candy.matched;
}
bool testApp::done(Bullet &bullet) {
    if (bullet.transform || bullet.destroy) {
        return true;
    }
    return false;
}
bool testApp::popped(ScorePop &scorepop) {
    if (scorepop.duration < ofGetElapsedTimef()) {
        return true;
    }
    else {
        return false;
    }
}

bool testApp::hanging(Candy &candy) {
    return candy.hanging;
}

bool testApp::tooManyCandies() {
    for (int i = 0; i < candies.size(); i++) {
        if (candies[i].position.y >= 360) {
            return true;
        }
    }
    return false;
}

bool testApp::zappedAllCandies() {
    if (candies.size() == 0) {
        return true;
    }
    return false;
}

void testApp::checkHangers(Candy &c) {
    float upNeighborX = c.position.x;
    float upNeighborY = c.position.y - GRID_SQUARE_SIZE;
    float downNeighborX = c.position.x;
    float downNeighborY = c.position.y + GRID_SQUARE_SIZE;
    float leftNeighborX = c.position.x - GRID_SQUARE_SIZE;
    float leftNeighborY = c.position.y;
    float rightNeighborX = c.position.x + GRID_SQUARE_SIZE;
    float rightNeighborY = c.position.y;
    c.hanging = true;
    for (int i = 0; i < candies.size(); i++) {
            //UP
            if (candies[i].position.x == upNeighborX && candies[i].position.y == upNeighborY) {
                c.hanging = false;
            }
            //DOWN
            if (candies[i].position.x == downNeighborX && candies[i].position.y == downNeighborY) {
                c.hanging = false;
            }
            //LEFT
            if (candies[i].position.x == leftNeighborX && candies[i].position.y == leftNeighborY) {
                c.hanging = false;
            }
            //RIGHT
            if (candies[i].position.x == rightNeighborX && candies[i].position.y == rightNeighborY) {
                c.hanging = false;
            }
        
    }
}

void testApp::findMatchingColors(Candy &c) {
    float upNeighborX = c.position.x;
    float upNeighborY = c.position.y - GRID_SQUARE_SIZE;
    float downNeighborX = c.position.x;
    float downNeighborY = c.position.y + GRID_SQUARE_SIZE;
    float leftNeighborX = c.position.x - GRID_SQUARE_SIZE;
    float leftNeighborY = c.position.y;
    float rightNeighborX = c.position.x + GRID_SQUARE_SIZE;
    float rightNeighborY = c.position.y;
    
    for (int i = 0; i < candies.size() - 1; i++) {
        if (!candies[i].matched) {
            //UP
            if (candies[i].position.x == upNeighborX && candies[i].position.y == upNeighborY) {
                if (candies[i].type == c.type) {
                    candies[i].matched = true;
                }
            }
            //DOWN
            if (candies[i].position.x == downNeighborX && candies[i].position.y == downNeighborY) {
                if (candies[i].type == c.type) {
                    candies[i].matched = true;
                }
            }
            //LEFT
            if (candies[i].position.x == leftNeighborX && candies[i].position.y == leftNeighborY) {
                if (candies[i].type == c.type) {
                    candies[i].matched = true;
                }
            }
            //RIGHT
            if (candies[i].position.x == rightNeighborX && candies[i].position.y == rightNeighborY) {
                if (candies[i].type == c.type) {
                    candies[i].matched = true;
                }
            }
            if (candies[i].matched) {
                candiesCollected++;
                c.matched = true;
                candySounds[candies[i].subtype].play();
                findMatchingColors(candies[i]);
            }
        }
    }
}


//--------------------------------------------------------------
void testApp::draw(){
    float sandTimerHeight;
    float sandTimerY;
    switch (gameState) {
        case MAIN_MENU_STATE:
            break;
        case STARTING_STATE:
            ofSetColor(255, 255, 255);
            themeImage.draw(0, 0, ofGetWidth(), ofGetHeight());
            break;
        case TAKE_PICTURE_STATE:
            ofSetColor(255, 255, 255);
            colorImg.draw(0, 0);
            cauldronMask.draw(0, 0, ofGetWidth(), ofGetHeight());
            break;
        case LOADING_GAME_STATE:
            break;
        case PLAYING_GAME_STATE:
            for (int i = 0; i < candies.size(); i++) {
                candies[i].display();
            }
            for (int i = 0; i < scorePops.size(); i++) {
                ofSetColor(0, 0, 0);
                scoreText.drawString(scorePops[i].text, scorePops[i].position.x, scorePops[i].position.y);
            }
            shooter.display();
            ofSetColor(229, 186, 33);
            sandTimerHeight = ofMap(ofGetElapsedTimef(), startTime, endTime, 60, 0);
            sandTimerY = ofMap(ofGetElapsedTimef(), startTime, endTime, 0, 60);
            ofRect(ofGetWidth()-30, sandTimerY + SCORE_PADDING, 30, sandTimerHeight);
            ofSetColor(255, 255, 255);
            scoreBarImage.draw(0,SCORE_PADDING, 290, 60);
            hourglassImage.draw(ofGetWidth()-30, SCORE_PADDING, 30, 60);
            ofSetColor(0, 0, 0);
            scoreTextBig.drawString(ofToString(score), 120, SCORE_PADDING + 40);
            break;
        case GAME_OVER_STATE:
            ofSetColor(255, 255, 255);
            gameOverImage.draw(0, ofGetHeight()/4, 320, 162);
            ofSetColor(0, 0, 0);
            messageText.drawStringCentered(ofToString(score), ofGetWidth()/2, ofGetHeight()-100);
            break;
    }
    
}
//--------------------------------------------------------------
vector<int> testApp::getAmmo() {
    vector<int> tmpInts;
    unsigned char * pixels = colorImg.getPixels();
    
    for (int x = 0; x < ofGetWidth(); x+= GRID_SQUARE_SIZE) {
        for (int y = TOP_PADDING; y < ofGetHeight()/2 + TOP_PADDING; y+= GRID_SQUARE_SIZE) {
            int index = y*ofGetWidth()*3 + x*3;
            int red = pixels[index];
            int green = pixels[index+1];
            int blue = pixels[index+2];
            
            if (red > green && red > blue) {
                tmpInts.push_back(RED_TYPE);
                cout << "Red Candy"<< endl;
            }
            else if  (green > red && green > blue) {
                cout << "Green Candy" << endl;
                tmpInts.push_back(GREEN_TYPE);
            }
            else if (blue > red && blue > green) {
                cout << "Blue Candy" << endl;
                tmpInts.push_back(BLUE_TYPE);
                
            }
        }
    }
    return tmpInts;

}
//--------------------------------------------------------------
void testApp::grabImage() {

        candies.clear();
        
        unsigned char * pixels = colorImg.getPixels();
        
        for (int x = 0; x < ofGetWidth(); x+= GRID_SQUARE_SIZE) {
            for (int y = TOP_PADDING; y < ofGetHeight()/2 + TOP_PADDING; y+= GRID_SQUARE_SIZE) {
                Candy tmpCandy;
                int index = y*ofGetWidth()*3 + x*3;
                int red = pixels[index];
                int green = pixels[index+1];
                int blue = pixels[index+2];
                int selectedColor;
                
                if (red > green && red > blue) {
                    selectedColor = RED_TYPE;
                    
                    cout << "Red Candy"<< endl;
                }
                else if  (green > red && green > blue) {
                    cout << "Green Candy" << endl;
                    selectedColor = GREEN_TYPE;
                }
                else if (blue > red && blue > green) {
                    cout << "Blue Candy" << endl;
                    selectedColor = BLUE_TYPE;
                    
                }
                int randomInt = ofRandom(0,7);

                tmpCandy.create(x, y,GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, selectedColor, randomInt, &candyImages[selectedColor][randomInt]);

                /* CREATE CANDY */
                candies.push_back(tmpCandy);
            }
        }
}

bool testApp::hitTest(Candy candy, Bullet bullet) {
    if (candy.position.x < bullet.position.x + bullet.width && candy.position.x + candy.width > bullet.position.x &&
        candy.position.y < bullet.position.y + bullet.height && candy.position.y + candy.height > bullet.position.y) {
        return true;
    }
    return false;
}

void testApp::randomLevel() {
    candies.clear();
    for (int x = 0; x < ofGetWidth(); x+= GRID_SQUARE_SIZE) {
        for (int y = TOP_PADDING + SCORE_PADDING + SCORE_PADDING_BOTTOM; y < ofGetHeight()/2; y+= GRID_SQUARE_SIZE) {
            Candy tmpCandy;
            int colorSelect = ofRandom(0,3);
            int randomInt = ofRandom(0,7);

            /* CREATE CANDY */
            tmpCandy.create(x, y,GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, colorSelect, randomInt, &candyImages[colorSelect][randomInt]);
            
            candies.push_back(tmpCandy);
        }
    }

}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    switch (gameState) {
        case MAIN_MENU_STATE:
            break;
        case STARTING_STATE:
            break;
        case TAKE_PICTURE_STATE:
            break;
        case LOADING_GAME_STATE:
            break;
        case PLAYING_GAME_STATE:
            shooter.move(touch.x, touch.y);
            
            break;
        case GAME_OVER_STATE:
            break;
    }

    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    switch (gameState) {
        case MAIN_MENU_STATE:
            break;
        case STARTING_STATE:
            break;
        case TAKE_PICTURE_STATE:
            break;
        case LOADING_GAME_STATE:
            break;
        case PLAYING_GAME_STATE:
            shooter.move(touch.x, touch.y);
            
            break;
        case GAME_OVER_STATE:
            break;
    }

}
    
//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    switch (gameState) {
        case MAIN_MENU_STATE:
            gameState = STARTING_STATE;
            
            break;
        case STARTING_STATE:
            cauldron.play();
            rememberSound.play();
            gameState = TAKE_PICTURE_STATE;

            break;
        case TAKE_PICTURE_STATE:
            startSound.play();
            gameState = LOADING_GAME_STATE;
            break;
        case LOADING_GAME_STATE:
            gameState = PLAYING_GAME_STATE;
            
            break;
        case PLAYING_GAME_STATE:
            if (!shooter.bulletBeingShot) {
                wand.vibrate();
                firingWand.play();
                shooter.shoot();
            }
            break;
        case GAME_OVER_STATE:
            cout << "moving from game over state back to main menu" << endl;
            mainMenuViewController.view.hidden = false;
            gameState = MAIN_MENU_STATE;
            introSound.play();
            break;
    }

}
    
//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}
    
//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
        
}
    
//--------------------------------------------------------------
void testApp::lostFocus(){
        
}
    
//--------------------------------------------------------------
void testApp::gotFocus(){
        
}
    
//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
        
}
    
//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
        
}

