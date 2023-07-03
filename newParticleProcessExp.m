% nlist = [1000];
% nlist = [500,1000,5000,10000,50000];
nlist = [1000,5000];
M = 5000;
X = 0:0.05:10;
Nlist = zeros(1,M);
figure
hold on

for i = 1:numel(nlist)
    n= nlist(i);
    dist = zeros(1,numel(X));
    yList = [];
    for m = 1:M
        %simulate one set of the particle process with n samples
    
        u = 0;
        x = 0;
        Y = [];
        y = 0;
        N = 0;
        while u < n
            N = N+1;
            x = exprnd(n-u);
            y = y+x;
            Y = [Y, y];
            u = unidrnd(n-u)+u;
        end
        Nlist(m) = N;
        yList = [yList, Y];
%         for k = 1:N
%             xcdf = dist(m,:);
%             xcdf( X >= Y(k) ) = 1;
%             dist(m,:) = dist(m,:) + xcdf;
%         end
    end
    for k = 1:numel(yList)
        dist(X<= yList(k)) = dist(X<=yList(k)) + 1/M;
    end
    plot(X,dist)
        % disp(Y)
        % disp(N)
end
% figure
% hist(Nlist,20)
