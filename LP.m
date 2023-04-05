%%% The LP function estimates the local projections in the terms of Jordà (2005)

function [lp,bands]=LP(y,lags,controls,X,hor,c)

    lp=zeros(size(controls,2)+c+lags+size(X,2),hor);
    bands=zeros(size(controls,2)+c+lags+size(X,2),hor);
    
if lags>size(X,2)-1
    
    lagdep=lagmaker(y,lags); % lagged dependent variable
    
    for i=1:hor
        
    dep=y(i+lags:end); % dependent variable
    
    if i==1
          reg=[lagdep controls(i+lags:end,:) X(lags+i:end,:)]; % regressors = controls + shocks
          
    else, lagshock=lagmatrix(X,i-1);
          reg=[lagdep(1:end-i+1,:) controls(lags+i:end,:) lagshock(lags+i:end,:)];
    end
    
    [~,bands(:,i),lp(:,i)]=hac(reg,dep,'display','off');
    
    end
    
else
    
    lagdep=lagmaker(y,lags); % lagged dependent variable
    lagdep=lagdep(size(X,2)-1-lags+1:end,:);
          
    for i=1:hor
    
    dep=y(i+lags+(size(X,2)-1-lags):end); % dependent variable  
    
    if i==1
          reg=[lagdep controls(i+lags+(size(X,2)-1-lags):end,:) X(lags+(size(X,2)-1-lags)+1:end,:)]; % regressors = controls + shocks
    else, dep=y(i+lags+(size(X,2)-1-lags):end);
          reg=lagmatrix(X,i-1);
          reg=[lagdep(1:end-i+1,:) controls(i+lags+(size(X,2)-1-lags):end,:) reg(i+lags+(size(X,2)-1-lags):end,:)];
    end
    
    [~,bands(:,i),lp(:,i)]=hac(reg,dep,'display','off');
    
    end
    
end
    
end

