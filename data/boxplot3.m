function [L,H] = boxplot3(X,Y,faceColor,faceAlpha)

meanY = nanmean(Y);
stdY = nanstd(Y);

dataX = [X(1) X(2) X(2) X(1)];
dataY = [meanY-stdY meanY-stdY meanY+stdY meanY+stdY];
hold(gca,'on')
H = patch(dataX,dataY,'r','FaceColor',faceColor,'FaceAlpha',faceAlpha,'LineStyle','none');
L = plot(X,[meanY meanY],'k-');
