function plotResults(testbed_data,sorted_data)
################################################################################
# 'function plotResults(testbed_data,sorted_data)'
#
# Save PI results as plots and save it in *.pdf
# 
# Copyright BeStable project 2020
#
################################################################################

figure_handle = figure('Position',[1 41 1920 963],'Visible','on');

annotation(figure_handle,'textbox',[0.00625 0.75 0.0963541666666667 0.172377985462097],...
     'String',{...
     ['Subject ID: ' num2str(testbed_data.subject_ID)],'',...
     ['Age: ' num2str(testbed_data.subject_age) ' yrs'],...
     ['Height: ' num2str(testbed_data.subject_height) ' cm'],...
     ['Mass: ' num2str(testbed_data.subject_mass) ' kg'],...
     ['Gender: ' testbed_data.subject_gender],...
     ['Affected side: ' testbed_data.subject_affected_body_side],...
     ['Treadmill speed: ' num2str(testbed_data.treadmill_speed) ' m/s'],...
     ['Pert. amplitude: ' num2str(testbed_data.perturbation_amplitude) ' m']},...
     'FitBoxToText','on');

annotation(figure_handle,'textbox',[0.00625 0.69 0.0963541666666667 0.142377985462097],...
     'String',{...
     'BASE walking (before perturbations)',...
     'FREE walking (between perturbations)',...
     'P_1~P_4 - consecutive steps after pert. onset'},...
     'FitBoxToText','on');


## NATIVE GAIT #################################################################
# step length
subplot(4,6,1)
hold on
step_time_mean = [
    mean(sorted_data.base.l_heel_strike.step_length) mean(sorted_data.base.r_heel_strike.step_length);
    mean(sorted_data.free.l_heel_strike.step_length) mean(sorted_data.free.r_heel_strike.step_length)];
step_time_std = [
    std(sorted_data.base.l_heel_strike.step_length) std(sorted_data.base.r_heel_strike.step_length);
    std(sorted_data.free.l_heel_strike.step_length) std(sorted_data.free.r_heel_strike.step_length)];
errorbar((1:2)-0.15,step_time_mean(:,1),step_time_std(:,1),'or')
errorbar((1:2)+0.15,step_time_mean(:,2),step_time_std(:,2),'ob')
axis([0.5 2.5 0 1])
grid
box on
hold off
ylabel('Step length (m)')
set(gca,'xtick',1:2,'xticklabel',{'BASE','FREE'})
title('NATIVE GAIT')

# step width
subplot(4,6,7)
hold on
step_width_mean = [
    mean(sorted_data.base.l_heel_strike.step_width) mean(sorted_data.base.r_heel_strike.step_width);
    mean(sorted_data.free.l_heel_strike.step_width) mean(sorted_data.free.r_heel_strike.step_width)];
step_width_std = [
    std(sorted_data.base.l_heel_strike.step_width) std(sorted_data.base.r_heel_strike.step_width);
    std(sorted_data.free.l_heel_strike.step_width) std(sorted_data.free.r_heel_strike.step_width)];
errorbar((1:2)-0.15,step_width_mean(:,1),step_width_std(:,1),'or')
errorbar((1:2)+0.15,step_width_mean(:,2),step_width_std(:,2),'ob')
axis([0.5 2.5 -0.2 0.6])
grid
box on
hold off
ylabel('Step width (m)')
set(gca,'xtick',1:2,'xticklabel',{'BASE','FREE'})

# step time
subplot(4,6,13)
hold on
step_time_mean = [
    mean(sorted_data.base.l_heel_strike.step_time) mean(sorted_data.base.r_heel_strike.step_time);
    mean(sorted_data.free.l_heel_strike.step_time) mean(sorted_data.free.r_heel_strike.step_time)];
step_time_std = [
    std(sorted_data.base.l_heel_strike.step_time) std(sorted_data.base.r_heel_strike.step_time);
    std(sorted_data.free.l_heel_strike.step_time) std(sorted_data.free.r_heel_strike.step_time)];
