//
//  explode.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/27/14.
//
//

#include "ofMain.h"

class Explode {
    
public:
	
	void display();
    void create(ofImage *);
    ofImage *image;
    ofPoint position;
    ofPoint speed;
    
};
