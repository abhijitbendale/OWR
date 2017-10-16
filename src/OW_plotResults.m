
function OW_plotResults(OSNCM, OSNNO, xx, yy)

% This script illustrates the a way to generate surface plots as shown
% in the paper [1]. You can replace performance numbers for OSNCM and
% OSNNO with whatever algorithm you prefer. A script that contains
% hard-coded performance numbers used in the paper are available in
% plots/plot_results_50.m and plots/lot_results_200.m. These two scripts
% should give a fair idea about how to use this function. I have
% ignored plotting of SVM/1vSet baselines in this script. However, it can
% be easily added by modifying this function
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
% OSNCM = Performance Number for Open Set NCM Classifier (or any other algorithm)
% OSNNO = Performance Number for Open Set NNO Classifier (or any other algorithm)
% xx    = # Unknown Testing Categories e.g. [0, 100, 200, 500]
% yy    = # Vary Known Classes  e.g. [200, 300, 400, 500]
%


figure;hold on
colormap([1 0 1;0 0 1]) %red and blue
surf(xx,yy, OSNCM', 'FaceColor','red','EdgeColor','black', 'MeshStyle', 'both', 'AlphaData', 0.5); %first color (red)
surf(xx,yy, OSNNO', 'FaceColor','green','EdgeColor','white', 'MeshStyle', 'both'); %second color(blue)
%line(xx,yymet, OSSVM','linewidth', 2, 'marker', 'o', 'color', 'c');
%line(xx,yymet, CSSVM','linewidth', 2, 'marker', '*', 'color','b');
alpha(0.55)

LEG = legend('NCM','NNO');
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
