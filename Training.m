clc;
clear all;
close all;
%% Taking an Image
[fname, path]=uigetfile('*.jpg;*.bmp;*.png','Open an Image as input for training');
fname=strcat(path, fname);
I=imread(fname);

[nx,ny,d] = size(I) ;
[mc,lc] = meshgrid(1:ny,1:nx) ;
imshow(I) ;

hold on
[px,py] = getpts ;
r = sqrt(diff(px).^2+diff(py).^2) ;
th = linspace(0,2*pi) ;
xc = px(1)+r*cos(th) ; 
yc = py(1)+r*sin(th) ; 
plot(xc,yc,'r') ;
idx = inpolygon(mc,lc,xc',yc) ;
for i = 1:d
    I1 = I(:,:,i) ;
    I1(~idx) = 255 ;
    I(:,:,i) = I1 ;
end
figure
imshow(I)

img2=rgb2gray(I);
img3= imgaussfilt(img2);
img4= im2bw(img3);
imshow(img4);
title('Input Image');
c=input('Enter the Class(Number from 1-2)');
%% Feature Extraction
F=FeatureStatistical(img4);
try 
    load dbfinal;
    F=[F c];
    db=[db; F];
    save dbfinal.mat db
catch 
    db=[F c]; % 10 12 1
    save dbfinal.mat db
end



