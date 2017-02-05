function results = imm_run(design,opts,varargin)
    
    % Run all simulations.
    %
    % USAGE: results = imm_run(design,[opts],[varargin])
    
    % if no input, run all designs
    if nargin < 1 || isempty(design)
        for i = 1:100;
            try
                if nargin > 1
                    results(i) = imm_run(i,opts);
                else
                    results(i) = imm_run(i);
                end
            catch
                return
            end
        end
    end
    
    % design parameters
    if nargin < 2 || isempty(opts)
        opts = struct('alpha',0.1,'g',1,'psi',0,'eta',0.3,'maxIter',3,...
            'w0',0,'sr',0.4,'sx',1,'theta',0.02,'lambda',0.01,'K',15);
    end
    
    % experimental parameters
    nAcq = 3;
    train_ext_interval = 20;
    ext_test_interval = 200;
    
    switch design
        
        case 1
            %extinction w/o retrieval
            N = [nAcq 1 18 1];
            feats = [1; 1; 1; 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 0 ext_test_interval];
            
        case 2
            %extinction w/ retrieval, short ITI
            N = [nAcq 1 18 1];
            feats = [1; 1; 1; 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 3 ext_test_interval];
            
        case 3
            %extinction w/ retrieval, long ITI
            N = [nAcq 1 18 1];
            feats = [1; 1; 1; 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 100 ext_test_interval];
            
        case 4
            %ext-ret-ext, short ITI (reinstatement)
            N = [nAcq 5 1 15 1 1];
            feats = [1; 1; 1; 1; 0; 1];
            rewards = [1; 0; 0; 0; 1; 0];
            I = [train_ext_interval 20 3 20 20];
            
        case 5
            %retrieval - extinction, short ITI (reinstatement)
            N = [nAcq 1 18 1 1];
            feats = [1; 1; 1; 0; 1];
            rewards = [1; 0; 0; 1; 0];
            I = [train_ext_interval 3 20 20];
            
        case 6
            %PSI injection, short duration
            N = [1 1 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 7
            %PSI injection, long duration
            N = [1 3 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 8
            %no PSI injection, long duration (control)
            N = [1 3 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            
        case 9
            %PSI injection, long interval
            N = [1 1 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval*2 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 10
            %PSI injection, strong training
            N = [2 1 1];
            feats = [1; 1; 1];
            %feats = [1 0; 1 0; 1 0];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 11
            %PSI injection, short duration, with US
            N = [1 1 1];
            feats = [1; 1; 1];
            rewards = [1; 1; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 12
            %PSI injection, strong training, novelty
            N = [2 1 1];
            %feats = [1 0 1; 1 1 1; 1 0 1];
            feats = [1 0; 1 1; 1 0];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 13
            %extinction w/ retrieval, variable ITI
            N = [nAcq 1 18 1];
            feats = [1; 1; 1; 1];
            rewards = [1; 0; 0; 0];
            if nargin < 3; iti = 3; else iti = varargin{1}; end
            I = [train_ext_interval iti ext_test_interval];
            
        case 14
            %Schiller et al., (2010), Experiment 2
            % CSa+ (reminded), CSb+ (not reminded), CS-
            opts.theta = 0.0016; opts.lambda = 0.00008;
            nExt = 18;
            %ext_test_interval = 100;
            N = [ones(1,nAcq*3) 1 1 1 ones(1,nExt*3) 1 1 1];
            feats = [repmat(eye(3),nAcq,1); 1 0 0; 0 0 1; 0 1 0; repmat(eye(3),nExt,1); eye(3)];
            rewards = [repmat([1; 1; 0],nAcq,1); 0; 0; 0; 0; 0; zeros(nExt*3,1); 0; 0; 0];
            I = [zeros(1,nAcq*3-1) train_ext_interval 0 3 0 zeros(1,nExt*3-1) ext_test_interval 0 0];
            
        case 15
            %PSI injection, short duration (Doyere et al., 2007)
            N = [1 1 1 1 1];
            feats = [1 0; 0 1; 1 0; 1 0; 0 1];
            rewards = [1; 1; 0; 0; 0];
            I = [0 train_ext_interval 20 0];
            opts.psi = zeros(sum(N),1);
            opts.psi(3) = 1;
            
        case 16
            %no PSI injection, short duration (Doyere et al., 2007)
            N = [1 1 1 1 1];
            feats = [1 0; 0 1; 1 0; 1 0; 0 1];
            rewards = [1; 1; 0; 0; 0];
            I = [0 train_ext_interval 20 0];
            
        case 17
            % non-contingent footshock
            % training | amnestic | shock | test
            nAcq = 1;
            opts.lambda = 0.2;
            opts.theta = 0.1;
            opts.psi = [zeros(1,nAcq) 0.01 0 0]';
            N = [nAcq 1 1 1];
            feats = [1 1 0 1]';
            feats = [feats ones(4,1)];  % context feature
            rewards = [1; 0; 1; 0];
            I = [train_ext_interval 20 0];
            
        case 18
            % multiple retrievals (Jarome et al., 2012)
            % PSI injection, short duration
            ITI = varargin{1};
            PSI = varargin{2};
            N = [2 1 1 1];
            feats = [1; 1; 1; 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval ITI 20];
            opts.psi = zeros(sum(N),1);
            if PSI
                opts.psi(sum(N)-1) = 1;
            end
            
        case 19
            % PSI injection, variable retention interval
            retention_interval = varargin{1};
            N = [1 1 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [100 retention_interval];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 20
            % Sevenster et al. (2013) PE experiment
            N = [1 1 1 1 12 1 1];
            feats = [1 1 1 1 1 0 1]';
            feats = [ones(size(feats)) feats];
            %rewards = [0; 1; 0; 1; 0; 1; 0];
            rewards = [1; 1; 1; 1; 0; 1; 0];
            I = [0 0 train_ext_interval train_ext_interval 0 0];
            opts.psi = zeros(sum(N),1);
            opts.psi(4) = 1;
            
            %PSI injection, short duration, with US
%             N = [1 1 1 1 1];
%             feats = [1; 1; 1; 1; 1];
%             %rewards = [0; 1; 0; 1; 0];
%             rewards = [1; 1; 1; 0; 0];
%             I = [0 0 train_ext_interval 20];
%             opts.psi = zeros(sum(N),1);
%             opts.psi(4) = 1;
            
        case 21
            % Constanzi et al. (2011) variation on Monfils et al. (2009): longer training-extinction interval
            N = [nAcq 1 18 1];
            feats = [1; 1; 1; 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval*29 3 ext_test_interval];
            
        case 22
            N = [nAcq 1 18 1];
            feats = [1 1; 1 0; 1 0; 1 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 3 train_ext_interval];
            
        case 23
            N = [nAcq 1 18 1];
            feats = [1 1; 1 0.8; 1 0.8; 1 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 3 train_ext_interval];
            
        case 24
            % PSI injection, Debiec et al. (2013)
            N = [1 1 1 1];
            feats = [1 1; 1 0; 1 0; 0 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 20 0];
            opts.psi = zeros(sum(N),1);
            opts.psi(2) = 1;
            
        case 25
            % no PSI injection, Debiec et al. (2013)
            N = [1 1 1 1];
            feats = [1 1; 1 0; 1 0; 0 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 20 0];
            
        case 26 % US retrieval (Liu et al 2014)
            N = [nAcq 1 18 1];
            feats = [1 1; 0 1; 1 1; 1 1];
            %feats = [1; 0; 1; 1];
            rewards = [1; 0; 0; 0];
            I = [train_ext_interval 3 ext_test_interval];
            
        case 27
            %no PSI injection, short duration, context change
            N = [1 1 1];
            feats = [1 0; 1 0; 0 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            
        case 28
            %PSI injection, short duration, context change
            N = [1 1 1];
            feats = [1 0; 1 0; 0 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 29
            %extinction, variable N
            nAcq = varargin{1};
            N = [nAcq 1];
            feats = [1; 1];
            rewards = [1; 0];
            I = train_ext_interval;
            
        case 30
            %post-training PSI injection + pre-test reminder
            N = [2 1 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(N(1)) = 1;
            
        case 31
            %post-training PSI injection + no reminder
            N = [2 1 1];
            feats = [1; 0; 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(N(1)) = 1;
            
        case 32
            %paradoxical enhancement of fear (Rorbaugh & Riccio): short
            %retention interval + reminder
            N = [2 1 1];
            feats = [1; 1; 1];
            rewards = [0.1; 0; 0];
            I = [train_ext_interval 2];
            opts.psi = zeros(sum(N),1);
            
        case 33
            %paradoxical enhancement of fear (Rorbaugh & Riccio): short
            %retention interval + no reminder
            N = [2 1 1];
            feats = [1; 0; 1];
            rewards = [0.1; 0; 0];
            I = [train_ext_interval 2];
            
        case 34
            %paradoxical enhancement of fear (Rorbaugh & Riccio): long
            %retention interval + reminder
            N = [2 1 1];
            feats = [1; 1; 1];
            rewards = [0.1; 0; 0];
            I = [train_ext_interval 50];
            opts.psi = zeros(sum(N),1);
            
        case 35
            %paradoxical enhancement of fear (Rorbaugh & Riccio): long
            %retention interval + no reminder
            N = [2 1 1];
            feats = [1; 0; 1];
            rewards = [0.1; 0; 0];
            I = [train_ext_interval 50];
            
        case 36
            %forgetting of stimulus attributes
            N = [1 1 1];
            feats = [1 0 1; 0 0 0; 1 1 0];
            rewards = [0.1; 0; 0];
            I = [0 1];
            
        case 37
            %variable interval
            N = [1 1 1];
            feats = [1; 1; 1];
            rewards = [1; 0; 0];
            I = [100 200];
            
        case 38
            %PSI at retrieval (Guisquet-Verrier 2015)
            N = [1 1 1];
            feats = [1 1; 1 0; 1 0];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 39
            %no PSI at retrieval or test (Guisquet-Verrier 2015)
            N = [1 1 1];
            feats = [1 0; 1 0; 1 0];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            
        case 40
            %PSI at retrieval + test (Guisquet-Verrier 2015)
            N = [1 1 1];
            feats = [1 1; 1 0; 1 1];
            rewards = [1; 0; 0];
            I = [train_ext_interval 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            opts.psi(sum(N)) = 1;
            
        case 41
            %post-acquisition retrograde gradient of amnesia
            N = [1 1 1];
            feats = [1; varargin{2}; 1];
            rewards = [1; 0; 0];
            I = [varargin{1} 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 42
            %post-retrieval ANI, delayed
            N = [1 1 1];
            feats = [1; varargin{2}; 1];
            rewards = [1; 0; 0];
            I = [varargin{1} 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
            
        case 43
            %post-acquisition no PSI
            N = [1 1 1];
            feats = [1; varargin{2}; 1];
            rewards = [1; 0; 0];
            I = [varargin{1} 20];
            
        case 44
            %PSI injection, familiarization
            N = [varargin{1} 1 1];
            feats = [1; 1; 1];
            rewards = [0; 1; 0];
            I = [20 20];
            opts.psi = zeros(sum(N),1);
            opts.psi(sum(N)-1) = 1;
    end
    
    %----- construct features and rewards ---%
    X = []; r = [];
    for i = 1:size(feats,1)
        X = [X; repmat(feats(i,:),N(i),1)];
        r = [r; repmat(rewards(i,:),N(i),1)];
    end
    
    %------- construct time indices ---------%
    I = [0 I];
    t = 0;
    Time = [];
    for i = 1:length(N)
        t = t + I(i);
        for j = 1:N(i)
            Time = [Time; t];
            t = t + 1;
        end
    end
    
    %------- construct distance matrix ---------%
    T = sum(N);
    Dist = zeros(T);
    for i = 1:T
        for j = 1:T
            Dist(i,j) = abs(Time(i)-Time(j));
        end
    end
    
    %-------- run particle filter -----------%
    results = imm_localmap(X,r,Dist,opts);
    results.design = design;
    results.N = N;
    results.I = I;
    results.Time = Time;
    results.X = X;
    results.r = r;
    results.opts = opts;