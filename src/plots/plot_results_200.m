% This script generates plot shown in Fig 3a in the paper
% 
% [1] Abhijit Bendale, Terrance Boult "Towards Open World Recognition"
% Computer Vision and Pattern Recognition Conference (CVPR) 2015
% 
% If you use this code, please cite the above paper [1]. 
% 
% Author: Abhijit Bendale (abendale@vast.uccs.edu)
% Vision and Security Technology Lab
% University of Colorado at Colorado Springs
% Code Available at: http://vast.uccs.edu/OpenWorld
% 
% Running this script yields a pdf 3D surface of recognition performance.
% On X axis, Open Set Learning is demonstrated by varying number of 
% unknown testing categories. 
% On Y axis, Incremental Learning is demonstrated by adding additional
% training categories incrementally to the system.
% On Z axis, top-1 accuracy on ImageNet 2010 data is provided
% 
% Metric Learning was performed using 200 initial categories. 
% The performance numbers are hard coded in this script, but another
% script (OW_plotResults.m) is provided with the package which can help 
% generate similar plot with performance numbers of your choice.
% 
% Performance numbers for SVM were obtained using LibSVM and for 1vsSet
% algorithm were obtained using https://github.com/Vastlab/liblinear
% Building on top of the work in 
% 
% [4] W Scheirer, A Rocha, A Sapkota, T Boult "Towards Open Set Recognition"
% IEEE Trans. on Pattern Analysis and Machine Intelligence 2013

clc; clear all; close all;

disp('---------------------------------------------------------------');
disp('Code written by Abhijit Bendale (abendale@vast.uccs.edu)');
disp('Producing results/plots related to work:');
disp('A Bendale, T Boult Towards Open World Recognition, CVPR 2015');
disp('---------------------------------------------------------------');

% Number for plots when Metric learning is performed on
% 50 categories.
figure;hold on
xx = [0, 100, 200, 500]; %Vary Unknowns Classes
yy = [200, 300, 400, 500]; % Vary Known Classes 

% classes on which metric is learned
% required for plotting SVM baseline
yymet = [200, 200, 200, 200]; 

OSNCM = [22.6133 ,  10.1400 ,  9.3300 , 7.2987;...
    12.4089 , 2.3550 , 2.6640 , 2.7489;...
    9.3067, 1.8840, 2.2200, 2.3562;...
    5.3181 , 1.1775 ,  1.4800 ,  1.6493];

OSNNO = [22.4033, 9.1000 , 9.2833, 7.0307;...
    17.7378 , 6.3933 , 5.8520, 5.3478;...
   16.2900, 7.4627 ,6.8178 ,6.2276;...
   12.4343,  7.3167,  6.8926 , 6.4387];

OSSVM = [14.0933; 12.4044; 11.6617; 10.8448];
CSSVM = [19.25; 12.8333; 9.625; 5.5];

colormap([1 0 1;0 0 1]) %red and blue
surf(xx,yy, OSNCM', 'FaceColor','red','EdgeColor','black', 'MeshStyle', 'both', 'AlphaData', 0.5); %first color (red)
surf(xx,yy, OSNNO', 'FaceColor','green','EdgeColor','white', 'MeshStyle', 'both'); %second color(blue)
line(xx,yymet, OSSVM','linewidth', 2, 'marker', 'o', 'color', 'c');
line(xx,yymet, CSSVM','linewidth', 2, 'marker', '*', 'color','b');
alpha(0.55)

LEG = legend('NCM','NNO', w'1vSet', 'SVM');
set(LEG,'FontSize',15);
xl = xlabel('# Unknown Testing Categories', 'Rotation', 13);
yl = ylabel('# Known Training Categories', 'Rotation', -16);
zl = zlabel('Top-1 Accuracy');
set(xl, 'FontSize',14)
set(yl, 'FontSize',14)
set(zl, 'FontSize',14)
grid on
camlight left;

lighting phong
view(139, 19)
set(gcf, 'PaperPosition', [0 0 7 5]);
set(gcf, 'PaperSize', [7 5]);
saveas(gcf, 'owplot_200', 'pdf') 