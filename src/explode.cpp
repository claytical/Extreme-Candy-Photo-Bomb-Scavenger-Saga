
//
//  explode.c
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/27/14.
//
//

#include "explode.h"


void Explode::create(ofImage * img) {
    image = img;
    position.set(ofRandom(ofGetWidth()), ofRandom(-70, -140));
    speed.set(0, ofRandom(2, 9));
}
void Explode::display() {
    image->draw(position, 40, 40);
    position += speed;
}