function imm_plot(mode,results)
    
    % Plot results.
    %
    % USAGE: imm_plot(mode,[results])
    
    ylim = [-0.1 1.1];
    ytick = [0 0.2 0.4 0.6 0.8 1];
    warning off all
    
    opts = struct('alpha',0.1,'g',1,'psi',0,'eta',0.3,'maxIter',3,...
        'w0',0,'sr',0.4,'sx',1,'theta',0.02,'lambda',0.01,'K',15);
    
    switch mode
        case 'monfils09'
            
            subplot(2,3,[1 2 3]);
            n = cumsum(results(1).N);
            clr = {'bo' 'gs' 'r^'};
            lwidth = 3; msize = 10;
            for i = 1:3
                V = results(i).V;
                style = ['-',clr{i}];
                plot(1:n(1),V(1:n(1)),style,'LineWidth',lwidth,'MarkerSize',msize,'MarkerFaceColor','w'); hold on
            end
            for i = 1:3
                V = results(i).V;
                style = clr{i};
                plot(n(2),V(n(2)),style,'LineWidth',lwidth,'MarkerSize',msize,'MarkerFaceColor','w');
            end
            for i = 1:3
                V = results(i).V;
                style = ['-',clr{i}];
                plot((n(2)+1):n(3),V((n(2)+1):n(3)),style,'LineWidth',lwidth,'MarkerSize',msize,'MarkerFaceColor','w');
            end
            for i = 1:3
                V = results(i).V;
                style = clr{i};
                plot(n(4),V(n(4)),style,'LineWidth',lwidth,'MarkerSize',msize,'MarkerFaceColor','w');
            end
            ylabel('CR','FontSize',20);
            set(gca,'XLim',[0,n(end)+1],'YLim',ylim,'FontSize',20,'YTick',ytick)
            set(gca,'XTick',[1 4 5 23],'XTickLabel',{'Acq' 'Ret' 'Ext' 'Test'});
            legend({'No Ret (interval = 0)' 'Ret-short (interval = 3)' 'Ret-long (interval = 100)'},'FontSize',20);
            mytitle('A','Left','FontWeight','Bold','FontSize',20);
            for i=1:length(n)-1; plot([n(i)+0.5 n(i)+0.5],ylim,'--k'); end
            
            letters = {'B         No Ret' 'C         Ret-short' 'D         Ret-long'};
            for i = 1:3
                subplot(2,3,i+3);
                for j = 1:4
                    z(j,:) = results(i).Zp(n(j),1:3);
                end
                h = bar(z); colormap hot
                if i == 1; legend({'C1' 'C2' 'C3'},'FontSize',14); end
                ylabel('Posterior Prob.','FontSize',18);
                set(gca,'XTickLabel',{'Acq' 'Ret' 'Ext' 'Test'},'YLim',[0 1],'FontSize',18,'XLim',[0 5])
                mytitle(letters{i},'Left','FontWeight','Bold','FontSize',20);
            end
            
        case 'ERE'
            lwidth = 3; msize = 13;
            figure;
            subplot(2,2,1);
            n = cumsum(results(5).N);
            for j = 1:5
                z(j,:) = results(5).Zp(n(j),1:3);
            end
            h = bar(z); colormap hot
            ylabel('Posterior Prob.','FontSize',18);
            legend({'C1' 'C2' 'C3'},'FontSize',14,'Location','North');
            set(gca,'XTickLabel',{'Train' 'Ret' 'Ext' 'US' 'Test'},'YLim',[0 1],'FontSize',18,'XLim',[0 6])
            mytitle('B          R-E','Left','FontWeight','Bold','FontSize',20');
            
            subplot(2,2,2);
            n = cumsum(results(4).N);
            for j = 1:5
                z(j,:) = results(4).Zp(n(j),1:3);
            end
            h = bar(z); colormap hot
            ylabel('Posterior Prob.','FontSize',18);
            set(gca,'XTickLabel',{'Train' 'Ret' 'Ext' 'US' 'Test'},'YLim',[0 1],'FontSize',18,'XLim',[0 6])
            mytitle('C          E-R-E','Left','FontWeight','Bold','FontSize',20);
            
            subplot(2,2,3);
            v = [results(5).V(end) results(4).V(end)];
            plot(1,v(1),'ok','MarkerFaceColor','w','MarkerSize',msize,'LineWidth',lwidth); hold on
            plot(2,v(2),'ok','MarkerFaceColor','k','MarkerSize',msize,'LineWidth',lwidth);
            set(gca,'FontSize',18,'XTick',[1 2],'XTickLabel',{'R-E','E-R-E'},'XLim',[0.5 2.5],'YLim',[0 1]);
            mytitle('D          Simulation','Left','FontWeight','Bold','FontSize',20);
            ylabel('CR','FontSize',18);
            
            subplot(2,2,4);
            load ERE_data
            v = [mean(RE(:)) mean(ERE(:))];
            se = [std(mean(RE,2)) std(mean(ERE,2))];
            errorbar(1,v(1),se(1),'ok','MarkerFaceColor','w','MarkerSize',msize,'LineWidth',lwidth); hold on
            errorbar(2,v(2),se(2),'ok','MarkerFaceColor','k','MarkerSize',msize,'LineWidth',lwidth);
            set(gca,'FontSize',18,'XTick',[1 2],'XTickLabel',{'R-E','E-R-E'},'XLim',[0.5 2.5],'YLim',[0 100]);
            ylabel('% Freezing','FontSize',18);
            mytitle('E          Data','Left','FontWeight','Bold','FontSize',20);
            
        case 'suzuki04'
            figure;
            lwidth = 3; msize = 13;
            subplot(1,3,1);
            bar([results(6).V(end) results(7).V(end)]);
            %plot(1,results(6).V(end),'or','MarkerFaceColor','r','MarkerSize',msize,'LineWidth',lwidth); hold on
            %plot(2,results(7).V(end),'sb','MarkerFaceColor','b','MarkerSize',msize,'LineWidth',lwidth);
            set(gca,'XTick',1:2,'XTickLabel',{'Short' 'Long'},'FontSize',15,'YLim',[0 ylim(2)],'XLim',[0 3]);
            ylabel('CR','FontSize',20);
            xlabel('Reexposure duration','FontSize',20);
            axis square
            
            subplot(1,3,2);
            bar([results(6).V(end) results(9).V(end)]);
            %plot(1,results(6).V(end),'or','MarkerFaceColor','r','MarkerSize',msize,'LineWidth',lwidth); hold on
            %plot(2,results(9).V(end),'sb','MarkerFaceColor','b','MarkerSize',msize,'LineWidth',lwidth);
            set(gca,'XTick',1:2,'XTickLabel',{'Young' 'Old'},'FontSize',15,'YLim',[0 ylim(2)],'XLim',[0 3]);
            ylabel('CR','FontSize',20);
            xlabel('Memory age','FontSize',20);
            axis square
            
            subplot(1,3,3);
            bar([results(6).V(end) results(10).V(end)]);
            %plot(1,results(6).V(end),'or','MarkerFaceColor','r','MarkerSize',msize,'LineWidth',lwidth); hold on
            %plot(2,results(10).V(end),'sb','MarkerFaceColor','b','MarkerSize',msize,'LineWidth',lwidth);
            colormap bone
            set(gca,'XTick',1:2,'XTickLabel',{'Weak' 'Strong'},'FontSize',15,'YLim',[0 ylim(2)],'XLim',[0 3]);
            ylabel('CR','FontSize',20);
            xlabel('Memory strength','FontSize',20);
            axis square
            
        case 'prediction_error'
            figure;
            lwidth = 3; msize = 13;
            subplot(1,2,1);
            results = imm_run(6); v(1) = results.V(end);
            results = imm_run(11); v(2) = results.V(end);
            bar(v);
            %plot(1,results(6).V(end),'or','MarkerFaceColor','r','MarkerSize',msize,'LineWidth',lwidth); hold on
            %plot(2,results(11).V(end),'sb','MarkerFaceColor','b','MarkerSize',msize,'LineWidth',lwidth);
            colormap bone
            set(gca,'XTick',1:2,'XTickLabel',{'No US' 'US'},'FontSize',15,'YLim',[0 ylim(2)],'XLim',[0 3]);
            ylabel('CR','FontSize',20);
            xlabel('Reexposure condition','FontSize',20);
            axis square
            
            subplot(1,2,2);
            results = imm_run(10); v(1) = results.V(end);
            results = imm_run(12); v(2) = results.V(end);
            bar(v);
            %plot(1,results(10).V(end),'or','MarkerFaceColor','r','MarkerSize',msize,'LineWidth',lwidth); hold on
            %plot(2,results(12).V(end),'sb','MarkerFaceColor','b','MarkerSize',msize,'LineWidth',lwidth);
            colormap bone
            set(gca,'XTick',1:2,'XTickLabel',{'Strong' 'Strong+N'},'FontSize',15,'YLim',[0 ylim(2)],'XLim',[0 3]);
            ylabel('CR','FontSize',20);
            xlabel('Memory strength','FontSize',20);
            axis square
            
        case 'timecourse'
            opts.maxIter = 3;
            ITI = 3;
            figure;
            subplot(1,2,1);
            results = imm_run(13,opts,ITI);
            W = results.W; w = W{3,min(ITI,opts.maxIter)};
            P = results.P; p = P{3,min(ITI,opts.maxIter)};
            nums = {'0'};
            n = 0;
            for j = 1:opts.maxIter
                n = n + 1;
                nums{n+1} = num2str(j);
                w = [w; W{4,j}];
                p = [p; P{4,j}];
            end
            w = w(:,1); p = p(:,1);
            plot(w,p,'-sk','LineWidth',3,'MarkerSize',12,'MarkerFaceColor','w');
            text(w+0.01,p-0.07,nums,'LineWidth',3,'FontSize',18);
            set(gca,'FontSize',15);
            set(gca,'YLim',[0 1.1]);
            xlabel('Associative strength  (Acq. cause)','FontSize',20);
            ylabel('Posterior prob. (Acq. cause)','FontSize',20);
            mytitle('A','Left','FontWeight','Bold','FontSize',20);
            subplot(1,2,2);
            x = linspace(0.01,20,60);
            for i=1:length(x); results = imm_run(13,opts,x(i)); y(i,1) = results.P{5,1}(end,1); end
            opts.alpha = 0.13; for i=1:length(x); results = imm_run(13,opts,x(i)); y(i,2) = results.P{5,1}(end,1); end
            opts.alpha = 0.2; for i=1:length(x); results = imm_run(13,opts,x(i)); y(i,3) = results.P{5,1}(end,1); end
            plot(1+x,y(:,1),'-k','LineWidth',4); hold on;
            %plot(1+x,y(:,2),'-','LineWidth',4,'Color',[0.3 0.3 0.3]);
            %plot(1+x,y(:,3),'-','LineWidth',4,'Color',[0.5 0.5 0.5]);
            %legend({'\alpha = 0.1' '\alpha = 0.13'},'FontSize',20);
            set(gca,'FontSize',15,'YLim',[0 1.1],'XLim',[-1 x(end)+1]);
            xlabel('Retrieval-extinction interval','FontSize',20)
            ylabel('Posterior prob. (Acq. cause)','FontSize',20)
            mytitle('B','Left','FontWeight','Bold','FontSize',20);
            %hold on;
            %plot([ITI ITI],get(gca,'YLim'),'--k','LineWidth',3);
            set(gcf,'Position',[200 200 900 400])
            
        case 'compression'
            figure;
            f = @(t) t.^(-1);
            t = linspace(1,52,100);
            %             subplot(1,2,1);
            %             plot(t,f(t(end)-t),'-k','LineWidth',4);
            %             hold on
            %             tp = [35 45];
            %             stem(tp,f(t(end)-tp),'-k','LineWidth',2.5,'MarkerSize',10,'MarkerFaceColor',[0.5 0.5 0.5]);
            %             set(gca,'FontSize',15,'XLim',[0 51]);
            %             text(tp(1)-1,f(t(end)-tp(1))+0.12,'t_1','FontSize',15)
            %             text(tp(2)-1,f(t(end)-tp(2))+0.12,'t_2','FontSize',15)
            %             %text(tp(3)-5,f(t(end)-tp(3))+0.12,'t_3-0.5','FontSize',15)
            %             xlabel('Time (\tau)','FontSize',20);
            %             ylabel('K(\tau(t_3)-\tau(t))','FontSize',20);
            %             mytitle('A','Left','FontWeight','Bold','FontSize',20);
            %
            %             subplot(1,2,2);
            j = [2 5];
            for i = 1:length(j)
                y(:,i) = f(t)./(f(t+j(i)) + f(t));
            end
            surf(y); colormap bone
            plot(t,y(:,1),'-k','LineWidth',4); hold on;
            %plot(t,y(:,2),'-','LineWidth',2.5,'Color',[0.5 0.5 0.5]);
            set(gca,'FontSize',15,'XLim',[0 t(end)+1],'YLim',[0.5 1]);
            xlabel('Memory age, \tau(t_3)-\tau(t_2)','FontSize',20);
            ylabel('P(z_3=z_2)','FontSize',20);
            %legend({'t_2-t_1=2','t_2-t_1=5'},'FontSize',15);
            %mytitle('B','Left','FontWeight','Bold','FontSize',20);
            
            set(gcf,'Position',[200 200 700 400])
            
        case 'schiller10'
            results = imm_run(14);
            bar([results.V([7 8 9]) results.V(end-5:end-3) results.V(end-2:end)]'+1e-2);
            colormap bone
            set(gca,'FontSize',15,'XTickLabel',{'Acquisition' 'Extinction' 'Test'},'YLim',[0 1.1]);
            ylabel('CR','FontSize',20)
            legend({'CSa+ (Ret)' 'CSb+ (No Ret)' 'CS-'},'FontSize',15);
            
        case 'doyere07'
            results = imm_run(15);
            v = results.V(end-1:end);
            results = imm_run(16);
            v = [v results.V(end-1:end)];
            bar(v);
            set(gca,'FontSize',15,'YLim',[0 1.1],'XTickLabel',{'PSI' 'Control'});
            legend({'CSr' 'CSn'},'FontSize',20,'Location','NorthWest');
            ylabel('CR','FontSize',20)
            colormap bone
            
        case 'jarome12'
            iti = [5 50 100 200];
            for i = 1:length(iti)
                results = imm_run(18,[],iti(i),1);
                v(i,1) = results.V(end);
                results = imm_run(18,[],iti(i),0);
                v(i,2) = results.V(end);
            end
            plot(v(:,1),'-ok','MarkerSize',10,'MarkerFaceColor','k','LineWidth',2.5);
            hold on; plot(v(:,2),'-ok','MarkerSize',10,'MarkerFaceColor','w','LineWidth',2.5);
            set(gca,'FontSize',15,'XTick',1:length(iti),'XTickLabel',iti,'XLim',[0 length(iti)+1],'YLim',[0 1.05]);
            legend({'PSI' 'Control'},'FontSize',25,'Location','East');
            xlabel('ITI','FontSize',20);
            ylabel('CR','FontSize',20);
            
        case 'rbf'
            x = linspace(-2,2,100);
            sr = 0.5;
            y = normpdf(x,0,sr);
            plot(x,y,'-k','LineWidth',2.5);
            hold on
            plot([0 0],get(gca,'YLim'),'--k','LineWidth',2.5)
            m = [-0.33 0.33];
            p = normpdf(m,0,sr);
            plot(m,p,'-','LineWidth',2.5,'Color',[0.5 0.5 0.5]);
            text(m(1)+0.05,p(1)-0.04,'\sigma_r','FontSize',15);
            set(gca,'FontSize',15);
            xlabel('Prediction error (\delta)','FontSize',20)
            ylabel('Activation','FontSize',20);
            
        case 'power06'
            r = [1 10:10:100];
            for i = 1:length(r); results = imm_run(19,[],r(i)); v(i) = results.V(end); end
            plot(r,v,'-ok','MarkerSize',10,'LineWidth',2.5,'MarkerFaceColor','k');
            set(gca,'FontSize',15,'XLim',[0 r(end)+1],'YLim',[0 1]);
            xlabel('Retrieval-test interval','FontSize',20)
            ylabel('CR','FontSize',20);
            
        case 'constanzi11'
            results(1) = imm_run(2); results(2) = imm_run(21);
            
            %             subplot(1,2,1);
            V = [results(1).V results(2).V];
            bar(V(end,:));
            colormap bone
            set(gca,'FontSize',15,'XTickLabel',{'1 day' '29 days'},'YLim',[0 1.1]);
            ylabel('CR','FontSize',20)
            xlabel('Acquisition-retrieval interval','FontSize',20);
            
            %             subplot(1,2,2);
            %             P = [results(1).Zp(4:end-1,1) results(2).Zp(4:end-1,1)];
            %             plot(P(:,1),'-k','LineWidth',4); hold on
            %             plot(P(:,2),'-','LineWidth',4,'Color',[0.5 0.5 0.5])
            %             set(gca,'FontSize',15,'YLim',[0 1.1]);
            %             ylabel('Probability','FontSize',20)
            %             xlabel('Extinction trial','FontSize',20);
            %             legend({'1 day' '29 days'},'FontSize',15,'Location','East');
            
        case 'renewal'
            results(1) = imm_run(23); results(2) = imm_run(22);
            V = [results(1).V results(2).V];
            bar(V(end,:));
            colormap bone
            set(gca,'FontSize',15,'XTickLabel',{'A*' 'B'},'YLim',[0 1.1]);
            ylabel('CR','FontSize',20)
            xlabel('Retrieval/extinction context','FontSize',20);
            
        case 'debiec13'
            results = imm_run(24);
            v = results.V(end-1:end);
            results = imm_run(25);
            v = [v results.V(end-1:end)];
            bar(v');
            set(gca,'FontSize',15,'YLim',[0 1.1],'XTickLabel',{'PSI' 'Control'});
            legend({'CSr' 'CSn'},'FontSize',20,'Location','NorthWest');
            ylabel('CR','FontSize',20)
            colormap bone
            
        case 'new_cause_prob'
            %a = linspace(0.01,1,10);
            a = [0.1 0.13 2];
            c = [0 0.3 0.5];
            N = 20;
            Y = zeros(N,1);
            X = [0.4  0.3; 0.1 0.3; 0.4 0.1; 0.1 0.1];
            for k = 1:size(X,1)
                subplot(2,2,k)
                opts.eta = X(k,2);
                opts.sr = X(k,1);
                for i = 1:length(a)
                    L{i} = ['\alpha = ',num2str(a(i))];
                    for n = 1:N
                        opts.alpha = a(i);
                        results = imm_run(29,opts,n);
                        Y(n,1) = results.P{end,1}(2);
                    end
                    plot(1:N,Y,'-','LineWidth',5,'Color',[c(i) c(i) c(i)]);
                    hold on;
                end
                if k==1
                    legend(L,'FontSize',20);
                end
                set(gca,'FontSize',15,'YLim',[0 1.05]);
                xlabel('Number of acquisition trials (N)','FontSize',20)
                %ylabel('Concentration parameter (\alpha)','FontSize',20);
                ylabel('P(new cause)','FontSize',20)
                title(['\eta = ',num2str(X(k,2)),', \sigma_r^2 = ',num2str(opts.sr)],'FontSize',20,'FontWeight','Bold');
            end
            
        case 'prediction_error_schematic'
            x = linspace(-1,1,1000);
            y = normpdf(x,0,1);
            plot(x,y,'-k','LineWidth',4);
            xlabel('Prediction error','FontSize',25);
            ylabel('Weight change (acquisition cause)','FontSize',25);
            hold on;
            plot([0 0],get(gca,'YLim'),'--','LineWidth',3,'Color',[0.5 0.5 0.5]);
            set(gca,'YTick',[],'XTick',[]);
            text(-0.9,max(y)+0.012,'Memory','FontSize',25);
            text(-0.9,max(y),'modification','FontSize',25);
            text(0.3,max(y)+0.012,'Memory','FontSize',25);
            text(0.3,max(y),'formation','FontSize',25);
            
        case 'ryan15'
            results = imm_run(27); v(1,1) = results.V(end);
            p = results.p; p(1) = 1; p(2:end)=0;
            v(1,2) = results.w(1,:)*p';
            v(1,2) = 1-normcdf(opts.theta,v(1,2),opts.lambda);
            results = imm_run(28); v(2,1) = results.V(end);
            p = results.p; p(1) = 1; p(2:end)=0;
            v(2,2) = results.w(1,:)*p';
            v(2,2) = 1-normcdf(opts.theta,v(2,2),opts.lambda);
            bar(v');
            set(gca,'FontSize',20,'YLim',[0 1.1],'XTickLabel',{'Off' 'On'});
            ylabel('CR','FontSize',20)
            colormap bone
            legend({'SAL' 'ANI'},'FontSize',25,'Location','North');
            
        case 'paradoxical_enhancement'
            results = imm_run(32); v(1,1) = results.V(end);
            results = imm_run(33); v(2,1) = results.V(end);
            results = imm_run(34); v(1,2) = results.V(end);
            results = imm_run(35); v(2,2) = results.V(end);
            bar(v'); colormap bone
            set(gca,'YLim',[0 1],'FontSize',25,'XTickLabel',{'Short' 'Long'});
            ylabel('CR','FontSize',25);
            xlabel('Retrieval-test interval','FontSize',25);
            legend({'Ret' 'No Ret'},'FontSize',25);
            
        case 'state_dependent'
            n=0; for i=38:40; n=n+1; results = imm_run(i); v(n)=results.V(end); end
            bar(v); colormap bone
            set(gca,'YLim',[0 1.1],'FontSize',25,'XTickLabel',{'PSI-SAL' 'SAL-SAL' 'PSI-PSI'});
            ylabel('CR','FontSize',25);
            
        case 'nader00'
            data(1,:) = [0.28 nan nan nan];
            data(2,:) = [0.65 0.70 0.30 0.60];
            n = [5 15];
            for i=1:length(n)
                results = imm_run(41,[],n(i),0); v(i,1)=results.V(end);
                results = imm_run(41,[],n(i),1); v(i,2)=results.V(end);
                results = imm_run(42,[],n(i),0); v(i,3)=results.V(end);
                results = imm_run(42,[],n(i),1); v(i,4)=results.V(end);
                results = imm_run(43,[],n(i),1); v(i,5)=results.V(end);
            end
            subplot(1,2,1)
            h = bar([v(1,2) v(2,2)]);
            w = get(h,'BarWidth');
            set(h,'BarWidth',w*2/3);
            colormap bone
            hold on;
            plot([data(1,1) data(2,1)],'or','MarkerFaceColor','r','MarkerSize',15);
            set(gca,'FontSize',25,'XTickLabel',{'Immediate' 'Delayed'},'YLim',[0 1.1],'XLim',[0.5 2.5]);
            ylabel('CR','FontSize',25);
            xlabel('Acquisition-PSI interval','FontSize',25);
            subplot(1,2,2)
            bar([v(1,3) v(1,4) v(2,4)]);
            colormap bone
            hold on;
            plot(data(2,2:4),'or','MarkerFaceColor','r','MarkerSize',15);
            set(gca,'FontSize',25,'XTickLabel',{'No Ret' 'Ret' 'Ret delayed'},'YLim',[0 1.1],'XLim',[0.5 3.5]);
            ylabel('CR','FontSize',25);
            set(gcf,'Position',[200 200 1200 500]);
            
        case 'nader00_param'
            alpha = linspace(0.01,2,10);
            sr = linspace(0.1,1,10);
            for i = 1:length(alpha)
                for j = 1:length(sr)
                    opts2 = opts;
                    opts2.alpha = alpha(i);
                    opts2.sr = sr(j);
                    results = imm_run(42,opts2,5,1);
                    v(i,j) = results.V(end);
                end
            end
            figure;
            surf(sr,alpha,v);
            ylabel('Concentration parameter (\alpha)','FontSize',25);
            xlabel('Reward variance (\sigma^2)','FontSize',25);
            zlabel('CR','FontSize',25);
            set(gca,'FontSize',25);
            %plot(alpha,v,'-ok','LineWidth',4,'MarkerSize',10,'MarkerFaceColor','k')
            %set(gca,'FontSize',25,'XLim',[alpha(1)-0.1 alpha(end)+0.1],'XTick',0:0.5:2);
            %xlabel('Concentration parameter (\alpha)','FontSize',25);
            %ylabel('CR','FontSize',25);
            
        case 'familiarization'
            d = [0 1];
            for i = 1:length(d)
                results = imm_run(44,[],d(i));
                v(i) = results.V(end);
            end
            bar(v); colormap bone
            set(gca,'YLim',[0 1.1],'FontSize',25,'XTickLabel',{'Novel' 'Familiar'});
            ylabel('CR','FontSize',25);
    end