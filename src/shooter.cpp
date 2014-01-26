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
    if (bullets.size() > 0) {
        if (!bulletBeingShot) {
            switch (bullets[0].type) {
                case 0:
                    ofSetColor(255, 0, 0);
                    break;
                case 1:
                    ofSetColor(0, 255, 0);
                    break;
                case 2:
                    ofSetColor(0, 0, 255);
                    break;
                    
                default:
                    break;
            }
//            ofSetColor(bullets[0].color);
            ofRect(position.x, position.y, bullet_width, bullet_width);
        }
        switch (bullets[1].type) {
            case 0:
                ofSetColor(255, 0, 0);
                break;
            case 1:
                ofSetColor(0, 255, 0);
                break;
            case 2:
                ofSetColor(0, 0, 255);
                break;
                
            default:
                break;
        }
        ofRect(position.x, position.y + bullet_width, bullet_width, bullet_width);
        for (int i = 0; i < bullets.size(); i++) {
            bullets[i].display();
        }
        staff.draw(position.x - 15, position.y, 80, 160);
    }
}

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
        /* ASSIGN COLOR */
        tmpBullet.create(bullet_width, bullet_width, colorSelect, &candyImages[colorSelect]);
        bullets.push_back(tmpBullet);
    }
}

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
    reload();
}
