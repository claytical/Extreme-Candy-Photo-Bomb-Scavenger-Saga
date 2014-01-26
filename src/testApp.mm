#define GRID_WIDTH          8
#define GRID_HEIGHT         5
#define GRID_SQUARE_SIZE    40
#define TOP_PADDING         20

#include "testApp.h"


//--------------------------------------------------------------
void testApp::setup(){	
	//ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
        capW = ofGetWidth();
        capH = ofGetHeight();
		vidGrabber.initGrabber(capW, capH);
		capW = vidGrabber.getWidth();
		capH = vidGrabber.getHeight();
        colorImg.allocate(capW,capH);
        bLearnPhoto = true;
        createGrid = true;
        threshold = 80;
        ofSetFrameRate(20);
        ofBackground(0, 0, 0);
    //CREATE GRID
        for (int x = 0; x < ofGetWidth(); x+= GRID_SQUARE_SIZE) {
            for (int y = TOP_PADDING; y < ofGetHeight()/2 + TOP_PADDING; y+= GRID_SQUARE_SIZE) {
                Candy tmpCandy;
                int colorSelect = ofRandom(0,3);
                ofColor tmpColor;
                /* ASSIGN COLOR */
                switch (colorSelect) {
                    case 0:
                         tmpColor = ofColor(255,0,0);
                        break;
                    case 1:
                        tmpColor = ofColor(0,255,0);
                        break;
                    case 2:
                        tmpColor = ofColor(0,0,255);
                        break;
                    default:
                        tmpColor = ofColor(0,0,0);
                        break;
                }
                /* CREATE CANDY */
                tmpCandy.create(x, y,GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, tmpColor);
                candies.push_back(tmpCandy);
            }
        }
    shooter.create(ofGetWidth()/2, ofGetHeight() - (TOP_PADDING*4), GRID_SQUARE_SIZE, GRID_SQUARE_SIZE);

}

//--------------------------------------------------------------
void testApp::update(){
    if (shooter.bulletBeingShot) {
        for (int i = 0; i < candies.size(); i++) {
            if (hitTest(candies[i], shooter.bullets[0])) {
                cout << "hit something" << endl;
                //stop the trajectory
                shooter.bullets[0].beingShot = false;
                shooter.bullets[0].transform = true;
                Candy tmpCandy;
                tmpCandy.create(shooter.bullets[0].position.x, candies[i].position.y + GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[0].color);
                
                candies.push_back(tmpCandy);
                findMatchingColors(candies[candies.size()-1]);
                shooter.bulletBeingShot = false;
                break;

            }
        }
        if (shooter.bullets[0].position.y <= TOP_PADDING) {
            Candy tmpCandy;
            tmpCandy.create(shooter.bullets[0].position.x, TOP_PADDING, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[0].color);
            candies.push_back(tmpCandy);
            shooter.bulletBeingShot = false;
            shooter.bullets[0].transform = true;

        }
    }
    
    //remove the bullet
    ofRemove(shooter.bullets, done);
    //remove any matched candies
    ofRemove(candies, matched);

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
                if (candies[i].color == c.color) {
                    candies[i].matched = true;
                }
            }
            //DOWN
            if (candies[i].position.x == downNeighborX && candies[i].position.y == downNeighborY) {
                if (candies[i].color == c.color) {
                    candies[i].matched = true;
                    
                }
            }
            //LEFT
            if (candies[i].position.x == leftNeighborX && candies[i].position.y == leftNeighborY) {
                if (candies[i].color == c.color) {
                    candies[i].matched = true;
                    
                }
            }
            //RIGHT
            if (candies[i].position.x == rightNeighborX && candies[i].position.y == rightNeighborY) {
                if (candies[i].color == c.color) {
                    candies[i].matched = true;
                    
                }
            }
            if (candies[i].matched) {
                c.matched = true;
                findMatchingColors(candies[i]);
            }
        }
    }
}


//--------------------------------------------------------------
void testApp::draw(){	
//    colorImg.draw(0, 0, ofGetWidth(), ofGetHeight());
    for (int i = 0; i < candies.size(); i++) {
        candies[i].display();
    }
    shooter.display();
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
                ofColor tmpColor;
                
                if (red > green && red > blue) {
                    tmpColor = ofColor(255,0,0);
                    
                    cout << "Red Candy"<< endl;
                }
                else if  (green > red && green > blue) {
                    cout << "Green Candy" << endl;
                    tmpColor = ofColor(0,255,0);
                    
                }
                else if (blue > red && blue > green) {
                    cout << "Blue Candy" << endl;
                    tmpColor = ofColor(0,0,255);
                    
                }
                /* CREATE CANDY */
                tmpCandy.create(x, y,GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, tmpColor);
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


//--------------------------------------------------------------
void testApp::exit(){
        
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    shooter.move(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    shooter.move(touch.x, touch.y);
}
    
//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    if (!shooter.bulletBeingShot) {
        shooter.shoot();
    }
}
    
//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    grabImage();
    
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
