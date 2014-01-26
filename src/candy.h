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
    void create(float x, float y, int w, int h, int t, int st, ofImage *);
    ofImage *image;
    ofColor color;
    ofPoint position;
    bool matched;
    bool hanging;
    int width;
    int height;
    int type;
    int subtype;
    
    
};
