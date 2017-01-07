//
//  ImageProcessor.cpp
//  InfojobOCR
//
//  Created by Paolo Tagliani on 06/06/12.
//  Copyright (c) 2012 26775. All rights reserved.
//

#include "ImageProcessor.h"

/**
 * Functor to help sorting rectangles by their x-position.
 */
class sortRectByX {
public:
    bool operator()(cv::Rect const & a, cv::Rect const & b) const {
        return a.x < b.x;
    }
};

cv::Mat ImageProcessor::processImage(cv::Mat source, float height){
    
    
    //Rotacion
    
    if (correctRotation(source, source, height)<0) printf("Error in rotation correction");
    
  //  cv::Mat equalized=equalize(source);
    
    cv::Mat median_filtered=filterMedianSmoot(source);
    
    cv::Mat result=binarize(median_filtered);
    
   
    return result;
    
}

cv::Mat ImageProcessor::filterMedianSmoot(const cv::Mat &source){
    
    
    cv::Mat results;
    cv::medianBlur(source, results, 3);
    return results;
}

cv::Mat ImageProcessor::filterGaussian(const cv::Mat&source){
    
    cv::Mat results;
    cv::GaussianBlur(source, results, cvSize(3, 3), 0);
    return results;
}

cv::Mat ImageProcessor::equalize(const cv::Mat&source){
    
    cv::Mat results;
    cv::equalizeHist(source, results);
    return results;
}

cv::Mat ImageProcessor::binarize(const cv::Mat&source){
    
    cv::Mat results;
    int blockDim=MIN( source.size().height/4, source.size().width/4);
    if(blockDim % 2 != 1) blockDim++;   //block has to be odd
    
    printf("%s : %d","Block dimension", blockDim);
    
    
    
    cv::adaptiveThreshold(source, results, 255, cv::ADAPTIVE_THRESH_MEAN_C,
                          cv::THRESH_BINARY,blockDim, 0);
    return results;
    
}



int ImageProcessor::correctRotation(cv::Mat &image, cv::Mat &output, float height)
{
	//calcular el tamaño optimo de la imagen
	//Ha de ser lo suficicnetemte grande como para que de detecten bien las líneas
	
	//si tomamos de que la imagen ha de ser de 1296 de alto se calcula
    
	float prop=0;
    
	prop = height/image.cols;
    
	//std::cout<<image.cols<<std::endl;
	int cols = image.cols*prop;
	int rows = image.rows*prop;
    
	std::vector<cv::Vec4i> lines;
	cv::Mat resized(cols,rows,CV_8UC1,0);
	cv::Mat dst(cols,rows,CV_8UC1,255);
	cv::Mat original = image.clone();;
	cv::Mat kernel(1,2,CV_8UC1,0);
	cv::Mat kernel2(3,3,CV_8UC1,0);
	
	cv::Size si(0,0);
    
//	cv::Mat trans(cols, rows, CV_8UC1,0);
//	cv::transpose(image,trans);
//	cv::flip(trans,trans,1);
//	cv::resize(trans, resized, si, prop,prop);	
	cv::threshold(image, image, 100, 255, CV_THRESH_BINARY);
	//cv::Canny(image,image,0,100);	
	//cv::erode(image, image, kernel,cv::Point(0,1), 10);
	cv::morphologyEx(image, image, cv::MORPH_OPEN, kernel2, cv::Point(1,1), 15);
	//cv::dilate(image, image, kernel,cv::Point(0,1), 2);
	cv::Canny(image,image,0,100);	
	//lineas de hough
	//cv::HoughLinesP(image, lines, 1, CV_PI/180, 50, 50, 10 );
	cv::HoughLinesP(image, lines, 1, CV_PI/180, 80, 30, 10 );
	double media=0;
	double ang=0;
	int num=0;
	cuadrante c[4];
	for (int i =0; i < 4;i++)
	{
		c[i].media = 0;
		c[i].contador = 0;
	}	
	for( size_t i = 0; i < lines.size(); i++ )
  	{
		cv::Vec4i l = lines[i];
		cv::line( dst, cv::Point(l[0], l[1]), cv::Point(l[2], l[3]), cv::Scalar(0,0,0), 3, CV_AA);
		//ang =atan2(l[3]-l[1],l[0]-l[2]);
		ang =atan2(l[1]-l[3],l[0]-l[2]);
		
		//if (ang >= 0 && ang <=CV_PI / 2)
		if (ang >= 0 && ang <=CV_PI / 3)
		{
			c[0].media += ang;
			c[0].contador++;	
            //}else if (ang >CV_PI/2 && ang <= CV_PI)
		}else if (ang >(2*CV_PI)/3 && ang <= CV_PI)
		{
			c[1].media += ang;
			c[1].contador++;	
            //}else if (ang < 0 && ang > -1*CV_PI/2)
		}else if (ang > -1*CV_PI && ang < -2*CV_PI/3)
		{
			c[2].media += ang;
			c[2].contador++;	
            
		}else if (ang > CV_PI/3 && ang < 0)
		{
			c[3].media += ang;
			c[3].contador++;	
		}
		
	}	
	int biggest = 0;
	int bi=0;
	double rot =0;
	double aux;
	for (int i =0; i < 4;i++)
	{
		if (c[i].contador > bi)
		{
			biggest = i;
			bi = c[i].contador;
		}
		//std::cout<<"El cudrante "<<i<<" tiene "<<c[i].contador<<" elementos y media "<<180*(c[i].media/c[i].contador)/CV_PI<<std::endl;
	}	
	
    
	//std::cout<< "el que mas tiene es "<<biggest<<" con "<<180*(c[biggest].media/c[biggest].contador)/CV_PI<<std::endl;
	
	aux = (180*(c[biggest].media/c[biggest].contador)/CV_PI);
	aux = (aux<0)?-1*aux:aux;	
	if (biggest == 1 || biggest == 2)
	{
        
		rot = 180 - aux; 
	}else{
		rot = aux; 
	}
	
	if (!(biggest == 0 || biggest == 2))
	{
		rot = rot *-1;
	}
	
    
	if (rot<-3 || rot > 3)
	{
		//std::cout<<"he rotado la image "<<rot<<std::endl;
		image = rotateImage(original, rot);
	}else{
		image = original; //no se rota
	}
    
	output = image.clone();
//	/*cv::namedWindow( "Ori+Thres", CV_WINDOW_NORMAL );// Create a window for display.
//     cv::imshow( "Ori+Thres", original);                 	// Show our image inside it.
//     cv::namedWindow( "Detected Lines", CV_WINDOW_NORMAL );// Create a window for display.
//     cv::imshow( "Detected Lines", dst);                 	// Show our image inside it.
//     cv::namedWindow( "Final rotated", CV_WINDOW_NORMAL );// Create a window for display.
//     cv::imshow( "Final rotated", output);      */        	// Show our image inside it.
//	cv::waitKey();
	return 0;
}

