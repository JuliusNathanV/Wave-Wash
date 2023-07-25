N = 100000;
h = 0.001;
x = -1:h:1;

M = -Inf*ones([N+1 size(x,2)]);
for i = 1:N
    X = normrnd(0,1,[1,2]);
    Y = X(1)*x + X(2)*sqrt(1-x.^2);
    M(i+1,:) = max(M(i,:),Y);
end
M = unique(M,'rows');
figure
plot(x,M(1:size(M,1),:))