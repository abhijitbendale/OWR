function [W, obj, W0] = NCM_train_sgd(X,Y,Means,W,k,ops)
    % Basic SGD training for NCM objective
    %
    % Input
    %   X       [D x N]             Feature matrix D dimensional feature, N images
    %   Y       [1 x N]             Ground Truth Class Labels for N images
    %   Means   [D x C]             Means matrix, D dimensional, C classes
    %   W       [d x D]             W matrix init
    %         or scalar             Number of dimensions d
    %   k       scalar              Number of means (default = 1);
    %   opts    struct              Struct with options
    %
    % Output
    %   W       [d x D]             Learned W matrix
    %   obj     [I x 2]             Objective over I iterations
    %   W0      [d x D]             Initial W matrix
    %
    % This functions implements a very basic SGD scheme to maximize the NCM objective, eq 7 in [1].
    % It relies on the NCM_gradient_LogLoss_Eucl_k1 and NCM_gradient_LogLoss_Eucl_kAll function.
    %
    % This function should be seen as a skeleton for a more elaborative function for evaluation.
    % It lacks the cross validation of the number of dimensions or the number of iterations on a seperate validation set.
    % And, also the possibility to store current results etc.
    %
    % See also: NCM_sqdist, NCM_softmax, NCM_gradient_LogLoss_Eucl_k1, NCM_gradient_LogLoss_Eucl_kAll
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
    
    v = .51;
    fprintf('%15s | v %7.4f | start %s\n',mfilename,v,datestr(now,31));
    
    %Some defaults
    if nargin < 4 || isempty(W),        W   = 2;        end
    if nargin < 5 || isempty(k),        k   = 1;        end
    if nargin < 6 || isempty(ops),      ops = struct(); end
        
    %Some useful sizes
    [NrD,NrN]   = size(X);
    NrC         = size(Means,2)/k;
            
    %% Important variables which should be adjusted to the problem at hand
    if ~isfield(ops,'iter1'),       ops.iter1   = 1;            end
    if ~isfield(ops,'iter2'),       ops.iter2   = 200;          end %The number of iterations
    if ~isfield(ops,'NrNi'),        ops.NrNi    = max(50,NrC);  end %Number of images used per iteration
    if ~isfield(ops,'Eta'),         ops.Eta     = .1;           end %Learning rate
    if ~isfield(ops,'rseed'),       ops.rseed   = 0;            end
    
    rs          = RandStream('mt19937ar','seed',ops.rseed);  % Initialize random seed for data sampling etc.
    
    %% Initialisation and input check
    
    if isscalar(W),
        NrP     = W;
        W       = randn(rs,NrP,NrD,'single')*.1;
    else
        NrP     = size(W,1);
    end
    
    W0          = W;
    assert(NrC == ceil(NrC) && NrC == floor(NrC));
    assert(NrD == size(W,2))
    assert(NrD == size(Means,1));
    assert(NrN == size(Y,1));
    assert(NrP == size(W,1));
    assert(max(Y) <= NrC);
    fprintf('\tNrN %6d | Proj dim %3d Feat dim %5d | NrC %4d k%4d | Img per Iter %4d | Eta %15.10f\n',NrN,NrP,NrD,NrC,k,ops.NrNi,ops.Eta);
    
    %% Start SGD
    nincrements = 1; %perf_array = {};
    obj(ops.iter2,2)    = 0;
    t0 = tic;
    fprintf('\tRunning from iters %d --> %d\n',ops.iter1, ops.iter2);
    for iter = ops.iter1 : ops.iter2;
        t1 = tic;
        
        %% Training Iteration i
        ii  = randi(rs,NrN,1,ops.NrNi);                 % Random select n
        Yii = Y(ii);
        Xii = X(:,ii);
        
        %% Gradient Computation
        if k == 1,
            [f, G] = NCM_Gradient_LogLoss_Eucl_k1(W,Xii,Yii,Means);     % Compute the Gradient
        else
            [f, G] = NCM_Gradient_LogLoss_Eucl_kAll(W,Xii,Yii,Means,k); % Compute the Gradient
        end        
        fprintf('\r\t%10d i| f %15.10f |',iter,f);
        
        %% Error checking
        if ~isfinite(f),
            fprintf('error objective is not finite\n');
            return;
        end
        
        %% Update the projection matrix and save
        
        W = W - ops.Eta * reshape(G,size(W));
        
            
        
        obj(iter,:) = [f toc(t1)];
        
        fprintf('| mean obj %15.10f | cum time %8.4f |',mean(obj(1:iter,1),1),toc(t0));
%         if ismember(iter, [1000:1000:10000])
%             perf_array.err(nincrements) = validate_NCM_train(X, Y, W, Means)*100;
%             perf_array.iter(nincrements) = iter;
%             %fprintf('iteration no %d %f', iter, err_iter*100);
%             nincrements = nincrements +1;
%         end
        
    end
    fprintf('\nFinally done !\n');
%    perf_array
end
