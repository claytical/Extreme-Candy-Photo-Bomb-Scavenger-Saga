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
        ofSetColor(color);
        ofRect(position.x, position.y, width, height);
    }
}

void Bullet::create(int w, int h, ofColor c) {
    speed = 20;
    transform = false;
    destroy = false;
    color = c;
    width = w;
    height = h;
}

void Bullet::shoot(ofPoint pos) {
    position = pos;
    beingShot = true;
}