clear all
close all
clc

fileName = 'output_file.csv';
subject = BeStable_import_data(fileName);
load groupDataEXAMPLE



%% PLOT DATA
FIG1 = figure('Position',[1 41 1920 963]);

annotation(FIG1,'textbox',[0.00625 0.751817237798546 0.0963541666666667 0.172377985462097],...
    'String',{...
    ['Subject ID: ' num2str(subject.ID)],'',...
    ['Age: ' num2str(subject.age) ' yrs'],...
    ['Height: ' num2str(subject.height) ' cm'],...
    ['Mass: ' num2str(subject.mass) ' kg'],...
    ['Gender: ' subject.gender],...
    ['Affected side: ' subject.affectedSide],...
    ['Treadmill speed: ' num2str(subject.treadmillSpeed) ' m/s'],...
    ['Pert. amplitude: ' num2str(round(subject.perturbationAmplitude,2)) ' m']},...
    'FitBoxToText','off');

annotation(FIG1,'textbox',[0.00625 0.601817237798546 0.0963541666666667 0.142377985462097],...
    'String',{...
    'BASE walking (before perturbations)',...
    'FREE walking (between perturbations)',...
    'P_1~P_4 - consecutive steps after pert. onset'},...
    'FitBoxToText','off');


% NATIVE GAIT
% step length
subplot(4,6,1)
hold on
boxplot3(1+[-0.3 +0.0],group.dataSegmented.base.leftHeelStrike.stepLength,'r',0.3);
boxplot3(1+[-0.0 +0.3],group.dataSegmented.base.rightHeelStrike.stepLength,'b',0.3);
boxplot3(2+[-0.3 +0.0],group.dataSegmented.free.leftHeelStrike.stepLength,'r',0.3);
boxplot3(2+[-0.0 +0.3],group.dataSegmented.free.rightHeelStrike.stepLength,'b',0.3);
stepLengthMean = [
    mean(subject.dataSegmented.base.leftHeelStrike.stepLength) mean(subject.dataSegmented.base.rightHeelStrike.stepLength);
    mean(subject.dataSegmented.free.leftHeelStrike.stepLength) mean(subject.dataSegmented.free.rightHeelStrike.stepLength)];
stepLengthStd = [
    std(subject.dataSegmented.base.leftHeelStrike.stepLength) std(subject.dataSegmented.base.rightHeelStrike.stepLength);
    std(subject.dataSegmented.free.leftHeelStrike.stepLength) std(subject.dataSegmented.free.rightHeelStrike.stepLength)];
