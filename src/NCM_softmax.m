function  [p, z] = NCM_softmax(e,d)
    % Computes the softmax over vector/matrix e in dimension d
    %
    % Computes the softmax p = exp(e)/sum(exp(e))
    % sums are taken over dimension d (which defaults to 1)
    %
    % Input
    %  e    vector/matrix
    %  d    dimension over which softmax is taken
    %
    % Output
    %  p    softmaxed value
    %  z    normalizing factor: sum(exp(e))
    %
    
    % J.J. Verbeek, 2006, 2011
    % Thomas Mensink, 2012-2013
    % LEAR - INRIA Rhone Alpes, Grenoble, France
    % ISLA - University of Amsterdam, Amsterdam, the Netherlands
    % thomas.mensink@uva.nl
    
    if nargin<2; d=1;end

    if d>0
        p = bsxfun(@minus,e,max(e,[],d));
        p = exp(p);
        z = sum(p,d);
        p = bsxfun(@times,p,z.^-1);
    else % softmax over all elements at once
        p = e - max(e(:));
        p = exp(p);
        z = sum(p(:));
        p = p* ( z.^-1);
    end
end