errorbar((1:2)-0.15,step_time_mean(:,1),step_time_std(:,1),'or')
errorbar((1:2)+0.15,step_time_mean(:,2),step_time_std(:,2),'ob')
axis([0.5 2.5 0 1.4])
grid
box on
hold off
ylabel('Step time (s)')
set(gca,'xtick',1:2,'xticklabel',{'BASE','FREE'})



## PERTURBATIONS ###############################################################
fieldNames = fieldnames(sorted_data.pert);
for j = 1:length(fieldNames)
    
    pertStr = fieldNames{j};
    eval(['plot_pert_data = sorted_data.pert.' pertStr ';'])
    
    # step length
    subplot(4,6,j+1)
    hold on
    step_time_mean = [mean(plot_pert_data.l_step.step_length)' mean(plot_pert_data.r_step.step_length)'];
    step_time_std = [std(plot_pert_data.l_step.step_length)' std(plot_pert_data.r_step.step_length)'];
    errorbar((1:4)-0.15,step_time_mean(:,1),step_time_std(:,1),'or')
    errorbar((1:4)+0.15,step_time_mean(:,2),step_time_std(:,2),'ob')
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
    endswitch
    
    # step width
    subplot(4,6,j+1+6)
    hold on
    step_width_mean = [mean(plot_pert_data.l_step.step_width)' mean(plot_pert_data.r_step.step_width)'];
    step_width_std = [std(plot_pert_data.l_step.step_width)' std(plot_pert_data.r_step.step_width)'];
    errorbar((1:4)-0.15,step_width_mean(:,1),step_width_std(:,1),'or')
    errorbar((1:4)+0.15,step_width_mean(:,2),step_width_std(:,2),'ob')
    axis([0.5 4.5 -0.2 0.6])
    grid
    box on
    hold off
    ylabel('Step width (m)')
    set(gca,'xtick',1:4,'xticklabel',{'P_1','P_2','P_3','P_4'})
    
    
    # step time
    subplot(4,6,j+1+12)
    hold on
    step_time_mean = [mean(plot_pert_data.l_step.step_time)' mean(plot_pert_data.r_step.step_time)'];
    step_time_std = [std(plot_pert_data.l_step.step_time)' std(plot_pert_data.r_step.step_time)'];
    errorbar((1:4)-0.15,step_time_mean(:,1),step_time_std(:,1),'or')
    errorbar((1:4)+0.15,step_time_mean(:,2),step_time_std(:,2),'ob')
    axis([0.5 4.5 0 1.4])
    grid
    box on
    hold off
    ylabel('Step time (s)')
    set(gca,'xtick',1:4,'xticklabel',{'P_1','P_2','P_3','P_4'})
    
    # target error
    subplot(4,6,j+1+18)
    hold on
    target_error_mean = [mean(plot_pert_data.l_step.target_error) mean(plot_pert_data.r_step.target_error)];
    target_error_std = [std(plot_pert_data.l_step.target_error) std(plot_pert_data.r_step.target_error)];
    E_leftLeg = errorbar(1,target_error_mean(1),target_error_std(1),'or');
    E_rightLeg = errorbar(2,target_error_mean(2),target_error_std(2),'ob');
    axis([0.5 2.5 0 0.2])
    grid
    box on
    hold off
    ylabel('Target error (m)')
    set(gca,'xtick',1:2,'xticklabel',{'L','R'})
    
endfor

L = legend([E_leftLeg,E_rightLeg],...
    {['subject mean with STD (pert. onset at left heel strike)'],...
    ['subject mean with STD (pert. onset at right heel strike)']});
set(L,'Position',[0.09 0.13 0.14 0.04])

set (gcf, "papersize", [13, 8.5])
set (gcf, "paperposition", [0, 0, 13, 8.5])
print -dpdf test_plot.pdf

endfunction