errorbar((1:2)-0.15,stepLengthMean(:,1),stepLengthStd(:,1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0)
errorbar((1:2)+0.15,stepLengthMean(:,2),stepLengthStd(:,2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0)
axis([0.5 2.5 0 1])
grid
box on
hold off
ylabel('Step length (m)')
set(gca,'xtick',1:2,'xticklabel',{'BASE','FREE'})
title('NATIVE GAIT')

% step width
subplot(4,6,7)
hold on
boxplot3(1+[-0.3 +0.0],group.dataSegmented.base.leftHeelStrike.stepWidth,'r',0.3);
boxplot3(1+[-0.0 +0.3],group.dataSegmented.base.rightHeelStrike.stepWidth,'b',0.3);
boxplot3(2+[-0.3 +0.0],group.dataSegmented.free.leftHeelStrike.stepWidth,'r',0.3);
boxplot3(2+[-0.0 +0.3],group.dataSegmented.free.rightHeelStrike.stepWidth,'b',0.3);
stepWidthMean = [
    mean(subject.dataSegmented.base.leftHeelStrike.stepWidth) mean(subject.dataSegmented.base.rightHeelStrike.stepWidth);
    mean(subject.dataSegmented.free.leftHeelStrike.stepWidth) mean(subject.dataSegmented.free.rightHeelStrike.stepWidth)];
stepWidthStd = [
    std(subject.dataSegmented.base.leftHeelStrike.stepWidth) std(subject.dataSegmented.base.rightHeelStrike.stepWidth);
    std(subject.dataSegmented.free.leftHeelStrike.stepWidth) std(subject.dataSegmented.free.rightHeelStrike.stepWidth)];
errorbar((1:2)-0.15,stepWidthMean(:,1),stepWidthStd(:,1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0)
errorbar((1:2)+0.15,stepWidthMean(:,2),stepWidthStd(:,2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0)
axis([0.5 2.5 -0.1 0.6])
grid
box on
hold off
ylabel('Step width (m)')
set(gca,'xtick',1:2,'xticklabel',{'BASE','FREE'})


% step time
subplot(4,6,13)
hold on
boxplot3(1+[-0.3 +0.0],group.dataSegmented.base.leftHeelStrike.stepTime,'r',0.3);
boxplot3(1+[-0.0 +0.3],group.dataSegmented.base.rightHeelStrike.stepTime,'b',0.3);
boxplot3(2+[-0.3 +0.0],group.dataSegmented.free.leftHeelStrike.stepTime,'r',0.3);
boxplot3(2+[-0.0 +0.3],group.dataSegmented.free.rightHeelStrike.stepTime,'b',0.3);
stepTimeMean = [
    mean(subject.dataSegmented.base.leftHeelStrike.stepTime) mean(subject.dataSegmented.base.rightHeelStrike.stepTime);
    mean(subject.dataSegmented.free.leftHeelStrike.stepTime) mean(subject.dataSegmented.free.rightHeelStrike.stepTime)];
stepTimeStd = [
    std(subject.dataSegmented.base.leftHeelStrike.stepTime) std(subject.dataSegmented.base.rightHeelStrike.stepTime);
    std(subject.dataSegmented.free.leftHeelStrike.stepTime) std(subject.dataSegmented.free.rightHeelStrike.stepTime)];
errorbar((1:2)-0.15,stepTimeMean(:,1),stepTimeStd(:,1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0)
errorbar((1:2)+0.15,stepTimeMean(:,2),stepTimeStd(:,2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0)
axis([0.5 2.5 0 1.4])
grid
box on
hold off
ylabel('Step time (s)')
set(gca,'xtick',1:2,'xticklabel',{'BASE','FREE'})



% PERTURBATIONS
fieldNames = fieldnames(subject.dataSegmented.pert);
for j = 1:length(fieldNames)
    
    pertStr = fieldNames{j};
    eval(['plotPertData = subject.dataSegmented.pert.' pertStr ';'])
    eval(['plotPertDataGroup = group.dataSegmented.pert.' pertStr ';'])
    
    % step length
    subplot(4,6,j+1)
    hold on
    boxplot3(1+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepLength(:,1),'r',0.3);
    boxplot3(1+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepLength(:,1),'b',0.3);
    boxplot3(2+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepLength(:,2),'r',0.3);
    boxplot3(2+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepLength(:,2),'b',0.3);
    boxplot3(3+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepLength(:,3),'r',0.3);
    boxplot3(3+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepLength(:,3),'b',0.3);
    boxplot3(4+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepLength(:,4),'r',0.3);
    boxplot3(4+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepLength(:,4),'b',0.3);
    stepLengthMean = [mean(plotPertData.withLeftLeg.stepLength)' mean(plotPertData.withRightLeg.stepLength)'];
    stepLengthStd = [std(plotPertData.withLeftLeg.stepLength)' std(plotPertData.withRightLeg.stepLength)'];
    errorbar((1:4)-0.15,stepLengthMean(:,1),stepLengthStd(:,1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0)
    errorbar((1:4)+0.15,stepLengthMean(:,2),stepLengthStd(:,2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0)
    axis([0.5 4.5 0 1])
    grid
    box on
    hold off
    ylabel('Step length (m)')
    set(gca,'xtick',1:4,'xticklabel',{'P_1','P_2','P_3','P_4'})
    
    switch pertStr
        case 'fw'
            title('FORWARD')
        case 'fwiw'
            title('FORWARD-INWARD')
        case 'iw'
            title('INWARD')
        case 'fwow'
            title('FORWARD-OUTWARD')
        case 'ow'
            title('OUTWARD')
    end
    
    % step width
    subplot(4,6,j+1+6)
    hold on
    boxplot3(1+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepWidth(:,1),'r',0.3);
    boxplot3(1+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepWidth(:,1),'b',0.3);
    boxplot3(2+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepWidth(:,2),'r',0.3);
    boxplot3(2+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepWidth(:,2),'b',0.3);
    boxplot3(3+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepWidth(:,3),'r',0.3);
    boxplot3(3+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepWidth(:,3),'b',0.3);
    boxplot3(4+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepWidth(:,4),'r',0.3);
    boxplot3(4+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepWidth(:,4),'b',0.3);
    stepWidthMean = [mean(plotPertData.withLeftLeg.stepWidth)' mean(plotPertData.withRightLeg.stepWidth)'];
    stepWidthStd = [std(plotPertData.withLeftLeg.stepWidth)' std(plotPertData.withRightLeg.stepWidth)'];
    errorbar((1:4)-0.15,stepWidthMean(:,1),stepWidthStd(:,1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0)
    errorbar((1:4)+0.15,stepWidthMean(:,2),stepWidthStd(:,2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0)
    axis([0.5 4.5 -0.1 0.6])
    grid
    box on
    hold off
    ylabel('Step width (m)')
    set(gca,'xtick',1:4,'xticklabel',{'P_1','P_2','P_3','P_4'})
    
    
    % step time
    subplot(4,6,j+1+12)
    hold on
    boxplot3(1+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepTime(:,1),'r',0.3);
    boxplot3(1+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepTime(:,1),'b',0.3);
    boxplot3(2+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepTime(:,2),'r',0.3);
    boxplot3(2+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepTime(:,2),'b',0.3);
    boxplot3(3+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepTime(:,3),'r',0.3);
    boxplot3(3+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepTime(:,3),'b',0.3);
    boxplot3(4+[-0.3 +0.0],plotPertDataGroup.withLeftLeg.stepTime(:,4),'r',0.3);
    boxplot3(4+[-0.0 +0.3],plotPertDataGroup.withRightLeg.stepTime(:,4),'b',0.3);
    stepTimeMean = [mean(plotPertData.withLeftLeg.stepTime)' mean(plotPertData.withRightLeg.stepTime)'];
    stepTimeStd = [std(plotPertData.withLeftLeg.stepTime)' std(plotPertData.withRightLeg.stepTime)'];
    errorbar((1:4)-0.15,stepTimeMean(:,1),stepTimeStd(:,1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0)
    errorbar((1:4)+0.15,stepTimeMean(:,2),stepTimeStd(:,2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0)
    axis([0.5 4.5 0 1.4])
    grid
    box on
    hold off
    ylabel('Step time (s)')
    set(gca,'xtick',1:4,'xticklabel',{'P_1','P_2','P_3','P_4'})
    
    % target error
    subplot(4,6,j+1+18)
    hold on
    [L_leftLeg,H_leftLeg] = boxplot3(1+[-0.3 +0.3],plotPertDataGroup.withLeftLeg.targetError,'r',0.3);
    [L_rightLeg,H_rightLeg] = boxplot3(2+[-0.3 +0.3],plotPertDataGroup.withRightLeg.targetError,'b',0.3);
    targetErrorMean = [nanmean(plotPertData.withLeftLeg.targetError) nanmean(plotPertData.withRightLeg.targetError)];
    targetErrorStd = [nanstd(plotPertData.withLeftLeg.targetError) nanstd(plotPertData.withRightLeg.targetError)];
    E_leftLeg = errorbar(1,targetErrorMean(1),targetErrorStd(1),'o','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','Color','k','CapSize',0);
    E_rightLeg = errorbar(2,targetErrorMean(2),targetErrorStd(2),'o','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','Color','k','CapSize',0);
    axis([0.5 2.5 0 0.3])
    grid
    box on
    hold off
    ylabel('Target error (m)')
    set(gca,'xtick',1:2,'xticklabel',{'L','R'})
    
end

L = legend([L_leftLeg,H_leftLeg,H_rightLeg,E_leftLeg,E_rightLeg],...
    {'group mean',...
    ['group STD',newline,'(pert. onset at left heel strike)'],...
    ['group STD',newline,'(pert. onset at right heel strike)'],...
    ['subject mean with STD',newline,'(pert. onset at left heel strike)'],...
    ['subject mean with STD',newline,'(pert. onset at right heel strike)']});
set(L,'Position',[0.121875 0.0976116303219107 0.110369361970485 0.170820350974396])%[0.00625 0.506583646195082 0.0963541666666667 0.0841121472116572])

