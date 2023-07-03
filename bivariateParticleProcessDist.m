%particle process discarding particles which are larger and
%taking exponentially distributed particles
% n = [500,1000,5000,10000,50000];
%t = time = number of particles sent through
t = [1000];
figure
hold on

%rho a correlation parameter
% rho = 0.5; 

for l = 1:numel(t)
    %M = number of repeats we do 
    M = 1000;
%     s = zeros(1,M);
    %we make an empirical distribution function 
    x = 0:0.1:10;
    [x0,y0] = meshgrid(x,x);
    
    %y is used to store the empirical CDFs for each simulation
%     y = zeros([x0,y0,M]);
    
    %list of every surviving pair of particles from every simulation.
    %don't need to keep track of which simulation it's from
    sxList = [];
    syList = [];
    for j = 1:M
        N = t(l);
        
        %simulate correlated normals
%         X = normrnd(0,1,[1,N]);
%         Z = normrnd(0,1,[1,N]);
%         Y = rho*X + sqrt(1-rho^2)*Z;

        %simulate correlated exponentials
        X = exprnd(1,[1,N]);
        Z = exprnd(1,[1,N]);
        Y = 2*min(X,Z);
        
        Sx = [X(1),Y(1)];
        Sy = [X(1),Y(1)];
        for i = 2:N
            Sx = [Sx(Sx(:,1) >= X(i),:); X(i), Y(i)];
            Sy = [Sy(Sy(:,2) >= Y(i),:); X(i), Y(i)];
        end
        sxList = [sxList; Sx];
        syList = [syList; Sy];
        sBothList = intersect(sxList,syList,'rows');
        sUnionList = union(sxList,syList,'rows');
    end
    
    disp('simulation complete!')
    
    %create dist fns  
    distx = zeros(size(x0));
    for k = 1:size(sxList,1)
        distx(and(x0 >= sxList(k,1),y0 >= sxList(k,2))) = ...
            distx(and(x0 >= sxList(k,1),y0 >= sxList(k,2))) + 1/M;
    end
    
    disp('cdf for x complete')
    
    disty = zeros(size(x0));
    for k = 1:size(syList,1)
        disty(and(x0 >= syList(k,1),y0 >= syList(k,2))) = ...
            disty(and(x0 >= syList(k,1),y0 >= syList(k,2))) + 1/M;
    end    
    
    disp('cdf for y complete')
    distBoth = zeros(size(x0));
    for k = 1:size(sBothList,1)
        distBoth(and(x0 >= sBothList(k,1),y0 >= sBothList(k,2))) = ...
            distBoth(and(x0 >= sBothList(k,1),y0 >= sBothList(k,2))) + 1/M;
    end       
    
    disp('cdf for intersection complete')
    distUnion = zeros(size(x0));
    for k = 1:size(sUnionList,1)
        distUnion(and(x0 >= sUnionList(k,1),y0 >= sUnionList(k,2))) = ...
            distUnion(and(x0 >= sUnionList(k,1),y0 >= sUnionList(k,2))) + 1/M;
    end
    
    figure
    surf(x0,y0,distx,'edgecolor','none')
    figure
    surf(x0,y0,distBoth,'edgecolor','none')
%     plot(x,dist);
end