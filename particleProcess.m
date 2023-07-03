n = [500,1000,5000,10000,50000];
% n = [1000];
figure
hold on
for l = 1:numel(n)
    M = 1000;
    s = zeros(1,M);
    x = 0:0.01:1;
    y = zeros([M,numel(x)]);
    sList = [];
    for j = 1:M
        N = n(l);
        X = unifrnd(0,1,[1,N]);
        S = [X(1)];
        for i = 2:N
            S = [S(S >= X(i)), X(i)];
        end
%         plot(S,zeros(size(S)),'o')
    %     s = numel(S);
%         s(j) = numel(S);
%     
%         %create cdf
%         cdf = zeros(size(x));
%         for k = 1:s(j)
%             xcdf = zeros(size(x));
%             xcdf(x >= S(k)) = 1;
%             cdf = cdf + xcdf;
%         end
%         y(j,:) = cdf;
        sList = [sList, S];
    end
%     if l == numel(n)
%         figure
%         hist(s,20)
%     end
    %create cdf
    cdf = zeros(size(x));
    for k = 1:numel(sList)
        cdf( x >= sList(k)) = cdf(x >= sList(k)) + 1;
    end
%     plot(x,sum(y)/M)
    plot(x,cdf/M);
end