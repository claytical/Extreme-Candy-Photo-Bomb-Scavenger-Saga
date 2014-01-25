//
//  candy.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "ofMain.h"

class Candy {
    
public:
	
	void display();
    void create(float x, float y, int w, int h, ofColor c);

    ofColor color;
    ofPoint position;
    bool matched;
    int width;
    int height;
    
    
};
