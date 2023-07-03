%particle process discarding particles which are larger and
%taking exponentially distributed particles
% n = [500,1000,5000,10000,50000];
n = [1000,5000];
figure
hold on
for l = 1:numel(n)
    M = 1000;
    s = zeros(1,M);
    x = 0:0.05:10;
    y = zeros([M,numel(x)]);
    sList = [];
    for j = 1:M
        N = n(l);
        X = exprnd(1,[1,N]);
        S = [X(1)];
        for i = 2:N
            S = [S(S <= X(i)), X(i)];
        end
        sList = [sList, S];
    end
    %create dist fn 
    dist = zeros(size(x));
    for k = 1:numel(sList)
        dist( x <= sList(k)) = dist(x <= sList(k)) + 1/M;
    end
    plot(x,dist);
end