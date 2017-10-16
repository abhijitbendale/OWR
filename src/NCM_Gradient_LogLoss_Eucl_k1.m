function [f, G] = NCM_Gradient_LogLoss_Eucl_k1(W,X,Y,Means)
        % Computes the gradient for the NCM
        %
        % Inputs
        %   W       d x D   Projection Matrix
        %   X       D x n   Image features
        %   Y       n x 1   Class labels         
        %   Means   D x C   Class Means
        %
        % Output
        %   f       log loss value
        %   G       1 x (d * D) Gradient vector
        %
        %
        % This functions computes the gradient and function value for the NCM classifier, see equation 8 in [1].
        % This function is exactly the one used for the experiments in [1].
        %
        % See also: NCM_sqdist, softmax
        %
        % References
        % [1]   Metric Learning for Large Scale Image Classification: Generalizing to New Classes at Near-Zero Cost,
        %       Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka
        %       In European Conference on Computer Vision (ECCV), 2012.
        %       http://hal.inria.fr/hal-00722313/en
        
        % Thomas Mensink, 2012-2013
        % LEAR - INRIA Rhone Alpes, Grenoble, France
        % ISLA - University of Amsterdam, Amsterdam, the Netherlands
        % thomas.mensink@uva.nl
              
        %% Get some useful sizes
        n = size(X,2);
        C = size(Means,2);
        
        D = size(X,1);
        W = reshape(W,[],D);
        
        jj = sub2ind([C n], Y, (1:n)');         % linear indices in a matrix of Classes x Images        
                
        %% Project data
        Wm = W * Means;                         % project class centers 
        Wx = W * X;                             % project feature vectors
        
        %% Compute distance and probabilities
        sqd = NCM_sqdist(Wm,Wx);                    % pairwise distances between class centers and images :  C x n
        wic = NCM_softmax(-sqd,1);                  % compute class probabilities
                                
        %% Objective value
        f   = mean( log(wic(jj)+eps) );
            
        %% Compute gradient
        wic(jj) = ( wic(jj)-1 );                % class weights in the gradient
        
        %first part takes high dimensional class centers
        tmp = bsxfun(@times, Wm, sum(wic,2)') - Wx*wic';
        G = tmp * Means';
        % second part takes high dimensional image features
        tmp = (Wm*wic);
        G = G - tmp * X';        
        
        G = (2/n) * G(:);   %Add correct normalisation

        % We do Stochastic Gradient DESCENT: 
        f = -f;
        G = -G;
end
