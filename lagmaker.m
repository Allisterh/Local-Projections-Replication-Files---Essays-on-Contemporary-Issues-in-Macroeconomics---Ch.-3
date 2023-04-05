function lags=lagmaker(y,p)

% This function generates a matrix of p lags of y:

    X=lagmatrix(y,1:p);  
    X(1:p,:)=[]; 
    lags=X;

end