%particle process discarding particles which are larger and
%taking exponentially distributed particles
% n = [500,1000,5000,10000,50000];
%t = time = number of particles sent through
t = [5000];
% figure
% hold on

%rho a correlation parameter
% rho = 0.5; 

%plot distribution function for number of particles in (-inf,x1]x(-inf,y1]
x1 = 5;
y1 = 5;
for l = 1:numel(t)
    %M = number of repeats we do 
    M = 10000;

    %number of particles in process for each interation. 4 rows for x, y,
    %both, union
    s = zeros(4,M);

    %we make an empirical distribution function 
    x = 0:0.1:10;
    [x0,y0] = meshgrid(x,x);
    
    %y is used to store the empirical CDFs for each simulation
%     y = zeros([x0,y0,M]);
    
    %list of every surviving pair of particles from every simulation.
    %don't need to keep track of which simulation it's from
    sxList = [];
    syList = [];
    sBothList = [];
    sUnionList = [];
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
        SBoth = intersect(Sx,Sy,'rows');
        SUnion = union(Sx,Sy,'rows');

        %number of particles in the process in entire region
        s(1,j) = size(Sx,1);
        s(2,j) = size(Sy,1);
        s(3,j) = size(SBoth,1);
        s(4,j) = size(SUnion,1);

        %alternatively we can do number of particles w x<=x1 and y<=y1
        s(1,j) = size(Sx(and(Sx(:,1)<=x1,Sx(:,2)<=y1)),1);
        s(2,j) = size(Sy(and(Sy(:,1)<=x1,Sy(:,2)<=y1)),1);
        s(3,j) = size(SBoth(and(SBoth(:,1)<=x1,SBoth(:,2)<=y1)),1);
        s(4,j) = size(SUnion(and(SUnion(:,1)<=x1,SUnion(:,2)<=y1)),1);

        sxList = [sxList; Sx];
        syList = [syList; Sy];
        sBothList = [sBothList; SBoth];
        sUnionList = [sUnionList; SUnion];


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
    
%     figure
%     surf(x0,y0,distx,'edgecolor','none')
%     figure
%     surf(x0,y0,distBoth,'edgecolor','none')
%     plot(x,dist);
    figure
    hist(s',[0:1:50])
end