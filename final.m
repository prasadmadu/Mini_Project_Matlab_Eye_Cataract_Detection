function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 06-Jun-2020 22:49:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
[FileName,PathName]=uigetfile('*.jpg;*.bmp;*.png;*.jpeg','INPUT IMAGE ');
I=imread([PathName,FileName]);
axes(handles.axes4);
imshow(I);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I
[nx,ny,d] = size(I) ;
[mc,lc] = meshgrid(1:ny,1:nx) ;%2-D grid coordinates 
imshow(I) ;
hold on
[px,py] = getpts ; % click at the center and approximate Radius
r = sqrt(diff(px).^2+diff(py).^2) ;
set(0,'userdata',r);
th = linspace(0,2*pi) ;%from 0 to 2*pi
xc = px(1)+r*cos(th) ;
yc = py(1)+r*sin(th) ; 
plot(xc,yc,'r') ; %plot(xc,yc,'r') ;
% Keep only points lying inside circle
idx = inpolygon(mc,lc,xc,yc) ;
for i = 1:d
    I1 = I(:,:,i) ;
    I1(~idx) = 255 ;
    I(:,:,i) = I1 ;
end
axes(handles.axes4);
imshow(I)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I
%img1 = imresize(I, [256, 256]);
img2=rgb2gray(I);
img3= imgaussfilt(img2);%used to reduce noise
img4= im2bw(img3);
axes(handles.axes4);
imshow(img4) 

%save image
baseFileName = sprintf('my new image.png'); % creates a string variable
fullFileName = fullfile('C:\Users\Madhusha\Documents\MATLAB\new', baseFileName); %returns a character vector containing the full path to the file
imwrite(img4, fullFileName);% Write image to graphics file

%% Find the class the test image belongs
Ftest=FeatureStatistical(img4);

%% Compare with the feature of training image in the database
load dbfinal.mat
Ftrain=db(:,1:2);% 1 & 2 column
Ctrain=db(:,3);% class 
for (i=1:size(Ftrain,1));
    dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));%abstract
end   
m=find(dist==min(dist),1);
det_class=Ctrain(m);
%msgbox(strcat('Detected Class=',num2str(det_class)));

%Display results
if (det_class == 1 )
    
x = get(0,'userdata');
%find area
area = pi * x^2;

I=imread('C:\Users\Madhusha\Documents\MATLAB\new\my new image.png');

%get image size in pixels;
Imagesize=numel(I);

%get background size
backgroundSize = Imagesize - area;

%get white pixels in whole image;
whitePixels = nnz(I);% Number of nonzero matrix elements

%get cataract pixels;
cataractPixels = whitePixels - backgroundSize;

%calculate cataract presentage
percentageCataract=(cataractPixels/area)*100;
Round_value=round(percentageCataract,3);

%display result
msgbox(strcat('It is a cataract eye & cataract presentage is =',num2str(Round_value)),'Results');
     
else
    msgbox('It is a normal eye');
end
    
    
    
    
    
 
