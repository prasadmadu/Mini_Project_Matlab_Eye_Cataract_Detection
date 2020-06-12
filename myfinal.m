%select image
[FileName,PathName]=uigetfile('*.jpg;*.bmp;*.png;*.jpeg','INPUT IMAGE ');
I=imread([PathName,FileName]);
figure;
imshow(I);

%crop pupil
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


%convert to gray scale
img2=rgb2gray(I);
figure;
imshow(img2);

%filter image
img3= imgaussfilt(img2);
figure;
imshow(img3);

%convert to bw
img4= im2bw(img3);
figure;
imshow(img4);

%save image
baseFileName = sprintf('my new image.png'); % Whatever....
fullFileName = fullfile('C:\Users\Madhusha\Documents\MATLAB\new', baseFileName);
imwrite(img4, fullFileName);

