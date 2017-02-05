function results = imm_localmap(X,r,Dist,opts)
    
    % Latent cause-modulated Rescorla-Wagner model.
    %
    % USAGE: results = imm_pf(X,r,Dist,[opts])
    %
    % INPUTS:
    %   X - [N x D] matrix, where X(n,d) specifies the stimulus intensity
    %       of stimulus d on trial n
    %   r - [N x 1] US on each trial
    %   Dist - [N x N] temporal distance between each timepoint
    %   opts (optional) - options structure, containing the following fields:
    %                       .alpha - concentration parameter (default: 0.1)
    %                       .g - temporal scaling parameter (default: 1)
    %                       .psi - [N x 1] binary vector specifying when protein
    %                              synthesis inhibitor is injected (default: all 0)
    %                       .eta - learning rate (default: 0.2)
    %                       .maxIter - maximum number of iterations between
    %                                  each trial (default: 3)
    %                       .w0 - initial weight value (default: 0)
    %                       .sr - US variance (default: 0.4)
    %                       .sx - stimulus variance (default: 1)
    %                       .theta - response threshold (default: 0.3)
    %                       .lambda - response gain (default: 0.005)
    %                       .K - max number of latent sources (default: 15)
    %
    % OUTPUTS:
    %   results - structure containing the following fields:
    %               .V - [N x 1] conditioned response on each trial
    %               .Zp - [N x K] latent cause posterior before observing US
    %               .Z - [N x K] latent cause posterior 
    
    %###### DEFAULT PARAMETERS ##########
    def_opts = struct('alpha',0.1,'g',1,'psi',0,'eta',0.2,'maxIter',3,...
        'w0',0,'sr',0.4,'sx',1,'theta',0.03,'lambda',0.005,'K',15);
    F = fieldnames(def_opts);
    
    if nargin < 4 || isempty(opts)
        opts = def_opts;
    else
        for f = 1:length(F)
            if ~isfield(opts,F{f}) || isempty(opts.(F{f}))
                opts.(F{f}) = def_opts.(F{f});
            end
        end
    end
    
    %######## INITIALIZATION ############
    [T D] = size(X);
    if length(opts.alpha)==1; opts.alpha = opts.alpha.*ones(T,1); end
    if length(opts.eta)==1; opts.eta = opts.eta.*ones(T,1); end
    psi = opts.psi.*ones(T,1);
    Z = zeros(T,opts.K);
    results.V = zeros(T,1);
    W = zeros(D,opts.K) + opts.w0;
    S = Dist.^(-opts.g);
    
    %########## RUN INFERENCE ############
    
    % iterate over timepoints
    for t = 1:T

        % determine how many EM iterations to perform based on ITI
        if t == T
            nIter = 1;
        else
            nIter = min(opts.maxIter,round(Dist(t,t+1)));
        end
        
        % calculate (unnormalized) posterior, not including reward
        N = sum(Z(1:t-1,:),1);                  % cluster counts
        prior = S(1:t-1,t)'*Z(1:t-1,:);         % ddCRP prior
        prior(find(N==0,1)) = opts.alpha(t);    % probability of new cluster
        L = prior./sum(prior);                  % normalize prior
        xsum = X(1:t-1,:)'*Z(1:t-1,:);      % [D x K] matrix of feature sums
        nu = opts.sx./(N+opts.sx) + opts.sx;
        for d = 1:D
            xhat = xsum(d,:)./(N+opts.sx);
            L = L.*normpdf(X(t,d),xhat,sqrt(nu)); % likelihood
        end
        
        % reward prediction, before feedback
        post = L./sum(L);
        results.V(t) = (X(t,:)*W)*post';
        results.w = W; results.p = post;
        if ~isnan(opts.theta); results.V(t) = 1-normcdf(opts.theta,results.V(t),opts.lambda); end
        
        % loop over EM iterations
        for iter = 1:nIter
            V = X(t,:)*W;                               % reward prediction
            post = L.*normpdf(r(t),V,sqrt(opts.sr));    % unnormalized posterior with reward
            post = post./sum(post);
            results.Zp(t,:) = post;
            rpe = repmat((r(t)-V).*post,D,1);           % reward prediction error
            x = repmat(X(t,:)',1,opts.K);
            W = W + opts.eta(t).*x.*rpe;                % weight update
            if psi(t)>0
                W = W.*(1-repmat(post,D,1)).*psi(t);
            end
            results.W{t,iter} = W;
            results.P{t,iter} = post;
        end
        
        % cluster assignment
        [~,k] = max(post);                  % maximum a posteriori cluster assignment
        Z(t,k) = 1;
        
    end
    
    %store results
    results.Z = Z;
    results.S = S;