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
        //ofSetColor(color);
        //ofRect(position.x, position.y, width, height);
        ofSetColor(255, 255, 255);
        image->draw(position, width, height);
    }
}

void Bullet::create(int w, int h, int t, ofImage * img) {
    image = img;
    speed = 20;
    type = t;
    transform = false;
    destroy = false;
    width = w;
    height = h;
}

void Bullet::shoot(ofPoint pos) {
    position = pos;
    beingShot = true;
}