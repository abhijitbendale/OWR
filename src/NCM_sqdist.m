function d = NCM_sqdist(a,b)
    % NCM_sqdist - computes pairwise squared Euclidean distances between points
    %
    % Input
    %  a    matrix  [d x n] input A, data in columns (ie each column is an observation)
    %  b    matrix  [d x m] input B.
    %
    % Output
    %  d    matrix  [n x m] distance between A and B
    %
    %
        
    % original version by Roland Bunschoten, 1999
    % modified by Jakob Verbeek, 2011
    % J.J. Verbeek, 2006, 2011
    % Thomas Mensink, 2012-2013
    % LEAR - INRIA Rhone Alpes, Grenoble, France
    % ISLA - University of Amsterdam, Amsterdam, the Netherlands
    % thomas.mensink@uva.nl
    
    
    d = -2 * a'*b;
    d = bsxfun(@plus,d,sum(a.^2,1)');
    d = bsxfun(@plus,d,sum(b.^2,1));   
end
