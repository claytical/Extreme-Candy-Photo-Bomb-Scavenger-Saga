//
//  shooter.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "shooter.h"

void Shooter::display() {
    for (int i = 0; i < bullets.size(); i++) {
        bullets[i].display();
    }
}

void Shooter::create(float x, float y, int w, int h) {
    bulletBeingShot = -1;
    position.set(x, y);
    bullet_width = w;
    for (int x = 0; x < ofGetWidth(); x+= bullet_width) {
        Bullet tmpBullet;
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

        tmpBullet.create(x, y, bullet_width, bullet_width, tmpColor);
        bullets.push_back(tmpBullet);
    }
}

void Shooter::reload() {
    bullets.clear();
    for (int x = 0; x < ofGetWidth(); x+= bullet_width) {
    //for (int i = 0; i < 5; i++) {
        Bullet tmpBullet;
        tmpBullet.create(x, position.y, bullet_width, bullet_width, ofColor(255,255,0));
        bullets.push_back(tmpBullet);
    }
    
}

void Shooter::shoot(float x) {
    float touchDistanceToBullet = 999999;
//    bulletBeingShot = -1;
    for (int i = 0; i < bullets.size(); i++) {
        float tmpDistance = abs(bullets[i].position.x - x);
        if (tmpDistance < touchDistanceToBullet) {
            bulletBeingShot = i;
            touchDistanceToBullet = tmpDistance;
        }
    }
    bullets[bulletBeingShot].beingShot = true;

}
