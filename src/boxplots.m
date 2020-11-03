function h = boxplots(X,varargin)

% parameters
space = 0.6; % space between data sets
width = 1; % boxplot width between groups
ticksize = 0.9; % errorbar width
outMarker = 'o';
outMarkerSize = 5;
outMarkerEdgeColor = [0.6 0.6 0.6];
outMarkerFaceColor = 'none';
alpha = 0.05;
colors = {};
outliers = 'off';
showmean = 'off';

% number of groups
M = size(X,2);

% number of data sets in group
N = size(X,1);

% set the labels
labels = cell(N,1);
for n = 1:N
    labels{n} = num2str(n);
endfor

% optional arguments
optargin = size(varargin,2);

k = 1;
while k <= optargin
    switch lower(varargin{k})
        case 'labels'
            labels = varargin{k+1};
        case 'colormap'
            cmap = varargin{k+1};
        case 'colors'
            colors = varargin{k+1};
        case 'outliermarker'
            outMarker = varargin{k+1};
        case 'outliermarkersize'
            outMarkerSize = varargin{k+1};
        case 'outliermarkeredgecolor'
            outMarkerEdgeColor = varargin{k+1};
        case 'outliermarkerfacecolor'
            outMarkerFaceColor = varargin{k+1};
        case 'space'
            space = varargin{k+1};
        case 'width'
            width = varargin{k+1};
        case 'ticksize'
            ticksize = varargin{k+1};
        case 'outliers'
            outliers = varargin{k+1};
        case 'showmean'
            showmean = varargin{k+1};
    endswitch
    k = k + 2;
endwhile

% colors
if isempty(colors)
  color_palete = {'r','b','g','k','c','m','y'};
  colors = repmat(color_palete(1:M),size(X));
else
  colors = repmat(colors,size(X));
endif

xlim([0.5 N+0.5])
hgg = zeros(M,1);

for m = 1:M
    
    hgg(m) = hggroup(); % create a hggroup for each data set
    
    for n = 1:N
      
      Y = X{n,m};
      
      try
        
          y = sort(Y); % rank the data
          q2 = nanmedian(y); % compute 50th percentile (second quartile)
          q1 = nanmedian(y(y<=q2)); % compute 25th percentile (first quartile)
          q3 = nanmedian(y(y>=q2)); % compute 75th percentile (third quartile)
          IQR = q3-q1; % compute Interquartile Range (IQR)
          fl = min(y(y>=q1-1.5*IQR));
          fu = max(y(y<=q3+1.5*IQR));
          ol = y(y<q1-1.5*IQR);
          ou = y(y>q3+1.5*IQR);
        
        % plot outliers
        if strcmp(outliers,'on')
          hold on
          plot((n-space/2+(2*m-1)*space/(2*M)).*ones(size(ou)),ou,...
             'LineStyle','none',...
             'Marker',outMarker,...
             'MarkerSize',outMarkerSize,...
             'MarkerEdgeColor',outMarkerEdgeColor,...
             'MarkerFaceColor',outMarkerFaceColor,...
             'HitTest','off',...
             'Parent',hgg(m));
          plot((n-space/2+(2*m-1)*space/(2*M)).*ones(size(ol)),ol,...
             'LineStyle','none',...
             'Marker',outMarker,...
             'MarkerSize',outMarkerSize,...
             'MarkerEdgeColor',outMarkerEdgeColor,...
             'MarkerFaceColor',outMarkerFaceColor,...
             'HitTest','off',...
             'Parent',hgg(m));
          hold off
        endif
        
        % plot fence
        line([n-space/2+(2*m-1)*space/(2*M) n-space/2+(2*m-1)*space/(2*M)],[fu fl],...
            'Color','k','LineStyle','-','HitTest','off','Parent',hgg(m));
        line([n-space/2+(2*m-1-ticksize)*space/(2*M) n-space/2+(2*m-1+ticksize)*space/(2*M)],[fu fu],...
            'Color','k','HitTest','off','Parent',hgg(m));
        line([n-space/2+(2*m-1-ticksize)*space/(2*M) n-space/2+(2*m-1+ticksize)*space/(2*M)],[fl fl],...
            'Color','k','HitTest','off','Parent',hgg(m));
        
        % plot quantile
        if q3 > q1
            h(m) = rectangle('Position',[n-space/2+(2*m-1-width)*space/(2*M) q1 width*space/M q3-q1],...
                'EdgeColor','none','FaceColor',colors{n,m},'HitTest','off','Parent',hgg(m));
        endif
        
        % plot median
        line([n-space/2+(2*m-1-width)*space/(2*M) n-space/2+(2*m-1+width)*space/(2*M)],[q2 q2],...
            'Color','k','LineWidth',1,'HitTest','off','Parent',hgg(m));
        
        % plot mean
        if strcmp(showmean,'on')
          u = nanmean(Y);
          hold on
          line([n-space/2+(2*m-1-width)*space/(2*M) n-space/2+(2*m-1+width)*space/(2*M)],[u u],...
            'Color','k','LineWidth',1,'LineStyle','--','HitTest','off','Parent',hgg(m));
          hold off
        endif
        
      catch
        
        u = nanmean(Y);
        if ~isnan(u)
          fu = u + nanstd(Y);
          fl = u - nanstd(Y);
          
          hold on
          line([n-space/2+(2*m-1)*space/(2*M) n-space/2+(2*m-1)*space/(2*M)],[fu fl],...
              'Color','k','LineStyle','-','HitTest','off','Parent',hgg(m));
          line([n-space/2+(2*m-1-ticksize)*space/(2*M) n-space/2+(2*m-1+ticksize)*space/(2*M)],[fu fu],...
              'Color','k','HitTest','off','Parent',hgg(m));
          line([n-space/2+(2*m-1-ticksize)*space/(2*M) n-space/2+(2*m-1+ticksize)*space/(2*M)],[fl fl],...
              'Color','k','HitTest','off','Parent',hgg(m));
          h(m) = plot((n-space/2+(2*m-1)*space/(2*M)).*ones(size(u)),u,...
               'LineStyle','none',...
              'Marker','o',...
              'MarkerSize',6,...
              'MarkerEdgeColor','k',...
              'MarkerFaceColor',colors{n,m},...
              'HitTest','off',...
              'Parent',hgg(m));
          hold off
        else
          h(m) = nan;
        endif
        
      end_try_catch
        
    endfor
endfor

box on
set(gca,'XTick',1:N,'XTickLabel',labels);

endfunction
