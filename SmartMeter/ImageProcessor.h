//
//  ImageProcessor.h
//  InfojobOCR
//
//  Created by Paolo Tagliani on 06/06/12.
//  Copyright (c) 2012 26775. All rights reserved.
//

#ifndef InfojobOCR_ImageProcessor_h
#define InfojobOCR_ImageProcessor_h
#import <opencv2/opencv.hpp>

class ImageProcessor {
    
    typedef struct{
        int contador;
        double media;
    }cuadrante;
    
    cv::Mat _imgGray;
    std::vector<cv::Mat> _digits;
    
public:
    /*
     To test the implementation I perform a canny on a black white image
     */
    cv::Mat processImage(cv::Mat source, float height);
    
    /*
     Filter the image with a median filter to redue the salt&pepper noise,
     then apply the smooth operator to reduce noise.
     */
    cv::Mat filterMedianSmoot(const cv::Mat &source);
    
    /*
     Filter with a gaussian
     */
    
    cv::Mat filterGaussian(const cv::Mat&source);
    
    /*
     Histogram equalization on 1 channel image
     */
    cv::Mat equalize(const cv::Mat&source);
    
    /*
     Binarization made using a mobile median treshold,
     adapted using the image dimension
     */
    cv::Mat binarize(const cv::Mat&source);
    
    
    /*
     Detect if an image is rotated and correct to the proper orientation
     of the text
     */
    int correctRotation (cv::Mat &image, cv::Mat &output, float height);
    
    /*
     Implements the rotation of the image according to the angle passed
     as parameter
     */
    cv::Mat rotateImage(const cv::Mat& source, double angle);
    
    /**
     * Draw lines into image.
     * For debugging purposes.
     */
    void drawLines(std::vector<cv::Vec2f>& lines);
    
    /**
     * Draw lines into image.
     * For debugging purposes.
     */
    void drawLines(std::vector<cv::Vec4i>& lines, int xoff, int yoff);
    
    /**
     * Detect the skew of the image by finding almost (+- 30 deg) horizontal lines.
     */
    float detectSkew();
    
    /**
     * Rotate image.
     */
    void rotate(float rotationDegrees);
    
    cv::Mat cannyEdges();
    
    /**
     * Filter contours by size of bounding rectangle.
     */
    void filterContours(std::vector<std::vector<cv::Point> >& contours,
                                        std::vector<cv::Rect>& boundingBoxes, std::vector<std::vector<cv::Point> >& filteredContours);
    
    
    void findAlignedBoxes(std::vector<cv::Rect>::const_iterator begin,
                                          std::vector<cv::Rect>::const_iterator end, std::vector<cv::Rect>& result);
    /**
     * Find and isolate the digits of the counter,
     */
    void findCounterDigits();

};

#endif
