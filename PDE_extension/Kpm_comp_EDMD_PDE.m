function [ Kdmd, data] = Kpm_comp_EDMD_PDE(fun,z0, dT, Tf, Psi)
% Extended Dynamic Mode Decomposition and/or Naturally Structured DMD 
% main script for 2D nonlinear example
% Nx: number of basis functions chosen
global dx
%% Generate time sequence of data
noi = size(z0,2);
data = [];
X = [];
Y = [];

for i = 1:noi
    [t, z] = ode45(fun,[0:dT:Tf],z0(:,i));
    X = [X z(1:end-1,:)'];
    Y = [Y z(2:end,:)'];
    data = [data z'];
    for tt = 1:length(t)
    figure(1)
    h = plot(0:dx:2,z(tt,:));
    drawnow;
    refreshdata(h)
    end
end


% figure(5)
% plot(data(1,:),data(2,:),'*')
% t = 0:dT:Tf;
% for i = 1:N
%     z(:,1) = z0(:,i);
%  	for tt = 1:length(t)-1
%         z(:,tt+1) = feval(fun,0,z(:,tt));
%     end
%     X = [X z(:,1:end-1)];
%     Y = [Y z(:,2:end)];
%     data = [data z];
% end
%% Compute the G and A matrix
G = 0;
A = 0;
M = size(X,2); % length of time-series
for i = 1:M
    PsiX = Psi(X(:,i));
    PsiY = Psi(Y(:,i));
    G = G + PsiX'*PsiX;
    A = A + PsiX'*PsiY;
end
G = G/M;
A = A/M;

% EDMD
Kdmd = pinv(G)*A;
method = 'EDMD';

% % NSDMD
% m = size(A,2);
% Zeros_m = zeros(1,m);
% Ones_m = ones(m,1);
% Vec = Lambda\Ones_m;
% 
% 
% LambdaInv = inv(Lambda);
% % YALMIP
% K = sdpvar(m,m,'full');
% Objective =  norm(G*K-A,'fro'); % trace(Q); %
% Constraints = [];
% for i = 1:m
%    Constraints = [Constraints, Zeros_m <= K(i,:)];
%       Constraints = [Constraints, K(i,:)*Vec == Vec(i)];
%             Constraints = [Constraints, Zeros_m <= K(i,:)*LambdaInv];
% end
% 
% % opt = sdpsettings('solver','mosek-sdp','verbose',0);
% opt = sdpsettings('solver','gurobi','verbose',0);
% % Try this if u install Gurobi
% sol = optimize(Constraints,Objective,opt)
% Kdmd = value(K);

% At = A';
% b = At(:);
% A = kron(G,sparse(eye(m)));
% C = sparse(kron(Lambda,inv(Lambda)));
% M = kron(sparse(eye(m)),ones(1,m));
% M_new = M*C;
% % YALMIP
% x = sdpvar(m^2,1);
% Objective = norm(A*x-b);
% Constraints = [C*x >= 0; M_new*x == Ones_m; x >= 0];
% % opt = sdpsettings('solver','mosek-sdp','verbose',0);
% opt = sdpsettings('solver','gurobi','verbose',0);
% sol = optimize(Constraints,Objective,opt)
% Kdmd = reshape(value(x),m,m)';

% Kdmd = projGradient(G,A);

% Kdmd = projGradient2(G,A,Vec);

% Kdmd = projGradient4(G,A,Lambda);

% method = 'NSDMD';

% %% Plotting eigenfunctions 
% n = 4; % Compute eigenfunctions corresponding to first n dominant eigenvalues
% % Construct X-Y boxes
% Nx = 100;
% Ny = 100;
% x_limit = [-3 3]; % range of x
% y_limit = [-3 3]; % range of y
% xmax=x_limit(2); xmin=x_limit(1);
% ymax=y_limit(2); ymin=y_limit(1);
% dx=(xmax-xmin)/(Nx);
% dy=(ymax-ymin)/(Ny);
% xvec = xmin+dx/2:dx:xmax-dx/2;
% yvec = ymin+dy/2:dy:ymax-dy/2;
% [xx,yy] = meshgrid(xvec,yvec);
% x = reshape(xx,1,[]);
% y = reshape(yy,1,[]);
% XY =  [x;y];
% 
% [V, D] = eig(Kdmd); % D are eigenvalues of Koopman Operator or ln(D)/dT
% 


% PF = (Lambda*Kdmd/Lambda)';



end
