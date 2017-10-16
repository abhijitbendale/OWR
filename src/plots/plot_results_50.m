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
% Metric Learning was performed using 50 initial categories. 
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
yy = [50, 100, 150, 200]; % Vary Known Classes 

% classes on which metric is learned
% required for plotting SVM baseline
yymet = [50, 50, 50, 50]; 


OSNCM = [20.5600, 9.3667, 9.4400, 9.1033; ...
        6.8533, 4.6833, 5.6640 ,6.0689; ...
        4.1120 ,3.1222, 4.0457, 4.5517; ...
        1.8691, 1.5611, 2.1785, 2.6010];
OSNNO = [19.8933,  8 , 8.5600,  8.4267;...
    12.2178, 7.5700, 7.9440 ,7.8267;...
    10.0267, 7.2667 , 7.5752,  7.5667;...
    9.0412  ,  7.5656  ,  7.7015 , 7.6867];    

% only unknown classes i.e. X dimension is varied
% use OSSVM' to be consistent with other plots.
OSSVM = [ 16.0267; 13.5689; 11.2827; 10.3988]; 
CSSVM = [21.12; 7.04;  4.224; 1.92];

colormap([1 0 1;0 0 1]) %red and blue
surf(xx,yy, OSNCM', 'FaceColor','red','EdgeColor','black', 'MeshStyle', 'both', 'AlphaData', 0.5); %first color (red)
surf(xx,yy, OSNNO', 'FaceColor','green','EdgeColor','white', 'MeshStyle', 'both'); %second color(blue)
line(xx,yymet, OSSVM','linewidth', 2, 'marker', 'o', 'color', 'c');
line(xx,yymet, CSSVM','linewidth', 2, 'marker', '*', 'color','b');
alpha(0.55)
ylim([50, 200])
xlim([0, 500])
zlim([0, 25])
LEG = legend('NNO','NCM','1vSet','SVM');
set(LEG,'FontSize',15);
xl = xlabel('# Unknown Testing Categories', 'Rotation', 13);
yl = ylabel('# Known Training Categories', 'Rotation', -16);
zl = zlabel('Top-1 Accuracy');
set(xl, 'FontSize',14)
set(yl, 'FontSize',14)
set(zl, 'FontSize',14)
grid on
axis on
camlight left;

lighting phong
view(139, 19)
set(gcf, 'PaperPosition', [0 0 7 5]);
set(gcf, 'PaperSize', [7 5]);
saveas(gcf, 'owplot_50', 'pdf') 