cv::Mat ImageProcessor::rotateImage(const cv::Mat& source, double angle)
{
    cv::Point2f src_center(source.cols/2.0F, source.rows/2.0F);
    cv::Mat rot_mat = cv::getRotationMatrix2D(src_center, angle, 1.0);
    cv::Mat dst;
    cv::warpAffine(source, dst, rot_mat, source.size());
    return dst;
}

cv::Mat ImageProcessor::cannyEdges() {
    cv::Mat edges;
    double cannyThreshold1 = 100;
    double cannyThreshold2 = 200;
    // detect edges
    cv::Canny(_imgGray, edges, cannyThreshold1, cannyThreshold2);
    return edges;
}

/**
 * Filter contours by size of bounding rectangle.
 */
void ImageProcessor::filterContours(std::vector<std::vector<cv::Point> >& contours,
                                    std::vector<cv::Rect>& boundingBoxes, std::vector<std::vector<cv::Point> >& filteredContours) {
    
    double digitMinHeight = 20;
    double digitMaxHeight = 90;
    
    // filter contours by bounding rect size
    for (size_t i = 0; i < contours.size(); i++) {
        cv::Rect bounds = cv::boundingRect(contours[i]);
        if (bounds.height > digitMinHeight && bounds.height < digitMaxHeight
            && bounds.width > 5 && bounds.width < bounds.height) {
            boundingBoxes.push_back(bounds);
            filteredContours.push_back(contours[i]);
        }
    }
}

/**
 * Find bounding boxes that are aligned at y position.
 */
void ImageProcessor::findAlignedBoxes(std::vector<cv::Rect>::const_iterator begin,
                                      std::vector<cv::Rect>::const_iterator end, std::vector<cv::Rect>& result) {
    
    double digitYAlignment = 10;
    
    std::vector<cv::Rect>::const_iterator it = begin;
    cv::Rect start = *it;
    ++it;
    result.push_back(start);
    
    for (; it != end; ++it) {
        if (abs(start.y - it->y) < digitYAlignment && abs(start.height - it->height) < 5) {
            result.push_back(*it);
        }
    }
}


void ImageProcessor::findCounterDigits() {
    
    // edge image
    cv::Mat edges = cannyEdges();
    
    cv::Mat img_ret = edges.clone();
    
    // find contours in whole image
    std::vector<std::vector<cv::Point> > contours, filteredContours;
    std::vector<cv::Rect> boundingBoxes;
    cv::findContours(edges, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
    // filter contours by bounding rect size
    filterContours(contours, boundingBoxes, filteredContours);
    
    // find bounding boxes that are aligned at y position
    std::vector<cv::Rect> alignedBoundingBoxes, tmpRes;
    for (std::vector<cv::Rect>::const_iterator ib = boundingBoxes.begin(); ib != boundingBoxes.end(); ++ib) {
        tmpRes.clear();
        findAlignedBoxes(ib, boundingBoxes.end(), tmpRes);
        if (tmpRes.size() > alignedBoundingBoxes.size()) {
            alignedBoundingBoxes = tmpRes;
        }
    }
    
    // sort bounding boxes from left to right
    std::sort(alignedBoundingBoxes.begin(), alignedBoundingBoxes.end(), sortRectByX());
    
    // draw contours
    cv::Mat cont = cv::Mat::zeros(edges.rows, edges.cols, CV_8UC1);
    cv::drawContours(cont, filteredContours, -1, cv::Scalar(255));
    //        cv::imshow("contours", cont);
    
    // cut out found rectangles from edged image
    for (int i = 0; i < alignedBoundingBoxes.size(); ++i) {
        cv::Rect roi = alignedBoundingBoxes[i];
        _digits.push_back(img_ret(roi));
        //        if (_debugDigits) {
        cv::rectangle(_imgGray, roi, cv::Scalar(0, 255, 0), 2);
        //        }
    }
}

