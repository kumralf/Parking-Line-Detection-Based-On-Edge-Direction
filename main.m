clear all; close all; clc;
a=VideoReader('parklinevideo1.mp4');
for img=1:a.NumberOfFrames
    filename=strcat('frame',num2str(img),'.jpg');
    b=read(a,img);
    imwrite(b,filename);
end
I1=imread('frame20.jpg');
I1=imresize(I1, 1.5, 'bicubic');
Igray=rgb2gray(I1);

I = medfilt2(Igray);                            %MEDIAN FILTERING

counts=imhist(I);
T = otsuthresh(counts);                           %THRESHOLDING
Ibin=imbinarize(I,T);                        

C=edge(Ibin,'canny');                       %EDGE DETECTION

        
       [H,T,R] = hough(C);      
       P  = houghpeaks(H,20,'threshold',ceil(0.1*max(H(:))));         
       lines = houghlines(C,T,R,P,'FillGap',12,'MinLength',40); %DETECTING THE LINEAR LINES
       figure; imshow(I); hold on; title('20. Frame');
       
       
       [w,h]=size(lines);
    for k = 1:1:h
         delta_x1=I(lines(k).point1(2) , lines(k).point1(1)+1);
         delta_x2=I(lines(k).point1(2) , lines(k).point1(1)-1);
         delta_x=double(delta_x1) - double(delta_x2);
                                                                       %EDGE DIRECTION EQUATION IN THE THESIS
         delta_y1=I(lines(k).point1(2)-1 , lines(k).point1(1));
         delta_y2=I(lines(k).point1(2)+1 , lines(k).point1(1));
         delta_y=double(delta_y1) - double(delta_y2);
   
         
         if abs(lines(k).theta) < 30    
             
            if delta_x < 0
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
            end
         
            if delta_x > 0
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            end
         end
         
         if abs(lines(k).theta) >= 30
             
            if delta_y < 0
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
            end
         
            if delta_y > 0
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            end        
         end
    end