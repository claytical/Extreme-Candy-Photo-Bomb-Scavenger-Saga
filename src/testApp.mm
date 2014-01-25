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
    shooter.create(ofGetWidth(), ofGetHeight() - (TOP_PADDING*4), GRID_SQUARE_SIZE, GRID_SQUARE_SIZE);
    cout << candies.size() << " candies created" << endl;

}

//--------------------------------------------------------------
void testApp::update(){
    if (shooter.bulletBeingShot != -1) {
        for (int i = 0; i < candies.size(); i++) {
            if (hitTest(candies[i], shooter.bullets[shooter.bulletBeingShot])) {
                cout << "hit something" << endl;
                //stop the trajectory
                shooter.bullets[shooter.bulletBeingShot].beingShot = false;
                shooter.bullets[shooter.bulletBeingShot].transform = true;
                Candy tmpCandy;
                tmpCandy.create(shooter.bullets[shooter.bulletBeingShot].position.x, candies[i].position.y + GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, GRID_SQUARE_SIZE, shooter.bullets[shooter.bulletBeingShot].color);
                if(findNeighbors(tmpCandy)) {
                    tmpCandy.matched = true;
                }
                candies.push_back(tmpCandy);
                shooter.bulletBeingShot = -1;
                break;

            }
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

bool testApp::findNeighbors(Candy c) {
    if(findNorthernNeighbors(c) || findLeftNeighbors(c) || findRightNeighbors(c)) {
        return true;
    }
    else {
        return false;
    }
}
bool testApp::findNorthernNeighbors(Candy c) {
    float neighborX = c.position.x;
    float neighborY = c.position.y - GRID_SQUARE_SIZE;
    for (int i = 0; i < candies.size(); i++) {
        if (candies[i].position.y == neighborY && candies[i].position.x == neighborX) {
            if (candies[i].color == c.color) {
                candies[i].matched = true;
                findNorthernNeighbors(candies[i]);
                findLeftNeighbors(candies[i]);
                findRightNeighbors(candies[i]);
                return true;
            }
        }
    }
    return false;
}

bool testApp::findSouthernNeighbors(Candy c) {
    float neighborX = c.position.x;
    float neighborY = c.position.y + GRID_SQUARE_SIZE;
    for (int i = 0; i < candies.size(); i++) {
        if (candies[i].position.y == neighborY && candies[i].position.x == neighborX) {
            if (candies[i].color == c.color) {
                findLeftNeighbors(candies[i]);
                findRightNeighbors(candies[i]);
                findSouthernNeighbors(candies[i]);
                return true;
            }
        }
    }
    return false;
}

bool testApp::findLeftNeighbors(Candy c) {
    float neighborX = c.position.x - GRID_SQUARE_SIZE;
    float neighborY = c.position.y;
    for (int i = 0; i < candies.size(); i++) {
        if (candies[i].position.y == neighborY && candies[i].position.x == neighborX) {
            if (candies[i].color == c.color) {
                candies[i].matched = true;
                findNorthernNeighbors(candies[i]);
                findSouthernNeighbors(candies[i]);
                findLeftNeighbors(candies[i]);
                return true;
            }
        }
    }
    return false;
}

bool testApp::findRightNeighbors(Candy c) {
    float neighborX = c.position.x + GRID_SQUARE_SIZE;
    float neighborY = c.position.y;
    for (int i = 0; i < candies.size(); i++) {
        if (candies[i].position.y == neighborY && candies[i].position.x == neighborX) {
            if (candies[i].color == c.color) {
                candies[i].matched = true;
                findNorthernNeighbors(candies[i]);
                findSouthernNeighbors(candies[i]);
                findRightNeighbors(candies[i]);
                return true;
            }
        }
    }
    return false;
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
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
        
}
    
//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    shooter.shoot(touch.x);
    
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
