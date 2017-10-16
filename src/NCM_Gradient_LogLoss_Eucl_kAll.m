function [f, G] = NCM_Gradient_LogLoss_Eucl_kAll(W,X,Y,MMeans,k)
        % Computes the gradient 
        % Inputs
        %   W       d x D   Projection Matrix
        %   X       D x n   Image features
        %   Y       n x 1   Class labels 
        %   MMeans  D x k*C Class Means
        %   k       scalar  Number of class means
        %
        % Output
        %   f       log loss value
        %   G       1 x (d * D) Gradient vector
        %
        % Requires: NCM_sqdist, NCM_softmax
        %
        % Please cite the following paper(s) when using this methods        
        % [1]   Distance-Based Image Classification: Generalizing to New Classes at Near Zero Cost
        %       Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka
        %       In Transactions on Pattern Analysis and Machine Intelligence (PAMI) 2013. 
        %       
        % [2]   Metric Learning for Large Scale Image Classification: Generalizing to New Classes at Near-Zero Cost,
        %       Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka
        %       In European Conference on Computer Vision (ECCV), 2012.
        %       
        % Code available at:
        % https://staff.fnwi.uva.nl/t.e.j.mensink/code.php

        % Thomas Mensink, 2012-2014
        % LEAR - INRIA Rhone Alpes, Grenoble, France
        % ISLA - University of Amsterdam, Amsterdam, the Netherlands
        % thomas.mensink@uva.nl
        % https://staff.science.uva.nl/~tmensink/
              
        %% Get some useful sizes
        n  = size(X,2);        
        D   = size(X,1);
        W   = reshape(W,[],D);
        
        % Prepare mask function for the multiple means
        C       = size(MMeans,2) / k;
        assert(C == ceil(C) && C == floor(C));
        
        kMsk    = zeros(k*C,C);
        msk     = bsxfun(@plus,(1:k)',(1:k*C:k*C*C) + (0:k:(k*C)-1))-1;
        kMsk(msk) = 1;
        clear msk
        
        %% Project data
        Wm = W * MMeans;                         % project class centers 
        Wx = W * X;                             % project feature vectors
        
        %% Compute distance and probabilities
        sqd = NCM_sqdist(Wm,Wx);                    % pairwise distances between class centers and images :  C x n
        wic = NCM_softmax(-sqd,1);                  % compute per mean probabilities
        
        cic = kMsk(:,Y) .* wic;
        lic = sum(cic,1);                       % Class probabilities
        
        %% Objective value
        f   = mean( log(lic+eps) );
        
        wic  = wic-bsxfun(@rdivide,cic,lic);    % class weights in the gradient
        
        %% compute gradient, first part takes high dimensional class centers
        tmp = bsxfun(@times, Wm, sum(wic,2)') - Wx*wic';                
        G   = tmp * MMeans';
        % second part takes high dimensional image features
        tmp = (Wm*wic);
        G   = G - tmp * X';        
        G   = (2/n) * G(:);                       % Add correct normalisation

        % To test with minimize
        f = -f;
        G = -G;
end
