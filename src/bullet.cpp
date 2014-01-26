//
//  bullet.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "bullet.h"

void Bullet::display() {
    if (beingShot) {
        position.y-=speed;
        switch (type) {
            case 0:
                ofSetColor(255,0,0);
                break;
            case 1:
                ofSetColor(0,255,0);
                break;
            case 2:
                ofSetColor(0,0,255);
                break;
                
            default:
                break;
        }
//        ofSetColor(color);
        ofRect(position.x, position.y, width, height);
    }
}

void Bullet::create(int w, int h) {
    speed = 20;
    type = ofRandom(3);
    transform = false;
    destroy = false;
    width = w;
    height = h;
}

void Bullet::shoot(ofPoint pos) {
    position = pos;
    beingShot = true;
}