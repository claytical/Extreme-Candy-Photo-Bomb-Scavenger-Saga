//
//  shooter.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "shooter.h"
#define RED     ofColor(255,0,0)
#define GREEN   ofColor(0,255,0)
#define BLUE    ofColor(0,0,255)

void Shooter::display() {
    ofSetColor(255, 255, 255);
    if (bullets.size() > 0) {
        if (!bulletBeingShot) {
            candyImages[bullets[0].type].draw(position, bullet_width, bullet_width);
        }
        
        candyImages[bullets[1].type].draw(position.x, position.y + bullet_width, bullet_width, bullet_width);
        for (int i = 0; i < bullets.size(); i++) {
            bullets[i].display();
        }
        ofSetColor(255, 255, 255);
        staff.draw(position.x - 15, position.y, 80, 160);
    }
}
void Shooter::create(float x, float y, int w, vector<int> b_types) {
    bullet_width = w;
    bulletBeingShot = false;
    position.set(x, y);
    candyImages[RED_TYPE].loadImage("red.png");
    candyImages[GREEN_TYPE].loadImage("green.png");
    candyImages[BLUE_TYPE].loadImage("blue.png");
    staff.loadImage("staff.png");
    for (int x = 0; x < ofGetWidth(); x+=w) {
        crates.push_back(ofPoint(x, y));
    }
    
    int centerCrate = crates.size() / 2;
    position.set(crates[centerCrate].x, y);
    for (int i = 0; i < b_types.size(); i++) {
        Bullet tmpBullet;
        tmpBullet.create(w, w, b_types[i], &candyImages[b_types[i]]);
        bullets.push_back(tmpBullet);
    }

}
/*
void Shooter::create(float x, float y, int w, int h) {
    bulletBeingShot = false;
    position.set(x, y);
    bullet_width = w;

    candyImages[RED_TYPE].loadImage("red.png");
    candyImages[GREEN_TYPE].loadImage("green.png");
    candyImages[BLUE_TYPE].loadImage("blue.png");
    staff.loadImage("staff.png");
    //make specific spots for the shot to come from
    for (int x = 0; x < ofGetWidth(); x+=bullet_width) {
        crates.push_back(ofPoint(x, y));
    }
    
    int centerCrate = crates.size() / 2;
    position.set(crates[centerCrate].x, y);

    for (int i = 0; i < 2; i++) {
        Bullet tmpBullet;
        int colorSelect = ofRandom(0,3);
//        ofColor tmpColor;
        tmpBullet.create(bullet_width, bullet_width, colorSelect, &candyImages[colorSelect]);
        bullets.push_back(tmpBullet);
    }
}
*/
void Shooter::move(float x, float y) {
    float closestCrateDistance = 999999;
    int closestCrate = -1;
    for (int i = 0; i < crates.size(); i++) {
        float distanceToCrate = ofDist(x, y, crates[i].x, crates[i].y);
        if (distanceToCrate < closestCrateDistance) {
            closestCrate = i;
            closestCrateDistance = distanceToCrate;
        }
    }
    position.set(crates[closestCrate].x, crates[closestCrate].y);
}

void Shooter::reload() {
        Bullet tmpBullet;
        int colorSelect = ofRandom(0,3);
        tmpBullet.create(bullet_width, bullet_width, colorSelect, &candyImages[colorSelect]);
        bullets.push_back(tmpBullet);
    
}

void Shooter::shoot() {
    bullets[0].shoot(position);
    bulletBeingShot = true;
//    reload();
}
