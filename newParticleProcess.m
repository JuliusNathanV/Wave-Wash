% nlist = [1000];
nlist = [500,1000,5000,10000,50000];
M = 5000;
X = 0:0.01:1;
Nlist = zeros(1,M);
figure
hold on

for i = 1:numel(nlist)
    n= nlist(i);
    cdf = zeros(M,numel(X));
    for m = 1:M
        %simulate one set of the particle process with n samples
    
        u = 0;
        x = 1;
        Y = [1];
        y = 1;
        N = 0;
        while u < n
            N = N+1;
            x = betarnd(n-u,1);
            y = y*x;
            Y = [Y, y];
            u = unidrnd(n-u)+u;
        end
        Nlist(m) = N;
        for k = 1:N
            xcdf = cdf(m,:);
            xcdf( X >= Y(k) ) = 1;
            cdf(m,:) = cdf(m,:) + xcdf;
        end
    end
    plot(X,sum(cdf)/M)
        % disp(Y)
        % disp(N)
end
% figure
% hist(Nlist,20)
