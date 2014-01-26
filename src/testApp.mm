#define GRID_WIDTH          8
#define GRID_HEIGHT         5
#define GRID_SQUARE_SIZE    40
#define TOP_PADDING         20
#define STARTING_TIME       10
#define GAME_LENGTH         30

#include "testApp.h"

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


//--------------------------------------------------------------
void testApp::setup(){	
	//ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
        candyImages[RED_TYPE].loadImage("red.png");
        candyImages[GREEN_TYPE].loadImage("green.png");
        candyImages[BLUE_TYPE].loadImage("blue.png");

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
        ofBackground(0, 0, 0);
        score = 0;
        candiesCollected = 0;
        ofEnableAlphaBlending();
        gameState = MAIN_MENU_STATE;
}

//--------------------------------------------------------------
void testApp::update(){
    switch (gameState) {
        case MAIN_MENU_STATE:
            break;
        case STARTING_STATE:
            break;
        case TAKE_PICTURE_STATE:
            break;
        case LOADING_GAME_STATE:
            shooter.create(ofGetWidth()/2, ofGetHeight() - (TOP_PADDING*4), GRID_SQUARE_SIZE, GRID_SQUARE_SIZE);
            randomLevel();
            startTime = ofGetElapsedTimef();
            endTime = startTime + GAME_LENGTH;
            gameState = PLAYING_GAME_STATE;
            break;
        case PLAYING_GAME_STATE:
            
                if (shooter.bulletBeingShot) {
                    for (int i = 0; i < candies.size(); i++) {
                        if (hitTest(candies[i], shooter.bullets[0])) {
                            cout << "hit something" << endl;
                            //stop the trajectory
                            shooter.bullets[0].beingShot = false;
                            shooter.bullets[0].transform = true;
                            Candy tmpCandy;
                            
                            tmpCandy.create(shooter.bullets[0].position.x, candies[i].position.y + GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[0].type, &candyImages[shooter.bullets[0].type]);
                            
                            candies.push_back(tmpCandy);
                            findMatchingColors(candies[candies.size()-1]);
                            shooter.bulletBeingShot = false;
                            break;
                            
                        }
                    }
                    
                    if (shooter.bullets[0].position.y <= TOP_PADDING) {
                        Candy tmpCandy;
                        
                        tmpCandy.create(shooter.bullets[0].position.x, TOP_PADDING, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[0].type, &candyImages[shooter.bullets[0].type]);
                        
                        
                        candies.push_back(tmpCandy);
                        shooter.bulletBeingShot = false;
                        shooter.bullets[0].transform = true;
                        
                    }
                    
                    if (candiesCollected > 0) {
                        int additionalPoints = (candiesCollected * candiesCollected * 10);
                        score = score + additionalPoints;
                        cout << "Additional Points: " << additionalPoints;
                        cout << "New Score: " << score;
                        candiesCollected = 0;
                        
                    }
                }
                
                //remove the bullet
                ofRemove(shooter.bullets, done);
                //remove any matched candies
                ofRemove(candies, matched);
                if (ofGetElapsedTimef() > endTime) {
                    gameState = GAME_OVER_STATE;
                }

            if (tooManyCandies()) {
                gameState = GAME_OVER_STATE;
            }

            
            break;
        case GAME_OVER_STATE:
            break;
            
        default:
            break;
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

bool testApp::tooManyCandies() {
    for (int i = 0; i < candies.size(); i++) {
        if (candies[i].position.y >= 360) {
            return true;
        }
    }
    return false;
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
                findMatchingColors(candies[i]);
            }
        }
    }
}


//--------------------------------------------------------------
void testApp::draw(){
    switch (gameState) {
        case MAIN_MENU_STATE:
            break;
        case STARTING_STATE:
            break;
        case TAKE_PICTURE_STATE:
            ofSetColor(255, 255, 255);
            colorImg.draw(0, 0, ofGetWidth(), ofGetHeight());
            break;
        case LOADING_GAME_STATE:
            break;
        case PLAYING_GAME_STATE:
            for (int i = 0; i < candies.size(); i++) {
                candies[i].display();
            }
            shooter.display();

            break;
        case GAME_OVER_STATE:
            break;
    }
    
}
//--------------------------------------------------------------
void testApp::grabImage() {
        vidGrabber.update();
        if( vidGrabber.getPixels() != NULL ){
            colorImg.setFromPixels(vidGrabber.getPixels(), capW, capH);
        }

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
                tmpCandy.create(x, y,GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, selectedColor, &candyImages[selectedColor]);

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
        for (int y = TOP_PADDING; y < ofGetHeight()/2 + TOP_PADDING; y+= GRID_SQUARE_SIZE) {
            Candy tmpCandy;
            int colorSelect = ofRandom(0,3);
            
            /* CREATE CANDY */
            tmpCandy.create(x, y,GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, colorSelect, &candyImages[colorSelect]);
            
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
            cout << "moving from main menu" << endl;
            gameState = STARTING_STATE;
            
            break;
        case STARTING_STATE:
            cout << "moving from starting state" << endl;
            gameState = TAKE_PICTURE_STATE;

            break;
        case TAKE_PICTURE_STATE:
            cout << "moving from taking picture state" << endl;
            gameState = LOADING_GAME_STATE;
            break;
        case LOADING_GAME_STATE:
            cout << "moving from loading game state" << endl;
            gameState = PLAYING_GAME_STATE;
            break;
        case PLAYING_GAME_STATE:
            if (!shooter.bulletBeingShot) {
                wand.vibrate();
                shooter.shoot();
            }
            break;
        case GAME_OVER_STATE:
            cout << "moving from game over state back to main menu" << endl;
            gameState = MAIN_MENU_STATE;
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
